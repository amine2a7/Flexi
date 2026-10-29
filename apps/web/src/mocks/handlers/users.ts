import type { Schemas as S } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { db } from '../db';
import { apiUrl, guardRead, guardWrite, isResponse, matches, paginate, problem } from './util';

// User management in the mock (decisions A to D of 2026-10-23): same rules as the API (immediate
// change, reason kept, own account and last super-admin refused, no comeback from DEACTIVATED).
// The permissions themselves are refused by the permission gate (route table of the API).

const GRACE_DAYS = 30;
const DAY_MS = 86_400_000;
type Status = S['UserStatus'];
interface UserState {
  status: Status;
  graceUntil: string | null;
  subRole: S['SubRole'] | null;
  history: S['UserAuditEntry'][];
}
const state = new Map<string, UserState>();

function stateOf(id: string, fallback: Partial<UserState> = {}): UserState {
  let found = state.get(id);
  if (found === undefined) {
    found = { status: 'ACTIVE', graceUntil: null, subRole: null, history: [], ...fallback };
    state.set(id, found);
  }
  return found;
}

function users(): S['AdminUser'][] {
  const accounts = db.accounts.map((account) => {
    const current = stateOf(account.id, {
      status: account.temporaryPassword ? 'INVITED' : 'ACTIVE',
      subRole: account.subRole,
    });
    return {
      id: account.id,
      displayName: account.displayName,
      email: account.identifier,
      role: account.role,
      subRole: current.subRole,
      tenant:
        account.tenant === null ? null : { id: account.tenant.id, name: account.tenant.label },
      status: current.status,
      graceUntil: current.graceUntil,
      createdAt: '2026-09-01T08:00:00.000Z',
    };
  });
  const employees = db.company.employees.map((employee) => ({
    id: employee.id,
    displayName: `${employee.firstName} ${employee.lastName}`,
    email: employee.email,
    role: 'EMPLOYEE' as const,
    subRole: null,
    tenant: { id: '01930a1c-2b3d-7e4f-8a5b-6c7d8e9f0a1b', name: 'Groupe Carthage Services' },
    status: employee.status,
    graceUntil: employee.graceUntil ?? null,
    createdAt: '2026-09-15T08:00:00.000Z',
  }));
  return [...accounts, ...employees];
}

function detail(user: S['AdminUser'], withBalance: boolean): S['AdminUserDetail'] {
  const employee = db.company.employees.find((item) => item.id === user.id);
  return {
    ...user,
    mfaEnabled: user.role !== 'EMPLOYEE',
    pinLocked: false,
    ...(employee === undefined ? {} : { graceDays: GRACE_DAYS }),
    ...(employee !== undefined && withBalance
      ? { balanceMillimes: employee.monthAllocatedMillimes }
      : {}),
    history: stateOf(user.id).history,
  };
}

function next(status: Status, action: 'suspend' | 'reactivate' | 'deactivate'): Status | null {
  if (status === 'DEACTIVATED') return null;
  if (action === 'deactivate') return 'DEACTIVATED';
  if (action === 'suspend') return status === 'SUSPENDED' ? null : 'SUSPENDED';
  return status === 'SUSPENDED' ? 'ACTIVE' : null;
}

async function readReason(request: Request): Promise<string | null> {
  const body = (await request.json().catch(() => ({}))) as { reason?: unknown };
  const reason = typeof body.reason === 'string' ? body.reason.trim() : '';
  return reason.length >= 10 && reason.length <= 500 ? reason : null;
}

const reasonProblem = () =>
  problem(400, 'VALIDATION_FAILED', {
    fields: [
      { in: 'body', pointer: '/reason', code: 'TOO_SHORT', messageKey: 'errors.field.tooShort' },
    ],
  });

function record(id: string, actorName: string, action: string, reason: string | null) {
  stateOf(id).history.unshift({ occurredAt: new Date().toISOString(), actorName, action, reason });
}

/** Applies a status change to a mock user (and to the company employee it is). */
function applyStatus(id: string, status: Status): void {
  const current = stateOf(id);
  current.status = status;
  current.graceUntil =
    status === 'DEACTIVATED' ? new Date(Date.now() + GRACE_DAYS * DAY_MS).toISOString() : null;
  const employee = db.company.employees.find((item) => item.id === id);
  if (employee !== undefined) {
    employee.status = status;
    if (current.graceUntil === null) delete employee.graceUntil;
    else employee.graceUntil = current.graceUntil;
  }
}

const statusRoute = (action: 'suspend' | 'reactivate' | 'deactivate') =>
  http.post(apiUrl(`/v1/admin/users/:userId/${action}`), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const user = users().find((item) => item.id === params.userId);
    if (user === undefined) return problem(404, 'NOT_FOUND');
    if (user.id === account.id) return problem(403, 'FORBIDDEN');
    const reason = await readReason(request);
    if (reason === null) return reasonProblem();
    const superAdmins = users().filter(
      (item) => item.subRole === 'SUPER_ADMIN' && item.status === 'ACTIVE',
    ).length;
    if (user.subRole === 'SUPER_ADMIN' && action !== 'reactivate' && superAdmins <= 1)
      return problem(422, 'LAST_SUPER_ADMIN');
    const status = next(user.status, action);
    if (status === null) return problem(409, 'RESOURCE_STATE_CONFLICT');
    applyStatus(user.id, status);
    record(user.id, account.displayName, `users.${action}`, reason);
    const updated = users().find((item) => item.id === user.id) ?? user;
    return HttpResponse.json<S['AdminUserDetail']>(
      detail(updated, account.permissions.includes('userBalances.read')),
    );
  });

const companyStatusRoute = (action: 'suspend' | 'reactivate' | 'deactivate') =>
  http.post(apiUrl(`/v1/company/employees/:employeeId/${action}`), async ({ request, params }) => {
    const account = await guardWrite(request, 'COMPANY');
    if (isResponse(account)) return account;
    const employee = db.company.employees.find((item) => item.id === params.employeeId);
    if (employee === undefined) return problem(404, 'NOT_FOUND');
    const reason = await readReason(request);
    if (reason === null) return reasonProblem();
    const status = next(employee.status, action);
    if (status === null) return problem(409, 'RESOURCE_STATE_CONFLICT');
    applyStatus(employee.id, status);
    record(employee.id, account.displayName, `users.${action}`, reason);
    return HttpResponse.json<S['Employee']>(employee);
  });

export const userHandlers = [
  http.get(apiUrl('/v1/admin/users'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const query = new URL(request.url).searchParams;
    const role = query.get('role');
    const status = query.get('status');
    const items = users()
      .filter((user) => role === null || user.role === role)
      .filter((user) => status === null || user.status === status)
      .filter((user) => matches(query.get('q'), user.displayName, user.email));
    return HttpResponse.json<S['AdminUserPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/admin/users'), async ({ request }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['AdminUserCreate'];
    if (body.reason.trim().length < 10) return reasonProblem();
    // Same answer whatever the address (no enumeration); nothing is created in the mock.
    return new HttpResponse(null, { status: 202 });
  }),

  http.get(apiUrl('/v1/admin/users/:userId'), async ({ params }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const user = users().find((item) => item.id === params.userId);
    if (user === undefined) return problem(404, 'NOT_FOUND');
    return HttpResponse.json<S['AdminUserDetail']>(
      detail(user, account.permissions.includes('userBalances.read')),
    );
  }),

  statusRoute('suspend'),
  statusRoute('reactivate'),
  statusRoute('deactivate'),

  http.post(apiUrl('/v1/admin/users/:userId/role'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const user = users().find((item) => item.id === params.userId);
    if (user === undefined) return problem(404, 'NOT_FOUND');
    if (user.id === account.id) return problem(403, 'FORBIDDEN');
    const body = (await request.clone().json()) as { subRole: S['SubRole'] };
    const reason = await readReason(request);
    if (reason === null) return reasonProblem();
    stateOf(user.id).subRole = body.subRole;
    record(user.id, account.displayName, 'users.role', reason);
    const updated = users().find((item) => item.id === user.id) ?? user;
    return HttpResponse.json<S['AdminUserDetail']>(
      detail(updated, account.permissions.includes('userBalances.read')),
    );
  }),

  http.post(apiUrl('/v1/admin/users/:userId/reset-invitation'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const user = users().find((item) => item.id === params.userId);
    if (user === undefined) return problem(404, 'NOT_FOUND');
    if (user.id === account.id || user.role === 'ADMIN') return problem(403, 'FORBIDDEN');
    record(user.id, account.displayName, 'users.resendInvitation', null);
    return HttpResponse.json<S['AdminUserDetail']>(
      detail(user, account.permissions.includes('userBalances.read')),
    );
  }),

  http.post(apiUrl('/v1/admin/users/:userId/unlock-pin'), () => {
    // No locked PIN in the mock data.
    return problem(409, 'RESOURCE_STATE_CONFLICT');
  }),

  companyStatusRoute('suspend'),
  companyStatusRoute('reactivate'),
  companyStatusRoute('deactivate'),
];
