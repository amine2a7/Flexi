'use client';

import type { Schemas } from '@flexipay/api-client';
import { FileUp } from 'lucide-react';
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
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import {
  CreditTypeBadge,
  CreditTypeBalanceCards,
  CreditTypeSelect,
  useCreditTypeLabel,
  type CreditType,
} from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { Skeleton } from '@/components/ui/states';

type Employee = Schemas['Employee'];
type Preview = Schemas['AllocationImportPreview'];

/**
 * Credit allocation by credit type: the company chooses the type and the amount, and only the
 * balance of THAT type is debited (decision of 2026-10-13). Also by CSV, one column per type.
 */
export default function AllocationPage() {
  const t = useTranslations('company.allocation');
  const tTypes = useTranslations('ui.creditTypes');
  const tRoot = useTranslations();
  const typeLabel = useCreditTypeLabel();
  const locale = useLocale();
  const [q, setQ] = useState('');
  const [selected, setSelected] = useState<ReadonlyMap<string, Employee>>(new Map());
  const [creditType, setCreditType] = useState<CreditType>('RESTAURATION');
  const [amountText, setAmountText] = useState('');
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [errorType, setErrorType] = useState<CreditType | undefined>(undefined);
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

  async function allocate(lines: Schemas['AllocationLine'][], type?: CreditType): Promise<boolean> {
    setSending(true);
    setError(undefined);
    setErrorType(type);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/allocations', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: { allocations: lines },
      });
      setConfirming(false);
      if (data === undefined) {
        setError(problem);
        return false;
      }
      setResult(data);
      setIntentKey(newIdempotencyKey());
      setRefresh((value) => value + 1);
      return true;
    } finally {
      setSending(false);
    }
  }

  async function onAllocate() {
    if (millimes === undefined) return;
    const done = await allocate(
      [...selected.keys()].map((employeeId) => ({
        employeeId,
        creditType,
        amountMillimes: millimes,
      })),
      creditType,
    );
    if (done) {
      setSelected(new Map());
      setAmountText('');
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
  const typeBalance =
    dashboard.status === 'success'
      ? dashboard.data.balances.find((item) => item.creditType === creditType)?.amountMillimes
      : undefined;

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6">
        {dashboard.status === 'success' ? (
          <CreditTypeBalanceCards balances={dashboard.data.balances} progress="share" />
        ) : (
          <Skeleton className="h-input-height w-full" />
        )}
      </div>
      {result !== undefined ? (
        <div className="mb-6">
          <Alert tone="success">{t('importDone', { count: result.allocatedCount })}</Alert>
        </div>
      ) : null}
      {error !== undefined ? (
        <div className="mb-6">
          <Alert tone="danger">
            {missing !== undefined && errorType !== undefined
              ? tTypes('insufficient', {
                  type: typeLabel(errorType),
                  missing: formatMillimesWithCurrency(missing, locale),
                })
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
            <CreditTypeSelect
              label={t('typeLabel')}
              hint={t('typeHint')}
              value={creditType}
              onChange={(value) => {
                if (value !== '') setCreditType(value);
              }}
            />
            {typeBalance !== undefined ? (
              <p className="flex flex-wrap items-center gap-2 text-caption text-text-muted">
                <span>{tTypes('balanceOf', { type: typeLabel(creditType) })}</span>
                <Amount millimes={typeBalance} />
              </p>
            ) : null}
            <TextField
              label={t('amount')}
              hint={
                millimes === undefined
                  ? undefined
                  : t('amountPreview', { amount: formatMillimesWithCurrency(millimes, locale) })
              }
              error={amountText !== '' && millimes === undefined ? t('amountInvalid') : undefined}
              inputMode="decimal"
              dir="ltr"
              value={amountText}
              onChange={(event) => setAmountText(event.target.value)}
            />
            <StatCard
              label={t('total')}
              value={
                total === undefined ? (
                  <Skeleton className="h-input-height w-full" />
                ) : (
                  <Amount millimes={total} size="title" />
                )
              }
              hint={t('selected', { count: selected.size })}
            />
            <Button
              disabled={selected.size === 0 || millimes === undefined || millimes === 0}
              onClick={() => setConfirming(true)}
            >
              {t('submit')}
            </Button>
          </div>
        </Card>
      </div>
      <AllocationImport onAllocate={(lines) => allocate(lines)} sending={sending} />
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
        >
          <CreditTypeBadge type={creditType} />
        </ConfirmDialog>
      ) : null}
    </>
  );
}

/** CSV allocation import: one column per type; the server analyses, then the valid rows go out. */
function AllocationImport({
  onAllocate,
  sending,
}: {
  onAllocate: (lines: Schemas['AllocationLine'][]) => Promise<boolean>;
  sending: boolean;
}) {
  const t = useTranslations('company.allocation');
  const tTypes = useTranslations('ui.creditTypes');
  const tRoot = useTranslations();
  const [csv, setCsv] = useState<string | undefined>(undefined);
  const [preview, setPreview] = useState<Preview | undefined>(undefined);
  const [analysing, setAnalysing] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [confirming, setConfirming] = useState(false);

  async function analyse() {
    if (csv === undefined) return;
    setAnalysing(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/company/allocation-imports/previews',
        { body: { csv } },
      );
      if (data === undefined) setError(problem);
      else setPreview(data);
    } finally {
      setAnalysing(false);
    }
  }

  const columns: Column<Schemas['AllocationImportRow']>[] = [
    { key: 'line', header: t('importLine'), cell: (row) => row.line },
    {
      key: 'employee',
      header: t('importEmployee'),
      cell: (row) => (
        <span className="flex flex-col">
          <span className="font-label">{row.employeeName ?? row.employeeNumber}</span>
          <span className="text-caption text-text-muted" dir="ltr">
            {row.employeeNumber}
          </span>
        </span>
      ),
    },
    {
      key: 'amounts',
      header: tTypes('column'),
      cell: (row) => (
        <span className="flex flex-wrap gap-2">
          {row.amounts
            .filter((item) => item.amountMillimes > 0)
            .map((item) => (
              <span key={item.creditType} className="flex items-center gap-1">
                <CreditTypeBadge type={item.creditType} />
                <Amount millimes={item.amountMillimes} />
              </span>
            ))}
        </span>
      ),
    },
    {
      key: 'issues',
      header: t('importIssues'),
      cell: (row) =>
        row.issues.length === 0 ? null : (
          <span className="text-caption text-danger-text">
            {row.issues.map((issue) => t(`issues.${issue}`)).join(' · ')}
          </span>
        ),
    },
  ];

  return (
    <Card className="mt-6">
      <CardTitle description={t('importHint')}>{t('importTitle')}</CardTitle>
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <div className="flex flex-wrap items-end gap-3">
          <TextField
            label={t('importFile')}
            type="file"
            accept=".csv,text/csv"
            onChange={(event) => {
              const file = event.target.files?.[0];
              setPreview(undefined);
              if (file === undefined) {
                setCsv(undefined);
                return;
              }
              void file.text().then(setCsv);
            }}
          />
          <Button
            variant="secondary"
            loading={analysing}
            disabled={csv === undefined}
            icon={<FileUp aria-hidden="true" className="size-icon-sm" />}
            onClick={() => void analyse()}
          >
            {t('importAnalyse')}
          </Button>
        </div>
        {preview !== undefined ? (
          <>
            <p className="text-body text-text">
              {t('importRows', { valid: preview.validCount, errors: preview.errorCount })}
            </p>
            <div className="flex flex-col gap-2">
              <p className="text-label text-text">{t('importTotals')}</p>
              <span className="flex flex-wrap gap-3">
                {preview.totals
                  .filter((item) => item.amountMillimes > 0)
                  .map((item) => (
                    <span key={item.creditType} className="flex items-center gap-2">
                      <CreditTypeBadge type={item.creditType} />
                      <Amount millimes={item.amountMillimes} />
                    </span>
                  ))}
              </span>
            </div>
            <DataTable
              caption={t('importTitle')}
              columns={columns}
              rows={preview.rows}
              rowKey={(row) => String(row.line)}
              empty={{ title: t('emptyTitle') }}
            />
            <Button disabled={preview.lines.length === 0} onClick={() => setConfirming(true)}>
              {t('importConfirm')}
            </Button>
            <ConfirmDialog
              open={confirming}
              onOpenChange={setConfirming}
              title={t('importConfirm')}
              description={t('importRows', {
                valid: preview.validCount,
                errors: preview.errorCount,
              })}
              confirmLabel={t('importConfirm')}
              loading={sending}
              onConfirm={() =>
                void onAllocate(preview.lines).then((done) => {
                  setConfirming(false);
                  if (done) setPreview(undefined);
                })
              }
            >
              <span className="flex flex-wrap gap-3">
                {preview.totals
                  .filter((item) => item.amountMillimes > 0)
                  .map((item) => (
                    <span key={item.creditType} className="flex items-center gap-2">
                      <CreditTypeBadge type={item.creditType} />
                      <Amount millimes={item.amountMillimes} />
                    </span>
                  ))}
              </span>
            </ConfirmDialog>
          </>
        ) : null}
      </div>
    </Card>
  );
}
