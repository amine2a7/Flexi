'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';

type Employee = Schemas['Employee'];

/**
 * Credit allocation: same amount for every selected active employee. The total shown is only the
 * product of what the user typed; the server checks the balance (INSUFFICIENT_FUNDS).
 */
export default function AllocationPage() {
  const t = useTranslations('company.allocation');
  const tRoot = useTranslations();
  const locale = useLocale();
  const [q, setQ] = useState('');
  const [selected, setSelected] = useState<ReadonlyMap<string, Employee>>(new Map());
  const [amountText, setAmountText] = useState('');
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [result, setResult] = useState<Schemas['AllocationResult'] | undefined>(undefined);
  const [refresh, setRefresh] = useState(0);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);

  const dashboard = useApiQuery(() => getApi().GET('/v1/company/dashboard'), [refresh]);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/employees', {
        params: { query: { cursor, withCount, status: 'ACTIVE', ...(q === '' ? {} : { q }) } },
      }),
    [q, refresh],
  );
  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);
  const total = millimes === undefined ? undefined : millimes * selected.size;

  function toggle(employee: Employee) {
    setSelected((current) => {
      const next = new Map(current);
      if (next.has(employee.id)) next.delete(employee.id);
      else next.set(employee.id, employee);
      return next;
    });
  }

  async function onAllocate() {
    if (millimes === undefined) return;
    setSending(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/allocations', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: {
          allocations: [...selected.keys()].map((employeeId) => ({
            employeeId,
            amountMillimes: millimes,
          })),
        },
      });
      setConfirming(false);
      if (data === undefined) {
        setError(problem);
        return;
      }
      setResult(data);
      setSelected(new Map());
      setAmountText('');
      setIntentKey(newIdempotencyKey());
      setRefresh((value) => value + 1);
    } finally {
      setSending(false);
    }
  }

  const missing = (asProblem(error)?.details as { missingMillimes?: number } | undefined)
    ?.missingMillimes;
  const rows = list.rows ?? [];
  const allOnPage = rows.length > 0 && rows.every((row) => selected.has(row.id));
  const columns: Column<Employee>[] = [
    {
      key: 'select',
      header: t('selectPage'),
      cell: (row) => (
        <input
          type="checkbox"
          aria-label={t('select', { name: `${row.firstName} ${row.lastName}` })}
          checked={selected.has(row.id)}
          onChange={() => toggle(row)}
          className="size-icon-md"
        />
      ),
    },
    { key: 'number', header: t('number'), cell: (row) => row.employeeNumber },
    { key: 'name', header: t('name'), cell: (row) => `${row.firstName} ${row.lastName}` },
    {
      key: 'allocated',
      header: t('allocated'),
      align: 'end',
      cell: (row) => <Amount millimes={row.monthAllocatedMillimes} />,
    },
  ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6 grid gap-4 sm:grid-cols-2">
        <StatCard
          label={t('balance')}
          value={
            dashboard.status === 'success' ? (
              <Amount millimes={dashboard.data.walletBalanceMillimes} size="title" />
            ) : (
              '…'
            )
          }
          tone="positive"
        />
        <StatCard
          label={t('total')}
          value={total === undefined ? '…' : <Amount millimes={total} size="title" />}
          hint={t('selected', { count: selected.size })}
        />
      </div>
      {result !== undefined ? (
        <div className="mb-6">
          <Alert tone="success">
            {t('done', {
              count: result.allocatedCount,
              balance: formatMillimesWithCurrency(result.walletBalanceMillimes, locale),
            })}
          </Alert>
        </div>
      ) : null}
      {error !== undefined ? (
        <div className="mb-6">
          <Alert tone="danger">
            {missing !== undefined
              ? t('insufficient', { amount: formatMillimesWithCurrency(missing, locale) })
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        </div>
      ) : null}
      <div className="grid gap-6 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <FilterBar searchLabel={t('search')} onApply={(filters) => setQ(filters.q)} />
          <div className="mb-3">
            <Button
              variant="ghost"
              size="sm"
              disabled={rows.length === 0}
              onClick={() =>
                setSelected((current) => {
                  const next = new Map(current);
                  for (const row of rows) {
                    if (allOnPage) next.delete(row.id);
                    else next.set(row.id, row);
                  }
                  return next;
                })
              }
            >
              {t('selectPage')}
            </Button>
          </div>
          <DataTable
            caption={t('title')}
            columns={columns}
            rows={list.rows}
            rowKey={(row) => row.id}
            loading={list.loading}
            error={list.error}
            onRetry={list.reload}
            empty={{ title: t('emptyTitle') }}
            page={list.page}
            pageNumber={list.pageNumber}
            onNext={list.next}
            onPrevious={list.previous}
          />
        </Card>
        <Card>
          <div className="flex flex-col gap-5">
            <TextField
              label={t('amount')}
              hint={
                millimes === undefined
                  ? undefined
                  : t('amountPreview', { amount: formatMillimesWithCurrency(millimes, locale) })
              }
              error={amountText !== '' && millimes === undefined ? t('amountInvalid') : undefined}
              inputMode="decimal"
              value={amountText}
              onChange={(event) => setAmountText(event.target.value)}
            />
            <p className="text-body text-text-muted">{t('selected', { count: selected.size })}</p>
            <Button
              disabled={selected.size === 0 || millimes === undefined || millimes === 0}
              onClick={() => setConfirming(true)}
            >
              {t('submit')}
            </Button>
          </div>
        </Card>
      </div>
      {millimes !== undefined && total !== undefined ? (
        <ConfirmDialog
          open={confirming}
          onOpenChange={setConfirming}
          title={t('confirmTitle')}
          description={t('confirmMessage', {
            count: selected.size,
            amount: formatMillimesWithCurrency(millimes, locale),
          })}
          confirmLabel={t('confirmSubmit', { amount: formatMillimesWithCurrency(total, locale) })}
          loading={sending}
          onConfirm={() => void onAllocate()}
        />
      ) : null}
    </>
  );
}
