import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import {
  commissionOf,
  currentAccount,
  db,
  invoicesOf,
  saveOrders,
  SECOND_VALIDATION_THRESHOLD_MILLIMES,
  type MockOrder,
} from '../db';
import { COMPANY_TENANT } from '../fixtures/accounts';
import { checkOrderLines } from './company';
import { FUNDING_ACCOUNT } from '../fixtures/funding-account';
import {
  apiUrl,
  audit,
  guardRead,
  guardWrite,
  isResponse,
  listParams,
  paginate,
  problem,
  validationProblem,
} from './util';

type S = Schemas;

// Credit order circuit: the company orders, the admin confirms, the company declares its transfer
// (with a proof), the admin validates (credits added to the balance) or rejects the proof.

const MAX_PROOF_BYTES = 5 * 1024 * 1024;
const NEEDS_ADMIN: readonly S['OrderStatus'][] = ['AWAITING_CONFIRMATION', 'AWAITING_VALIDATION'];
/** Orders still in progress (company dashboard counter). */
export const OPEN_ORDER_STATUSES: readonly S['OrderStatus'][] = [
  ...NEEDS_ADMIN,
  'AWAITING_PAYMENT',
];

export function orderSummary(order: MockOrder): S['CreditOrder'] {
  const {
    proof: _proof,
    declaration: _declaration,
    history: _history,
    refusalReason: _refusal,
    proofRejectionReason: _rejection,
    requiresSecondValidation: _four,
    firstValidator: _first,
    ...rest
  } = order;
  return rest;
}

function detail(order: MockOrder): S['CreditOrderDetail'] {
  const { proof: _proof, firstValidator, ...rest } = order;
  return {
    ...rest,
    ...(firstValidator === undefined || order.status !== 'AWAITING_VALIDATION'
      ? {}
      : {
          firstValidation: {
            actorName: firstValidator.actorName,
            occurredAt: firstValidator.occurredAt,
            byMe: firstValidator.actorId === currentAccount()?.id,
          },
        }),
  };
}

function find(id: string, companyOnly: boolean): MockOrder | undefined {
  return db.orders.find(
    (order) => order.id === id && (!companyOnly || order.companyId === COMPANY_TENANT.id),
  );
}

function record(order: MockOrder, action: S['CreditOrderEventAction'], reason?: string): void {
  const account = currentAccount();
  order.history.push({
    action,
    occurredAt: new Date().toISOString(),
    actorName: account?.displayName ?? 'FlexiPay',
    actorRole: account?.role ?? 'ADMIN',
    ...(reason === undefined ? {} : { reason }),
  });
}

function refreshInvoices(): void {
  db.company.invoices = invoicesOf(db.orders);
}

async function readReason(request: Request): Promise<string | Response> {
  const body = (await request.json().catch(() => ({}))) as Partial<S['CreditOrderDecisionReason']>;
  const reason = typeof body.reason === 'string' ? body.reason.trim() : '';
  if (reason === '') return validationProblem([{ pointer: '/reason', code: 'REQUIRED' }]);
  if (reason.length > 500) return validationProblem([{ pointer: '/reason', code: 'TOO_LONG' }]);
  return reason;
}

/** File type from its first bytes (never from the name): JPG, PNG or PDF. */
async function sniff(file: Blob): Promise<S['TransferProof']['contentType'] | undefined> {
  const head = new Uint8Array(await file.slice(0, 8).arrayBuffer());
  if (head[0] === 0xff && head[1] === 0xd8 && head[2] === 0xff) return 'image/jpeg';
  if (head[0] === 0x89 && head[1] === 0x50 && head[2] === 0x4e && head[3] === 0x47) {
    return 'image/png';
  }
  if (head[0] === 0x25 && head[1] === 0x50 && head[2] === 0x44 && head[3] === 0x46) {
    return 'application/pdf';
  }
  return undefined;
}

function formatTnd(millimes: number): string {
  return `${Math.trunc(millimes / 1000).toLocaleString('fr-FR')},${String(millimes % 1000).padStart(3, '0')} TND`;
}

/** Demo transfer notice for the seeded declarations (generated on first read, then kept). */
async function demoProof(order: MockOrder): Promise<Blob> {
  const declaration = order.declaration;
  if (typeof OffscreenCanvas === 'undefined' || declaration === undefined) {
    return new Blob(['%PDF-1.4\n%demo\n'], { type: 'application/pdf' });
  }
  const canvas = new OffscreenCanvas(900, 560);
  const context = canvas.getContext('2d');
  if (context === null) return new Blob([], { type: 'image/png' });
  context.fillStyle = 'white';
  context.fillRect(0, 0, 900, 560);
  context.strokeStyle = 'silver';
  context.strokeRect(20, 20, 860, 520);
  context.fillStyle = 'black';
  context.font = 'bold 30px sans-serif';
  context.fillText('AVIS DE VIREMENT ÉMIS', 50, 80);
  context.font = '22px sans-serif';
  const lines = [
    `Donneur d'ordre : ${order.companyName}`,
    `Bénéficiaire : ${FUNDING_ACCOUNT.holder}`,
    `IBAN bénéficiaire : ${FUNDING_ACCOUNT.iban}`,
    `Montant : ${formatTnd(declaration.amountMillimes)}`,
    `Date d'exécution : ${declaration.transferDate}`,
    `Référence banque : ${declaration.transferReference}`,
    `Motif : ${order.paymentReference}`,
  ];
  lines.forEach((line, index) => {
    context.fillText(line, 50, 150 + index * 50);
  });
  return canvas.convertToBlob({ type: 'image/png' });
}

async function proofResponse(order: MockOrder | undefined): Promise<Response> {
  if (order?.declaration === undefined) return problem(404, 'NOT_FOUND');
  order.proof ??= await demoProof(order);
  return new HttpResponse(order.proof, {
    headers: {
      'Content-Type': order.proof.type || order.declaration.proof.contentType,
      'Content-Disposition': `attachment; filename="${order.declaration.proof.fileName.replace(/[^\w.-]/g, '_')}"`,
      'X-Content-Type-Options': 'nosniff',
      'Cache-Control': 'no-store',
    },
  });
}

function conflict(): Response {
  return problem(409, 'RESOURCE_STATE_CONFLICT');
}

const today = (): string => {
  const now = new Date();
  return `${String(now.getFullYear())}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
};

export const orderHandlers = [
  // ---------------------------------------------------------------- company
  http.get(apiUrl('/v1/company/funding-account'), async () => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['FundingBankAccount']>(FUNDING_ACCOUNT);
  }),

  http.get(apiUrl('/v1/company/orders'), async ({ request }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const status = listParams(request).query.get('status');
    const creditType = listParams(request).query.get('creditType');
    const items = db.orders
      .filter((order) => order.companyId === COMPANY_TENANT.id)
      .filter((order) => status === null || order.status === status)
      .filter(
        (order) =>
          creditType === null || order.lines.some((line) => line.creditType === creditType),
      )
      .map(orderSummary);
    return HttpResponse.json<S['CreditOrderPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/company/orders'), async ({ request }) => {
    const account = await guardWrite(request, 'COMPANY', true);
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['CreditOrderCreate'];
    const invalid = checkOrderLines(body.lines);
    if (invalid !== undefined) return invalid;
    const amount = body.lines.reduce((sum, line) => sum + line.amountMillimes, 0);
    const fees = commissionOf(amount, db.admin.settings.orderFeeRateBps);
    const own = db.admin.companies.find((company) => company.id === COMPANY_TENANT.id);
    const order: MockOrder = {
      id: crypto.randomUUID(),
      reference: `CMD-2026-${String(7300 + db.orders.length)}`,
      status: 'AWAITING_CONFIRMATION',
      lines: body.lines,
      requiresSecondValidation: amount > SECOND_VALIDATION_THRESHOLD_MILLIMES,
      companyId: COMPANY_TENANT.id,
      companyName: own?.name ?? COMPANY_TENANT.label,
      amountMillimes: amount,
      feesMillimes: fees,
      totalMillimes: amount + fees,
      createdAt: new Date().toISOString(),
      paymentReference: `FXP-${String(Date.now()).slice(-8)}`,
      history: [],
    };
    record(order, 'CREATED');
    db.orders.unshift(order);
    audit('orders.create', order.reference);
    saveOrders();
    return HttpResponse.json<S['CreditOrder']>(orderSummary(order), { status: 201 });
  }),

  http.get(apiUrl('/v1/company/orders/:orderId'), async ({ params }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), true);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(apiUrl('/v1/company/orders/:orderId/cancel'), async ({ request, params }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), true);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    if (order.status !== 'AWAITING_CONFIRMATION' && order.status !== 'AWAITING_PAYMENT') {
      return conflict();
    }
    order.status = 'CANCELLED';
    record(order, 'CANCELLED');
    audit('orders.cancel', order.reference);
    saveOrders();
    refreshInvoices();
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(
    apiUrl('/v1/company/orders/:orderId/transfer-declarations'),
    async ({ request, params }) => {
      const account = await guardWrite(request, 'COMPANY', true);
      if (isResponse(account)) return account;
      const order = find(String(params.orderId), true);
      if (order === undefined) return problem(404, 'NOT_FOUND');
      if (order.status !== 'AWAITING_PAYMENT') return conflict();
      const form = await request.formData().catch(() => undefined);
      if (form === undefined) return problem(415, 'UNSUPPORTED_MEDIA_TYPE');
      const text = (name: string) => {
        const value = form.get(name);
        return typeof value === 'string' ? value.trim() : '';
      };
      const reference = text('transferReference');
      const date = text('transferDate');
      const amount = text('amountMillimes');
      const proof = form.get('proof');
      const errors: { pointer: string; code: S['FieldErrorCode'] }[] = [];
      if (reference === '') errors.push({ pointer: '/transferReference', code: 'REQUIRED' });
      else if (reference.length > 64) {
        errors.push({ pointer: '/transferReference', code: 'TOO_LONG' });
      }
      if (date === '') errors.push({ pointer: '/transferDate', code: 'REQUIRED' });
      else if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
        errors.push({ pointer: '/transferDate', code: 'INVALID_FORMAT' });
      } else if (date > today()) errors.push({ pointer: '/transferDate', code: 'IN_FUTURE' });
      if (amount === '') errors.push({ pointer: '/amountMillimes', code: 'REQUIRED' });
      else if (!/^[1-9][0-9]{0,14}$/.test(amount)) {
        errors.push({ pointer: '/amountMillimes', code: 'INVALID_FORMAT' });
      }
      if (!(proof instanceof File) || proof.size === 0) {
        errors.push({ pointer: '/proof', code: 'REQUIRED' });
      }
      if (errors.length > 0) return validationProblem(errors);
      if (!(proof instanceof File))
        return validationProblem([{ pointer: '/proof', code: 'REQUIRED' }]);
      if (proof.size > MAX_PROOF_BYTES) return problem(413, 'PAYLOAD_TOO_LARGE');
      const contentType = await sniff(proof);
      if (contentType === undefined) return problem(415, 'UNSUPPORTED_MEDIA_TYPE');
      const declaredAt = new Date().toISOString();
      order.declaration = {
        transferReference: reference,
        transferDate: date,
        amountMillimes: Number(amount),
        proof: {
          fileName: proof.name.slice(0, 255) || 'capture',
          contentType,
          sizeBytes: proof.size,
        },
        declaredAt,
      };
      order.declaredAmountMillimes = Number(amount);
      order.proof = new Blob([proof], { type: contentType });
      delete order.proofRejectionReason;
      order.status = 'AWAITING_VALIDATION';
      record(order, 'TRANSFER_DECLARED');
      audit('orders.declare-transfer', order.reference);
      saveOrders();
      return HttpResponse.json<S['CreditOrderDetail']>(detail(order), { status: 201 });
    },
  ),

  http.get(apiUrl('/v1/company/orders/:orderId/proof'), async ({ params }) => {
    const account = await guardRead('COMPANY');
    if (isResponse(account)) return account;
    return proofResponse(find(String(params.orderId), true));
  }),

  // ---------------------------------------------------------------- admin
  http.get(apiUrl('/v1/admin/credit-orders'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const creditType = query.get('creditType');
    const companyId = query.get('companyId');
    const rank = (order: MockOrder) => (NEEDS_ADMIN.includes(order.status) ? 0 : 1);
    const items = db.orders
      .filter((order) => status === null || order.status === status)
      .filter(
        (order) =>
          creditType === null || order.lines.some((line) => line.creditType === creditType),
      )
      .filter((order) => companyId === null || order.companyId === companyId)
      .sort((a, b) => rank(a) - rank(b) || b.createdAt.localeCompare(a.createdAt))
      .map(orderSummary);
    return HttpResponse.json<S['CreditOrderPage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/admin/credit-orders/:orderId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), false);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(apiUrl('/v1/admin/credit-orders/:orderId/confirm'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), false);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    if (order.status !== 'AWAITING_CONFIRMATION') return conflict();
    order.status = 'AWAITING_PAYMENT';
    record(order, 'CONFIRMED');
    audit('orders.confirm', order.reference);
    saveOrders();
    refreshInvoices();
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(apiUrl('/v1/admin/credit-orders/:orderId/refuse'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), false);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    if (order.status !== 'AWAITING_CONFIRMATION') return conflict();
    const reason = await readReason(request);
    if (isResponse(reason)) return reason;
    order.status = 'REFUSED';
    order.refusalReason = reason;
    record(order, 'REFUSED', reason);
    audit('orders.refuse', order.reference);
    saveOrders();
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(apiUrl('/v1/admin/credit-orders/:orderId/validate'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN', true);
    if (isResponse(account)) return account;
    const order = find(String(params.orderId), false);
    if (order === undefined) return problem(404, 'NOT_FOUND');
    if (order.status !== 'AWAITING_VALIDATION') return conflict();
    // Four-eyes (rule 12): above the threshold, two different administrators validate.
    if (order.requiresSecondValidation) {
      if (order.firstValidator === undefined) {
        order.firstValidator = {
          actorId: account.id,
          actorName: account.displayName,
          occurredAt: new Date().toISOString(),
        };
        record(order, 'FIRST_VALIDATION');
        audit('orders.first-validation', order.reference);
        saveOrders();
        return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
      }
      if (order.firstValidator.actorId === account.id) return problem(403, 'FORBIDDEN');
    }
    order.status = 'VALIDATED';
    record(order, 'VALIDATED');
    // Each line credits the balance of its own type.
    if (order.companyId === COMPANY_TENANT.id) {
      for (const line of order.lines) db.company.balances[line.creditType] += line.amountMillimes;
    }
    audit('orders.validate', order.reference);
    saveOrders();
    refreshInvoices();
    return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
  }),

  http.post(
    apiUrl('/v1/admin/credit-orders/:orderId/reject-proof'),
    async ({ request, params }) => {
      const account = await guardWrite(request, 'ADMIN');
      if (isResponse(account)) return account;
      const order = find(String(params.orderId), false);
      if (order === undefined) return problem(404, 'NOT_FOUND');
      if (order.status !== 'AWAITING_VALIDATION') return conflict();
      const reason = await readReason(request);
      if (isResponse(reason)) return reason;
      order.status = 'AWAITING_PAYMENT';
      order.proofRejectionReason = reason;
      delete order.firstValidator;
      delete order.declaration;
      delete order.declaredAmountMillimes;
      delete order.proof;
      record(order, 'PROOF_REJECTED', reason);
      audit('orders.reject-proof', order.reference);
      saveOrders();
      return HttpResponse.json<S['CreditOrderDetail']>(detail(order));
    },
  ),

  http.get(apiUrl('/v1/admin/credit-orders/:orderId/proof'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    return proofResponse(find(String(params.orderId), false));
  }),
];
