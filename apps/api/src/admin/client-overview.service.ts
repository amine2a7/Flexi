import { Inject, Injectable } from '@nestjs/common';
import { DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { problems } from '../common/problem.js';
import { LedgerService, accounts } from '../ledger/ledger.service.js';
import { CREDIT_TYPES } from '../platform/settings.service.js';
import { templateView, withTemplateAmounts } from '../company/allocation-templates.service.js';

const LATEST = 50;

/**
 * Full client record (processus v2, « Fiche client complète »): one read per tab of a company
 * (users, departments, employees, balances, orders, allocations and templates, invoices) or of a
 * merchant (users, sales, payouts). Read-only; each line opens the page that carries its actions.
 * Platform RLS: an administrator reads every tenant; no secret, no RIB, no employee contact.
 */
@Injectable()
export class ClientOverviewService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
  ) {}

  private async users(tx: Tx, where: { companyId: string } | { merchantId: string }) {
    const rows = await tx.user.findMany({
      where: { ...where, employeeId: null },
      orderBy: { createdAt: 'asc' },
      take: 100,
    });
    return rows.map((row) => ({
      id: row.id,
      displayName: row.displayName,
      email: row.email,
      subRole: row.subRole,
      status: row.status,
      createdAt: row.createdAt.toISOString(),
    }));
  }

  private async kyc(tx: Tx, where: { companyId: string } | { merchantId: string }) {
    const file = await tx.kycFile.findFirst({ where, orderBy: { submittedAt: 'desc' } });
    return file === null ? null : { fileId: file.id, status: file.status };
  }

  async company(companyId: string) {
    return this.db.user(async (tx) => {
      const company = await tx.company.findUnique({ where: { id: companyId } });
      if (company === null) throw problems.notFound();
      const departments = await tx.department.findMany({
        where: { companyId },
        orderBy: { name: 'asc' },
        include: { _count: { select: { employees: true } } },
      });
      const employees = await tx.employee.findMany({
        where: { companyId, holderEmployeeId: null },
        orderBy: [{ lastName: 'asc' }, { firstName: 'asc' }],
        include: { department: { select: { name: true } } },
        take: 500,
      });
      const employeeCount = await tx.employee.count({
        where: { companyId, holderEmployeeId: null },
      });
      const found = await this.ledger.balances(
        tx,
        CREDIT_TYPES.map((type) => accounts.companyWallet(companyId, type)),
      );
      const balances = CREDIT_TYPES.map((creditType) => ({
        creditType,
        amountMillimes: toMillimes(
          found.get(accounts.companyWallet(companyId, creditType).code) ?? 0n,
        ),
      }));
      const orders = await tx.creditOrder.findMany({
        where: { companyId },
        orderBy: { createdAt: 'desc' },
        take: LATEST,
      });
      const groups = await tx.allocation.groupBy({
        by: ['transactionId', 'templateId'],
        where: { companyId },
        _sum: { amountMillimes: true },
        _count: { _all: true },
        _max: { createdAt: true },
        orderBy: { _max: { createdAt: 'desc' } },
        take: LATEST,
      });
      const templates = await tx.allocationTemplate.findMany({
        where: { companyId },
        include: withTemplateAmounts,
        orderBy: { name: 'asc' },
      });
      const invoices = await tx.invoice.findMany({
        where: { companyId },
        orderBy: { issuedAt: 'desc' },
        take: LATEST,
      });
      return {
        kyc: await this.kyc(tx, { companyId }),
        users: await this.users(tx, { companyId }),
        departments: departments.map((row) => ({
          id: row.id,
          name: row.name,
          employeeCount: row._count.employees,
          archived: row.archivedAt !== null,
        })),
        employeeCount,
        employees: employees.map((row) => ({
          id: row.id,
          employeeNumber: row.employeeNumber,
          firstName: row.firstName,
          lastName: row.lastName,
          departmentName: row.department?.name ?? null,
          position: row.position,
          status: row.status,
        })),
        balances,
        orders: orders.map((row) => ({
          id: row.id,
          reference: row.reference,
          status: row.status,
          amountMillimes: toMillimes(row.amountMillimes),
          totalMillimes: toMillimes(row.totalMillimes),
          createdAt: row.createdAt.toISOString(),
        })),
        allocations: groups.map((group) => ({
          transactionId: group.transactionId,
          allocatedAt: (group._max.createdAt ?? new Date(0)).toISOString(),
          lineCount: group._count._all,
          totalMillimes: toMillimes(group._sum.amountMillimes ?? 0n),
          templateName: templates.find((row) => row.id === group.templateId)?.name ?? null,
        })),
        templates: templates
          .filter((row) => row.archivedAt === null)
          .map((row) => templateView(row)),
        invoices: invoices.map((row) => ({
          id: row.id,
          number: row.number,
          status: row.status,
          totalMillimes: toMillimes(row.totalMillimes),
          issuedAt: row.issuedAt.toISOString(),
        })),
      };
    });
  }

  async merchant(merchantId: string) {
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUnique({ where: { id: merchantId } });
      if (merchant === null) throw problems.notFound();
      const sales = await tx.payment.findMany({
        where: { merchantId },
        orderBy: { createdAt: 'desc' },
        take: LATEST,
      });
      const payouts = await tx.payoutRequest.findMany({
        where: { merchantId },
        orderBy: { requestedAt: 'desc' },
        take: LATEST,
      });
      return {
        kyc: await this.kyc(tx, { merchantId }),
        users: await this.users(tx, { merchantId }),
        sales: sales.map((row) => ({
          id: row.id,
          reference: row.reference,
          creditType: row.creditType,
          amountMillimes: toMillimes(row.amountMillimes),
          status: row.status,
          createdAt: row.createdAt.toISOString(),
        })),
        payouts: payouts.map((row) => ({
          id: row.id,
          reference: row.reference,
          creditType: row.creditType,
          status: row.status,
          grossMillimes: toMillimes(row.grossMillimes),
          netMillimes: toMillimes(row.netMillimes),
          bankReference: row.bankReference,
          requestedAt: row.requestedAt.toISOString(),
        })),
      };
    });
  }
}
