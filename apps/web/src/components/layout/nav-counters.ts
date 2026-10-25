'use client';

import type { Schemas } from '@flexipay/api-client';
import { useEffect, useState } from 'react';
import { getApi } from '@/lib/api/client';
import { can } from '@/lib/session/permissions';
import type { Me } from '@/lib/session/session-context';

type Role = Schemas['Role'];

/** Counters shown in the sidebar next to what waits for an action of the signed-in user. */
export type NavCounter =
  | 'companyOrdersToPay'
  | 'adminOrdersToHandle'
  | 'adminApprovals'
  | 'adminKyc'
  | 'adminPayouts'
  | 'adminMessages'
  | 'employeeRequests';
export type NavCounts = Partial<Record<NavCounter, number>>;

type CountResult = Promise<{ data?: { page: Schemas['PageInfo'] } }>;

/** A counter the session may not read is never asked to the API (0, no 403). */
async function count(load: () => CountResult, allowed = true): Promise<number> {
  if (!allowed) return 0;
  const { data } = await load();
  return data?.page.count?.value ?? 0;
}

const LOADERS: Partial<Record<Role, (me: Me) => Promise<NavCounts>>> = {
  EMPLOYEE: async () => {
    const { data } = await getApi().GET('/v1/employee/payment-requests');
    return { employeeRequests: data?.data.length ?? 0 };
  },
  COMPANY: async (me) => ({
    companyOrdersToPay: await count(
      () =>
        getApi().GET('/v1/company/orders', {
          params: { query: { status: 'AWAITING_PAYMENT', limit: 1, withCount: true } },
        }),
      can(me, 'orders.read'),
    ),
  }),
  ADMIN: async (me) => {
    const orders = (status: Schemas['OrderStatus']) =>
      count(
        () =>
          getApi().GET('/v1/admin/credit-orders', {
            params: { query: { status, limit: 1, withCount: true } },
          }),
        can(me, 'creditOrders.read'),
      );
    const [toConfirm, toValidate, approvals, kyc, payouts, messages] = await Promise.all([
      orders('AWAITING_CONFIRMATION'),
      orders('AWAITING_VALIDATION'),
      count(
        () =>
          getApi().GET('/v1/admin/approvals', {
            params: { query: { status: 'PENDING', limit: 1, withCount: true } },
          }),
        can(me, 'approvals.read'),
      ),
      count(
        () =>
          getApi().GET('/v1/admin/kyc-files', {
            params: { query: { status: 'PENDING', limit: 1, withCount: true } },
          }),
        can(me, 'kyc.read'),
      ),
      count(
        () =>
          getApi().GET('/v1/admin/payout-requests', {
            params: { query: { status: 'REQUESTED', limit: 1, withCount: true } },
          }),
        can(me, 'adminPayouts.read'),
      ),
      count(
        () =>
          getApi().GET('/v1/admin/contact-messages', {
            params: { query: { status: 'NEW', limit: 1, withCount: true } },
          }),
        can(me, 'messages.read'),
      ),
    ]);
    return {
      adminOrdersToHandle: toConfirm + toValidate,
      adminApprovals: approvals,
      adminKyc: kyc,
      adminPayouts: payouts,
      adminMessages: messages,
    };
  },
};

/** Loads the counters of the role, again at each page change (after an action). */
export function useNavCounters(me: Me, pathname: string): NavCounts {
  const role = me.role;
  const [counts, setCounts] = useState<NavCounts>({});
  useEffect(() => {
    const load = LOADERS[role];
    if (load === undefined) return undefined;
    let active = true;
    load(me)
      .then((next) => {
        if (active) setCounts(next);
      })
      .catch(() => undefined);
    return () => {
      active = false;
    };
  }, [role, me, pathname]);
  return counts;
}
