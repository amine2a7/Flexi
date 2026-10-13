'use client';

import type { Schemas } from '@flexipay/api-client';
import { useEffect, useState } from 'react';
import { getApi } from '@/lib/api/client';

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

async function count(load: () => CountResult): Promise<number> {
  const { data } = await load();
  return data?.page.count?.value ?? 0;
}

const LOADERS: Partial<Record<Role, () => Promise<NavCounts>>> = {
  EMPLOYEE: async () => {
    const { data } = await getApi().GET('/v1/employee/payment-requests');
    return { employeeRequests: data?.data.length ?? 0 };
  },
  COMPANY: async () => ({
    companyOrdersToPay: await count(() =>
      getApi().GET('/v1/company/orders', {
        params: { query: { status: 'AWAITING_PAYMENT', limit: 1, withCount: true } },
      }),
    ),
  }),
  ADMIN: async () => {
    const orders = (status: Schemas['OrderStatus']) =>
      count(() =>
        getApi().GET('/v1/admin/credit-orders', {
          params: { query: { status, limit: 1, withCount: true } },
        }),
      );
    const [toConfirm, toValidate, approvals, kyc, payouts, messages] = await Promise.all([
      orders('AWAITING_CONFIRMATION'),
      orders('AWAITING_VALIDATION'),
      count(() =>
        getApi().GET('/v1/admin/approvals', {
          params: { query: { status: 'PENDING', limit: 1, withCount: true } },
        }),
      ),
      count(() =>
        getApi().GET('/v1/admin/kyc-files', {
          params: { query: { status: 'PENDING', limit: 1, withCount: true } },
        }),
      ),
      count(() =>
        getApi().GET('/v1/admin/payout-requests', {
          params: { query: { status: 'REQUESTED', limit: 1, withCount: true } },
        }),
      ),
      count(() =>
        getApi().GET('/v1/admin/contact-messages', {
          params: { query: { status: 'NEW', limit: 1, withCount: true } },
        }),
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
export function useNavCounters(role: Role, pathname: string): NavCounts {
  const [counts, setCounts] = useState<NavCounts>({});
  useEffect(() => {
    const load = LOADERS[role];
    if (load === undefined) return undefined;
    let active = true;
    load()
      .then((next) => {
        if (active) setCounts(next);
      })
      .catch(() => undefined);
    return () => {
      active = false;
    };
  }, [role, pathname]);
  return counts;
}
