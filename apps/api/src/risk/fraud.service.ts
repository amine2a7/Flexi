import { Inject, Injectable, Logger } from '@nestjs/common';
import { z } from 'zod';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { Paginator, type Page } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import type {
  FraudAlert,
  FraudAlertKind,
  FraudAlertSeverity,
  Prisma,
} from '../generated/prisma/client.js';

/** Thresholds of the starting rules (decision of 2026-10-31), set by the super-admin. */
interface FraudRules {
  readonly refusedCount: number;
  readonly refusedMinutes: number;
  readonly merchantCount: number;
  readonly merchantMinutes: number;
  readonly limitPercent: number;
  readonly ribPayoutHours: number;
}
const DEFAULT_RULES: FraudRules = {
  refusedCount: 5,
  refusedMinutes: 10,
  merchantCount: 3,
  merchantMinutes: 5,
  limitPercent: 80,
  ribPayoutHours: 24,
};
/** Bounded thresholds: an invalid value falls back on its default, a rule is never switched off. */
const fraudRules = z
  .object({
    refusedCount: z.number().int().min(1).max(1000).catch(DEFAULT_RULES.refusedCount),
    refusedMinutes: z.number().int().min(1).max(1440).catch(DEFAULT_RULES.refusedMinutes),
    merchantCount: z.number().int().min(1).max(1000).catch(DEFAULT_RULES.merchantCount),
    merchantMinutes: z.number().int().min(1).max(1440).catch(DEFAULT_RULES.merchantMinutes),
    limitPercent: z.number().int().min(1).max(100).catch(DEFAULT_RULES.limitPercent),
    ribPayoutHours: z.number().int().min(1).max(720).catch(DEFAULT_RULES.ribPayoutHours),
  })
  .catch(DEFAULT_RULES);
/** Look-back of a run: twice the job period, so that no window is missed between two runs. */
const LOOK_BACK_MINUTES = 20;

interface Candidate {
  readonly kind: FraudAlertKind;
  readonly severity: FraudAlertSeverity;
  readonly subject: string;
  readonly subjectKey: string;
}

function alertBody(alert: FraudAlert) {
  return {
    id: alert.id,
    kind: alert.kind,
    severity: alert.severity,
    subject: alert.subject,
    occurredAt: alert.occurredAt.toISOString(),
    status: alert.status,
    handledByName: alert.handledByName,
    closeReason: alert.closeReason,
  };
}

/**
 * Fraud alerts (decision of 2026-10-31). The job raises an alert per rule, subject and window
 * (unique key: two runs never duplicate it); an alert never blocks anything, Opérations handles
 * it: open → in progress → closed with a reason. Rules 4 (IBAN change then payout) and 5 (new
 * device then payment) wait for the IBAN change and the device registration (mobile API).
 */
@Injectable()
export class FraudService {
  private readonly logger = new Logger('Fraud');

  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async detect(now = new Date()): Promise<number> {
    return this.db.system(async (tx) => {
      const rules = await this.rules(tx);
      const since = new Date(now.getTime() - LOOK_BACK_MINUTES * 60_000);
      const candidates = [
        ...(await this.repeatedRefusals(tx, rules, since)),
        ...(await this.merchantBursts(tx, rules, since)),
        ...(await this.nearDailyLimit(tx, rules, since)),
      ];
      let raised = 0;
      for (const candidate of candidates) {
        const inserted = await tx.$executeRaw`
          INSERT INTO fraud_alerts (id, kind, severity, subject, subject_key)
          VALUES (${uuidv7()}::uuid, ${candidate.kind}::"FraudAlertKind",
                  ${candidate.severity}::"FraudAlertSeverity", ${candidate.subject}, ${candidate.subjectKey})
          ON CONFLICT (kind, subject_key) DO NOTHING`;
        raised += inserted;
      }
      if (raised > 0) this.logger.log(`fraud alerts raised: ${String(raised)}`);
      return raised;
    });
  }

  async list(query: Record<string, unknown>, q?: string): Promise<Page<unknown>> {
    const request = this.paginator.request(query, { q });
    // W-SUP-bis: search by subject of the alert.
    const needle = q?.trim() ?? '';
    const where: Prisma.FraudAlertWhereInput =
      needle === '' ? {} : { subject: { contains: needle, mode: 'insensitive' } };
    return this.db.user(async (tx) => {
      const rows = await tx.fraudAlert.findMany({
        where,
        orderBy: [{ occurredAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.fraudAlert.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(request, rows.map(alertBody), { q }, count);
    });
  }

  /** Open → in progress (Opérations takes it). */
  async start(id: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const moved = await tx.fraudAlert.updateMany({
        where: { id, status: 'OPEN' },
        data: { status: 'IN_PROGRESS', handledBy: who.userId, handledByName: who.displayName },
      });
      if (moved.count !== 1) throw await this.missingOrConflict(tx, id);
      const alert = await tx.fraudAlert.findUniqueOrThrow({ where: { id } });
      await this.audit.record(tx, 'fraudAlerts.start', `${alert.kind} ${alert.subject}`);
      return alertBody(alert);
    });
  }

  /** Closed with a reason (logged), from open or in progress. */
  async close(id: string, reason: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const moved = await tx.fraudAlert.updateMany({
        where: { id, status: { in: ['OPEN', 'IN_PROGRESS'] } },
        data: {
          status: 'CLOSED',
          closeReason: reason,
          closedAt: new Date(),
          handledBy: who.userId,
          handledByName: who.displayName,
        },
      });
      if (moved.count !== 1) throw await this.missingOrConflict(tx, id);
      const alert = await tx.fraudAlert.findUniqueOrThrow({ where: { id } });
      await this.audit.record(tx, 'fraudAlerts.close', `${alert.kind} ${alert.subject}`);
      return alertBody(alert);
    });
  }

  private async missingOrConflict(tx: Tx, id: string) {
    return (await tx.fraudAlert.count({ where: { id } })) === 0
      ? problems.notFound()
      : problems.conflict();
  }

  private async rules(tx: Tx): Promise<FraudRules> {
    const settings = await tx.platformSettings.findUnique({ where: { id: 1 } });
    return fraudRules.parse({ ...DEFAULT_RULES, ...(settings?.fraudRules as object | null) });
  }

  /** Rule 1: more than N refused payments in M minutes for the same employee. */
  private async repeatedRefusals(tx: Tx, rules: FraudRules, since: Date): Promise<Candidate[]> {
    const rows = await tx.$queryRaw<{ employee_id: string; name: string; bucket: Date }[]>`
      SELECT p.employee_id, e.first_name || ' ' || left(e.last_name, 1) || '.' AS name,
             to_timestamp(floor(extract(epoch FROM p.created_at) / (${rules.refusedMinutes} * 60)) * ${rules.refusedMinutes} * 60) AS bucket
        FROM payments p JOIN employees e ON e.id = p.employee_id
       WHERE p.status = 'REFUSED' AND p.created_at >= ${since}
       GROUP BY p.employee_id, name, bucket
      HAVING count(*) > ${rules.refusedCount}`;
    return rows.map((row) => ({
      kind: 'REPEATED_REFUSALS',
      severity: 'HIGH',
      subject: row.name,
      subjectKey: `${row.employee_id}:${row.bucket.toISOString()}`,
    }));
  }

  /** Rule 2: more than N payments of the same employee at the same shop in M minutes. */
  private async merchantBursts(tx: Tx, rules: FraudRules, since: Date): Promise<Candidate[]> {
    const rows = await tx.$queryRaw<
      { employee_id: string; merchant_id: string; shop: string; bucket: Date }[]
    >`
      SELECT p.employee_id, p.merchant_id, m.name AS shop,
             to_timestamp(floor(extract(epoch FROM p.created_at) / (${rules.merchantMinutes} * 60)) * ${rules.merchantMinutes} * 60) AS bucket
        FROM payments p JOIN merchants m ON m.id = p.merchant_id
       WHERE p.status IN ('CONFIRMED', 'SETTLED', 'INITIATED') AND p.created_at >= ${since}
       GROUP BY p.employee_id, p.merchant_id, shop, bucket
      HAVING count(*) > ${rules.merchantCount}`;
    return rows.map((row) => ({
      kind: 'MERCHANT_BURST',
      severity: 'MEDIUM',
      subject: row.shop,
      subjectKey: `${row.merchant_id}:${row.employee_id}:${row.bucket.toISOString()}`,
    }));
  }

  /** Rule 3: one payment above P % of the daily limit of its credit type. */
  private async nearDailyLimit(tx: Tx, rules: FraudRules, since: Date): Promise<Candidate[]> {
    const rows = await tx.$queryRaw<{ id: string; employee_id: string; name: string }[]>`
      SELECT p.id, p.employee_id, e.first_name || ' ' || left(e.last_name, 1) || '.' AS name
        FROM payments p
        JOIN employees e ON e.id = p.employee_id
        JOIN credit_type_settings s ON s.credit_type = p.credit_type
       WHERE p.status IN ('CONFIRMED', 'SETTLED') AND p.created_at >= ${since}
         AND p.amount_millimes * 100 > s.daily_limit_millimes * ${rules.limitPercent}`;
    return rows.map((row) => ({
      kind: 'NEAR_DAILY_LIMIT',
      severity: 'MEDIUM',
      subject: row.name,
      subjectKey: `${row.employee_id}:${row.id}`,
    }));
  }
}
