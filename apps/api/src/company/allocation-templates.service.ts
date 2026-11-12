import { createHash } from 'node:crypto';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { canReceiveCredits } from '../common/account-lifecycle.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { fromMillimes, toMillimes } from '../common/money.js';
import { permissionsOf } from '../common/permissions.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal, runWithContext } from '../common/request-context.js';
import { businessDay, businessMonth } from '../common/tunis.js';
import type { CreditType, Prisma } from '../generated/prisma/client.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';
import { CompanyService } from './company.service.js';

export interface TypeAmount {
  creditType: CreditType;
  amountMillimes: number;
}

export interface TemplateInput {
  name: string;
  departmentId: string | null;
  position: string | null;
  amounts: readonly TypeAmount[];
  /** Day of the month (1 to 28) of the automatic relaunch; null = by hand; absent = unchanged. */
  autoMonthlyDay?: number | null;
}

export interface PreviewInput {
  templateId?: string;
  departmentId?: string | null;
  position?: string | null;
  q?: string;
  employeeIds?: readonly string[];
  amounts: readonly TypeAmount[];
}

/** Outcome kept on the template when its day was set after that day of the current month. */
const NOT_DUE = 'NOT_DUE';
/** Another process already relaunched the template this month: nothing written. */
const ALREADY = 'ALREADY';

/** A unique index refused the row (Postgres 23505, through Prisma or a raw query). */
function isUniqueViolation(error: unknown): boolean {
  if (typeof error !== 'object' || error === null) return false;
  const found = error as { code?: unknown; meta?: { code?: unknown }; message?: unknown };
  return (
    found.code === 'P2002' ||
    found.code === '23505' ||
    found.meta?.code === '23505' ||
    (typeof found.message === 'string' && found.message.includes('23505'))
  );
}

/**
 * Idempotency key of the automatic relaunch of a template for a month: the same for every run of
 * the job that month, so the ledger posts it once whatever happens (several API processes).
 */
export function monthlyKey(templateId: string, month: string): string {
  const hex = createHash('sha256').update(`template-auto:${templateId}:${month}`).digest('hex');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

/**
 * The day is set after it has passed this month: the first automatic run is next month (setting
 * the 5th on the 12th never allocates at once).
 */
function firstRun(day: number | null | undefined, now = new Date()) {
  if (day === undefined) return {};
  if (day === null) return { autoMonthlyDay: null };
  const today = Number(businessDay(now).slice(8, 10));
  return {
    autoMonthlyDay: day,
    ...(day <= today ? { lastAutoRunMonth: businessMonth(now), lastAutoRunStatus: NOT_DUE } : {}),
  };
}

/** At most this many employees in one allocation (contract: 5 000 lines). */
const MAX_EMPLOYEES = 5_000;

export const withTemplateAmounts = {
  amounts: true,
  department: { select: { name: true } },
} satisfies Prisma.AllocationTemplateInclude;
type TemplateRow = Prisma.AllocationTemplateGetPayload<{ include: typeof withTemplateAmounts }>;

/** Amounts in the order of the credit types, whatever the order of the request. */
function ordered<T extends { creditType: CreditType }>(rows: readonly T[]): T[] {
  return [...rows].sort(
    (a, b) => CREDIT_TYPES.indexOf(a.creditType) - CREDIT_TYPES.indexOf(b.creditType),
  );
}

export function templateView(row: TemplateRow) {
  return {
    id: row.id,
    name: row.name,
    departmentId: row.departmentId,
    departmentName: row.department?.name ?? null,
    position: row.position,
    amounts: ordered(row.amounts).map((amount) => ({
      creditType: amount.creditType,
      amountMillimes: toMillimes(amount.amountMillimes),
    })),
    lastRunAt: row.lastRunAt?.toISOString() ?? null,
    autoMonthlyDay: row.autoMonthlyDay,
    // NOT_DUE marks the month in which the day was set after it had passed: nothing ran.
    lastAutoRun:
      row.lastAutoRunMonth === null ||
      row.lastAutoRunStatus === null ||
      row.lastAutoRunStatus === NOT_DUE
        ? null
        : { month: row.lastAutoRunMonth, status: row.lastAutoRunStatus },
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

/**
 * Processus v2 (processus 4): the company picks its employees with filters (department,
 * position), gives an amount per credit type, previews the totals against its balances, and
 * saves the filters and amounts as a template to relaunch with the CURRENT employees. RLS keeps
 * each company to its own templates, departments and employees (another one's: 404).
 */
@Injectable()
export class AllocationTemplatesService {
  private readonly logger = new Logger('TemplatesAuto');

  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(CompanyService) private readonly company: CompanyService,
  ) {}

  private companyId(): string {
    const id = principal().companyId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  async list() {
    this.companyId();
    return this.db.user(async (tx) => {
      const rows = await tx.allocationTemplate.findMany({
        where: { archivedAt: null },
        include: withTemplateAmounts,
        orderBy: { name: 'asc' },
        take: 200,
      });
      return { data: rows.map(templateView) };
    });
  }

  async create(input: TemplateInput) {
    const companyId = this.companyId();
    return this.db.user(async (tx) => {
      await this.check(tx, input, null);
      const id = uuidv7();
      await tx.allocationTemplate.create({
        data: {
          id,
          companyId,
          name: input.name,
          departmentId: input.departmentId,
          position: input.position,
          ...firstRun(input.autoMonthlyDay ?? null),
          createdBy: principal().userId,
          amounts: { create: this.amountRows(companyId, input.amounts) },
        },
      });
      await this.audit.record(tx, 'allocationTemplates.create', input.name);
      return templateView(await this.found(tx, id));
    });
  }

  async update(id: string, input: TemplateInput) {
    const companyId = this.companyId();
    return this.db.user(async (tx) => {
      await this.found(tx, id);
      await this.check(tx, input, id);
      await tx.allocationTemplateAmount.deleteMany({ where: { templateId: id } });
      await tx.allocationTemplate.update({
        where: { id },
        data: {
          name: input.name,
          departmentId: input.departmentId,
          position: input.position,
          ...firstRun(input.autoMonthlyDay),
          updatedAt: new Date(),
          amounts: { create: this.amountRows(companyId, input.amounts) },
        },
      });
      await this.audit.record(tx, 'allocationTemplates.update', input.name);
      return templateView(await this.found(tx, id));
    });
  }

  /** « Supprimer »: archived (gone from the list), the allocations made with it keep it. */
  async archive(id: string): Promise<void> {
    this.companyId();
    await this.db.user(async (tx) => {
      const template = await this.found(tx, id);
      await tx.allocationTemplate.update({ where: { id }, data: { archivedAt: new Date() } });
      await this.audit.record(tx, 'allocationTemplates.archive', template.name);
    });
  }

  /** « Fiche client › Modèles »: an administrator archives a template of this company only. */
  async archiveAsAdmin(companyId: string, id: string): Promise<void> {
    await this.db.system(async (tx) => {
      const template = await tx.allocationTemplate.findFirst({
        where: { id, companyId, archivedAt: null },
      });
      if (template === null) throw problems.notFound();
      await tx.allocationTemplate.update({ where: { id }, data: { archivedAt: new Date() } });
      await this.audit.record(tx, 'allocationTemplates.archive', template.name);
    });
  }

  /** A live template of the company (archived or another company's: 404). */
  async found(tx: Tx, id: string): Promise<TemplateRow> {
    const row = await tx.allocationTemplate.findFirst({
      where: { id, archivedAt: null },
      include: withTemplateAmounts,
    });
    if (row === null) throw problems.notFound();
    return row;
  }

  /** Marks the relaunch of a template (inside the allocation's transaction). */
  async ran(tx: Tx, id: string): Promise<void> {
    await this.found(tx, id);
    await tx.allocationTemplate.update({ where: { id }, data: { lastRunAt: new Date() } });
  }

  /**
   * Monthly relaunch (processus v2, decision of 2026-11-12): every template whose day has come
   * this month and that has not run this month is relaunched AS ITS AUTHOR (still an active user
   * of the company allowed to allocate), for the current employees of its filters. Never over the
   * balance: nothing moves and the template keeps the refusal; the company relaunches by hand.
   * Returns the number of templates relaunched.
   */
  async runMonthly(now = new Date()): Promise<number> {
    const month = businessMonth(now);
    const day = Number(businessDay(now).slice(8, 10));
    const due = await this.db.system((tx) =>
      tx.allocationTemplate.findMany({
        where: {
          archivedAt: null,
          autoMonthlyDay: { not: null, lte: day },
          OR: [{ lastAutoRunMonth: null }, { lastAutoRunMonth: { not: month } }],
        },
        select: { id: true, companyId: true, createdBy: true, name: true },
      }),
    );
    let done = 0;
    for (const template of due) {
      const status = await this.runOne(template, month);
      // DONE is written inside the allocation's own transaction; another process already took
      // this month: nothing to write.
      if (status === 'DONE') {
        done += 1;
        await this.db.system((tx) =>
          this.audit.record(
            tx,
            'allocationTemplates.autoRun',
            `${template.name} ${month} DONE`,
            'Système',
          ),
        );
        continue;
      }
      if (status === ALREADY) continue;
      // A refusal never overwrites the month a run has already taken (ledger-auditor, Haute).
      await this.db.system(async (tx) => {
        const kept = await tx.allocationTemplate.updateMany({
          where: {
            id: template.id,
            OR: [{ lastAutoRunMonth: null }, { lastAutoRunMonth: { not: month } }],
          },
          data: { lastAutoRunMonth: month, lastAutoRunStatus: status },
        });
        if (kept.count > 0)
          await this.audit.record(
            tx,
            'allocationTemplates.autoRun',
            `${template.name} ${month} ${status}`,
            'Système',
          );
      });
    }
    return done;
  }

  private async runOne(
    template: { id: string; companyId: string; createdBy: string },
    month: string,
  ): Promise<string> {
    const author = await this.db.system((tx) =>
      tx.user.findUnique({ where: { id: template.createdBy } }),
    );
    if (
      author?.status !== 'ACTIVE' ||
      author.companyId !== template.companyId ||
      !permissionsOf(author.role, author.subRole).includes('credits.allocate')
    ) {
      return 'AUTHOR_UNAVAILABLE';
    }
    const context = {
      requestId: `template-auto-${template.id}`,
      ip: 'system',
      principal: {
        userId: author.id,
        sessionId: '00000000-0000-0000-0000-000000000000',
        role: author.role,
        subRole: author.subRole,
        displayName: author.displayName,
        step: 'NONE' as const,
        companyId: author.companyId,
        merchantId: null,
        employeeId: null,
      },
    };
    return runWithContext(context, async () => {
      try {
        const preview = await this.preview({ templateId: template.id, amounts: [] });
        if (preview.employeeCount === 0) return 'NO_EMPLOYEE';
        if (!preview.sufficient) return 'INSUFFICIENT_FUNDS';
        const lines = preview.employees.flatMap((employee) =>
          preview.lines.map((line) => ({
            employeeId: employee.id,
            creditType: line.creditType,
            amountMillimes: line.perEmployeeMillimes,
          })),
        );
        return await this.db.user(async (tx) => {
          // The month is taken in the transaction that allocates: a second process waits on this
          // row, then finds the month taken and leaves without writing anything.
          const taken = await tx.$executeRaw`
            UPDATE allocation_templates
               SET last_auto_run_month = ${month}, last_auto_run_status = 'DONE'
             WHERE id = ${template.id}::uuid AND last_auto_run_month IS DISTINCT FROM ${month}`;
          if (taken === 0) return ALREADY;
          await this.ran(tx, template.id);
          await this.company.allocate(tx, lines, monthlyKey(template.id, month), template.id);
          return 'DONE';
        });
      } catch (error) {
        // The balance moved since the preview: refused as a whole, nothing posted.
        if (error instanceof ApiProblem && error.code === 'INSUFFICIENT_FUNDS') {
          return 'INSUFFICIENT_FUNDS';
        }
        // The key of this month is already in the ledger: it was posted, never twice.
        if (isUniqueViolation(error)) return ALREADY;
        this.logger.error(
          `template auto run failed: ${error instanceof Error ? error.constructor.name : 'unknown'}`,
        );
        return 'FAILED';
      }
    });
  }

  /**
   * Preview (step 4): the employees who would receive the credits (the filters, a template's
   * filters or an explicit list; only those who can receive credits), the total per type, the
   * balance of the company per type, what remains after and what is missing (shown in red).
   * Without amounts, it only resolves the employees (« Tout sélectionner »).
   */
  async preview(input: PreviewInput) {
    const companyId = this.companyId();
    return this.db.user(async (tx) => {
      const typed = input.position?.trim() ?? '';
      let filters = {
        departmentId: input.departmentId ?? null,
        position: typed === '' ? null : typed,
      };
      let amounts: readonly TypeAmount[] = input.amounts;
      if (input.templateId !== undefined) {
        const template = await this.found(tx, input.templateId);
        filters = { departmentId: template.departmentId, position: template.position };
        if (amounts.length === 0) amounts = templateView(template).amounts;
      }
      if (filters.departmentId !== null) {
        const department = await tx.department.findUnique({ where: { id: filters.departmentId } });
        if (department === null) throw problems.notFound();
      }
      await this.checkTypes(tx, amounts);
      const q = input.q?.trim() ?? '';
      const rows = await tx.employee.findMany({
        where: {
          status: { in: ['ACTIVE', 'INVITED'] },
          ...(input.employeeIds === undefined ? {} : { id: { in: [...input.employeeIds] } }),
          ...(filters.departmentId === null ? {} : { departmentId: filters.departmentId }),
          ...(filters.position === null
            ? {}
            : { position: { equals: filters.position.trim(), mode: 'insensitive' as const } }),
          ...(q === ''
            ? {}
            : {
                OR: [
                  { firstName: { contains: q, mode: 'insensitive' as const } },
                  { lastName: { contains: q, mode: 'insensitive' as const } },
                  { employeeNumber: { contains: q, mode: 'insensitive' as const } },
                ],
              }),
        },
        include: { department: { select: { name: true } } },
        orderBy: [{ lastName: 'asc' }, { firstName: 'asc' }],
        take: MAX_EMPLOYEES + 1,
      });
      const employees = rows.filter(canReceiveCredits);
      if (employees.length > MAX_EMPLOYEES)
        throw validationFailed([{ in: 'body', pointer: '/employeeIds', code: 'TOO_LONG' }]);
      const balances = await this.company.balances(tx, companyId);
      const count = BigInt(employees.length);
      const lines = ordered(amounts).map((amount) => {
        const per = fromMillimes(amount.amountMillimes);
        const total = per * count;
        const balance = balances.get(amount.creditType) ?? 0n;
        return {
          creditType: amount.creditType,
          perEmployeeMillimes: toMillimes(per),
          totalMillimes: toMillimes(total),
          balanceMillimes: toMillimes(balance),
          remainingMillimes: toMillimes(balance > total ? balance - total : 0n),
          missingMillimes: toMillimes(total > balance ? total - balance : 0n),
        };
      });
      return {
        employees: employees.map((employee) => ({
          id: employee.id,
          employeeNumber: employee.employeeNumber,
          firstName: employee.firstName,
          lastName: employee.lastName,
          departmentName: employee.department?.name ?? null,
          position: employee.position,
        })),
        employeeCount: employees.length,
        lines,
        sufficient: lines.every((line) => line.missingMillimes === 0),
      };
    });
  }

  private amountRows(companyId: string, amounts: readonly TypeAmount[]) {
    return amounts.map((amount) => ({
      companyId,
      creditType: amount.creditType,
      amountMillimes: fromMillimes(amount.amountMillimes),
    }));
  }

  /** Each type once, enabled; a department of the company (never archived); a unique name. */
  private async check(tx: Tx, input: TemplateInput, id: string | null): Promise<void> {
    if (input.amounts.length === 0)
      throw validationFailed([{ in: 'body', pointer: '/amounts', code: 'TOO_SHORT' }]);
    await this.checkTypes(tx, input.amounts);
    if (input.departmentId !== null) {
      const department = await tx.department.findUnique({ where: { id: input.departmentId } });
      if (department === null) throw problems.notFound();
      if (department.archivedAt !== null) throw problems.conflict();
    }
    const taken = await tx.allocationTemplate.findFirst({
      where: {
        archivedAt: null,
        name: { equals: input.name, mode: 'insensitive' },
        ...(id === null ? {} : { NOT: { id } }),
      },
    });
    if (taken !== null) throw problems.conflict();
  }

  private async checkTypes(tx: Tx, amounts: readonly TypeAmount[]): Promise<void> {
    const types = amounts.map((amount) => amount.creditType);
    if (new Set(types).size !== types.length)
      throw validationFailed([{ in: 'body', pointer: '/amounts', code: 'INVALID_FORMAT' }]);
    const enabled = await this.settings.enabledTypes(tx);
    if (types.some((type) => !enabled.has(type)))
      throw validationFailed([{ in: 'body', pointer: '/amounts', code: 'INVALID_ENUM' }]);
  }
}
