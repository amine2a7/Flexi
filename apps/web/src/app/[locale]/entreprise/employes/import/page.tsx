'use client';

import type { Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useId, useState, type ChangeEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link, useRouter } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { useToast } from '@/components/ui/toast';

const MAX_BYTES = 1_048_576;

/** CSV import in two steps: server analysis (errors, duplicates), then creation of the valid lines. */
export default function ImportPage() {
  const t = useTranslations('company.import');
  const tFields = useTranslations('company.employees.fields');
  const tRoot = useTranslations();
  const router = useRouter();
  const toast = useToast();
  const inputId = useId();
  const [csv, setCsv] = useState<string | undefined>(undefined);
  const [preview, setPreview] = useState<Schemas['EmployeeImportPreview'] | undefined>(undefined);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [tooBig, setTooBig] = useState(false);

  function onFile(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    setPreview(undefined);
    setTooBig(false);
    if (file === undefined) return;
    if (file.size > MAX_BYTES) {
      setTooBig(true);
      return;
    }
    void file.text().then(setCsv);
  }

  async function onAnalyse() {
    if (csv === undefined) return;
    setBusy(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/company/employees/import-previews',
        { body: { csv } },
      );
      if (data === undefined) setError(problem);
      else setPreview(data);
    } finally {
      setBusy(false);
    }
  }

  async function onConfirm() {
    if (preview === undefined) return;
    setBusy(true);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/employees/imports', {
        body: { previewId: preview.previewId },
      });
      if (data === undefined) {
        setError(problem);
        return;
      }
      toast.notify('success', t('created', { count: data.createdCount }));
      router.push('/entreprise/employes');
    } finally {
      setBusy(false);
    }
  }

  const columns: Column<Schemas['ImportRow']>[] = [
    { key: 'line', header: t('line'), cell: (row) => row.line },
    { key: 'number', header: tFields('employeeNumber'), cell: (row) => row.employeeNumber },
    { key: 'name', header: tFields('lastName'), cell: (row) => `${row.firstName} ${row.lastName}` },
    { key: 'email', header: tFields('email'), cell: (row) => <span dir="ltr">{row.email}</span> },
    {
      key: 'issues',
      header: t('issues'),
      cell: (row) =>
        row.issues.length === 0 ? (
          <span className="text-emerald-text">{t('ok')}</span>
        ) : (
          <ul className="text-danger-text">
            {row.issues.map((issue) => (
              <li key={`${issue.field}-${issue.code}`}>
                {t(`issue.${issue.code}`, { field: tFields(issue.field) })}
              </li>
            ))}
          </ul>
        ),
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Link href="/entreprise/employes" className={buttonClasses('ghost')}>
            {t('back')}
          </Link>
        }
      />
      <div className="flex flex-col gap-6">
        <Card>
          <div className="flex flex-col gap-4">
            <label htmlFor={inputId} className="text-label text-text">
              {t('file')}
            </label>
            <input
              id={inputId}
              type="file"
              accept=".csv,text/csv"
              onChange={onFile}
              className="text-body text-text file:me-3 file:min-h-button-height file:rounded-button file:border-0 file:bg-bg file:px-4 file:text-label file:text-navy"
            />
            <p className="text-caption text-text-muted">{t('fileHint')}</p>
            {tooBig ? <Alert tone="danger">{tRoot('errors.validationFailed')}</Alert> : null}
            {error !== undefined ? (
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
            ) : null}
            <div>
              <Button
                variant="secondary"
                onClick={() => void onAnalyse()}
                loading={busy && preview === undefined}
                disabled={csv === undefined}
              >
                {t('analyse')}
              </Button>
            </div>
          </div>
        </Card>
        {preview !== undefined ? (
          <Card>
            <CardTitle>{t('summary')}</CardTitle>
            <div className="mb-4 flex flex-wrap gap-4 text-label">
              <span className="text-emerald-text">{t('valid', { count: preview.validCount })}</span>
              <span className="text-danger-text">{t('errors', { count: preview.errorCount })}</span>
              <span className="text-warning-text">
                {t('duplicates', { count: preview.duplicateCount })}
              </span>
            </div>
            {preview.errorCount > 0 ? <Alert tone="warning">{t('onlyValid')}</Alert> : null}
            <div className="my-4">
              <DataTable
                caption={t('summary')}
                columns={columns}
                rows={preview.rows}
                rowKey={(row) => String(row.line)}
                empty={{ title: t('summary') }}
              />
            </div>
            <Button
              onClick={() => void onConfirm()}
              loading={busy}
              disabled={preview.validCount === 0}
            >
              {t('confirm', { count: preview.validCount })}
            </Button>
          </Card>
        ) : null}
      </div>
    </>
  );
}
