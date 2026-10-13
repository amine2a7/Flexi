import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { currentAccount, db } from '../db';
import {
  apiUrl,
  audit,
  guardRead,
  guardWrite,
  isResponse,
  latency,
  listParams,
  matches,
  paginate,
  problem,
  validationProblem,
} from './util';

type S = Schemas;
type FieldError = { pointer: string; code: S['FieldErrorCode'] };

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE = /^\+[1-9][0-9]{7,14}$/;
const TYPES: readonly S['ContactRequesterType'][] = ['COMPANY', 'MERCHANT', 'OTHER'];

function checkMessage(body: Partial<S['ContactMessageCreate']>): FieldError[] {
  const errors: FieldError[] = [];
  const text = (value: unknown) => (typeof value === 'string' ? value.trim() : '');
  const name = text(body.name);
  if (name === '') errors.push({ pointer: '/name', code: 'REQUIRED' });
  else if (name.length < 2 || name.length > 120)
    errors.push({ pointer: '/name', code: 'INVALID_FORMAT' });
  const email = text(body.email);
  if (email === '') errors.push({ pointer: '/email', code: 'REQUIRED' });
  else if (!EMAIL.test(email)) errors.push({ pointer: '/email', code: 'INVALID_FORMAT' });
  if (body.phone !== undefined && !PHONE.test(body.phone)) {
    errors.push({ pointer: '/phone', code: 'INVALID_FORMAT' });
  }
  if (!TYPES.includes(body.requesterType as S['ContactRequesterType'])) {
    errors.push({ pointer: '/requesterType', code: 'REQUIRED' });
  }
  const message = text(body.message);
  if (message === '') errors.push({ pointer: '/message', code: 'REQUIRED' });
  else if (message.length < 10 || message.length > 2000) {
    errors.push({ pointer: '/message', code: 'INVALID_FORMAT' });
  }
  return errors;
}

// Public "Contact us" form and the admin "Messages" page.
export const contactHandlers = [
  http.post(apiUrl('/v1/public/contact-messages'), async ({ request }) => {
    await latency();
    const body = (await request.json().catch(() => ({}))) as Partial<S['ContactMessageCreate']>;
    const errors = checkMessage(body);
    if (errors.length > 0) return validationProblem(errors);
    const last = Math.max(
      1040,
      ...db.admin.contactMessages.map((item) => Number(item.reference.slice(4)) || 0),
    );
    const reference = `MSG-${String(last + 1)}`;
    db.admin.contactMessages.unshift({
      id: crypto.randomUUID(),
      reference,
      name: (body.name ?? '').trim(),
      email: (body.email ?? '').trim(),
      phone: body.phone ?? null,
      companyName: body.companyName?.trim() === '' ? null : (body.companyName?.trim() ?? null),
      requesterType: body.requesterType ?? 'OTHER',
      message: (body.message ?? '').trim(),
      status: 'NEW',
      receivedAt: new Date().toISOString(),
      handledAt: null,
      handledBy: null,
      note: null,
    });
    return HttpResponse.json<S['ContactMessageReceipt']>({ reference }, { status: 202 });
  }),

  http.get(apiUrl('/v1/admin/contact-messages'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const type = query.get('requesterType');
    const items = db.admin.contactMessages
      .filter((item) => status === null || item.status === status)
      .filter((item) => type === null || item.requesterType === type)
      .filter((item) =>
        matches(query.get('q'), item.name, item.email, item.companyName ?? '', item.reference),
      )
      .sort((a, b) => b.receivedAt.localeCompare(a.receivedAt));
    return HttpResponse.json<S['ContactMessagePage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/admin/contact-messages/:messageId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const item = db.admin.contactMessages.find((entry) => entry.id === params.messageId);
    if (item === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['ContactMessage']>(item);
  }),

  http.post(apiUrl('/v1/admin/contact-messages/:messageId/handle'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const item = db.admin.contactMessages.find((entry) => entry.id === params.messageId);
    if (item === undefined) return problem(404, 'NOT_FOUND');
    if (item.status !== 'NEW') return problem(409, 'RESOURCE_STATE_CONFLICT');
    const body = (await request.json().catch(() => ({}))) as Partial<S['ContactMessageHandle']>;
    const note = typeof body.note === 'string' ? body.note.trim() : '';
    if (note.length > 500) return validationProblem([{ pointer: '/note', code: 'TOO_LONG' }]);
    item.status = 'HANDLED';
    item.handledAt = new Date().toISOString();
    item.handledBy = currentAccount()?.displayName ?? null;
    item.note = note === '' ? null : note;
    audit('contact.handle', item.reference);
    return HttpResponse.json<S['ContactMessage']>(item);
  }),
];
