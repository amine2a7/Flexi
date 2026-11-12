import { Inject, Injectable } from '@nestjs/common';
import { canReceiveCredits } from '../common/account-lifecycle.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { fromMillimes, toMillimes } from '../common/money.js';
import { problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
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
}

export interface PreviewInput {
  templateId?: string;
  departmentId?: string | null;
  position?: string | null;
  q?: string;
  employeeIds?: readonly string[];
  amounts: readonly TypeAmount[];
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
