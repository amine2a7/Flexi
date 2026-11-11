import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { ApiProblem, problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';

/**
 * Departments of a company (cahier ENT-04): a name, the employees attached to it. RLS keeps each
 * company to its own departments; an employee of another company is never found (404).
 */
@Injectable()
export class DepartmentsService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  private companyId(): string {
    const id = principal().companyId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  async list() {
    this.companyId();
    return this.db.user(async (tx) => {
      const rows = await tx.department.findMany({
        orderBy: { name: 'asc' },
        include: { _count: { select: { employees: true } } },
      });
      return {
        data: rows.map((row) => ({
          id: row.id,
          name: row.name,
          employeeCount: row._count.employees,
          archived: row.archivedAt !== null,
        })),
      };
    });
  }

  async create(name: string) {
    const companyId = this.companyId();
    return this.db.user(async (tx) => {
      const taken = await tx.department.findFirst({
        where: { name: { equals: name, mode: 'insensitive' } },
      });
      if (taken !== null) throw problems.conflict();
      const created = await tx.department.create({ data: { id: uuidv7(), companyId, name } });
      await this.audit.record(tx, 'departments.create', name);
      return { id: created.id, name: created.name, employeeCount: 0, archived: false };
    });
  }

  async rename(id: string, name: string) {
    this.companyId();
    return this.db.user(async (tx) => {
      const department = await tx.department.findUnique({
        where: { id },
        include: { _count: { select: { employees: true } } },
      });
      if (department === null) throw problems.notFound();
      const taken = await tx.department.findFirst({
        where: { name: { equals: name, mode: 'insensitive' }, NOT: { id } },
      });
      if (taken !== null) throw problems.conflict();
      await tx.department.update({ where: { id }, data: { name } });
      await this.audit.record(tx, 'departments.rename', name);
      return {
        id,
        name,
        employeeCount: department._count.employees,
        archived: department.archivedAt !== null,
      };
    });
  }

  /** Archived only when empty: otherwise a clear refusal (409, reason DEPARTMENT_NOT_EMPTY). */
  async archive(id: string) {
    this.companyId();
    return this.db.user(async (tx) => {
      await tx.$queryRaw`SELECT id FROM departments WHERE id = ${id}::uuid FOR UPDATE`;
      const department = await tx.department.findUnique({
        where: { id },
        include: { _count: { select: { employees: true } } },
      });
      if (department === null) throw problems.notFound();
      if (department._count.employees > 0)
        throw new ApiProblem(409, 'RESOURCE_STATE_CONFLICT', {
          reason: 'DEPARTMENT_NOT_EMPTY',
          employeeCount: department._count.employees,
        });
      await tx.department.update({ where: { id }, data: { archivedAt: new Date() } });
      await this.audit.record(tx, 'departments.archive', department.name);
      return { id, name: department.name, employeeCount: 0, archived: true };
    });
  }

  /** A department of the company, open to new employees (never an archived one). */
  async checkDepartment(tx: Tx, departmentId: string | null): Promise<void> {
    if (departmentId === null) return;
    const department = await tx.department.findUnique({ where: { id: departmentId } });
    if (department === null) throw problems.notFound();
    if (department.archivedAt !== null) throw problems.conflict();
  }

  /** Attaches an employee to a department of the company, or detaches it (`null`). */
  async assign(employeeId: string, departmentId: string | null) {
    const done = await this.assignMany([employeeId], { departmentId });
    return { employeeId, departmentId: done.departmentId ?? null };
  }

  /**
   * Department and/or position of one or several employees of the company (processus v2: the
   * record's « Modifier », and « Changer de département / de poste » on the selected rows).
   */
  async assignMany(
    employeeIds: readonly string[],
    change: { departmentId?: string | null; position?: string | null },
  ) {
    this.companyId();
    return this.db.user(async (tx) => {
      const found = await tx.employee.findMany({
        where: { id: { in: [...employeeIds] } },
        select: { id: true },
      });
      // RLS: an employee of another company is not found (404, never a partial change).
      if (found.length !== new Set(employeeIds).size) throw problems.notFound();
      if (change.departmentId !== undefined) await this.checkDepartment(tx, change.departmentId);
      const position =
        change.position === undefined
          ? undefined
          : change.position === null || change.position.trim() === ''
            ? null
            : change.position.trim();
      await tx.employee.updateMany({
        where: { id: { in: [...employeeIds] } },
        data: {
          ...(change.departmentId === undefined ? {} : { departmentId: change.departmentId }),
          ...(position === undefined ? {} : { position }),
        },
      });
      await this.audit.record(
        tx,
        'employees.assign',
        `${String(employeeIds.length)} employé(s)`,
      );
      return {
        employeeIds: [...employeeIds],
        ...(change.departmentId === undefined ? {} : { departmentId: change.departmentId }),
        ...(position === undefined ? {} : { position }),
      };
    });
  }

  /** Positions already used in the company, suggested while typing (processus v2). */
  async positions() {
    this.companyId();
    return this.db.user(async (tx) => {
      const rows = await tx.employee.findMany({
        where: { position: { not: null } },
        distinct: ['position'],
        select: { position: true },
        orderBy: { position: 'asc' },
        take: 200,
      });
      return { data: rows.flatMap((row) => (row.position === null ? [] : [row.position])) };
    });
  }
}
