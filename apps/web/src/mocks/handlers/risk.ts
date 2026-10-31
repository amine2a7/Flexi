import type { Schemas as S } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { apiUrl, guardRead, isResponse, paginate, problem } from './util';

// Fraud alerts and disputes (contract 0.6.0): routes planned, not yet served by the API. The mock
// checks `risk.read` itself (the permission gate only knows the routes the API serves).
const DAY = 86_400_000;
const at = (days: number) => new Date(Date.UTC(2026, 9, 28, 9, 30) - days * DAY).toISOString();

const ALERTS: S['FraudAlert'][] = [
  {
    id: '0193f0a0-0000-7000-8000-000000000a01',
    kind: 'VELOCITY',
    severity: 'HIGH',
    subject: 'Snack Le Phare (Sousse)',
    occurredAt: at(0),
    status: 'OPEN',
  },
  {
    id: '0193f0a0-0000-7000-8000-000000000a02',
    kind: 'PIN_LOCKS',
    severity: 'MEDIUM',
    subject: 'Yasmine J. (Groupe Carthage Services)',
    occurredAt: at(1),
    status: 'IN_PROGRESS',
  },
  {
    id: '0193f0a0-0000-7000-8000-000000000a03',
    kind: 'LARGE_AMOUNT',
    severity: 'LOW',
    subject: 'Café El Medina (Tunis)',
    occurredAt: at(4),
    status: 'CLOSED',
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

const allowed = async () => {
  const account = await guardRead('ADMIN');
  if (isResponse(account)) return account;
  return account.permissions.includes('risk.read') ? account : problem(403, 'FORBIDDEN');
};

export const riskHandlers = [
  http.get(apiUrl('/v1/admin/fraud-alerts'), async ({ request }) => {
    const account = await allowed();
    if (isResponse(account)) return account;
    return HttpResponse.json<S['FraudAlertPage']>(paginate(ALERTS, request));
  }),
  http.get(apiUrl('/v1/admin/disputes'), async ({ request }) => {
    const account = await allowed();
    if (isResponse(account)) return account;
    return HttpResponse.json<S['DisputePage']>(paginate(DISPUTES, request));
  }),
];
