import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { Paginator, type PageRequest } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import type { Prisma } from '../generated/prisma/client.js';

/** Filters of the general ledger: one client (company with its employees, or merchant), a type. */
export interface LedgerFilters {
  clientType?: 'COMPANY' | 'MERCHANT' | undefined;
  clientId?: string | undefined;
  transactionType?: string | undefined;
}

/** Lines of one CSV export at most (the period narrows it). */
export const LEDGER_EXPORT_LIMIT = 10_000;

const entryInclude = {
  transaction: { select: { type: true, reference: true } },
  account: { select: { code: true, ownerType: true, ownerId: true, creditType: true } },
} satisfies Prisma.LedgerEntryInclude;

type EntryRow = Prisma.LedgerEntryGetPayload<{ include: typeof entryInclude }>;

/**
 * General ledger of the platform (W-FIN), read only: every double-entry line with its
 * transaction, its account and the owner of the account. Finance and the super-admin.
 */
@Injectable()
export class LedgerAdminService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  private async where(
    tx: Tx,
    filters: LedgerFilters,
    period: { createdFrom?: Date; createdTo?: Date },
  ): Promise<Prisma.LedgerEntryWhereInput> {
    let owners: Prisma.LedgerAccountWhereInput | undefined;
    if (filters.clientId !== undefined) {
      if (filters.clientType === 'MERCHANT') {
        owners = { ownerType: 'MERCHANT', ownerId: filters.clientId };
      } else {
        // A company and the wallets of its employees.
        const employees = await tx.employee.findMany({
          where: { companyId: filters.clientId },
          select: { id: true },
        });
        owners = {
          OR: [
            { ownerType: 'COMPANY', ownerId: filters.clientId },
            { ownerType: 'EMPLOYEE', ownerId: { in: employees.map((e) => e.id) } },
          ],
        };
      }
    }
    return {
      ...(owners === undefined ? {} : { account: owners }),
      ...(filters.transactionType === undefined
        ? {}
        : { transaction: { type: filters.transactionType } }),
      ...(period.createdFrom === undefined && period.createdTo === undefined
        ? {}
        : {
            createdAt: {
              ...(period.createdFrom === undefined ? {} : { gte: period.createdFrom }),
              ...(period.createdTo === undefined ? {} : { lt: period.createdTo }),
            },
          }),
    };
  }

  /** Names of the owners of the accounts (company, merchant, employee « Prénom N. »). */
  private async owners(tx: Tx, rows: readonly EntryRow[]): Promise<Map<string, string>> {
    const ids = (type: string) =>
      [
        ...new Set(rows.filter((r) => r.account.ownerType === type).map((r) => r.account.ownerId)),
      ].filter((id): id is string => id !== null);
    const names = new Map<string, string>();
    for (const c of await tx.company.findMany({
      where: { id: { in: ids('COMPANY') } },
      select: { id: true, name: true },
    }))
      names.set(c.id, c.name);
    for (const m of await tx.merchant.findMany({
      where: { id: { in: ids('MERCHANT') } },
      select: { id: true, name: true },
    }))
      names.set(m.id, m.name);
    for (const e of await tx.employee.findMany({
      where: { id: { in: ids('EMPLOYEE') } },
      select: { id: true, firstName: true, lastName: true, company: { select: { name: true } } },
    }))
      names.set(e.id, `${e.firstName} ${e.lastName.charAt(0)}. (${e.company.name})`);
    return names;
  }

  private view(row: EntryRow, names: Map<string, string>) {
    const owner = row.account.ownerId === null ? null : (names.get(row.account.ownerId) ?? null);
    return {
      id: row.id.toString(),
      occurredAt: row.createdAt.toISOString(),
      transactionId: row.transactionId,
      transactionType: row.transaction.type,
      reference: row.transaction.reference,
      accountCode: row.account.code,
      ownerType: row.account.ownerType,
      ownerName: row.account.ownerType === 'PLATFORM' ? 'FlexiPay' : owner,
      creditType: row.account.creditType,
      direction: row.direction === 'D' ? 'DEBIT' : 'CREDIT',
      amountMillimes: toMillimes(row.amountMillimes),
      balanceAfterMillimes: toMillimes(row.balanceAfterMillimes),
    };
  }

  async list(query: Record<string, unknown>, filters: LedgerFilters) {
    const request: PageRequest = this.paginator.request(query, { ...filters });
    return this.db.user(async (tx) => {
      const where = await this.where(tx, filters, request);
      const rows = await tx.ledgerEntry.findMany({
        where,
        include: entryInclude,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.ledgerEntry.count({ where, take: 10_001 })
        : undefined;
      const names = await this.owners(tx, rows);
      return this.paginator.page(
        request,
        rows.map((row) => this.view(row, names)),
        { ...filters },
        count,
      );
    });
  }

  /** Transaction types present in the ledger (filter of the page). */
  async types(): Promise<{ data: string[] }> {
    return this.db.user(async (tx) => {
      const rows = await tx.ledgerTransaction.findMany({
        distinct: ['type'],
        select: { type: true },
        orderBy: { type: 'asc' },
      });
      return { data: rows.map((row) => row.type) };
    });
  }

  /**
   * CSV export (UTF-8 with BOM for spreadsheets, `;` separated, amounts in dinars with 3
   * decimals). A cell starting with = + - @ is prefixed (no formula injection). Audited.
   */
  async exportCsv(
    filters: LedgerFilters,
    period: { createdFrom?: Date; createdTo?: Date },
  ): Promise<{ data: Buffer; fileName: string }> {
    return this.db.user(async (tx) => {
      const where = await this.where(tx, filters, period);
      const rows = await tx.ledgerEntry.findMany({
        where,
        include: entryInclude,
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        take: LEDGER_EXPORT_LIMIT,
      });
      const names = await this.owners(tx, rows);
      const header = [
        'date',
        'reference',
        'type',
        'compte',
        'titulaire',
        'type_credit',
        'debit_tnd',
        'credit_tnd',
        'solde_apres_tnd',
      ];
      const lines = rows.map((row) => {
        const v = this.view(row, names);
        const amount = dinars(row.amountMillimes);
        return [
          v.occurredAt,
          v.reference,
          v.transactionType,
          v.accountCode,
          v.ownerName ?? '',
          v.creditType ?? '',
          v.direction === 'DEBIT' ? amount : '',
          v.direction === 'CREDIT' ? amount : '',
          dinars(row.balanceAfterMillimes),
        ];
      });
      await this.audit.record(tx, 'ledger.export', `${String(rows.length)} écritures`);
      const csv = [header, ...lines].map((cells) => cells.map(csvCell).join(';')).join('\r\n');
      return {
        data: Buffer.from(`\u{FEFF}${csv}\r\n`, 'utf8'),
        fileName: `grand-livre-${new Date().toISOString().slice(0, 10)}.csv`,
      };
    });
  }

  /** The client exists (404 otherwise), so an unknown id never lists the whole ledger. */
  async checkClient(filters: LedgerFilters): Promise<void> {
    if (filters.clientId === undefined) return;
    const id = filters.clientId;
    const found = await this.db.user((tx) =>
      filters.clientType === 'MERCHANT'
        ? tx.merchant.count({ where: { id } })
        : tx.company.count({ where: { id } }),
    );
    if (found === 0) throw problems.notFound();
  }
}

/** Millimes as dinars with 3 decimals (exact integer arithmetic, never a float). */
function dinars(millimes: bigint): string {
  const negative = millimes < 0n;
  const abs = negative ? -millimes : millimes;
  const text = `${(abs / 1000n).toString()}.${(abs % 1000n).toString().padStart(3, '0')}`;
  return negative ? `-${text}` : text;
}

function csvCell(value: string): string {
  // A signed number stays a number; any other text starting like a formula is neutralised.
  const number = /^-?\d+(\.\d+)?$/.test(value);
  const safe = !number && /^[=+\-@\t\r]/.test(value) ? `'${value}` : value;
  return `"${safe.replaceAll('"', '""')}"`;
}
