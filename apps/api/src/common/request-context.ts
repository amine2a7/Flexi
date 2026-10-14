import { AsyncLocalStorage } from 'node:async_hooks';
import type { Role, SessionStep, SubRole } from '../generated/prisma/enums.js';

/** Signed-in user, as established by the AuthGuard from the session (never from the request). */
export interface Principal {
  readonly userId: string;
  readonly sessionId: string;
  readonly role: Role;
  readonly subRole: SubRole | null;
  readonly displayName: string;
  readonly step: SessionStep;
  readonly companyId: string | null;
  readonly merchantId: string | null;
  readonly employeeId: string | null;
}

export interface RequestContext {
  readonly requestId: string;
  readonly ip: string;
  principal?: Principal;
}

const storage = new AsyncLocalStorage<RequestContext>();

export function runWithContext<T>(context: RequestContext, fn: () => T): T {
  return storage.run(context, fn);
}

export function currentContext(): RequestContext | undefined {
  return storage.getStore();
}

/** Principal of the current request; routes behind the guard always have one. */
export function principal(): Principal {
  const value = storage.getStore()?.principal;
  if (value === undefined) throw new Error('no principal: route not protected by the AuthGuard');
  return value;
}

/** Tenant id of the principal (company, merchant or employee), for scopes and the ledger. */
export function tenantOf(value: Principal): string | null {
  return value.companyId ?? value.merchantId ?? value.employeeId;
}
