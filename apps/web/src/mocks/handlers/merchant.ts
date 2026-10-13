import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { CREDIT_TYPES } from '../credit-types';
import { commissionOf, db, type MockPayment } from '../db';
import { FIRST_NAMES, LAST_NAMES, calendarDate, createRandom } from '../fixtures/random';
import { linkEmployeePayment } from './employee';
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

const PAYMENT_VALIDITY_MS = 60_000; // decision 8
const CONFIRMATION_DELAY_MS = 4_000;
const RATE_LIMIT = { count: 6, windowMs: 60_000 };

// Customer codes of the demo (shown in the development panel of the collect screen):
// `00000000` declined at once, `99999999` server error, a code ending in `0000` refused by the
// customer, any other 8-digit code confirmed by the customer after about 4 seconds.
function customerFor(code: string): S['CustomerSummary'] {
  const random = createRandom(Number.parseInt(code, 10) || 1);
  return {
    firstName: random.pick(FIRST_NAMES),
    lastInitial: random.pick(LAST_NAMES).charAt(0),
    maskedEmployeeNumber: `•••${code.slice(-4)}`,
  };
}

/** Moves an initiated payment forward (customer confirmation simulated on read). */
function settle(payment: MockPayment): MockPayment {
  if (payment.status !== 'INITIATED') return payment;
  const now = Date.now();
  if (payment.expiresAt !== null && new Date(payment.expiresAt).getTime() < now) {
    payment.status = 'REFUSED';
    payment.expiresAt = null;
  } else if (payment.confirmAt !== undefined && payment.confirmAt <= now) {
    payment.status = payment.willRefuse === true ? 'REFUSED' : 'CONFIRMED';
    payment.expiresAt = null;
  }
  return payment;
}

function publicPayment(payment: MockPayment): S['MerchantPayment'] {
  const { confirmAt: _confirmAt, willRefuse: _willRefuse, ...rest } = settle(payment);
  return rest;
}

/** Payment detail: frozen rate, commission and net, D+2 settlement date, steps reached. */
function paymentDetail(payment: MockPayment): S['MerchantPaymentDetail'] {
  const base = publicPayment(payment);
  const start = new Date(base.createdAt).getTime();
  const collected = base.status === 'CONFIRMED' || base.status === 'SETTLED';
  const rate = typeRate(base.creditType);
  const commission = collected ? commissionOf(base.amountMillimes, rate) : 0;
  const settlementDate = collected ? calendarDate(start + 2 * 86_400_000) : null;
  const history: S['PaymentEvent'][] = [{ status: 'INITIATED', occurredAt: base.createdAt }];
  if (base.status !== 'INITIATED') {
    const decided = base.status === 'REFUSED' ? 'REFUSED' : 'CONFIRMED';
    history.push({ status: decided, occurredAt: new Date(start + 25_000).toISOString() });
  }
  if (base.status === 'SETTLED' && settlementDate !== null) {
    history.push({ status: 'SETTLED', occurredAt: `${settlementDate}T07:00:00.000Z` });
  }
  return {
    ...base,
    commissionRateBps: rate,
    commissionMillimes: commission,
    netMillimes: collected ? base.amountMillimes - commission : 0,
    settlementDate,
    history,
  };
}

function receivables(): S['Receivable'][] {
  return db.merchant.payments
    .map(settle)
    .filter((payment) => payment.status === 'CONFIRMED')
    .map((payment) => ({
      paymentId: payment.id,
      reference: payment.reference,
      creditType: payment.creditType,
      amountMillimes: payment.amountMillimes,
      confirmedAt: payment.createdAt,
      settlementDate: calendarDate(new Date(payment.createdAt).getTime() + 2 * 86_400_000),
    }));
}

/** Commission rate of a credit type (platform settings, rule 6). */
export function typeRate(type: S['CreditType']): number {
  return (
    db.admin.settings.creditTypes.find((item) => item.creditType === type)?.commissionRateBps ??
    db.merchant.rateBps
  );
}

const totalOf = (items: readonly { amountMillimes: number }[]) =>
  items.reduce((sum, item) => sum + item.amountMillimes, 0);

/** Net of the commission, integer millimes (mock of the server rule). */
const netOf = (gross: number) => gross - Math.floor((gross * db.merchant.rateBps + 5_000) / 10_000);

/** Six last months: the current month from the real demo payments, earlier months seeded. */
function monthlyFlows(): S['MerchantMonthlyFlow'][] {
  const now = new Date();
  return Array.from({ length: 6 }, (_, index) => {
    const date = new Date(now.getFullYear(), now.getMonth() - (5 - index), 1);
    const month = `${String(date.getFullYear())}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    if (index === 5) {
      const own = db.merchant.payments
        .map(settle)
        .filter(
          (payment) =>
            payment.createdAt.startsWith(month) &&
            (payment.status === 'CONFIRMED' || payment.status === 'SETTLED'),
        );
      return {
        month,
        collectedMillimes: totalOf(own),
        settledMillimes: netOf(totalOf(own.filter((payment) => payment.status === 'SETTLED'))),
      };
    }
    const collected = 3_850_000 + ((index * 7_919) % 11) * 412_500;
    return { month, collectedMillimes: collected, settledMillimes: netOf(collected) };
  });
}

const HOUR_MS = 3_600_000;
const PAYOUT_STEPS: readonly S['PayoutRequestStatus'][] = [
  'REQUESTED',
  'CHECKED',
  'SENT',
  'EXECUTED',
];
const PAYOUT_OFFSETS = [0, 6 * HOUR_MS, 26 * HOUR_MS, 50 * HOUR_MS];

/** Steps reached by a payout request, consistent with its status (demo timestamps). */
export function payoutHistory(
  payout: Pick<S['PayoutRequest'], 'id' | 'status' | 'requestedAt'>,
): S['PayoutEvent'][] {
  const recorded = db.admin.payoutEvents.get(payout.id);
  if (recorded !== undefined) return recorded;
  const start = new Date(payout.requestedAt).getTime();
  if (payout.status === 'REJECTED') {
    return [
      { status: 'REQUESTED', occurredAt: payout.requestedAt },
      {
        status: 'REJECTED',
        occurredAt: new Date(start + 6 * HOUR_MS).toISOString(),
        reasonKey: 'payoutRejection.ibanCheck',
      },
    ];
  }
  const reached = PAYOUT_STEPS.indexOf(payout.status);
  return PAYOUT_STEPS.slice(0, reached + 1).map((status, index) => ({
    status,
    occurredAt: new Date(start + (PAYOUT_OFFSETS[index] ?? 0)).toISOString(),
  }));
}

export const merchantHandlers = [
  http.get(apiUrl('/v1/merchant/dashboard'), async () => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const today = calendarDate(Date.now());
    const todays = db.merchant.payments
      .map(settle)
      .filter(
        (payment) =>
          payment.createdAt.startsWith(today) &&
          (payment.status === 'CONFIRMED' || payment.status === 'SETTLED'),
      );
    return HttpResponse.json<S['MerchantDashboard']>({
      todayCollectedMillimes: totalOf(todays),
      todayPaymentsCount: todays.length,
      receivablesMillimes: totalOf(receivables()),
      nextSettlementDate:
        db.merchant.settlements.find((item) => item.status === 'SCHEDULED')?.settlementDate ?? null,
      commissionRateBps: db.merchant.rateBps,
      recentPayments: db.merchant.payments.slice(0, 5).map(publicPayment),
      monthlyFlows: monthlyFlows(),
      monthByCreditType: CREDIT_TYPES.map((creditType) => ({
        creditType,
        amountMillimes: totalOf(
          db.merchant.payments
            .map(settle)
            .filter(
              (payment) =>
                payment.creditType === creditType &&
                payment.createdAt.startsWith(new Date().toISOString().slice(0, 7)) &&
                (payment.status === 'CONFIRMED' || payment.status === 'SETTLED'),
            ),
        ),
      })),
    });
  }),

  http.get(apiUrl('/v1/merchant/payments'), async ({ request }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const creditType = query.get('creditType');
    const items = db.merchant.payments
      .map(publicPayment)
      .filter((payment) => status === null || payment.status === status)
      .filter((payment) => creditType === null || payment.creditType === creditType)
      .filter((payment) => matches(query.get('q'), payment.reference, payment.customer.firstName));
    return HttpResponse.json<S['MerchantPaymentPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/merchant/payments'), async ({ request }) => {
    const account = await guardWrite(request, 'MERCHANT', true);
    if (isResponse(account)) return account;
    const now = Date.now();
    db.merchant.initiations = db.merchant.initiations.filter(
      (time) => now - time < RATE_LIMIT.windowMs,
    );
    if (db.merchant.initiations.length >= RATE_LIMIT.count) {
      return problem(429, 'RATE_LIMITED', { retryAfterSeconds: 30 });
    }
    db.merchant.initiations.push(now);
    const body = (await request.json()) as S['PaymentInitiateRequest'];
    if (!/^[0-9]{8}$/.test(body.customerCode)) {
      return validationProblem([{ pointer: '/customerCode', code: 'INVALID_FORMAT' }]);
    }
    if (!Number.isInteger(body.amountMillimes) || body.amountMillimes < 1) {
      return validationProblem([{ pointer: '/amountMillimes', code: 'TOO_SMALL' }]);
    }
    if (!db.merchant.profile.acceptedCreditTypes.includes(body.creditType)) {
      return validationProblem([{ pointer: '/creditType', code: 'INVALID_ENUM' }]);
    }
    if (body.customerCode === '99999999') return problem(500, 'INTERNAL_ERROR');
    if (body.customerCode === '00000000') return problem(422, 'PAYMENT_DECLINED');
    const payment: MockPayment = {
      id: crypto.randomUUID(),
      reference: `PAY-${String(5000 + db.merchant.payments.length)}`,
      status: 'INITIATED',
      creditType: body.creditType,
      amountMillimes: body.amountMillimes,
      customer: customerFor(body.customerCode),
      createdAt: new Date(now).toISOString(),
      expiresAt: new Date(now + PAYMENT_VALIDITY_MS).toISOString(),
      confirmAt: now + CONFIRMATION_DELAY_MS,
      willRefuse: body.customerCode.endsWith('0000'),
    };
    // The beneficiary's active code: the request waits for the PIN in the beneficiary space.
    if (linkEmployeePayment(body.customerCode, payment)) delete payment.willRefuse;
    db.merchant.payments.unshift(payment);
    return HttpResponse.json<S['MerchantPayment']>(publicPayment(payment), { status: 201 });
  }),

  http.get(apiUrl('/v1/merchant/payments/:paymentId'), async ({ params }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const payment = db.merchant.payments.find((item) => item.id === params.paymentId);
    if (payment === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['MerchantPaymentDetail']>(paymentDetail(payment));
  }),

  http.post(apiUrl('/v1/merchant/payments/:paymentId/cancel'), async ({ request, params }) => {
    const account = await guardWrite(request, 'MERCHANT');
    if (isResponse(account)) return account;
    const payment = db.merchant.payments.find((item) => item.id === params.paymentId);
    if (payment === undefined) return problem(404, 'NOT_FOUND');
    if (settle(payment).status !== 'INITIATED') return problem(409, 'RESOURCE_STATE_CONFLICT');
    payment.status = 'REFUSED';
    payment.expiresAt = null;
    return HttpResponse.json<S['MerchantPayment']>(publicPayment(payment));
  }),

  http.get(apiUrl('/v1/merchant/receivables'), async ({ request }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const creditType = listParams(request).query.get('creditType');
    const items = receivables().filter(
      (item) => creditType === null || item.creditType === creditType,
    );
    return HttpResponse.json<S['ReceivablePage']>({
      ...paginate(items, request),
      totalMillimes: totalOf(items),
    });
  }),

  http.post(apiUrl('/v1/merchant/payout-quotes'), async ({ request }) => {
    const account = await guardWrite(request, 'MERCHANT');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['PayoutQuoteRequest'];
    const available = totalOf(receivables().filter((item) => item.creditType === body.creditType));
    if (
      !Number.isInteger(body.grossMillimes) ||
      body.grossMillimes < db.admin.settings.payoutMinimumMillimes
    ) {
      return validationProblem([{ pointer: '/grossMillimes', code: 'TOO_SMALL' }]);
    }
    if (body.grossMillimes > available) return problem(422, 'INSUFFICIENT_FUNDS');
    const rate = typeRate(body.creditType);
    const commission = commissionOf(body.grossMillimes, rate);
    const quote: S['PayoutQuote'] = {
      quoteId: crypto.randomUUID(),
      creditType: body.creditType,
      grossMillimes: body.grossMillimes,
      commissionRateBps: rate,
      commissionMillimes: commission,
      netMillimes: body.grossMillimes - commission,
      availableMillimes: available,
      expiresAt: new Date(Date.now() + 10 * 60_000).toISOString(),
    };
    db.merchant.quotes.set(quote.quoteId, quote);
    return HttpResponse.json<S['PayoutQuote']>(quote);
  }),

  http.get(apiUrl('/v1/merchant/payouts'), async ({ request }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const status = listParams(request).query.get('status');
    const creditType = listParams(request).query.get('creditType');
    const items = db.merchant.payouts
      .filter((item) => status === null || item.status === status)
      .filter((item) => creditType === null || item.creditType === creditType);
    return HttpResponse.json<S['PayoutRequestPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/merchant/payouts'), async ({ request }) => {
    const account = await guardWrite(request, 'MERCHANT', true);
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['PayoutRequestCreate'];
    const quote = db.merchant.quotes.get(body.quoteId);
    if (
      quote === undefined ||
      new Date(quote.expiresAt).getTime() < Date.now() ||
      quote.commissionRateBps !== typeRate(quote.creditType)
    ) {
      return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    db.merchant.quotes.delete(body.quoteId);
    const payout: S['PayoutRequest'] = {
      id: crypto.randomUUID(),
      reference: `VIR-2026-${String(9400 + db.merchant.payouts.length)}`,
      status: 'REQUESTED',
      creditType: quote.creditType,
      grossMillimes: quote.grossMillimes,
      commissionRateBps: quote.commissionRateBps,
      commissionMillimes: quote.commissionMillimes,
      netMillimes: quote.netMillimes,
      requestedAt: new Date().toISOString(),
      maskedIban: db.merchant.profile.maskedIban.slice(-9),
    };
    db.merchant.payouts.unshift(payout);
    audit('payouts.request', payout.reference);
    return HttpResponse.json<S['PayoutRequest']>(payout, { status: 201 });
  }),

  http.get(apiUrl('/v1/merchant/payouts/:payoutId'), async ({ params }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    const payout = db.merchant.payouts.find((item) => item.id === params.payoutId);
    if (payout === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['PayoutRequestDetail']>({
      ...payout,
      history: payoutHistory(payout),
    });
  }),

  http.get(apiUrl('/v1/merchant/settlements'), async ({ request }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['SettlementPage']>(paginate(db.merchant.settlements, request));
  }),

  http.get(apiUrl('/v1/merchant/documents'), async ({ request }) => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['MerchantDocumentPage']>(paginate(db.merchant.documents, request));
  }),

  http.get(apiUrl('/v1/merchant/profile'), async () => {
    const account = await guardRead('MERCHANT');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['MerchantProfile']>({
      ...db.merchant.profile,
      commissionProfile: { ...db.merchant.profile.commissionProfile, rateBps: db.merchant.rateBps },
    });
  }),
];
