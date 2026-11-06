import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService } from '../common/db.service.js';
import { problems } from '../common/problem.js';
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
      return { id: created.id, name: created.name, employeeCount: 0 };
    });
  }

  /** Attaches an employee to a department of the company, or detaches it (`null`). */
  async assign(employeeId: string, departmentId: string | null) {
    this.companyId();
    return this.db.user(async (tx) => {
      const employee = await tx.employee.findUnique({ where: { id: employeeId } });
      if (employee === null) throw problems.notFound();
      if (departmentId !== null) {
        const department = await tx.department.findUnique({ where: { id: departmentId } });
        if (department === null) throw problems.notFound();
      }
      await tx.employee.update({ where: { id: employeeId }, data: { departmentId } });
      await this.audit.record(
        tx,
        'departments.assign',
        `${employee.firstName} ${employee.lastName.slice(0, 1)}.`,
      );
      return { employeeId, departmentId };
    });
  }
}
