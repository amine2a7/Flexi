'use client';

import type { Schemas } from '@flexipay/api-client';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';

/** Number of orders in a status (bounded counter of the contract), for KPI cards and tiles. */
export function useOrderCount(
  scope: 'company' | 'admin',
  status: Schemas['OrderStatus'],
  refresh = 0,
): number | undefined {
  const query = useApiQuery(
    () =>
      scope === 'company'
        ? getApi().GET('/v1/company/orders', {
            params: { query: { status, limit: 1, withCount: true } },
          })
        : getApi().GET('/v1/admin/credit-orders', {
            params: { query: { status, limit: 1, withCount: true } },
          }),
    [scope, status, refresh],
  );
  return query.status === 'success' ? (query.data.page.count?.value ?? 0) : undefined;
}
