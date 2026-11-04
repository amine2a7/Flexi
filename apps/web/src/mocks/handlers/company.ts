import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { CREDIT_TYPES, balancesList, emptyBalances, type TypeBalances } from '../credit-types';
import { commissionOf, db, saveOrders, defaultRateOf, taxLines, taxesOf } from '../db';
import { COMPANY_TENANT } from '../fixtures/accounts';
import { OPEN_ORDER_STATUSES, orderSummary } from './orders';
import {
  apiUrl,
  audit,
  guardRead,
  guardWrite,
  isResponse,
  listParams,
  matches,
  paginate,
  problem,
  validationProblem,
} from './util';

type S = Schemas;

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE = /^\+216[0-9]{8}$/;
const FIELDS = ['employeeNumber', 'firstName', 'lastName', 'email', 'phone'] as const;

/** Neutralises spreadsheet formulas (`= + - @`) of an imported cell (SEC: CSV injection). */
function neutralise(value: string): string {
  return /^[=+\-@]/.test(value) ? `'${value}` : value;
}

function analyseCsv(csv: string): S['EmployeeImportPreview'] {
  const lines = csv.split(/\r?\n/).map((line) => line.trim());
  const rows: S['ImportRow'][] = [];
  const seenNumbers = new Set<string>();
  const seenEmails = new Set<string>();
  lines.forEach((line, index) => {
    if (line === '' || (index === 0 && /matricule|employeeNumber/i.test(line))) return;
    const cells = line.split(/[;,]/).map((cell) => neutralise(cell.trim()));
    const [employeeNumber = '', firstName = '', lastName = '', email = '', phone = ''] = cells;
    const issues: S['ImportIssue'][] = [];
    const values = { employeeNumber, firstName, lastName, email, phone };
    for (const field of FIELDS) if (values[field] === '') issues.push({ field, code: 'REQUIRED' });
    if (email !== '' && !EMAIL.test(email)) issues.push({ field: 'email', code: 'INVALID_FORMAT' });
    if (phone !== '' && !PHONE.test(phone)) issues.push({ field: 'phone', code: 'INVALID_FORMAT' });
    if (seenNumbers.has(employeeNumber) || seenEmails.has(email.toLowerCase())) {
      issues.push({ field: 'employeeNumber', code: 'DUPLICATE_IN_FILE' });
    } else if (
      db.company.employees.some(
        (employee) =>
          employee.employeeNumber === employeeNumber || employee.email === email.toLowerCase(),
      )
    ) {
      issues.push({ field: 'employeeNumber', code: 'ALREADY_EXISTS' });
    }
    seenNumbers.add(employeeNumber);
    seenEmails.add(email.toLowerCase());
    rows.push({ line: index + 1, employeeNumber, firstName, lastName, email, phone, issues });
  });
  const duplicateCount = rows.filter((row) =>
    row.issues.some(
      (issue) => issue.code === 'DUPLICATE_IN_FILE' || issue.code === 'ALREADY_EXISTS',
    ),
  ).length;
  const errorCount = rows.filter((row) => row.issues.length > 0).length;
  return {
    previewId: crypto.randomUUID(),
    rows,
    validCount: rows.length - errorCount,
    errorCount,
    duplicateCount,
  };
}

/** Six last months: credits from the validated demo orders, allocations seeded (current month real). */
function companyFlows(
  orders: readonly S['CreditOrderDetail'][],
  employees: readonly S['Employee'][],
): S['CompanyMonthlyFlow'][] {
  const now = new Date();
  return Array.from({ length: 6 }, (_, index) => {
    const date = new Date(now.getFullYear(), now.getMonth() - (5 - index), 1);
    const month = `${String(date.getFullYear())}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    const credited = orders
      .filter((order) => order.status === 'VALIDATED')
      .filter((order) =>
        order.history.some(
          (event) => event.action === 'VALIDATED' && event.occurredAt.startsWith(month),
        ),
      )
      .reduce((sum, order) => sum + order.amountMillimes, 0);
    const allocated =
      index === 5
        ? employees.reduce((sum, employee) => sum + employee.monthAllocatedMillimes, 0)
        : 9_200_000 + ((index * 3_571) % 7) * 310_000;
    return { month, creditedMillimes: credited, allocatedMillimes: allocated };
  });
}

const totalOf = (balances: TypeBalances) =>
  CREDIT_TYPES.reduce((sum, type) => sum + balances[type], 0);

const typeEnabled = (type: S['CreditType']) =>
  db.admin.settings.creditTypes.find((item) => item.creditType === type)?.enabled ?? false;

/** Order lines: distinct enabled types, at least 100 TND in all. */
function checkOrderLines(lines: readonly S['CreditOrderLine'][] | undefined): Response | undefined {
  if (lines === undefined || lines.length === 0) {
    return validationProblem([{ pointer: '/lines', code: 'REQUIRED' }]);
  }
  if (new Set(lines.map((line) => line.creditType)).size !== lines.length) {
    return validationProblem([{ pointer: '/lines', code: 'INVALID_FORMAT' }]);
  }
  if (lines.some((line) => !typeEnabled(line.creditType))) {
    return validationProblem([{ pointer: '/lines', code: 'INVALID_ENUM' }]);
  }
  if (lines.some((line) => !Number.isInteger(line.amountMillimes) || line.amountMillimes < 1)) {
    return validationProblem([{ pointer: '/lines', code: 'TOO_SMALL' }]);
  }
  const amount = lines.reduce((sum, line) => sum + line.amountMillimes, 0);
  if (amount < 100_000) return validationProblem([{ pointer: '/lines', code: 'TOO_SMALL' }]);
  return undefined;
}
export { checkOrderLines };

/** Amount typed in TND in a CSV cell (`45,500`, `45.5`, empty = 0), in millimes; NaN if invalid. */
function csvMillimes(cell: string): number {
  const value = cell.trim().replace(/\s/g, '');
  if (value === '') return 0;
  const match = /^(\d{1,9})(?:[.,](\d{1,3}))?$/.exec(value);
  if (match === null) return Number.NaN;
  return Number(match[1]) * 1000 + Number((match[2] ?? '').padEnd(3, '0'));
}

/** Allocation CSV: `matricule;restauration;habillement;carburant;cadeaux` (one column per type). */
function previewAllocations(csv: string): S['AllocationImportPreview'] {
  const rows: S['AllocationImportRow'][] = [];
  const lines: S['AllocationLine'][] = [];
  const totals = emptyBalances();
  csv.split(/\r?\n/).forEach((raw, index) => {
    const line = raw.trim();
    if (line === '' || (index === 0 && /matricule|employeeNumber/i.test(line))) return;
    const [employeeNumber = '', ...cells] = line.split(/[;,\t]/).map((cell) => cell.trim());
    const employee = db.company.employees.find((item) => item.employeeNumber === employeeNumber);
    const issues: S['AllocationImportRow']['issues'] = [];
    if (employee === undefined) issues.push('UNKNOWN_EMPLOYEE');
    const amounts = CREDIT_TYPES.map((creditType, position) => ({
      creditType,
      amountMillimes: csvMillimes(cells[position] ?? ''),
    }));
    if (amounts.some((item) => Number.isNaN(item.amountMillimes))) issues.push('INVALID_AMOUNT');
    const positive = amounts.filter((item) => item.amountMillimes > 0);
    if (positive.length === 0 && !issues.includes('INVALID_AMOUNT')) issues.push('NO_AMOUNT');
    if (positive.some((item) => !typeEnabled(item.creditType))) issues.push('TYPE_DISABLED');
    rows.push({
      line: index + 1,
      employeeNumber,
      ...(employee === undefined
        ? {}
        : { employeeName: `${employee.firstName} ${employee.lastName}` }),
      amounts: amounts.map((item) => ({
        creditType: item.creditType,
        amountMillimes: Number.isNaN(item.amountMillimes) ? 0 : item.amountMillimes,
      })),
      issues,
    });
    if (issues.length === 0 && employee !== undefined) {
      for (const item of positive) {
        lines.push({
          employeeId: employee.id,
          creditType: item.creditType,
          amountMillimes: item.amountMillimes,
        });
        totals[item.creditType] += item.amountMillimes;
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
}

export const companyHandlers = [
  http.get(apiUrl('/v1/company/dashboard'), async () => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const { employees, balances } = db.company;
    const orders = db.orders.filter((order) => order.companyId === COMPANY_TENANT.id);
    return HttpResponse.json<S['CompanyDashboard']>({
      balances: balancesList(balances),
      walletBalanceMillimes: totalOf(balances),
      employeesCount: employees.length,
      activeEmployeesCount: employees.filter((employee) => employee.status === 'ACTIVE').length,
      monthAllocatedMillimes: employees.reduce(
        (sum, employee) => sum + employee.monthAllocatedMillimes,
        0,
      ),
      pendingOrdersCount: orders.filter((order) => OPEN_ORDER_STATUSES.includes(order.status))
        .length,
      recentOrders: orders.slice(0, 5).map(orderSummary),
      monthlyFlows: companyFlows(orders, employees),
    });
  }),

  http.get(apiUrl('/v1/company/employees'), async ({ request }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const items = db.company.employees
      .filter((employee) => status === null || employee.status === status)
      .filter((employee) =>
        matches(
          query.get('q'),
          employee.firstName,
          employee.lastName,
          employee.employeeNumber,
          employee.email,
        ),
      );
    return HttpResponse.json<S['EmployeePage']>({ ...paginate(items, request), graceDays: 30 });
  }),

  http.post(apiUrl('/v1/company/employees'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['EmployeeCreate'];
    const errors: { pointer: string; code: S['FieldErrorCode'] }[] = [];
    for (const field of FIELDS)
      if (body[field].trim() === '') errors.push({ pointer: `/${field}`, code: 'REQUIRED' });
    if (!EMAIL.test(body.email)) errors.push({ pointer: '/email', code: 'INVALID_FORMAT' });
    if (!PHONE.test(body.phone)) errors.push({ pointer: '/phone', code: 'INVALID_FORMAT' });
    if (errors.length > 0) return validationProblem(errors);
    if (
      db.company.employees.some(
        (employee) =>
          employee.employeeNumber === body.employeeNumber ||
          employee.email === body.email.toLowerCase(),
      )
    ) {
      return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    const employee: S['Employee'] = {
      id: crypto.randomUUID(),
      ...body,
      email: body.email.toLowerCase(),
      status: 'INVITED',
      monthAllocatedMillimes: 0,
    };
    db.company.employees.unshift(employee);
    audit('employees.create', `${employee.firstName} ${employee.lastName}`);
    return HttpResponse.json<S['Employee']>(employee, { status: 201 });
  }),

  http.post(apiUrl('/v1/company/employees/import-previews'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['EmployeeImportRequest'];
    const preview = analyseCsv(body.csv);
    db.company.previews.set(preview.previewId, preview);
    return HttpResponse.json<S['EmployeeImportPreview']>(preview);
  }),

  http.post(apiUrl('/v1/company/employees/imports'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['EmployeeImportConfirm'];
    const preview = db.company.previews.get(body.previewId);
    if (preview === undefined) return problem(409, 'RESOURCE_STATE_CONFLICT');
    db.company.previews.delete(body.previewId);
    const valid = preview.rows.filter((row) => row.issues.length === 0);
    for (const row of valid) {
      db.company.employees.unshift({
        id: crypto.randomUUID(),
        employeeNumber: row.employeeNumber,
        firstName: row.firstName,
        lastName: row.lastName,
        email: row.email.toLowerCase(),
        phone: row.phone,
        status: 'INVITED',
        monthAllocatedMillimes: 0,
      });
    }
    audit('employees.import', `${String(valid.length)} employés`);
    return HttpResponse.json<S['EmployeeImportResult']>(
      { createdCount: valid.length },
      { status: 201 },
    );
  }),

  http.post(apiUrl('/v1/company/order-quotes'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['CreditOrderQuoteRequest'];
    const invalid = checkOrderLines(body.lines);
    if (invalid !== undefined) return invalid;
    const amount = body.lines.reduce((sum, line) => sum + line.amountMillimes, 0);
    const own = db.admin.companies.find((company) => company.id === COMPANY_TENANT.id);
    const rate = defaultRateOf(own?.commissionGrid ?? null) ?? db.admin.settings.orderFeeRateBps;
    const fees = commissionOf(amount, rate);
    const taxes = taxLines(fees, db.admin.settings);
    return HttpResponse.json<S['CreditOrderQuote']>({
      lines: body.lines,
      amountMillimes: amount,
      feeRateBps: rate,
      feesMillimes: fees,
      ...taxes,
      totalMillimes: amount + fees + taxesOf(taxes),
    });
  }),

  http.post(apiUrl('/v1/company/allocations'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY', true);
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['AllocationRequest'];
    const total = body.allocations.reduce((sum, line) => sum + line.amountMillimes, 0);
    if (
      body.allocations.some(
        (line) => !Number.isInteger(line.amountMillimes) || line.amountMillimes < 1,
      )
    ) {
      return validationProblem([{ pointer: '/allocations', code: 'TOO_SMALL' }]);
    }
    // Each line debits the balance of ITS type: never another type (no transfer between types).
    const needed = emptyBalances();
    for (const line of body.allocations) needed[line.creditType] += line.amountMillimes;
    for (const type of CREDIT_TYPES) {
      if (needed[type] > 0 && !typeEnabled(type)) {
        return validationProblem([{ pointer: '/allocations', code: 'INVALID_ENUM' }]);
      }
      if (needed[type] > db.company.balances[type]) {
        return problem(422, 'INSUFFICIENT_FUNDS', {
          missingMillimes: needed[type] - db.company.balances[type],
        });
      }
    }
    for (const line of body.allocations) {
      const employee = db.company.employees.find((item) => item.id === line.employeeId);
      if (employee === undefined || employee.status === 'SUSPENDED')
        return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    for (const line of body.allocations) {
      const employee = db.company.employees.find((item) => item.id === line.employeeId);
      if (employee !== undefined) employee.monthAllocatedMillimes += line.amountMillimes;
    }
    for (const type of CREDIT_TYPES) db.company.balances[type] -= needed[type];
    saveOrders();
    audit('credits.allocate', `${String(body.allocations.length)} lignes`);
    return HttpResponse.json<S['AllocationResult']>({
      balances: balancesList(db.company.balances),
      allocatedCount: body.allocations.length,
      allocatedMillimes: total,
      walletBalanceMillimes: totalOf(db.company.balances),
    });
  }),

  http.post(apiUrl('/v1/company/allocation-imports/previews'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['AllocationImportRequest'];
    return HttpResponse.json<S['AllocationImportPreview']>(previewAllocations(body.csv));
  }),

  http.get(apiUrl('/v1/company/invoices'), async ({ request }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['InvoicePage']>(paginate(db.company.invoices, request));
  }),
];
