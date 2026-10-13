import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { demoIban } from '../admin-seed';
import { currentAccount, db } from '../db';
import { MERCHANT_TENANT } from '../fixtures/accounts';
import { createRandom } from '../fixtures/random';
import { fileResponse, renderDemoDocument } from './demo-document';
import { payoutHistory } from './merchant';
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
type AdminPayout = S['AdminPayoutRequest'];

// Admin operations: KYC files, merchant payout control, settlement batch detail, transactions.

async function readReason(request: Request): Promise<string | Response> {
  const body = (await request.json().catch(() => ({}))) as Partial<S['DecisionReason']>;
  const reason = typeof body.reason === 'string' ? body.reason.trim() : '';
  if (reason === '') return validationProblem([{ pointer: '/reason', code: 'REQUIRED' }]);
  if (reason.length > 500) return validationProblem([{ pointer: '/reason', code: 'TOO_LONG' }]);
  return reason;
}

const actor = (): string => currentAccount()?.displayName ?? 'FlexiPay';
const conflict = (): Response => problem(409, 'RESOURCE_STATE_CONFLICT');

// ---------------------------------------------------------------- KYC

function kycSummary(file: S['KycFile']): S['KycFileSummary'] {
  const { documents: _documents, history: _history, rejectionReason: _reason, ...rest } = file;
  return rest;
}

const DOCUMENT_TITLES: Record<S['KycDocumentType'], string> = {
  REGISTRY_EXTRACT: 'EXTRAIT DU REGISTRE DE COMMERCE',
  TAX_CERTIFICATE: 'ATTESTATION FISCALE',
  MANAGER_ID: "PIÈCE D'IDENTITÉ DU GÉRANT",
  BANK_DETAILS: "RELEVÉ D'IDENTITÉ BANCAIRE",
};

function setAccountStatus(file: S['KycFile'], status: S['AccountStatus']): void {
  const list = file.accountType === 'MERCHANT' ? db.admin.merchants : db.admin.companies;
  const account = list.find((item) => item.id === file.accountId);
  if (account !== undefined) account.status = status;
}

// ---------------------------------------------------------------- payouts and batches

function batchOf(payoutId: string): Pick<AdminPayout, 'batchId' | 'batchReference'> {
  for (const lines of db.admin.batchLines.values()) {
    const line = lines.find((item) => item.id === payoutId);
    if (line?.batchId !== undefined) {
      return { batchId: line.batchId, batchReference: line.batchReference ?? '' };
    }
  }
  return {};
}

function demoShopPayouts(): AdminPayout[] {
  return db.merchant.payouts.map((payout) => ({
    id: payout.id,
    reference: payout.reference,
    status: payout.status,
    creditType: payout.creditType,
    merchantId: MERCHANT_TENANT.id,
    merchantName: MERCHANT_TENANT.label,
    grossMillimes: payout.grossMillimes,
    commissionRateBps: payout.commissionRateBps,
    commissionMillimes: payout.commissionMillimes,
    netMillimes: payout.netMillimes,
    requestedAt: payout.requestedAt,
    iban: demoIban(MERCHANT_TENANT.id, () => ''),
    ...batchOf(payout.id),
  }));
}

function allPayouts(): AdminPayout[] {
  return [
    ...demoShopPayouts(),
    ...db.admin.payoutRequests.map((payout) => ({ ...payout, ...batchOf(payout.id) })),
  ];
}

/** Changes the status where the request lives (demo shop list or other merchants). */
function setPayoutStatus(id: string, status: S['PayoutRequestStatus']): void {
  const own = db.merchant.payouts.find((payout) => payout.id === id);
  if (own !== undefined) own.status = status;
  const other = db.admin.payoutRequests.find((payout) => payout.id === id);
  if (other !== undefined) other.status = status;
}

function payoutDetail(payout: AdminPayout): S['AdminPayoutRequestDetail'] {
  return { ...payout, history: payoutHistory(payout) };
}

/** Lines of a seeded batch: one validated payout per merchant, summing exactly to its totals. */
function ensureLines(batch: S['SettlementBatch']): AdminPayout[] {
  const existing = db.admin.batchLines.get(batch.id);
  if (existing !== undefined) return existing;
  const random = createRandom(Number(batch.reference.replace(/\D/g, '')) % 100_000);
  const merchants = db.admin.merchants
    .filter((merchant) => merchant.status === 'APPROVED')
    .slice(0, batch.merchantsCount);
  const weights = merchants.map(() => random.int(2, 12));
  const total = weights.reduce((sum, weight) => sum + weight, 0);
  let grossLeft = batch.grossMillimes;
  let commissionLeft = batch.commissionMillimes;
  const settlementTime = new Date(`${batch.settlementDate}T08:00:00.000Z`).getTime();
  const lines = merchants.map((merchant, index): AdminPayout => {
    const last = index === merchants.length - 1;
    const weight = weights[index] ?? 1;
    const gross = last ? grossLeft : Math.floor((batch.grossMillimes * weight) / total);
    const commission = last
      ? commissionLeft
      : Math.floor((batch.commissionMillimes * gross) / batch.grossMillimes);
    grossLeft -= gross;
    commissionLeft -= commission;
    return {
      id: random.uuid(),
      reference: `VIR-${batch.reference.slice(4)}-${String(index + 1).padStart(2, '0')}`,
      status: batch.status === 'PAID' ? 'EXECUTED' : 'CHECKED',
      creditType: merchant.acceptedCreditTypes[0] ?? 'RESTAURATION',
      merchantId: merchant.id,
      merchantName: merchant.name,
      grossMillimes: gross,
      commissionRateBps: merchant.commissionProfile.rateBps,
      commissionMillimes: commission,
      netMillimes: gross - commission,
      requestedAt: new Date(settlementTime - 2 * 86_400_000).toISOString(),
      iban: demoIban(merchant.id, () => random.digits(20)),
      batchId: batch.id,
      batchReference: batch.reference,
    };
  });
  db.admin.batchLines.set(batch.id, lines);
  return lines;
}

/** A validated payout joins the next scheduled batch; the batch totals follow. */
function addToNextBatch(payout: AdminPayout): void {
  const batch = db.admin.batches
    .filter((item) => item.status === 'SCHEDULED')
    .sort((a, b) => a.settlementDate.localeCompare(b.settlementDate))[0];
  if (batch === undefined) return;
  const lines = ensureLines(batch);
  lines.push({ ...payout, status: 'CHECKED', batchId: batch.id, batchReference: batch.reference });
  batch.grossMillimes += payout.grossMillimes;
  batch.commissionMillimes += payout.commissionMillimes;
  batch.netMillimes += payout.netMillimes;
  batch.merchantsCount = new Set(lines.map((line) => line.merchantId)).size;
}

export const adminOpsHandlers = [
  // ---------------------------------------------------------------- KYC
  http.get(apiUrl('/v1/admin/kyc-files'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const type = query.get('accountType');
    const items = db.admin.kycFiles
      .filter((file) => status === null || file.status === status)
      .filter((file) => type === null || file.accountType === type)
      .sort(
        (a, b) =>
          Number(b.status === 'PENDING') - Number(a.status === 'PENDING') ||
          b.submittedAt.localeCompare(a.submittedAt),
      )
      .map(kycSummary);
    return HttpResponse.json<S['KycFilePage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/admin/kyc-files/:fileId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const file = db.admin.kycFiles.find((item) => item.id === params.fileId);
    if (file === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['KycFile']>(file);
  }),

  http.get(apiUrl('/v1/admin/kyc-files/:fileId/documents/:documentId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const file = db.admin.kycFiles.find((item) => item.id === params.fileId);
    const document = file?.documents.find((item) => item.id === params.documentId);
    if (file === undefined || document === undefined) return problem(404, 'NOT_FOUND');
    let blob = db.admin.documents.get(document.id);
    if (blob === undefined) {
      blob = await renderDemoDocument(DOCUMENT_TITLES[document.type], [
        `Titulaire : ${file.accountName}`,
        `Ville : ${file.city}`,
        `Déposé le : ${document.uploadedAt.slice(0, 10)}`,
        `Référence du dossier : ${file.id.slice(0, 8).toUpperCase()}`,
      ]);
      db.admin.documents.set(document.id, blob);
    }
    return fileResponse(blob, document.fileName);
  }),

  http.post(apiUrl('/v1/admin/kyc-files/:fileId/approve'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const file = db.admin.kycFiles.find((item) => item.id === params.fileId);
    if (file === undefined) return problem(404, 'NOT_FOUND');
    if (file.status !== 'PENDING') return conflict();
    file.status = 'APPROVED';
    file.history.push({
      action: 'APPROVED',
      occurredAt: new Date().toISOString(),
      actorName: actor(),
    });
    setAccountStatus(file, 'APPROVED');
    audit('kyc.approve', file.accountName);
    return HttpResponse.json<S['KycFile']>(file);
  }),

  http.post(apiUrl('/v1/admin/kyc-files/:fileId/reject'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const file = db.admin.kycFiles.find((item) => item.id === params.fileId);
    if (file === undefined) return problem(404, 'NOT_FOUND');
    if (file.status !== 'PENDING') return conflict();
    const reason = await readReason(request);
    if (isResponse(reason)) return reason;
    file.status = 'REJECTED';
    file.rejectionReason = reason;
    file.history.push({
      action: 'REJECTED',
      occurredAt: new Date().toISOString(),
      actorName: actor(),
      reason,
    });
    setAccountStatus(file, 'REJECTED');
    audit('kyc.reject', file.accountName);
    return HttpResponse.json<S['KycFile']>(file);
  }),

  // ---------------------------------------------------------------- payout requests
  http.get(apiUrl('/v1/admin/payout-requests'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const creditType = query.get('creditType');
    const q = query.get('q');
    const items = allPayouts()
      .filter((payout) => status === null || payout.status === status)
      .filter((payout) => creditType === null || payout.creditType === creditType)
      .filter((payout) => matches(q, payout.merchantName, payout.reference))
      .sort(
        (a, b) =>
          Number(b.status === 'REQUESTED') - Number(a.status === 'REQUESTED') ||
          b.requestedAt.localeCompare(a.requestedAt),
      );
    return HttpResponse.json<S['AdminPayoutRequestPage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/admin/payout-requests/:payoutId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const payout = allPayouts().find((item) => item.id === params.payoutId);
    if (payout === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['AdminPayoutRequestDetail']>(payoutDetail(payout));
  }),

  http.post(apiUrl('/v1/admin/payout-requests/:payoutId/approve'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN', true);
    if (isResponse(account)) return account;
    const payout = allPayouts().find((item) => item.id === params.payoutId);
    if (payout === undefined) return problem(404, 'NOT_FOUND');
    if (payout.status !== 'REQUESTED') return conflict();
    const history = payoutHistory(payout);
    db.admin.payoutEvents.set(payout.id, [
      ...history,
      { status: 'CHECKED', occurredAt: new Date().toISOString() },
    ]);
    setPayoutStatus(payout.id, 'CHECKED');
    addToNextBatch(payout);
    audit('payouts.approve', payout.reference);
    const updated = allPayouts().find((item) => item.id === payout.id) ?? payout;
    return HttpResponse.json<S['AdminPayoutRequestDetail']>(payoutDetail(updated));
  }),

  http.post(apiUrl('/v1/admin/payout-requests/:payoutId/reject'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const payout = allPayouts().find((item) => item.id === params.payoutId);
    if (payout === undefined) return problem(404, 'NOT_FOUND');
    if (payout.status !== 'REQUESTED') return conflict();
    const reason = await readReason(request);
    if (isResponse(reason)) return reason;
    db.admin.payoutEvents.set(payout.id, [
      ...payoutHistory(payout),
      { status: 'REJECTED', occurredAt: new Date().toISOString(), reason },
    ]);
    setPayoutStatus(payout.id, 'REJECTED');
    audit('payouts.reject', payout.reference);
    const updated = allPayouts().find((item) => item.id === payout.id) ?? payout;
    return HttpResponse.json<S['AdminPayoutRequestDetail']>(payoutDetail(updated));
  }),

  // ---------------------------------------------------------------- batches and transactions
  http.get(apiUrl('/v1/admin/settlements/:batchId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const batch = db.admin.batches.find((item) => item.id === params.batchId);
    if (batch === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['SettlementBatchDetail']>({ ...batch, payouts: ensureLines(batch) });
  }),

  http.get(apiUrl('/v1/admin/transactions'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const q = query.get('q');
    const from = query.get('createdFrom');
    const to = query.get('createdTo');
    const creditType = query.get('creditType');
    const items = db.admin.transactions
      .filter((item) => status === null || item.status === status)
      .filter((item) => creditType === null || item.creditType === creditType)
      .filter((item) => matches(q, item.merchantName, item.companyName, item.reference))
      .filter((item) => from === null || item.createdAt >= from)
      .filter((item) => to === null || item.createdAt <= to);
    return HttpResponse.json<S['AdminTransactionPage']>(paginate(items, request));
  }),
];
