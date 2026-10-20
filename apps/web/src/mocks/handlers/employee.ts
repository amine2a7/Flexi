import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { currentAccount, db, type MockPayment } from '../db';
import { CREDIT_TYPES, type CreditType } from '../credit-types';
import { EMPLOYEE_SHOPS, employeeBalance, type MockEmployee } from '../employee-seed';
import { MERCHANT_TENANT } from '../fixtures/accounts';
import {
  apiUrl,
  guardRead,
  guardWrite,
  isResponse,
  latency,
  listParams,
  paginate,
  problem,
  validationProblem,
} from './util';

type S = Schemas;

// Beneficiary (employee) routes: the same contract routes as the future mobile app.

const CODE_VALIDITY_SECONDS = 60;
const REQUEST_VALIDITY_MS = 90_000;
const PIN_MAX_FAILURES = 3;
const PIN_LOCK_MS = 15 * 60_000;

const employee = (): MockEmployee => db.employee;
const today = (): string => new Date().toISOString().slice(0, 10);

function spentToday(creditType: CreditType): number {
  return employee()
    .operations.filter(
      (operation) =>
        operation.type === 'PAYMENT' &&
        operation.status === 'COMPLETED' &&
        operation.creditType === creditType &&
        operation.occurredAt.startsWith(today()),
    )
    .reduce((sum, operation) => sum + operation.amountMillimes, 0);
}

function typeSettings(creditType: CreditType): S['CreditTypeSettings'] | undefined {
  return db.admin.settings.creditTypes.find((item) => item.creditType === creditType);
}

/** One balance per credit type (the total is informative only). */
function wallet(): S['EmployeeWallet'] {
  const state = employee();
  const balances = CREDIT_TYPES.map((creditType) => {
    const balance = employeeBalance(state, creditType);
    const settings = typeSettings(creditType);
    return {
      creditType,
      balanceMillimes: balance,
      expiringMillimes: Math.min(balance, creditType === 'RESTAURATION' ? 64_000 : 0),
      nextExpiryDate: creditType === 'RESTAURATION' ? state.nextExpiryDate : null,
      dailyLimitMillimes: settings?.dailyLimitMillimes ?? 0,
      todaySpentMillimes: spentToday(creditType),
      enabled: settings?.enabled ?? false,
    };
  });
  return {
    companyName: state.profile.companyName,
    totalBalanceMillimes: balances.reduce((sum, item) => sum + item.balanceMillimes, 0),
    balances,
  };
}

/** Locked PIN: same code as a wrong one, with the time left (API behaviour, securite S01). */
function pinLocked(until: number): Response {
  return problem(403, 'PIN_INVALID', {
    retryAfterSeconds: Math.max(1, Math.ceil((until - Date.now()) / 1000)),
  });
}

/** Checks the PIN (3 failures lock it 15 min). Returns a problem response or undefined. */
function checkPin(pin: string): Response | undefined {
  const state = employee();
  if (state.pinLockedUntil !== undefined && state.pinLockedUntil > Date.now()) {
    return pinLocked(state.pinLockedUntil);
  }
  if (!/^[0-9]{4}$/.test(pin))
    return validationProblem([{ pointer: '/pin', code: 'INVALID_FORMAT' }]);
  if (pin !== state.pin) {
    state.pinFailures += 1;
    if (state.pinFailures >= PIN_MAX_FAILURES) {
      state.pinLockedUntil = Date.now() + PIN_LOCK_MS;
      state.pinFailures = 0;
      return pinLocked(state.pinLockedUntil);
    }
    return problem(403, 'PIN_INVALID');
  }
  state.pinFailures = 0;
  return undefined;
}

/** Balance and daily limit of ONE type: never covered by another type (rule 5). */
function checkFunds(amount: number, creditType: CreditType): Response | undefined {
  const balance = wallet().balances.find((item) => item.creditType === creditType);
  if (!balance?.enabled) {
    return validationProblem([{ pointer: '/creditType', code: 'INVALID_ENUM' }]);
  }
  if (amount > balance.balanceMillimes) {
    return problem(422, 'INSUFFICIENT_FUNDS', {
      missingMillimes: amount - balance.balanceMillimes,
    });
  }
  if (balance.todaySpentMillimes + amount > balance.dailyLimitMillimes) {
    return problem(422, 'LIMIT_EXCEEDED', {
      limitType: 'DAILY',
      remainingMillimes: Math.max(balance.dailyLimitMillimes - balance.todaySpentMillimes, 0),
    });
  }
  return undefined;
}

function recordPayment(
  merchantName: string,
  merchantCity: string | null,
  amount: number,
  creditType: CreditType,
): S['EmployeeOperationDetail'] {
  const state = employee();
  const balance = employeeBalance(state, creditType) - amount;
  const operation: S['EmployeeOperationDetail'] = {
    id: crypto.randomUUID(),
    reference: `PAY-${String(7700 + state.operations.length)}`,
    type: 'PAYMENT',
    direction: 'DEBIT',
    amountMillimes: amount,
    creditType,
    counterpartyName: merchantName,
    counterpartyCity: merchantCity,
    status: 'COMPLETED',
    occurredAt: new Date().toISOString(),
    balanceAfterMillimes: balance,
  };
  state.operations.unshift(operation);
  return operation;
}

/** Merchants a code can designate: the demo shop, then the other approved merchants. */
function merchantByCode(code: string): S['MerchantLookup'] | undefined {
  const profile = db.merchant.profile;
  if (code === profile.paymentCode) {
    return {
      merchantCode: code,
      merchantName: MERCHANT_TENANT.label,
      city: profile.city,
      category: profile.category,
      acceptedCreditTypes: profile.acceptedCreditTypes,
    };
  }
  const others = db.admin.merchants.filter(
    (merchant) => merchant.id !== MERCHANT_TENANT.id && merchant.status === 'APPROVED',
  );
  const index = others.findIndex((_, position) => String(300_000 + position * 1_237) === code);
  const merchant = others[index];
  return merchant === undefined
    ? undefined
    : {
        merchantCode: code,
        merchantName: merchant.name,
        city: merchant.city,
        category: merchant.category,
        acceptedCreditTypes: merchant.acceptedCreditTypes,
      };
}

function activeRequests(): S['EmployeePaymentRequest'][] {
  const now = Date.now();
  const state = employee();
  state.requests = state.requests.filter((item) => new Date(item.expiresAt).getTime() > now);
  return state.requests.map(({ merchantPaymentId: _id, ...rest }) => rest);
}

/**
 * Called by the merchant collect mock: if the typed code is the beneficiary's active code, the
 * request reaches the beneficiary space and waits for the PIN (no automatic confirmation).
 */
export function linkEmployeePayment(code: string, payment: MockPayment): boolean {
  const state = employee();
  const active = state.activeCode;
  if (active?.code !== code || active.expiresAt < Date.now()) return false;
  state.activeCode = undefined;
  payment.customer = {
    firstName: state.profile.firstName,
    lastInitial: state.profile.lastName.charAt(0),
    maskedEmployeeNumber: `•••${state.profile.employeeNumber.slice(-4)}`,
  };
  delete payment.confirmAt;
  state.requests.unshift({
    id: crypto.randomUUID(),
    reference: payment.reference,
    merchantName: MERCHANT_TENANT.label,
    amountMillimes: payment.amountMillimes,
    creditType: payment.creditType,
    createdAt: payment.createdAt,
    expiresAt: payment.expiresAt ?? new Date(Date.now() + REQUEST_VALIDITY_MS).toISOString(),
    merchantPaymentId: payment.id,
  });
  return true;
}

function settleMerchantPayment(paymentId: string | undefined, status: 'CONFIRMED' | 'REFUSED') {
  if (paymentId === undefined) return;
  const payment = db.merchant.payments.find((item) => item.id === paymentId);
  if (payment !== undefined) {
    payment.status = status;
    payment.expiresAt = null;
  }
}

export const employeeHandlers = [
  http.get(apiUrl('/v1/employee/wallet'), async () => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['EmployeeWallet']>(wallet());
  }),

  http.post(apiUrl('/v1/employee/payment-codes'), async ({ request }) => {
    const account = await guardWrite(request, 'EMPLOYEE');
    if (isResponse(account)) return account;
    const code = String(crypto.getRandomValues(new Uint32Array(1))[0] ?? 0)
      .padStart(8, '7')
      .slice(-8);
    const expiresAt = Date.now() + CODE_VALIDITY_SECONDS * 1000;
    employee().activeCode = { code, expiresAt };
    return HttpResponse.json<S['PaymentCode']>(
      {
        code,
        qrPayload: `flexipay:pay:${code}`,
        expiresAt: new Date(expiresAt).toISOString(),
        validitySeconds: CODE_VALIDITY_SECONDS,
      },
      { status: 201 },
    );
  }),

  http.get(apiUrl('/v1/employee/payment-requests'), async () => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['EmployeePaymentRequestList']>({ data: activeRequests() });
  }),

  http.post(
    apiUrl('/v1/employee/payment-requests/:requestId/confirm'),
    async ({ request, params }) => {
      const account = await guardWrite(request, 'EMPLOYEE', true);
      if (isResponse(account)) return account;
      activeRequests();
      const state = employee();
      const pending = state.requests.find((item) => item.id === params.requestId);
      if (pending === undefined) return problem(404, 'NOT_FOUND');
      const body = (await request.json().catch(() => ({}))) as Partial<S['PinConfirmation']>;
      const pinProblem = checkPin(body.pin ?? '');
      if (pinProblem !== undefined) return pinProblem;
      const fundsProblem = checkFunds(pending.amountMillimes, pending.creditType);
      if (fundsProblem !== undefined) return fundsProblem;
      state.requests = state.requests.filter((item) => item.id !== pending.id);
      settleMerchantPayment(pending.merchantPaymentId, 'CONFIRMED');
      const shop = EMPLOYEE_SHOPS.find((item) => item.name === pending.merchantName);
      return HttpResponse.json<S['EmployeeOperationDetail']>(
        recordPayment(
          pending.merchantName,
          shop?.city ?? null,
          pending.amountMillimes,
          pending.creditType,
        ),
      );
    },
  ),

  http.post(
    apiUrl('/v1/employee/payment-requests/:requestId/refuse'),
    async ({ request, params }) => {
      const account = await guardWrite(request, 'EMPLOYEE');
      if (isResponse(account)) return account;
      const state = employee();
      const pending = state.requests.find((item) => item.id === params.requestId);
      if (pending === undefined) return problem(404, 'NOT_FOUND');
      state.requests = state.requests.filter((item) => item.id !== pending.id);
      settleMerchantPayment(pending.merchantPaymentId, 'REFUSED');
      return new HttpResponse(null, { status: 204 });
    },
  ),

  http.get(apiUrl('/v1/employee/merchants/:merchantCode'), async ({ params }) => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    const code = String(params.merchantCode);
    if (!/^[0-9]{6}$/.test(code)) {
      return validationProblem([{ pointer: 'merchantCode', code: 'INVALID_FORMAT' }]);
    }
    const merchant = merchantByCode(code);
    if (merchant === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['MerchantLookup']>(merchant);
  }),

  http.post(apiUrl('/v1/employee/payments'), async ({ request }) => {
    const account = await guardWrite(request, 'EMPLOYEE', true);
    if (isResponse(account)) return account;
    const body = (await request.json().catch(() => ({}))) as Partial<S['EmployeePaymentCreate']>;
    const merchant = merchantByCode(body.merchantCode ?? '');
    if (merchant === undefined) return problem(404, 'NOT_FOUND');
    if (!Number.isInteger(body.amountMillimes) || (body.amountMillimes ?? 0) < 1) {
      return validationProblem([{ pointer: '/amountMillimes', code: 'TOO_SMALL' }]);
    }
    const amount = body.amountMillimes ?? 0;
    const creditType = body.creditType;
    // Only a type accepted by the merchant can be used (no payment with another type).
    if (creditType === undefined || !merchant.acceptedCreditTypes.includes(creditType)) {
      return validationProblem([{ pointer: '/creditType', code: 'INVALID_ENUM' }]);
    }
    const pinProblem = checkPin(body.pin ?? '');
    if (pinProblem !== undefined) return pinProblem;
    const fundsProblem = checkFunds(amount, creditType);
    if (fundsProblem !== undefined) return fundsProblem;
    const operation = recordPayment(merchant.merchantName, merchant.city, amount, creditType);
    if (merchant.merchantCode === db.merchant.profile.paymentCode) {
      const state = employee();
      db.merchant.payments.unshift({
        id: crypto.randomUUID(),
        reference: operation.reference,
        status: 'CONFIRMED',
        creditType,
        amountMillimes: amount,
        customer: {
          firstName: state.profile.firstName,
          lastInitial: state.profile.lastName.charAt(0),
          maskedEmployeeNumber: `•••${state.profile.employeeNumber.slice(-4)}`,
        },
        createdAt: operation.occurredAt,
        expiresAt: null,
      });
    }
    return HttpResponse.json<S['EmployeeOperationDetail']>(operation, { status: 201 });
  }),

  http.get(apiUrl('/v1/employee/operations'), async ({ request }) => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const type = query.get('type');
    const creditType = query.get('creditType');
    const from = query.get('createdFrom');
    const to = query.get('createdTo');
    const items = employee()
      .operations.filter((operation) => type === null || operation.type === type)
      .filter((operation) => creditType === null || operation.creditType === creditType)
      .filter((operation) => from === null || operation.occurredAt >= from)
      .filter((operation) => to === null || operation.occurredAt <= to)
      .map(({ balanceAfterMillimes: _balance, counterpartyCity: _city, ...rest }) => rest);
    return HttpResponse.json<S['EmployeeOperationPage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/employee/operations/:operationId'), async ({ params }) => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    const operation = employee().operations.find((item) => item.id === params.operationId);
    if (operation === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['EmployeeOperationDetail']>(operation);
  }),

  http.get(apiUrl('/v1/employee/profile'), async () => {
    const account = await guardRead('EMPLOYEE');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['EmployeeProfile']>(employee().profile);
  }),

  http.post(apiUrl('/v1/employee/pin'), async ({ request }) => {
    const account = await guardWrite(request, 'EMPLOYEE');
    if (isResponse(account)) return account;
    const body = (await request.json().catch(() => ({}))) as Partial<S['PinChange']>;
    if (!/^[0-9]{4}$/.test(body.newPin ?? '')) {
      return validationProblem([{ pointer: '/newPin', code: 'INVALID_FORMAT' }]);
    }
    const pinProblem = checkPin(body.currentPin ?? '');
    if (pinProblem !== undefined) return pinProblem;
    employee().pin = body.newPin ?? employee().pin;
    return new HttpResponse(null, { status: 204 });
  }),

  // Development only (not in the contract): a merchant request arrives, as if a shop had typed
  // the beneficiary's code. Lets the web space be tested alone in one tab.
  http.post(apiUrl('/__demo/employee/payment-request'), async () => {
    await latency();
    const account = currentAccount();
    if (account?.role !== 'EMPLOYEE') return problem(403, 'FORBIDDEN');
    const shop =
      EMPLOYEE_SHOPS[Math.floor(Math.random() * EMPLOYEE_SHOPS.length)] ?? EMPLOYEE_SHOPS[0];
    if (shop === undefined) return problem(500, 'INTERNAL_ERROR');
    const now = Date.now();
    employee().requests.unshift({
      id: crypto.randomUUID(),
      reference: `PAY-${String(8000 + Math.floor(Math.random() * 900))}`,
      merchantName: shop.name,
      amountMillimes: (25 + Math.floor(Math.random() * 46)) * 500,
      creditType: shop.types[Math.floor(Math.random() * shop.types.length)] ?? 'RESTAURATION',
      createdAt: new Date(now).toISOString(),
      expiresAt: new Date(now + REQUEST_VALIDITY_MS).toISOString(),
    });
    return new HttpResponse(null, { status: 204 });
  }),
];
