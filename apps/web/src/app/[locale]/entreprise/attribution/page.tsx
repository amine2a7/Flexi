'use client';

import type { Schemas } from '@flexipay/api-client';
import { Eye, FileUp, ListChecks, Repeat } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useMemo, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { EMPTY_TEXTS, amountTexts, readAmounts } from '@/lib/allocation-amounts';
import { Amount } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import {
  CREDIT_TYPES,
  CreditTypeBadge,
  CreditTypeBalanceCards,
  useCreditTypeLabel,
  type CreditType,
} from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { Skeleton } from '@/components/ui/states';

type Employee = Schemas['Employee'];
type Preview = Schemas['AllocationPreview'];
type ImportPreview = Schemas['AllocationImportPreview'];
interface Picked {
  readonly id: string;
  readonly name: string;
}

/**
 * « Attribuer » (processus v2, processus 4): beneficiaries chosen with filters (department,
 * position, name), an amount per credit type, a preview against the balances (what is missing in
 * red), then the allocation; the filters and amounts can be saved as a template. Only the balance
 * of each type is debited (decision of 2026-10-13). Also by CSV, one column per type.
 */
export default function AllocationPage() {
  const t = useTranslations('company.allocation');
  const tTypes = useTranslations('ui.creditTypes');
  const tRoot = useTranslations();
  const typeLabel = useCreditTypeLabel();
  const locale = useLocale();
  const [q, setQ] = useState('');
  const [departmentId, setDepartmentId] = useState('');
  const [position, setPosition] = useState('');
  const [selected, setSelected] = useState<ReadonlyMap<string, Picked>>(new Map());
  const [texts, setTexts] = useState<Record<CreditType, string>>(EMPTY_TEXTS);
  const [preview, setPreview] = useState<Preview | undefined>(undefined);
  const [previewing, setPreviewing] = useState(false);
  const [selectingAll, setSelectingAll] = useState(false);
  const [templateId, setTemplateId] = useState<string | undefined>(undefined);
  const [templateName, setTemplateName] = useState<string | undefined>(undefined);
  const [saveTemplate, setSaveTemplate] = useState(false);
  const [newTemplateName, setNewTemplateName] = useState('');
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [templateError, setTemplateError] = useState<unknown>(undefined);
  const [result, setResult] = useState<Schemas['AllocationResult'] | undefined>(undefined);
  const [savedTemplate, setSavedTemplate] = useState<string | undefined>(undefined);
  const [refresh, setRefresh] = useState(0);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);

  const dashboard = useApiQuery(() => getApi().GET('/v1/company/dashboard'), [refresh]);
  const departments = useApiQuery(() => getApi().GET('/v1/company/departments'), []);
  const positions = useApiQuery(() => getApi().GET('/v1/company/positions'), [refresh]);
  const departmentList = departments.status === 'success' ? departments.data.data : [];
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/employees', {
        params: {
          query: {
            cursor,
            withCount,
            status: 'ACTIVE',
            ...(q === '' ? {} : { q }),
            ...(departmentId === '' ? {} : { departmentId }),
            ...(position === '' ? {} : { position }),
          },
        },
      }),
    [q, departmentId, position, refresh],
  );
  const { invalid, amounts } = useMemo(() => readAmounts(texts, locale), [texts, locale]);
  const filters = {
    ...(departmentId === '' ? {} : { departmentId }),
    ...(position === '' ? {} : { position }),
  };

  // « Relancer » a template (Crédits › Modèles): its filters and amounts, the preview at once.
  useEffect(() => {
    const id = new URLSearchParams(window.location.search).get('modele');
    if (id === null) return;
    void (async () => {
      const { data } = await getApi().GET('/v1/company/allocation-templates');
      const template = data?.data.find((item) => item.id === id);
      if (template === undefined) return;
      setTemplateId(template.id);
      setTemplateName(template.name);
      setDepartmentId(template.departmentId ?? '');
      setPosition(template.position ?? '');
      setTexts(amountTexts(template.amounts, locale));
      const { data: found, error: problem } = await getApi().POST(
        '/v1/company/allocation-previews',
        { body: { templateId: template.id, amounts: [] } },
      );
      if (found === undefined) {
        setError(problem);
        return;
      }
      setSelected(new Map(found.employees.map((item) => [item.id, picked(item)])));
      setPreview(found);
    })();
  }, [locale]);

  function picked(employee: { id: string; firstName: string; lastName: string }): Picked {
    return {
      id: employee.id,
      name: `${employee.firstName} ${employee.lastName}`,
    };
  }

  function changeSelection(next: ReadonlyMap<string, Picked>) {
    setSelected(next);
    setPreview(undefined);
  }

  function toggle(employee: Employee) {
    const next = new Map(selected);
    if (next.has(employee.id)) next.delete(employee.id);
    else next.set(employee.id, picked(employee));
    changeSelection(next);
  }

  /** « Tout sélectionner »: every employee of the filters, not only the page shown. */
  async function selectAll() {
    setSelectingAll(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/allocation-previews', {
        body: { ...filters, ...(q === '' ? {} : { q }), amounts: [] },
      });
      if (data === undefined) setError(problem);
      else changeSelection(new Map(data.employees.map((item) => [item.id, picked(item)])));
    } finally {
      setSelectingAll(false);
    }
  }

  async function onPreview() {
    setPreviewing(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/allocation-previews', {
        body: { employeeIds: [...selected.keys()], amounts },
      });
      if (data === undefined) setError(problem);
      else setPreview(data);
    } finally {
      setPreviewing(false);
    }
  }

  async function allocate(
    lines: Schemas['AllocationLine'][],
    fromTemplate?: string,
  ): Promise<boolean> {
    setSending(true);
    setError(undefined);
    setTemplateError(undefined);
    setSavedTemplate(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/allocations', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: {
          ...(fromTemplate === undefined ? {} : { templateId: fromTemplate }),
          allocations: lines,
        },
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
    if (preview === undefined) return;
    const done = await allocate(
      preview.employees.flatMap((employee) =>
        amounts.map((amount) => ({
          employeeId: employee.id,
          creditType: amount.creditType,
          amountMillimes: amount.amountMillimes,
        })),
      ),
      templateId,
    );
    if (!done) return;
    if (saveTemplate && newTemplateName.trim() !== '') {
      const { data, error: problem } = await getApi().POST('/v1/company/allocation-templates', {
        body: {
          name: newTemplateName.trim(),
          departmentId: departmentId === '' ? null : departmentId,
          position: position === '' ? null : position,
          amounts,
        },
      });
      if (data === undefined) setTemplateError(problem);
      else setSavedTemplate(data.name);
    }
    setSelected(new Map());
    setPreview(undefined);
    setTexts(EMPTY_TEXTS);
    setSaveTemplate(false);
    setNewTemplateName('');
    setTemplateId(undefined);
    setTemplateName(undefined);
  }

  const missing = (asProblem(error)?.details as { missingMillimes?: number } | undefined)
    ?.missingMillimes;
  const rows = list.rows ?? [];
  const allOnPage = rows.length > 0 && rows.every((row) => selected.has(row.id));
  const departmentName = (id: string | null | undefined) =>
    departmentList.find((department) => department.id === id)?.name ?? '—';
  const columns: Column<Employee>[] = [
    {
      key: 'select',
      header: t('selectPage'),
      cell: (row) => (
        <input
          type="checkbox"
          aria-label={t('select', { name: `${row.firstName} ${row.lastName}` })}
          checked={selected.has(row.id)}
          onChange={() => {
            toggle(row);
          }}
          className="size-icon-md accent-navy"
        />
      ),
    },
    { key: 'number', header: t('number'), cell: (row) => row.employeeNumber },
    {
      key: 'name',
      header: t('name'),
      cell: (row) => `${row.firstName} ${row.lastName}`,
    },
    {
      key: 'department',
      header: t('department'),
      cell: (row) => departmentName(row.departmentId),
    },
    {
      key: 'position',
      header: t('position'),
      cell: (row) => row.position ?? '—',
    },
    {
      key: 'allocated',
      header: t('allocated'),
      align: 'end',
      cell: (row) => <Amount millimes={row.monthAllocatedMillimes} />,
    },
  ];
  const enabled =
    dashboard.status === 'success'
      ? CREDIT_TYPES.filter((type) =>
          dashboard.data.balances.some((item) => item.creditType === type),
        )
      : CREDIT_TYPES;
  const canPreview = selected.size > 0 && amounts.length > 0 && !invalid;
  const lineCount = (preview?.employeeCount ?? 0) * amounts.length;

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Link href="/entreprise/modeles" className={buttonClasses('secondary')}>
            <Repeat aria-hidden="true" className="size-icon-sm" />
            {t('templatesLink')}
          </Link>
        }
      />
      <div className="mb-6">
        {dashboard.status === 'success' ? (
          <CreditTypeBalanceCards balances={dashboard.data.balances} progress="share" />
        ) : (
          <Skeleton className="h-input-height w-full" />
        )}
      </div>
      <div className="mb-6 flex flex-col gap-3" aria-live="polite">
        {templateName !== undefined ? (
          <Alert tone="info">{t('relaunching', { name: templateName })}</Alert>
        ) : null}
        {result !== undefined ? (
          <Alert tone="success">{t('importDone', { count: result.allocatedCount })}</Alert>
        ) : null}
        {savedTemplate !== undefined ? (
          <Alert tone="success">{t('templateSaved', { name: savedTemplate })}</Alert>
        ) : null}
        {templateError !== undefined ? (
          <Alert tone="warning">
            {t('templateNotSaved', {
              reason: tRoot(messageKey(errorMessageKey(templateError))),
            })}
          </Alert>
        ) : null}
        {error !== undefined ? (
          <Alert tone="danger">
            {missing !== undefined
              ? t('insufficient', {
                  amount: formatMillimesWithCurrency(missing, locale),
                })
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
      </div>
      <div className="grid gap-6 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardTitle description={t('stepPeopleHint')}>{t('stepPeople')}</CardTitle>
          <FilterBar
            searchLabel={t('search')}
            onApply={(applied) => {
              setQ(applied.q);
            }}
          />
          <div className="mb-4 grid gap-4 sm:grid-cols-2">
            <SelectField
              label={t('department')}
              placeholder={t('allDepartments')}
              options={departmentList
                .filter((department) => !department.archived)
                .map((department) => ({
                  value: department.id,
                  label: department.name,
                }))}
              value={departmentId}
              onChange={(event) => {
                setDepartmentId(event.target.value);
                setTemplateId(undefined);
                setTemplateName(undefined);
              }}
            />
            <SelectField
              label={t('position')}
              placeholder={t('allPositions')}
              options={(positions.status === 'success' ? positions.data.data : []).map((item) => ({
                value: item,
                label: item,
              }))}
              value={position}
              onChange={(event) => {
                setPosition(event.target.value);
                setTemplateId(undefined);
                setTemplateName(undefined);
              }}
            />
          </div>
          <div className="mb-3 flex flex-wrap items-center gap-3">
            <Button
              variant="secondary"
              size="sm"
              loading={selectingAll}
              icon={<ListChecks aria-hidden="true" className="size-icon-sm" />}
              onClick={() => void selectAll()}
            >
              {t('selectAll')}
            </Button>
            <Button
              variant="ghost"
              size="sm"
              disabled={rows.length === 0}
              onClick={() => {
                const next = new Map(selected);
                for (const row of rows) {
                  if (allOnPage) next.delete(row.id);
                  else next.set(row.id, picked(row));
                }
                changeSelection(next);
              }}
            >
              {t('selectPage')}
            </Button>
            <Button
              variant="ghost"
              size="sm"
              disabled={selected.size === 0}
              onClick={() => {
                changeSelection(new Map());
              }}
            >
              {t('clearSelection')}
            </Button>
            <span className="text-caption text-text-muted">
              {t('selected', { count: selected.size })}
            </span>
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
        {/* Small screen: the action comes before the list of employees (ux, captures). */}
        <Card className="order-first lg:order-none">
          <div className="flex flex-col gap-5">
            <CardTitle description={t('stepAmountsHint')}>{t('stepAmounts')}</CardTitle>
            {enabled.map((type) => (
              <AmountField
                key={type}
                label={t('amountOf', { type: typeLabel(type) })}
                value={texts[type]}
                onChange={(value) => {
                  setTexts((current) => ({ ...current, [type]: value }));
                  setPreview(undefined);
                }}
              />
            ))}
            <Button
              variant="secondary"
              disabled={!canPreview}
              loading={previewing}
              icon={<Eye aria-hidden="true" className="size-icon-sm" />}
              onClick={() => void onPreview()}
            >
              {t('previewButton')}
            </Button>
            {preview !== undefined ? (
              <PreviewCard preview={preview} />
            ) : (
              <p className="text-caption text-text-muted">{t('previewHint')}</p>
            )}
            <label className="flex items-center gap-2 text-body text-text">
              <input
                type="checkbox"
                className="size-icon-sm accent-navy"
                checked={saveTemplate}
                onChange={(event) => {
                  setSaveTemplate(event.target.checked);
                }}
              />
              {t('saveAsTemplate')}
            </label>
            {saveTemplate ? (
              <TextField
                label={t('templateName')}
                hint={t('templateNameHint')}
                maxLength={80}
                value={newTemplateName}
                onChange={(event) => {
                  setNewTemplateName(event.target.value);
                }}
              />
            ) : null}
            <Button
              disabled={
                preview === undefined ||
                !preview.sufficient ||
                preview.employeeCount === 0 ||
                lineCount > 5_000 ||
                (saveTemplate && newTemplateName.trim() === '')
              }
              onClick={() => {
                setConfirming(true);
              }}
            >
              {t('submit')}
            </Button>
          </div>
        </Card>
      </div>
      <AllocationImport onAllocate={(lines) => allocate(lines)} sending={sending} />
      {preview !== undefined ? (
        <ConfirmDialog
          open={confirming}
          onOpenChange={setConfirming}
          title={t('confirmTitle')}
          description={t('confirmMany', { count: preview.employeeCount })}
          confirmLabel={t('submit')}
          loading={sending}
          onConfirm={() => void onAllocate()}
        >
          <span className="flex flex-wrap gap-3">
            {preview.lines.map((line) => (
              <span key={line.creditType} className="flex items-center gap-2">
                <CreditTypeBadge type={line.creditType} />
                <Amount millimes={line.totalMillimes} />
              </span>
            ))}
          </span>
        </ConfirmDialog>
      ) : null}
      <span className="sr-only">{tTypes('column')}</span>
    </>
  );
}

/** Step 4: per type, the total, the balance, what remains, and what is missing (in red). */
function PreviewCard({ preview }: { preview: Preview }) {
  const t = useTranslations('company.allocation');
  return (
    <div className="flex flex-col gap-3 rounded-card-desktop border border-border p-3">
      <p className="text-label text-text">{t('previewCount', { count: preview.employeeCount })}</p>
      {preview.lines.map((line) => (
        <dl key={line.creditType} className="flex flex-col gap-1 text-caption">
          <dt>
            <CreditTypeBadge type={line.creditType} />
          </dt>
          <dd className="flex justify-between gap-2">
            <span className="text-text-muted">{t('previewTotal')}</span>
            <Amount millimes={line.totalMillimes} />
          </dd>
          <dd className="flex justify-between gap-2">
            <span className="text-text-muted">{t('previewBalance')}</span>
            <Amount millimes={line.balanceMillimes} />
          </dd>
          <dd className="flex justify-between gap-2">
            <span className="text-text-muted">{t('previewRemaining')}</span>
            <Amount millimes={line.remainingMillimes} />
          </dd>
          {line.missingMillimes > 0 ? (
            <dd className="flex justify-between gap-2 font-label text-danger-text">
              <span>{t('previewMissing')}</span>
              <Amount millimes={line.missingMillimes} />
            </dd>
          ) : null}
        </dl>
      ))}
      {!preview.sufficient ? <Alert tone="danger">{t('previewInsufficient')}</Alert> : null}
    </div>
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
  const [preview, setPreview] = useState<ImportPreview | undefined>(undefined);
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
            <Button
              disabled={preview.lines.length === 0}
              onClick={() => {
                setConfirming(true);
              }}
            >
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
