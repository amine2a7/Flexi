import { PiiService } from '../common/pii.js';
import { pdfDocument, percent, tnd, type PdfLine } from '../common/pdf.js';
import { randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { InvitationService } from '../auth/invitation.service.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { asService, DbService, type Tx } from '../common/db.service.js';
import { fromMillimes, toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { addMonths, lastMonths, startOfBusinessMonth } from '../common/tunis.js';
import type { CreditType, Employee, EmployeeStatus } from '../generated/prisma/client.js';
import { InsufficientFundsError, LedgerService, accounts } from '../ledger/ledger.service.js';
import { OPEN_ORDER_STATUSES, orderSummary } from '../orders/orders.service.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';
import { canReceiveCredits } from '../common/account-lifecycle.js';

const TYPE_LABEL: Record<CreditType, string> = {
  RESTAURATION: 'Restauration',
  HABILLEMENT: 'Habillement',
  CARBURANT: 'Carburant',
  CADEAUX: 'Cadeaux',
};
const dateFr = (date: Date) =>
  date.toLocaleDateString('fr-TN', { timeZone: 'Africa/Tunis', day: '2-digit', month: '2-digit', year: 'numeric' });

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE = /^\+216[0-9]{8}$/;
const FIELDS = ['employeeNumber', 'firstName', 'lastName', 'email', 'phone'] as const;
const PREVIEW_TTL_MS = 30 * 60_000;

type ImportField = (typeof FIELDS)[number];
export interface ImportRow {
  line: number;
  employeeNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  issues: {
    field: ImportField;
    code: 'REQUIRED' | 'INVALID_FORMAT' | 'DUPLICATE_IN_FILE' | 'ALREADY_EXISTS';
  }[];
}

/** Neutralises spreadsheet formulas (`= + - @`) of an imported cell (CSV injection). */
function neutralise(value: string): string {
  return /^[=+\-@]/.test(value) ? `'${value}` : value;
}

/** Amount typed in TND in a CSV cell (`45,500`, `45.5`, empty = 0), in millimes; null if invalid. */
function csvMillimes(cell: string): bigint | null {
  const value = cell.trim().replace(/\s/g, '');
  if (value === '') return 0n;
  const match = /^(\d{1,9})(?:[.,](\d{1,3}))?$/.exec(value);
  if (match === null) return null;
  return BigInt(match[1] ?? '0') * 1000n + BigInt((match[2] ?? '').padEnd(3, '0'));
}

function balancesList(map: ReadonlyMap<CreditType, bigint>) {
  return CREDIT_TYPES.map((creditType) => ({
    creditType,
    amountMillimes: toMillimes(map.get(creditType) ?? 0n),
  }));
}

export interface AllocationInput {
  employeeId: string;
  creditType: CreditType;
  amountMillimes: number;
}

@Injectable()
export class CompanyService {
  /** Employee import previews (one process in development; a shared store when scaled out). */
  private readonly previews = new Map<
    string,
    { companyId: string; rows: ImportRow[]; expiresAt: number }
  >();

  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(InvitationService) private readonly invitations: InvitationService,
    @Inject(PiiService) private readonly pii: PiiService,
  ) {}

  private companyId(): string {
    const id = principal().companyId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  /** Balance of the company wallet of each type (never a single global balance). */
  async balances(tx: Tx, companyId: string): Promise<Map<CreditType, bigint>> {
    const refs = CREDIT_TYPES.map((type) => accounts.companyWallet(companyId, type));
    const found = await this.ledger.balances(tx, refs);
    return new Map(
      CREDIT_TYPES.map((type) => [
        type,
        found.get(accounts.companyWallet(companyId, type).code) ?? 0n,
      ]),
    );
  }

  /** Credits allocated this business month, per employee. */
  private async monthAllocated(
    tx: Tx,
    employeeIds: readonly string[],
  ): Promise<Map<string, bigint>> {
    if (employeeIds.length === 0) return new Map();
    const rows = await tx.allocation.groupBy({
      by: ['employeeId'],
      where: { employeeId: { in: [...employeeIds] }, createdAt: { gte: startOfBusinessMonth() } },
      _sum: { amountMillimes: true },
    });
    return new Map(rows.map((row) => [row.employeeId, row._sum.amountMillimes ?? 0n]));
  }

  /**
   * Invited employees whose temporary password expired before the first sign-in (request of
   * 2026-11-05). Read under the internal service role: a company never reads the accounts (0009).
   */
  private async expiredInvitations(tx: Tx, employeeIds: string[]): Promise<Set<string>> {
    if (employeeIds.length === 0) return new Set();
    const rows = await asService(tx, () =>
      tx.user.findMany({
        where: {
          employeeId: { in: employeeIds },
          mustChangePassword: true,
          tempPasswordExpiresAt: { lt: new Date() },
        },
        select: { employeeId: true },
      }),
    );
    return new Set(rows.flatMap((row) => (row.employeeId === null ? [] : [row.employeeId])));
  }

  private employeeBody(employee: Employee, allocated: bigint, invitationExpired = false) {
    return {
      id: employee.id,
      employeeNumber: employee.employeeNumber,
      firstName: employee.firstName,
      lastName: employee.lastName,
      email: employee.email,
      phone: this.pii.open(employee.phone),
      status: employee.status,
      monthAllocatedMillimes: toMillimes(allocated),
      ...(invitationExpired ? { invitationExpired: true } : {}),
      ...(employee.departmentId === null ? {} : { departmentId: employee.departmentId }),
      ...(employee.graceUntil === null ? {} : { graceUntil: employee.graceUntil.toISOString() }),
    };
  }

  async dashboard() {
    const companyId = this.companyId();
    return this.db.user(async (tx) => {
      const balances = await this.balances(tx, companyId);
      const total = [...balances.values()].reduce((sum, value) => sum + value, 0n);
      // One transaction = one connection: its queries run one after the other.
      const employeesCount = await tx.employee.count();
      const activeEmployeesCount = await tx.employee.count({ where: { status: 'ACTIVE' } });
      const pendingOrdersCount = await tx.creditOrder.count({
        where: { status: { in: [...OPEN_ORDER_STATUSES] } },
      });
      const recent = await tx.creditOrder.findMany({
        include: { lines: true, events: true, company: { select: { name: true } } },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        take: 5,
      });
      const months = lastMonths(6);
      const since = startOfBusinessMonth(months[0]);
      const validated = await tx.creditOrderEvent.findMany({
        where: { action: 'VALIDATED', occurredAt: { gte: since } },
        include: { order: { select: { amountMillimes: true } } },
      });
      const allocations = await tx.allocation.findMany({
        where: { createdAt: { gte: since } },
        select: { amountMillimes: true, createdAt: true },
      });
      const monthOf = (date: Date) =>
        months.find((month, index) => {
          const next = months[index + 1];
          return (
            date >= startOfBusinessMonth(month) &&
            (next === undefined || date < startOfBusinessMonth(next))
          );
        });
      const flows = months.map((month) => ({ month, creditedMillimes: 0n, allocatedMillimes: 0n }));
      for (const event of validated) {
        const flow = flows.find((item) => item.month === monthOf(event.occurredAt));
        if (flow !== undefined) flow.creditedMillimes += event.order.amountMillimes;
      }
      for (const allocation of allocations) {
        const flow = flows.find((item) => item.month === monthOf(allocation.createdAt));
        if (flow !== undefined) flow.allocatedMillimes += allocation.amountMillimes;
      }
      const current = flows[flows.length - 1]?.allocatedMillimes ?? 0n;
      return {
        balances: balancesList(balances),
        walletBalanceMillimes: toMillimes(total),
        employeesCount,
        activeEmployeesCount,
        monthAllocatedMillimes: toMillimes(current),
        pendingOrdersCount,
        recentOrders: recent.map(orderSummary),
        monthlyFlows: flows.map((flow) => ({
          month: flow.month,
          creditedMillimes: toMillimes(flow.creditedMillimes),
          allocatedMillimes: toMillimes(flow.allocatedMillimes),
        })),
      };
    });
  }

  // ---------------------------------------------------------------- employees

  async employees(
    query: Record<string, unknown>,
    filters: { status?: EmployeeStatus; q?: string },
  ): Promise<Page<ReturnType<CompanyService['employeeBody']>>> {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const needle = filters.q?.trim();
      const where = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(needle === undefined || needle === ''
          ? {}
          : {
              OR: [
                { firstName: { contains: needle, mode: 'insensitive' as const } },
                { lastName: { contains: needle, mode: 'insensitive' as const } },
                { employeeNumber: { contains: needle, mode: 'insensitive' as const } },
                { email: { contains: needle, mode: 'insensitive' as const } },
              ],
            }),
      };
      const rows = await tx.employee.findMany({
        where,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const allocated = await this.monthAllocated(
        tx,
        rows.map((row) => row.id),
      );
      const count = request.withCount
        ? await tx.employee.count({ where, take: 10_001 })
        : undefined;
      const settings = await tx.platformSettings.findUniqueOrThrow({ where: { id: 1 } });
      const expired = await this.expiredInvitations(
        tx,
        rows.filter((row) => row.status === 'INVITED').map((row) => row.id),
      );
      return {
        ...this.paginator.page(
          request,
          rows.map((row) =>
            this.employeeBody(row, allocated.get(row.id) ?? 0n, expired.has(row.id)),
          ),
          filters,
          count,
        ),
        // Grace period a deactivation would apply (shown before confirming it).
        graceDays: settings.accountGraceDays,
      };
    });
  }

  /** One employee of the company (RLS: another company's employee is a 404). */
  async employee(id: string) {
    return this.db.user(async (tx) => {
      const employee = await tx.employee.findUnique({ where: { id } });
      if (employee === null) throw problems.notFound();
      const allocated = await this.monthAllocated(tx, [id]);
      return this.employeeBody(employee, allocated.get(id) ?? 0n);
    });
  }

  async createEmployee(input: {
    employeeNumber: string;
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
  }) {
    const companyId = this.companyId();
    const errors: { in: 'body'; pointer: string; code: 'REQUIRED' | 'INVALID_FORMAT' }[] = [];
    for (const field of FIELDS)
      if (input[field].trim() === '')
        errors.push({ in: 'body', pointer: `/${field}`, code: 'REQUIRED' });
    if (input.email.trim() !== '' && !EMAIL.test(input.email))
      errors.push({ in: 'body', pointer: '/email', code: 'INVALID_FORMAT' });
    if (input.phone.trim() !== '' && !PHONE.test(input.phone))
      errors.push({ in: 'body', pointer: '/phone', code: 'INVALID_FORMAT' });
    if (errors.length > 0) throw validationFailed(errors);
    const id = uuidv7();
    const firstName = input.firstName.trim();
    const lastName = input.lastName.trim();
    // Its sign-in account and invitation come with it (decision of 2026-10-14). The password is
    // hashed even for an address that already signs in: same answer, same time (securite S04).
    const [invitation] = await this.invitations.prepare([
      {
        role: 'EMPLOYEE',
        subRole: null,
        displayName: `${firstName} ${lastName.charAt(0)}.`,
        email: input.email,
        employeeId: id,
      },
    ]);
    const email = input.email.trim().toLowerCase();
    const taken = await this.db.system((tx) => this.invitations.emailsInUse(tx, [email]));
    const body = await this.db.user(async (tx) => {
      const exists = await tx.employee.findFirst({
        where: { OR: [{ employeeNumber: input.employeeNumber.trim() }, { email }] },
      });
      if (exists !== null) throw problems.conflict();
      const employee = await tx.employee.create({
        data: {
          id,
          companyId,
          employeeNumber: input.employeeNumber.trim(),
          firstName,
          lastName,
          email,
          phone: this.pii.seal(input.phone.trim()),
          status: 'INVITED',
        },
      });
      // An address that already signs in elsewhere: employee without account, holder told.
      if (invitation !== undefined && !taken.has(email))
        await this.invitations.create(tx, [invitation]);
      await this.audit.record(tx, 'employees.create', `${employee.firstName} ${employee.lastName}`);
      return this.employeeBody(employee, 0n);
    });
    if (taken.has(email)) await this.invitations.notifyExisting([email]);
    else if (invitation !== undefined) await this.invitations.deliver([invitation]);
    return body;
  }

  async previewEmployees(csv: string) {
    const companyId = this.companyId();
    // Duplicates of the company only: whether an address signs in elsewhere is never shown
    // (securite B5-S04), confirmImport handles it.
    return this.db.user(async (tx) => {
      const existing = await tx.employee.findMany({
        select: { employeeNumber: true, email: true },
      });
      const numbers = new Set(existing.map((row) => row.employeeNumber));
      const emails = new Set(existing.map((row) => row.email));
      const rows: ImportRow[] = [];
      const seenNumbers = new Set<string>();
      const seenEmails = new Set<string>();
      csv.split(/\r?\n/).forEach((raw, index) => {
        const line = raw.trim();
        if (line === '' || (index === 0 && /matricule|employeeNumber/i.test(line))) return;
        // Formula characters are neutralised (CSV injection), except in a phone number that
        // matches the strict E.164 format: it cannot hold a formula, and its "+" is required.
        const cells = line
          .split(/[;,]/)
          .map((cell, column) =>
            column === 4 && PHONE.test(cell.trim()) ? cell.trim() : neutralise(cell.trim()),
          );
        const [employeeNumber = '', firstName = '', lastName = '', email = '', phone = ''] = cells;
        const values = { employeeNumber, firstName, lastName, email, phone };
        const issues: ImportRow['issues'] = [];
        for (const field of FIELDS)
          if (values[field] === '') issues.push({ field, code: 'REQUIRED' });
        if (email !== '' && !EMAIL.test(email))
          issues.push({ field: 'email', code: 'INVALID_FORMAT' });
        if (phone !== '' && !PHONE.test(phone))
          issues.push({ field: 'phone', code: 'INVALID_FORMAT' });
        if (seenNumbers.has(employeeNumber) || seenEmails.has(email.toLowerCase())) {
          issues.push({ field: 'employeeNumber', code: 'DUPLICATE_IN_FILE' });
        } else if (numbers.has(employeeNumber) || emails.has(email.toLowerCase())) {
          issues.push({ field: 'employeeNumber', code: 'ALREADY_EXISTS' });
        }
        seenNumbers.add(employeeNumber);
        seenEmails.add(email.toLowerCase());
        rows.push({ line: index + 1, employeeNumber, firstName, lastName, email, phone, issues });
      });
      if (rows.length > 5_000)
        throw validationFailed([{ in: 'body', pointer: '/csv', code: 'TOO_LONG' }]);
      const previewId = randomUUID();
      const now = Date.now();
      for (const [id, preview] of this.previews)
        if (preview.expiresAt < now) this.previews.delete(id);
      this.previews.set(previewId, { companyId, rows, expiresAt: now + PREVIEW_TTL_MS });
      const errorCount = rows.filter((row) => row.issues.length > 0).length;
      return {
        previewId,
        rows,
        validCount: rows.length - errorCount,
        errorCount,
        duplicateCount: rows.filter((row) =>
          row.issues.some(
            (issue) => issue.code === 'DUPLICATE_IN_FILE' || issue.code === 'ALREADY_EXISTS',
          ),
        ).length,
      };
    });
  }

  async confirmImport(previewId: string) {
    const companyId = this.companyId();
    const preview = this.previews.get(previewId);
    if (preview?.companyId !== companyId || preview.expiresAt < Date.now()) {
      throw problems.conflict();
    }
    this.previews.delete(previewId);
    const inUse = await this.db.system((tx) =>
      this.invitations.emailsInUse(
        tx,
        preview.rows.map((row) => row.email),
      ),
    );
    const valid = preview.rows
      .filter((row) => row.issues.length === 0)
      .map((row) => ({ ...row, id: uuidv7() }));
    // Accounts and invitations of the imported employees (hashing before the SQL transaction).
    // An address that already signs in elsewhere: employee without account, holder told; hashed
    // all the same, so that neither the answer nor the time tells it (securite B5-S04).
    const prepared = await this.invitations.prepare(
      valid.map((row) => ({
        role: 'EMPLOYEE' as const,
        subRole: null,
        displayName: `${row.firstName} ${row.lastName.charAt(0)}.`,
        email: row.email,
        employeeId: row.id,
      })),
    );
    const created = await this.db.user(async (tx) => {
      const existing = await tx.employee.findMany({
        select: { employeeNumber: true, email: true },
      });
      const numbers = new Set(existing.map((row) => row.employeeNumber));
      const emails = new Set(existing.map((row) => row.email));
      const fresh = valid.filter(
        (row) => !numbers.has(row.employeeNumber) && !emails.has(row.email.toLowerCase()),
      );
      await tx.employee.createMany({
        data: fresh.map((row) => ({
          id: row.id,
          companyId,
          employeeNumber: row.employeeNumber,
          firstName: row.firstName,
          lastName: row.lastName,
          email: row.email.toLowerCase(),
          phone: this.pii.seal(row.phone),
          status: 'INVITED' as const,
        })),
      });
      const taken = fresh.filter((row) => inUse.has(row.email.toLowerCase()));
      const ids = new Set(fresh.filter((row) => !taken.includes(row)).map((row) => row.id));
      const invited = prepared.filter((item) => ids.has(item.invitee.employeeId ?? ''));
      await this.invitations.create(tx, invited);
      await this.audit.record(tx, 'employees.import', `${String(fresh.length)} employés`);
      return { invited, notified: taken.map((row) => row.email), count: fresh.length };
    });
    await this.invitations.deliver(created.invited);
    await this.invitations.notifyExisting(created.notified);
    return { createdCount: created.count };
  }

  // ---------------------------------------------------------------- allocation

  async previewAllocations(csv: string) {
    return this.db.user(async (tx) => {
      const employees = await tx.employee.findMany({
        select: { id: true, employeeNumber: true, firstName: true, lastName: true },
      });
      const byNumber = new Map(employees.map((employee) => [employee.employeeNumber, employee]));
      const enabled = await this.settings.enabledTypes(tx);
      const rows: {
        line: number;
        employeeNumber: string;
        employeeName?: string;
        amounts: { creditType: CreditType; amountMillimes: number }[];
        issues: ('UNKNOWN_EMPLOYEE' | 'INVALID_AMOUNT' | 'NO_AMOUNT' | 'TYPE_DISABLED')[];
      }[] = [];
      const lines: AllocationInput[] = [];
      const totals = new Map<CreditType, bigint>();
      csv.split(/\r?\n/).forEach((raw, index) => {
        const line = raw.trim();
        if (line === '' || (index === 0 && /matricule|employeeNumber/i.test(line))) return;
        const [employeeNumber = '', ...cells] = line.split(/[;,\t]/).map((cell) => cell.trim());
        const employee = byNumber.get(employeeNumber);
        const issues: (typeof rows)[number]['issues'] = [];
        if (employee === undefined) issues.push('UNKNOWN_EMPLOYEE');
        const amounts = CREDIT_TYPES.map((creditType, position) => ({
          creditType,
          amount: csvMillimes(cells[position] ?? ''),
        }));
        if (amounts.some((item) => item.amount === null)) issues.push('INVALID_AMOUNT');
        const positive = amounts.filter(
          (item): item is { creditType: CreditType; amount: bigint } =>
            item.amount !== null && item.amount > 0n,
        );
        if (positive.length === 0 && !issues.includes('INVALID_AMOUNT')) issues.push('NO_AMOUNT');
        if (positive.some((item) => !enabled.has(item.creditType))) issues.push('TYPE_DISABLED');
        rows.push({
          line: index + 1,
          employeeNumber,
          ...(employee === undefined
            ? {}
            : { employeeName: `${employee.firstName} ${employee.lastName}` }),
          amounts: amounts.map((item) => ({
            creditType: item.creditType,
            amountMillimes: toMillimes(item.amount ?? 0n),
          })),
          issues,
        });
        if (issues.length === 0 && employee !== undefined) {
          for (const item of positive) {
            lines.push({
              employeeId: employee.id,
              creditType: item.creditType,
              amountMillimes: toMillimes(item.amount),
            });
            totals.set(item.creditType, (totals.get(item.creditType) ?? 0n) + item.amount);
          }
        }
      });
      const errorCount = rows.filter((row) => row.issues.length > 0).length;
      return {
        rows: rows.slice(0, 500),
        lines,
        totals: balancesList(totals),
        validCount: rows.length - errorCount,
        errorCount,
      };
    });
  }

  /**
   * Allocation (financial, idempotent): each line debits the company wallet of ITS type and
   * credits the employee wallet of that type, with an expiring lot (validity of the type). One
   * ledger transaction for the whole request.
   */
  async allocate(tx: Tx, lines: readonly AllocationInput[], key: string) {
    const who = principal();
    const companyId = this.companyId();
    const enabled = await this.settings.enabledTypes(tx);
    if (lines.some((line) => !enabled.has(line.creditType))) {
      throw validationFailed([{ in: 'body', pointer: '/allocations', code: 'INVALID_ENUM' }]);
    }
    const employees = await tx.employee.findMany({
      where: { id: { in: [...new Set(lines.map((line) => line.employeeId))] } },
    });
    const known = new Map(employees.map((employee) => [employee.id, employee]));
    // Unknown (or other company: RLS hides it), suspended or deactivated employee: the whole
    // request is refused (decision e3).
    if (
      lines.some((line) => {
        const employee = known.get(line.employeeId);
        return employee === undefined || !canReceiveCredits(employee);
      })
    ) {
      throw problems.conflict();
    }
    const perType = new Map<CreditType, bigint>();
    const perWallet = new Map<
      string,
      { employeeId: string; creditType: CreditType; amount: bigint }
    >();
    for (const line of lines) {
      const amount = fromMillimes(line.amountMillimes);
      perType.set(line.creditType, (perType.get(line.creditType) ?? 0n) + amount);
      const key2 = `${line.employeeId}:${line.creditType}`;
      const current = perWallet.get(key2);
      perWallet.set(key2, {
        employeeId: line.employeeId,
        creditType: line.creditType,
        amount: (current?.amount ?? 0n) + amount,
      });
    }
    let posted;
    try {
      posted = await this.ledger.post(tx, {
        type: 'ALLOCATION',
        reference: `ALLOC-${key.slice(0, 8)}`,
        tenantId: companyId,
        userId: who.userId,
        idempotencyKey: key,
        entries: [
          ...[...perType].map(([type, amount]) => ({
            account: accounts.companyWallet(companyId, type),
            direction: 'D' as const,
            amount,
          })),
          ...[...perWallet.values()].map((wallet) => ({
            account: accounts.employeeWallet(wallet.employeeId, wallet.creditType),
            direction: 'C' as const,
            amount: wallet.amount,
          })),
        ],
      });
    } catch (error) {
      if (error instanceof InsufficientFundsError) {
        throw new ApiProblem(422, 'INSUFFICIENT_FUNDS', {
          missingMillimes: toMillimes(error.missing),
        });
      }
      throw error;
    }
    const types = await this.settings.creditTypes(tx);
    const now = new Date();
    for (const wallet of perWallet.values()) {
      const validity =
        types.find((row) => row.creditType === wallet.creditType)?.validityMonths ?? 12;
      await this.ledger.addLot(tx, {
        account: accounts.employeeWallet(wallet.employeeId, wallet.creditType),
        creditType: wallet.creditType,
        amount: wallet.amount,
        expiresAt: addMonths(now, validity),
        sourceTransactionId: posted.transactionId,
      });
    }
    await tx.allocation.createMany({
      data: lines.map((line) => ({
        id: uuidv7(),
        companyId,
        employeeId: line.employeeId,
        creditType: line.creditType,
        amountMillimes: fromMillimes(line.amountMillimes),
        transactionId: posted.transactionId,
      })),
    });
    await this.audit.record(tx, 'credits.allocate', `${String(lines.length)} lignes`);
    const balances = await this.balances(tx, companyId);
    return {
      balances: balancesList(balances),
      allocatedCount: lines.length,
      allocatedMillimes: toMillimes([...perType.values()].reduce((sum, value) => sum + value, 0n)),
      walletBalanceMillimes: toMillimes(
        [...balances.values()].reduce((sum, value) => sum + value, 0n),
      ),
    };
  }

  /**
   * PDF of an invoice of the company (task 10): the credits ordered by type, the commission at
   * the rate of its tranche, the VAT on the commission, the stamp duty and the total, as frozen in
   * the order. Generated on download from the stored figures (RLS: the company of the session).
   */
  async invoicePdf(id: string): Promise<{ data: Buffer; fileName: string }> {
    return this.db.user(async (tx) => {
      const invoice = await tx.invoice.findUnique({
        where: { id },
        include: { order: { include: { lines: true } }, company: { select: { name: true, city: true } } },
      });
      if (invoice === null) throw problems.notFound();
      const order = invoice.order;
      const lines: PdfLine[] = [
        { text: 'FlexiPay', bold: true, size: 18 },
        { text: 'Titres-restaurant dématérialisés', size: 9 },
        { text: `Facture ${invoice.number}`, bold: true, size: 14, gap: 24 },
        { text: `Date : ${dateFr(invoice.issuedAt)}` },
        { text: `Commande : ${order.reference} · Référence de virement : ${order.paymentReference}` },
        { text: `Client : ${invoice.company.name}, ${invoice.company.city}`, gap: 12 },
        { text: 'Détail', bold: true, gap: 20 },
        ...order.lines.map((line) => ({
          text: `Crédits ${TYPE_LABEL[line.creditType]}`,
          right: tnd(line.amountMillimes),
        })),
        { text: 'Montant des crédits', right: tnd(order.amountMillimes), bold: true, gap: 8 },
        { text: `Commission FlexiPay (${percent(order.feeRateBps)})`, right: tnd(order.feesMillimes) },
        { text: `TVA sur la commission (${percent(order.vatRateBps)})`, right: tnd(order.vatMillimes) },
        ...(order.withholdingMillimes > 0n
          ? [
              {
                text: `Retenue à la source (${percent(order.withholdingRateBps)} de la commission)`,
                right: tnd(order.withholdingMillimes),
              },
            ]
          : []),
        { text: 'Timbre fiscal', right: tnd(order.stampDutyMillimes) },
        { text: 'Frais de virement', right: tnd(order.transferFeeMillimes) },
        { text: 'Total à payer', right: tnd(order.totalMillimes), bold: true, size: 12, gap: 10 },
        { text: `Statut : ${invoice.status === 'PAID' ? 'payée' : 'à payer'}`, gap: 16 },
        {
          text: 'Montants en dinars tunisiens (TND), au millime. Document généré par FlexiPay.',
          size: 8,
          gap: 30,
        },
      ];
      return { data: pdfDocument(`Facture ${invoice.number}`, lines), fileName: `${invoice.number}.pdf` };
    });
  }

  async invoices(query: Record<string, unknown>) {
    const request = this.paginator.request(query, {});
    return this.db.user(async (tx) => {
      const where = {
        // Issued invoices, and the cancelled ones with their credit note.
        OR: [
          {
            order: {
              status: {
                notIn: ['CANCELLED' as const, 'REFUSED' as const, 'AWAITING_CONFIRMATION' as const],
              },
            },
          },
          { status: 'CANCELLED' as const },
        ],
        ...(request.createdFrom === undefined && request.createdTo === undefined
          ? {}
          : {
              issuedAt: {
                ...(request.createdFrom === undefined ? {} : { gte: request.createdFrom }),
                ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
              },
            }),
      };
      const rows = await tx.invoice.findMany({
        where,
        include: { order: { select: { reference: true } } },
        orderBy: [{ issuedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.invoice.count({ where, take: 10_001 }) : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: row.id,
          number: row.number,
          orderReference: row.order.reference,
          totalMillimes: toMillimes(row.totalMillimes),
          issuedAt: row.issuedAt.toISOString(),
          status: row.status,
          ...(row.creditNoteNumber === null ? {} : { creditNoteNumber: row.creditNoteNumber }),
          ...(row.cancelledAt === null ? {} : { cancelledAt: row.cancelledAt.toISOString() }),
        })),
        {},
        count,
      );
    });
  }
}
