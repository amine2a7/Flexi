import type { Schemas as S } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { apiUrl, guardRead, isResponse, paginate, problem } from './util';

// Fraud alerts and disputes (contract 0.8.0). Permissions: the gate, as for the other routes.
const DAY = 86_400_000;
const at = (days: number) => new Date(Date.UTC(2026, 9, 28, 9, 30) - days * DAY).toISOString();

const ALERTS: S['FraudAlert'][] = [
  {
    id: '0193f0a0-0000-7000-8000-000000000a01',
    kind: 'MERCHANT_BURST',
    severity: 'HIGH',
    subject: 'Snack Le Phare (Sousse)',
    occurredAt: at(0),
    status: 'OPEN',
    handledByName: null,
    closeReason: null,
  },
  {
    id: '0193f0a0-0000-7000-8000-000000000a02',
    kind: 'REPEATED_REFUSALS',
    severity: 'MEDIUM',
    subject: 'Yasmine J. (Groupe Carthage Services)',
    occurredAt: at(1),
    status: 'IN_PROGRESS',
    handledByName: 'Mouna K.',
    closeReason: null,
  },
  {
    id: '0193f0a0-0000-7000-8000-000000000a03',
    kind: 'NEAR_DAILY_LIMIT',
    severity: 'LOW',
    subject: 'Café El Medina (Tunis)',
    occurredAt: at(4),
    status: 'CLOSED',
    handledByName: 'Mouna K.',
    closeReason: 'Plafond proche, achat légitime vérifié.',
  },
];

const DISPUTES: S['Dispute'][] = [
  {
    id: '0193f0a0-0000-7000-8000-000000000d01',
    reference: 'LIT-2026-0001',
    paymentReference: 'PAY-2026-004812',
    merchantName: 'Café El Medina',
    creditType: 'RESTAURATION',
    amountMillimes: 45_000,
    reason: 'Montant saisi deux fois par le caissier.',
    status: 'OPEN',
    openedAt: at(0),
    openedByName: 'Hela R.',
    dueAt: at(-15),
    decisionReason: null,
    decidedAt: null,
  },
  {
    id: '0193f0a0-0000-7000-8000-000000000d02',
    reference: 'LIT-2026-0002',
    paymentReference: 'PAY-2026-004377',
    merchantName: 'Boulangerie du Lac',
    creditType: 'RESTAURATION',
    amountMillimes: 12_500,
    reason: 'Paiement contesté par le bénéficiaire.',
    status: 'ACCEPTED',
    openedAt: at(3),
    openedByName: 'Hela R.',
    dueAt: at(-12),
    decisionReason: 'Double débit confirmé par le commerçant.',
    decidedAt: at(1),
  },
];

const NOTES = new Map<string, S['DisputeNote'][]>();

const signedIn = async () => {
  const account = await guardRead('ADMIN');
  return account;
};
const findAlert = (id: unknown) => ALERTS.find((alert) => alert.id === id);
const findDispute = (id: unknown) => DISPUTES.find((dispute) => dispute.id === id);
const detail = (dispute: S['Dispute']): S['DisputeDetail'] => ({
  ...dispute,
  notes: NOTES.get(dispute.id) ?? [],
});

export const riskHandlers = [
  http.get(apiUrl('/v1/admin/fraud-alerts'), async ({ request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    return HttpResponse.json<S['FraudAlertPage']>(paginate(ALERTS, request));
  }),
  http.post(apiUrl('/v1/admin/fraud-alerts/:alertId/start'), async ({ params }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const alert = findAlert(params.alertId);
    if (alert === undefined) return problem(404, 'NOT_FOUND');
    if (alert.status !== 'OPEN') return problem(409, 'RESOURCE_STATE_CONFLICT');
    alert.status = 'IN_PROGRESS';
    alert.handledByName = account.displayName;
    return HttpResponse.json<S['FraudAlert']>(alert);
  }),
  http.post(apiUrl('/v1/admin/fraud-alerts/:alertId/close'), async ({ params, request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const alert = findAlert(params.alertId);
    if (alert === undefined) return problem(404, 'NOT_FOUND');
    if (alert.status === 'CLOSED') return problem(409, 'RESOURCE_STATE_CONFLICT');
    const { reason } = (await request.json()) as S['DecisionReason'];
    alert.status = 'CLOSED';
    alert.handledByName = account.displayName;
    alert.closeReason = reason;
    return HttpResponse.json<S['FraudAlert']>(alert);
  }),
  http.get(apiUrl('/v1/admin/disputes'), async ({ request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    return HttpResponse.json<S['DisputePage']>(paginate(DISPUTES, request));
  }),
  http.get(apiUrl('/v1/admin/disputes/:disputeId'), async ({ params }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const dispute = findDispute(params.disputeId);
    if (dispute === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['DisputeDetail']>(detail(dispute));
  }),
  http.post(apiUrl('/v1/admin/disputes/:disputeId/notes'), async ({ params, request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const dispute = findDispute(params.disputeId);
    if (dispute === undefined) return problem(404, 'NOT_FOUND');
    const { text } = (await request.json()) as S['DisputeNoteCreate'];
    const note: S['DisputeNote'] = {
      id: crypto.randomUUID(),
      authorName: account.displayName,
      text,
      createdAt: new Date().toISOString(),
    };
    NOTES.set(dispute.id, [...(NOTES.get(dispute.id) ?? []), note]);
    return HttpResponse.json<S['DisputeNote']>(note, { status: 201 });
  }),
  http.post(apiUrl('/v1/admin/disputes/:disputeId/reject'), async ({ params, request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const dispute = findDispute(params.disputeId);
    if (dispute === undefined) return problem(404, 'NOT_FOUND');
    if (dispute.status !== 'OPEN') return problem(409, 'RESOURCE_STATE_CONFLICT');
    const { reason } = (await request.json()) as S['DecisionReason'];
    dispute.status = 'REJECTED';
    dispute.decisionReason = reason;
    dispute.decidedAt = new Date().toISOString();
    return HttpResponse.json<S['Dispute']>(dispute);
  }),
  http.post(apiUrl('/v1/admin/disputes/:disputeId/accept'), async ({ params, request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const dispute = findDispute(params.disputeId);
    if (dispute === undefined) return problem(404, 'NOT_FOUND');
    if (dispute.status !== 'OPEN') return problem(409, 'RESOURCE_STATE_CONFLICT');
    const { reason } = (await request.json()) as S['DecisionReason'];
    dispute.status = 'ACCEPTANCE_PENDING';
    dispute.decisionReason = reason;
    return HttpResponse.json<S['Dispute']>(dispute);
  }),
  http.post(apiUrl('/v1/admin/disputes'), async ({ request }) => {
    const account = await signedIn();
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['DisputeOpen'];
    const dispute: S['Dispute'] = {
      id: crypto.randomUUID(),
      reference: `LIT-2026-${String(DISPUTES.length + 1).padStart(4, '0')}`,
      paymentReference: body.paymentId.slice(0, 13),
      merchantName: 'Café El Medina',
      creditType: 'RESTAURATION',
      amountMillimes: 30_000,
      reason: body.reason,
      status: 'OPEN',
      openedAt: new Date().toISOString(),
      openedByName: account.displayName,
      dueAt: at(-15),
      decisionReason: null,
      decidedAt: null,
    };
    DISPUTES.unshift(dispute);
    return HttpResponse.json<S['Dispute']>(dispute, { status: 201 });
  }),
];
