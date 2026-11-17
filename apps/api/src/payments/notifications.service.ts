import { Inject, Injectable } from '@nestjs/common';
import { DbService } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { Paginator } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import type { CreditType } from '../generated/prisma/enums.js';

type Kind = 'CREDIT_RECEIVED' | 'PAYMENT_APPROVED' | 'FAMILY_PAYMENT';

/**
 * Notifications of a beneficiary (M4), derived from its own operations: credits received, its
 * payments, and the payments of its family members (read in an audited server step limited to
 * the members it holds). The text is built by the app from i18n keys.
 */
@Injectable()
export class NotificationsService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
  ) {}

  private employeeId(): string {
    const id = principal().employeeId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  async list(query: Record<string, unknown>) {
    const employeeId = this.employeeId();
    const request = this.paginator.request(query, {});
    const readUntil = await this.db.user(async (tx) => {
      const row = await tx.notificationRead.findUnique({ where: { employeeId } });
      return row?.readUntil ?? new Date(0);
    });
    // The members are designated by the holder link only: never another family's payments.
    const rows = await this.db.system(
      (tx) => tx.$queryRaw<
        {
          id: string;
          kind: Kind;
          occurred_at: Date;
          amount: bigint;
          credit_type: CreditType;
          counterparty: string;
        }[]
      >`
        SELECT * FROM (
          SELECT 'ALLOCATION:' || a.id AS id, 'CREDIT_RECEIVED' AS kind, a.created_at AS occurred_at,
                 a.amount_millimes AS amount, a.credit_type::text AS credit_type, c.name AS counterparty
            FROM allocations a JOIN companies c ON c.id = a.company_id
           WHERE a.employee_id = ${employeeId}::uuid
          UNION ALL
          SELECT 'PAYMENT:' || p.id, 'PAYMENT_APPROVED', p.confirmed_at, p.amount_millimes,
                 p.credit_type::text, m.name
            FROM payments p JOIN merchants m ON m.id = p.merchant_id
           WHERE p.employee_id = ${employeeId}::uuid AND p.status IN ('CONFIRMED', 'SETTLED')
          UNION ALL
          SELECT 'FAMILY:' || p.id, 'FAMILY_PAYMENT', p.confirmed_at, p.amount_millimes,
                 p.credit_type::text, e.first_name
            FROM payments p JOIN employees e ON e.id = p.employee_id
           WHERE e.holder_employee_id = ${employeeId}::uuid AND p.status IN ('CONFIRMED', 'SETTLED')
        ) n
        ORDER BY n.occurred_at DESC, n.id DESC
        OFFSET ${request.offset} LIMIT ${request.limit + 1}`,
    );
    return this.paginator.page(
      request,
      rows.map((row) => ({
        id: row.id,
        kind: row.kind,
        occurredAt: row.occurred_at.toISOString(),
        unread: row.occurred_at > readUntil,
        amountMillimes: toMillimes(row.amount),
        creditType: row.credit_type,
        counterpartyName: row.counterparty,
      })),
      {},
    );
  }

  async markAllRead(): Promise<void> {
    const employeeId = this.employeeId();
    await this.db.user((tx) =>
      tx.notificationRead.upsert({
        where: { employeeId },
        create: { employeeId, readUntil: new Date() },
        update: { readUntil: new Date() },
      }),
    );
  }
}
