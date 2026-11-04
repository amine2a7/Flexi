import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService } from '../common/db.service.js';
import type { CreditType } from '../generated/prisma/enums.js';
import { LedgerService, accounts } from '../ledger/ledger.service.js';
import { PaymentsService } from '../payments/payments.service.js';
import { PayoutsService } from '../payouts/payouts.service.js';
import { FraudService } from '../risk/fraud.service.js';

const EVERY_MS = 10 * 60_000;
const DAY_MS = 24 * 60 * 60 * 1000;

/**
 * Periodic jobs of the API process (one process in local development; BullMQ will run them when
 * the API is scaled out): expiry of credit lots, settlement batches due (D+2), stale requests.
 */
@Injectable()
export class JobsService implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger('Jobs');
  private timer: NodeJS.Timeout | undefined;
  private daily: NodeJS.Timeout | undefined;

  constructor(
    @Inject(ENV) private readonly env: Env,
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PayoutsService) private readonly payouts: PayoutsService,
    @Inject(PaymentsService) private readonly payments: PaymentsService,
    @Inject(FraudService) private readonly fraud: FraudService,
  ) {}

  onApplicationBootstrap(): void {
    if (this.env.NODE_ENV === 'test') return;
    void this.runAll();
    this.timer = setInterval(() => void this.runAll(), EVERY_MS);
    this.timer.unref();
    // Daily reconciliation of the books (spec 02 §5, ledger-auditor C8), at start-up then every day.
    void this.reconcileBooks();
    this.daily = setInterval(() => void this.reconcileBooks(), DAY_MS);
    this.daily.unref();
  }

  onApplicationShutdown(): void {
    if (this.timer !== undefined) clearInterval(this.timer);
    if (this.daily !== undefined) clearInterval(this.daily);
  }

  /**
   * Reconciliation (spec 02 §5): every balance equals its entries, the books are balanced, the
   * lots of each employee wallet add up to its balance, each dispute hold equals the disputes in
   * progress that hold it. A gap is a critical alert: audit entry and
   * error log naming the accounts, never an amount.
   */
  async reconcileBooks(): Promise<boolean> {
    const result = await this.db.system((tx) => this.ledger.reconcile(tx));
    if (result.ok) return true;
    const accountsInError = [
      ...result.mismatches,
      ...result.lotMismatches,
      ...result.holdMismatches,
      ...result.taxMismatches,
    ];
    this.logger.error(
      `ledger reconciliation failed: ${String(accountsInError.length)} account(s), books balanced: ${String(result.totalDebits === result.totalCredits)}`,
    );
    await this.db.system((tx) =>
      this.audit.record(
        tx,
        'ledger.reconcileFailed',
        accountsInError.join(', ').slice(0, 200) || 'débits ≠ crédits',
        'Système',
      ),
    );
    return false;
  }

  async runAll(): Promise<void> {
    for (const [name, job] of [
      ['expiries', () => this.expireLots()],
      ['settlements', () => this.payouts.executeDueBatches()],
      ['requests', () => this.payments.expireStale()],
      ['fraud', () => this.fraud.detect()],
    ] as const) {
      try {
        await job();
      } catch (error) {
        this.logger.error(
          `job ${name} failed: ${error instanceof Error ? error.constructor.name : 'unknown'}`,
        );
      }
    }
  }

  /**
   * Expired lots (E10): their remainder leaves the employee wallet of the type and is traced as
   * an EXPIRY. Destination set by the administrator (decision of 2026-10-14, provisional):
   * REVENUE_EXPIRED (FlexiPay) or back to the company wallet of the same type.
   */
  async expireLots(now = new Date()): Promise<number> {
    const due = await this.db.system(
      (tx) =>
        tx.$queryRaw<{ account_id: string; owner_id: string; credit_type: CreditType }[]>`
        SELECT DISTINCT l.account_id, a.owner_id, l.credit_type
          FROM credit_lots l JOIN ledger_accounts a ON a.id = l.account_id
         WHERE l.expires_at <= ${now} AND l.remaining_millimes > 0 AND a.owner_type = 'EMPLOYEE'`,
    );
    for (const row of due) {
      await this.db.system(async (tx) => {
        const wallet = accounts.employeeWallet(row.owner_id, row.credit_type);
        const employee = await tx.employee.findUnique({ where: { id: row.owner_id } });
        const destination = (await tx.platformSettings.findUnique({ where: { id: 1 } }))
          ?.expiredCreditsDestination;
        const target =
          destination === 'COMPANY_RETURN' && employee !== null
            ? accounts.companyWallet(employee.companyId, row.credit_type)
            : accounts.expiredCredits();
        // Both accounts locked together, in the order of every other posting (C5).
        await this.ledger.lockAccounts(tx, [wallet, target]);
        const lots = await tx.$queryRaw<{ id: string; remaining_millimes: bigint }[]>`
          SELECT id, remaining_millimes FROM credit_lots
           WHERE account_id = ${row.account_id}::uuid AND expires_at <= ${now} AND remaining_millimes > 0 FOR UPDATE`;
        const total = lots.reduce((sum, lot) => sum + lot.remaining_millimes, 0n);
        if (total === 0n) return;
        const posted = await this.ledger.post(tx, {
          type: 'CREDIT_EXPIRY',
          reference: `EXP-${row.owner_id.slice(0, 8)}`,
          entries: [
            ...lots.map((lot) => ({
              account: wallet,
              direction: 'D' as const,
              amount: lot.remaining_millimes,
              lotId: lot.id,
            })),
            { account: target, direction: 'C', amount: total },
          ],
        });
        await tx.$executeRaw`UPDATE credit_lots SET remaining_millimes = 0 WHERE id = ANY(${lots.map((lot) => lot.id)}::uuid[])`;
        if (employee !== null) {
          await tx.creditExpiry.create({
            data: {
              id: uuidv7(),
              employeeId: employee.id,
              companyId: employee.companyId,
              creditType: row.credit_type,
              amountMillimes: total,
              transactionId: posted.transactionId,
            },
          });
        }
        await this.audit.record(
          tx,
          'credits.expire',
          `${row.credit_type} ${row.owner_id.slice(0, 8)}`,
          'Système',
        );
      });
    }
    return due.length;
  }
}
