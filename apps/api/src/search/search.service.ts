import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { asService, DbService, type Tx } from '../common/db.service.js';
import { allows, type Permission } from '../common/permissions.js';
import { PiiService } from '../common/pii.js';
import { principal, type Principal } from '../common/request-context.js';
import { Prisma } from '../generated/prisma/client.js';

/** Results of each group (W-SUP: 5 per group). */
export const GROUP_SIZE = 5;

export type SearchType =
  | 'COMPANY'
  | 'MERCHANT'
  | 'USER'
  | 'EMPLOYEE'
  | 'ORDER'
  | 'PAYMENT'
  | 'PAYOUT'
  | 'INVOICE'
  | 'TICKET';

export interface SearchItem {
  type: SearchType;
  id: string;
  title: string;
  subtitle: string | null;
  status: string | null;
  amountMillimes: number | null;
  /** Owner of the item when its page is under it (the company of an employee). */
  parentId: string | null;
}

interface Row {
  id: string;
  title: string;
  subtitle: string | null;
  status: string | null;
  amount: bigint | null;
  parent_id: string | null;
}

/** Prefixes of the exact references; TX- and RV- are the names of the payments and payouts. */
const EXACT: readonly { pattern: RegExp; type: SearchType; prefix: string }[] = [
  { pattern: /^CMD-\d{4}-\d+$/, type: 'ORDER', prefix: 'CMD' },
  { pattern: /^(?:TX|PAY)-\d+$/, type: 'PAYMENT', prefix: 'PAY' },
  { pattern: /^(?:RV|VIR)-\d{4}-\d+$/, type: 'PAYOUT', prefix: 'VIR' },
  { pattern: /^TK-\d{4}-\d{6}$/, type: 'TICKET', prefix: 'TK' },
  { pattern: /^FAC-\d{4}-\d+$/, type: 'INVOICE', prefix: 'FAC' },
];

type SearchTable =
  | 'companies'
  | 'merchants'
  | 'users'
  | 'employees'
  | 'credit_orders'
  | 'payments'
  | 'payout_requests'
  | 'invoices'
  | 'support_tickets';

/** Tenant column a search is narrowed to, from the session (never from the request). */
type Scope = { column: 'company_id' | 'merchant_id' | 'employee_id'; id: string } | null;

/** The typed text, ready for the three ways of matching (normalised by the database). */
interface Needle {
  readonly text: string;
  /** `%text%`, LIKE wildcards of the text escaped. */
  readonly like: string;
  /** Prefix full-text query (`mot:* & autre:*`), null when the text has no word. */
  readonly words: string | null;
  /** `%word%` of each word of 2 characters or more (all of them must be found). */
  readonly parts: string[];
}

function needleOf(q: string): Needle {
  const text = q.trim().slice(0, 100);
  const like = `%${text.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;
  const tokens = text
    .split(/[^\p{L}\p{N}]+/u)
    .filter((token) => token.length > 0)
    .slice(0, 8);
  return {
    text,
    like,
    words: tokens.length === 0 ? null : tokens.map((t) => `${t}:*`).join(' & '),
    parts: tokens.filter((t) => t.length >= 2).map((t) => `%${t}%`),
  };
}

/**
 * Best rows of a table for the text (substring, word prefixes, close spelling), found through
 * its GIN indexes by `fp_search_candidates` (migration 0050): ids and scores only. The caller
 * joins them to the table under the RLS of the session and its explicit tenant filter.
 */
function candidates(table: SearchTable, needle: Needle, scope: Scope): Prisma.Sql {
  return Prisma.sql`fp_search_candidates(${table}, ${needle.text}, ${needle.like}, ${needle.words},
    ${needle.parts}::text[], ${scope?.column ?? null}, ${scope?.id ?? null}::uuid)`;
}

function item(type: SearchType, row: Row): SearchItem {
  return {
    type,
    id: row.id,
    title: row.title,
    subtitle: row.subtitle,
    status: row.status,
    amountMillimes: row.amount === null ? null : Number(row.amount),
    parentId: row.parent_id,
  };
}

/** Tickets of a client: its tenant, and its own unless it is the owner (`AND …`). */
function ticketScope(who: Principal): Prisma.Sql {
  const tenant =
    who.companyId !== null
      ? Prisma.sql`t.company_id = ${who.companyId}::uuid`
      : who.merchantId !== null
        ? Prisma.sql`t.merchant_id = ${who.merchantId}::uuid`
        : Prisma.sql`t.employee_id = ${who.employeeId}::uuid`;
  const own =
    who.subRole === 'OWNER' ? Prisma.empty : Prisma.sql`AND t.requester_id = ${who.userId}::uuid`;
  return Prisma.sql`AND ${tenant} ${own}`;
}

/** Results found by identifier first, without duplicates, 5 at most. */
function merge(first: Row[], second: Row[]): Row[] {
  const seen = new Set(first.map((row) => row.id));
  return [...first, ...second.filter((row) => !seen.has(row.id))].slice(0, GROUP_SIZE);
}

/**
 * Global search (W-SUP): what the signed-in user may open, grouped, 5 per group, during the
 * typing. Full text without accents + trigrams (typos, pieces of words) on GIN indexes; the rows
 * are always read under the RLS of the session AND an explicit filter on its tenant. Sealed
 * columns (CIN, RIB, phones) are never searched approximately: Opérations alone finds a client by
 * its complete CIN or RIB, through the blind index, and each such search is audited.
 */
@Injectable()
export class SearchService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(PiiService) private readonly pii: PiiService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async search(q: string) {
    const who = principal();
    const needle = needleOf(q);
    const can = (permission: Permission) => allows(who.role, who.subRole, [permission]);
    return this.db.user(async (tx) => {
      const exact = await this.exact(tx, who, needle.text, can);
      const groups: { type: SearchType; items: SearchItem[] }[] = [];
      const add = (type: SearchType, rows: Row[]) => {
        if (rows.length > 0) groups.push({ type, items: rows.map((row) => item(type, row)) });
      };
      if (who.role === 'ADMIN') {
        const identified = can('search.identifiers')
          ? await this.byIdentifier(tx, needle.text)
          : { companies: [], merchants: [] };
        if (can('accounts.read')) {
          add('COMPANY', merge(identified.companies, await this.companies(tx, needle)));
          add('MERCHANT', merge(identified.merchants, await this.merchants(tx, needle)));
        }
        if (can('users.read')) add('USER', await this.users(tx, needle, null));
        if (can('accounts.read')) add('EMPLOYEE', await this.employees(tx, needle, null));
        if (can('creditOrders.read')) add('ORDER', await this.orders(tx, needle, null));
        if (can('transactions.read')) add('PAYMENT', await this.payments(tx, needle, null));
        if (can('adminPayouts.read')) add('PAYOUT', await this.payouts(tx, needle, null));
        if (can('adminInvoices.read')) add('INVOICE', await this.invoices(tx, needle, null));
        if (can('tickets.read')) add('TICKET', await this.tickets(tx, needle, null));
      } else if (who.role === 'COMPANY' && who.companyId !== null) {
        const companyId = who.companyId;
        if (can('team.manage'))
          add('USER', await this.users(tx, needle, { column: 'company_id', id: companyId }));
        if (can('employees.read')) add('EMPLOYEE', await this.employees(tx, needle, companyId));
        if (can('orders.read')) add('ORDER', await this.orders(tx, needle, companyId));
        if (can('invoices.read')) add('INVOICE', await this.invoices(tx, needle, companyId));
        if (can('support.use')) add('TICKET', await this.tickets(tx, needle, who));
      } else if (who.role === 'MERCHANT' && who.merchantId !== null) {
        const merchantId = who.merchantId;
        if (can('team.manage'))
          add('USER', await this.users(tx, needle, { column: 'merchant_id', id: merchantId }));
        if (can('sales.read')) add('PAYMENT', await this.payments(tx, needle, merchantId));
        if (can('payouts.read')) add('PAYOUT', await this.payouts(tx, needle, merchantId));
        if (can('support.use')) add('TICKET', await this.tickets(tx, needle, who));
      }
      return { query: needle.text, exact, groups };
    });
  }

  /** A complete reference (CMD-, TX-, RV-, TK-, FAC-) opens its item directly. */
  private async exact(
    tx: Tx,
    who: Principal,
    text: string,
    can: (permission: Permission) => boolean,
  ): Promise<SearchItem | null> {
    const upper = text.toUpperCase().replace(/\s+/g, '');
    const entry = EXACT.find((candidate) => candidate.pattern.test(upper));
    if (entry === undefined) return null;
    const reference = `${entry.prefix}${upper.slice(upper.indexOf('-'))}`;
    const admin = who.role === 'ADMIN';
    const company = Prisma.sql`${who.companyId}::uuid`;
    const merchant = Prisma.sql`${who.merchantId}::uuid`;
    let found: Row[] = [];
    if (entry.type === 'ORDER') {
      if (admin ? can('creditOrders.read') : can('orders.read') && who.companyId !== null)
        found = await tx.$queryRaw<Row[]>`
          SELECT o.id, o.reference AS title, NULL AS subtitle, o.status::text AS status,
                 o.total_millimes AS amount, o.company_id AS parent_id
            FROM credit_orders o
           WHERE o.reference = ${reference}
             ${admin ? Prisma.empty : Prisma.sql`AND o.company_id = ${company}`}`;
    } else if (entry.type === 'PAYMENT') {
      if (admin ? can('transactions.read') : can('sales.read') && who.merchantId !== null)
        found = await tx.$queryRaw<Row[]>`
          SELECT p.id, p.reference AS title, NULL AS subtitle, p.status::text AS status,
                 p.amount_millimes AS amount, p.merchant_id AS parent_id
            FROM payments p
           WHERE p.reference = ${reference}
             ${admin ? Prisma.empty : Prisma.sql`AND p.merchant_id = ${merchant}`}`;
    } else if (entry.type === 'PAYOUT') {
      if (admin ? can('adminPayouts.read') : can('payouts.read') && who.merchantId !== null)
        found = await tx.$queryRaw<Row[]>`
          SELECT r.id, r.reference AS title, NULL AS subtitle, r.status::text AS status,
                 r.gross_millimes AS amount, r.merchant_id AS parent_id
            FROM payout_requests r
           WHERE r.reference = ${reference}
             ${admin ? Prisma.empty : Prisma.sql`AND r.merchant_id = ${merchant}`}`;
    } else if (entry.type === 'INVOICE') {
      if (admin ? can('adminInvoices.read') : can('invoices.read') && who.companyId !== null)
        found = await tx.$queryRaw<Row[]>`
          SELECT i.id, i.number AS title, NULL AS subtitle, i.status::text AS status,
                 i.total_millimes AS amount, i.company_id AS parent_id
            FROM invoices i
           WHERE i.number = ${reference}
             ${admin ? Prisma.empty : Prisma.sql`AND i.company_id = ${company}`}`;
    } else if (admin ? can('tickets.read') : can('support.use')) {
      found = await tx.$queryRaw<Row[]>`
        SELECT t.id, t.reference AS title, t.subject AS subtitle, t.status::text AS status,
               NULL::bigint AS amount, NULL::uuid AS parent_id
          FROM support_tickets t
         WHERE t.reference = ${reference} ${admin ? Prisma.empty : ticketScope(who)}`;
    }
    const row = found[0];
    return row === undefined ? null : item(entry.type, row);
  }

  /** Opérations only: a client by its complete CIN or RIB (blind index), audited. */
  private async byIdentifier(tx: Tx, text: string) {
    const compact = text.replace(/\s+/g, '').toUpperCase();
    let kind: 'CIN' | 'RIB';
    let companies: Row[] = [];
    let merchants: Row[];
    if (/^\d{8}$/.test(compact)) {
      kind = 'CIN';
      const index = this.pii.nationalIdIndex(compact);
      companies = await tx.$queryRaw<Row[]>`
        SELECT c.id, c.name AS title, c.city AS subtitle, c.status::text AS status,
               NULL::bigint AS amount, NULL::uuid AS parent_id
          FROM companies c WHERE c.national_id_index = ${index} LIMIT ${GROUP_SIZE}`;
      merchants = await tx.$queryRaw<Row[]>`
        SELECT m.id, m.name AS title, m.city AS subtitle, m.status::text AS status,
               NULL::bigint AS amount, NULL::uuid AS parent_id
          FROM merchants m WHERE m.national_id_index = ${index} LIMIT ${GROUP_SIZE}`;
    } else if (/^TN\d{22}$/.test(compact)) {
      kind = 'RIB';
      const index = this.pii.ibanIndex(compact);
      merchants = await tx.$queryRaw<Row[]>`
        SELECT m.id, m.name AS title, m.city AS subtitle, m.status::text AS status,
               NULL::bigint AS amount, NULL::uuid AS parent_id
          FROM merchants m WHERE m.iban_index = ${index} LIMIT ${GROUP_SIZE}`;
    } else {
      return { companies: [] as Row[], merchants: [] as Row[] };
    }
    // The value searched never reaches the audit log: its kind and the number of results only.
    await this.audit.record(
      tx,
      'search.identifier',
      `${kind}: ${String(companies.length + merchants.length)} résultat(s)`,
    );
    return { companies, merchants };
  }

  private companies(tx: Tx, needle: Needle) {
    return tx.$queryRaw<Row[]>`
      SELECT c.id, c.name AS title, c.city AS subtitle, c.status::text AS status,
             NULL::bigint AS amount, NULL::uuid AS parent_id
        FROM ${candidates('companies', needle, null)} s JOIN companies c ON c.id = s.id
       ORDER BY s.score DESC, c.name
       LIMIT ${GROUP_SIZE}`;
  }

  private merchants(tx: Tx, needle: Needle) {
    return tx.$queryRaw<Row[]>`
      SELECT m.id, m.name AS title, m.city AS subtitle, m.status::text AS status,
             NULL::bigint AS amount, NULL::uuid AS parent_id
        FROM ${candidates('merchants', needle, null)} s JOIN merchants m ON m.id = s.id
       ORDER BY s.score DESC, m.name
       LIMIT ${GROUP_SIZE}`;
  }

  /**
   * Users: every account for an administrator; the team of its company or shop for an owner.
   * The users of a company are not visible to its session (RLS): read as a service step,
   * narrowed to that company from the session, like the « Utilisateurs » page.
   */
  private async users(tx: Tx, needle: Needle, scope: Scope) {
    const tenant =
      scope === null
        ? Prisma.empty
        : scope.column === 'company_id'
          ? Prisma.sql`WHERE u.role = 'COMPANY' AND u.company_id = ${scope.id}::uuid
              AND u.employee_id IS NULL`
          : Prisma.sql`WHERE u.role = 'MERCHANT' AND u.merchant_id = ${scope.id}::uuid
              AND u.employee_id IS NULL`;
    // The candidates are always found under the session (the function checks its tenant).
    const found = await tx.$queryRaw<{ id: string; score: number }[]>`
      SELECT s.id, s.score FROM ${candidates('users', needle, scope)} s`;
    if (found.length === 0) return [];
    const ids = found.map((row) => row.id);
    const scores = found.map((row) => row.score);
    const query = () => tx.$queryRaw<Row[]>`
      SELECT u.id, u.display_name AS title, u.email AS subtitle, u.status::text AS status,
             NULL::bigint AS amount, coalesce(u.company_id, u.merchant_id) AS parent_id
        FROM unnest(${ids}::uuid[], ${scores}::real[]) AS s(id, score)
        JOIN users u ON u.id = s.id
       ${tenant}
       ORDER BY s.score DESC, u.display_name
       LIMIT ${GROUP_SIZE}`;
    // A company session does not read its team's rows (RLS): that read only is a service step,
    // narrowed to the company of the session.
    return scope?.column === 'company_id' ? asService(tx, query) : query();
  }

  private employees(tx: Tx, needle: Needle, companyId: string | null) {
    const scope: Scope = companyId === null ? null : { column: 'company_id', id: companyId };
    return tx.$queryRaw<Row[]>`
      SELECT e.id, e.first_name || ' ' || e.last_name AS title,
             e.employee_number || ' · ' || co.name AS subtitle, e.status::text AS status,
             NULL::bigint AS amount, e.company_id AS parent_id
        FROM ${candidates('employees', needle, scope)} s
        JOIN employees e ON e.id = s.id
        JOIN companies co ON co.id = e.company_id
       ${companyId === null ? Prisma.empty : Prisma.sql`WHERE e.company_id = ${companyId}::uuid`}
       ORDER BY s.score DESC, e.last_name
       LIMIT ${GROUP_SIZE}`;
  }

  private orders(tx: Tx, needle: Needle, companyId: string | null) {
    const scope: Scope = companyId === null ? null : { column: 'company_id', id: companyId };
    return tx.$queryRaw<Row[]>`
      SELECT o.id, o.reference AS title, co.name AS subtitle, o.status::text AS status,
             o.total_millimes AS amount, o.company_id AS parent_id
        FROM ${candidates('credit_orders', needle, scope)} s
        JOIN credit_orders o ON o.id = s.id
        JOIN companies co ON co.id = o.company_id
       ${companyId === null ? Prisma.empty : Prisma.sql`WHERE o.company_id = ${companyId}::uuid`}
       ORDER BY s.score DESC, o.created_at DESC
       LIMIT ${GROUP_SIZE}`;
  }

  private payments(tx: Tx, needle: Needle, merchantId: string | null) {
    const scope: Scope = merchantId === null ? null : { column: 'merchant_id', id: merchantId };
    return tx.$queryRaw<Row[]>`
      SELECT p.id, p.reference AS title, me.name AS subtitle, p.status::text AS status,
             p.amount_millimes AS amount, p.merchant_id AS parent_id
        FROM ${candidates('payments', needle, scope)} s
        JOIN payments p ON p.id = s.id
        JOIN merchants me ON me.id = p.merchant_id
       ${merchantId === null ? Prisma.empty : Prisma.sql`WHERE p.merchant_id = ${merchantId}::uuid`}
       ORDER BY s.score DESC, p.created_at DESC
       LIMIT ${GROUP_SIZE}`;
  }

  private payouts(tx: Tx, needle: Needle, merchantId: string | null) {
    const scope: Scope = merchantId === null ? null : { column: 'merchant_id', id: merchantId };
    return tx.$queryRaw<Row[]>`
      SELECT r.id, r.reference AS title, me.name AS subtitle, r.status::text AS status,
             r.gross_millimes AS amount, r.merchant_id AS parent_id
        FROM ${candidates('payout_requests', needle, scope)} s
        JOIN payout_requests r ON r.id = s.id
        JOIN merchants me ON me.id = r.merchant_id
       ${merchantId === null ? Prisma.empty : Prisma.sql`WHERE r.merchant_id = ${merchantId}::uuid`}
       ORDER BY s.score DESC, r.requested_at DESC
       LIMIT ${GROUP_SIZE}`;
  }

  private invoices(tx: Tx, needle: Needle, companyId: string | null) {
    const scope: Scope = companyId === null ? null : { column: 'company_id', id: companyId };
    return tx.$queryRaw<Row[]>`
      SELECT i.id, i.number AS title, co.name AS subtitle, i.status::text AS status,
             i.total_millimes AS amount, i.company_id AS parent_id
        FROM ${candidates('invoices', needle, scope)} s
        JOIN invoices i ON i.id = s.id
        JOIN companies co ON co.id = i.company_id
       ${companyId === null ? Prisma.empty : Prisma.sql`WHERE i.company_id = ${companyId}::uuid`}
       ORDER BY s.score DESC, i.issued_at DESC
       LIMIT ${GROUP_SIZE}`;
  }

  /** Tickets: all for an agent; for a client, its own (the whole tenant for the owner). */
  private tickets(tx: Tx, needle: Needle, who: Principal | null) {
    const scope: Scope =
      who === null
        ? null
        : who.companyId !== null
          ? { column: 'company_id', id: who.companyId }
          : who.merchantId !== null
            ? { column: 'merchant_id', id: who.merchantId }
            : who.employeeId !== null
              ? { column: 'employee_id', id: who.employeeId }
              : null;
    return tx.$queryRaw<Row[]>`
      SELECT t.id, t.reference AS title, t.subject AS subtitle, t.status::text AS status,
             NULL::bigint AS amount, NULL::uuid AS parent_id
        FROM ${candidates('support_tickets', needle, scope)} s
        JOIN support_tickets t ON t.id = s.id
       WHERE true ${who === null ? Prisma.empty : ticketScope(who)}
       ORDER BY s.score DESC, t.created_at DESC
       LIMIT ${GROUP_SIZE}`;
  }
}
