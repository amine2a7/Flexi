import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { commissionOf, db } from '../db';
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

export const companyHandlers = [
  http.get(apiUrl('/v1/company/dashboard'), async () => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const { employees, orders, walletMillimes } = db.company;
    return HttpResponse.json<S['CompanyDashboard']>({
      walletBalanceMillimes: walletMillimes,
      employeesCount: employees.length,
      activeEmployeesCount: employees.filter((employee) => employee.status === 'ACTIVE').length,
      monthAllocatedMillimes: employees.reduce(
        (sum, employee) => sum + employee.monthAllocatedMillimes,
        0,
      ),
      pendingOrdersCount: orders.filter(
        (order) => order.status === 'CREATED' || order.status === 'PAID',
      ).length,
      recentOrders: orders.slice(0, 5),
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
    return HttpResponse.json<S['EmployeePage']>(paginate(items, request));
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
    if (!Number.isInteger(body.amountMillimes) || body.amountMillimes < 100_000) {
      return validationProblem([{ pointer: '/amountMillimes', code: 'TOO_SMALL' }]);
    }
    const rate = db.admin.settings.orderFeeRateBps;
    const fees = commissionOf(body.amountMillimes, rate);
    return HttpResponse.json<S['CreditOrderQuote']>({
      amountMillimes: body.amountMillimes,
      feeRateBps: rate,
      feesMillimes: fees,
      totalMillimes: body.amountMillimes + fees,
    });
  }),

  http.get(apiUrl('/v1/company/orders'), async ({ request }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const status = listParams(request).query.get('status');
    const items = db.company.orders.filter((order) => status === null || order.status === status);
    return HttpResponse.json<S['CreditOrderPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/company/orders'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY', true);
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['CreditOrderCreate'];
    if (!Number.isInteger(body.amountMillimes) || body.amountMillimes < 100_000) {
      return validationProblem([{ pointer: '/amountMillimes', code: 'TOO_SMALL' }]);
    }
    const fees = commissionOf(body.amountMillimes, db.admin.settings.orderFeeRateBps);
    const order: S['CreditOrder'] = {
      id: crypto.randomUUID(),
      reference: `CMD-2026-${String(7300 + db.company.orders.length)}`,
      status: 'CREATED',
      amountMillimes: body.amountMillimes,
      feesMillimes: fees,
      totalMillimes: body.amountMillimes + fees,
      createdAt: new Date().toISOString(),
      paymentReference: `FXP-${String(Date.now()).slice(-8)}`,
    };
    db.company.orders.unshift(order);
    audit('orders.create', order.reference);
    return HttpResponse.json<S['CreditOrder']>(order, { status: 201 });
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
    if (total > db.company.walletMillimes) {
      return problem(422, 'INSUFFICIENT_FUNDS', {
        missingMillimes: total - db.company.walletMillimes,
      });
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
    db.company.walletMillimes -= total;
    audit('credits.allocate', `${String(body.allocations.length)} employés`);
    return HttpResponse.json<S['AllocationResult']>({
      allocatedCount: body.allocations.length,
      allocatedMillimes: total,
      walletBalanceMillimes: db.company.walletMillimes,
    });
  }),

  http.get(apiUrl('/v1/company/invoices'), async ({ request }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['InvoicePage']>(paginate(db.company.invoices, request));
  }),
];
