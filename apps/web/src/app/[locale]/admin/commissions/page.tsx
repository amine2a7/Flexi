'use client';

import type { Schemas } from '@flexipay/api-client';
import { Pencil } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { formatRateBps } from '@/lib/format/money';
import { parseBps } from '@/lib/format/money-input';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CommissionLabel } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

type Tier = Schemas['CommissionTier'];
/** A company or a shop with its grid (decision of 2026-11-03). */
interface GridRow {
  id: string;
  name: string;
  owner: { companyId: string } | { merchantId: string };
  grid: Schemas['CommissionGrid'] | null;
}

const isDefault = (tier: Tier) => tier.minMillimes === null && tier.maxMillimes === null;

export default function CommissionsPage() {
  const t = useTranslations('admin.commissions');
  const canRequest = useCan('commissions.request');
  const locale = useLocale();
  const companies = useApiQuery(
    () => getApi().GET('/v1/admin/companies', { params: { query: { limit: 100 } } }),
    [],
  );
  const merchants = useApiQuery(
    () => getApi().GET('/v1/admin/merchants', { params: { query: { limit: 100 } } }),
    [],
  );
  const [editing, setEditing] = useState<GridRow | undefined>(undefined);

  const columns = (kind: 'companies' | 'merchants'): Column<GridRow>[] => {
    const all: Column<GridRow>[] = [
      {
        key: 'name',
        header: t(`${kind}Name`),
        cell: (row) => row.name,
        sortValue: (row) => row.name,
      },
      { key: 'grid', header: t('grid'), cell: (row) => <CommissionLabel grid={row.grid} /> },
      {
        key: 'updated',
        header: t('updated'),
        cell: (row) => (row.grid === null ? '—' : formatDateTime(row.grid.effectiveFrom, locale)),
        sortValue: (row) => row.grid?.effectiveFrom ?? '',
      },
      {
        key: 'action',
        header: t('change'),
        align: 'end',
        cell: (row) => (
          <Button
            variant="secondary"
            size="sm"
            icon={<Pencil aria-hidden="true" className="size-icon-sm" />}
            aria-label={t('changeFor', { name: row.name })}
            onClick={() => {
              setEditing(row);
            }}
          >
            {t('change')}
          </Button>
        ),
      },
    ];
    return all.filter((column) => canRequest || column.key !== 'action');
  };

  const companyRows: GridRow[] =
    companies.status === 'success'
      ? companies.data.data.map((row) => ({
          id: row.id,
          name: row.name,
          owner: { companyId: row.id },
          grid: row.commissionGrid,
        }))
      : [];
  const merchantRows: GridRow[] =
    merchants.status === 'success'
      ? merchants.data.data.map((row) => ({
          id: row.id,
          name: row.name,
          owner: { merchantId: row.id },
          grid: row.commissionGrid,
        }))
      : [];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="flex flex-col gap-6">
        <Card>
          <CardTitle>{t('companiesTitle')}</CardTitle>
          <DataTable
            caption={t('companiesTitle')}
            columns={columns('companies')}
            rows={companyRows}
            rowKey={(row) => row.id}
            loading={companies.status === 'loading'}
            error={companies.status === 'error' ? companies.error : undefined}
            onRetry={companies.reload}
            empty={{ title: t('companiesTitle') }}
          />
        </Card>
        <Card>
          <CardTitle>{t('merchantsTitle')}</CardTitle>
          <DataTable
            caption={t('merchantsTitle')}
            columns={columns('merchants')}
            rows={merchantRows}
            rowKey={(row) => row.id}
            loading={merchants.status === 'loading'}
            error={merchants.status === 'error' ? merchants.error : undefined}
            onRetry={merchants.reload}
            empty={{ title: t('merchantsTitle') }}
          />
        </Card>
      </div>
      {editing !== undefined ? (
        <ChangeDefaultRate
          key={editing.id}
          row={editing}
          locale={locale}
          onClose={() => {
            setEditing(undefined);
          }}
        />
      ) : null}
    </>
  );
}

/** Change of the default line of a grid (the tranches are kept), four eyes. */
function ChangeDefaultRate({
  row,
  locale,
  onClose,
}: {
  row: GridRow;
  locale: Locale;
  onClose: () => void;
}) {
  const t = useTranslations('admin.commissions');
  const tRoot = useTranslations();
  const toast = useToast();
  const [rateText, setRateText] = useState('');
  const [reason, setReason] = useState('');
  const [rateError, setRateError] = useState<string | undefined>(undefined);
  const [reasonError, setReasonError] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const current = row.grid?.tiers.find(isDefault);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const rateBps = parseBps(rateText, locale);
    const rateInvalid = rateBps === undefined || rateBps > 10_000;
    setRateError(rateInvalid ? t('rateInvalid') : undefined);
    setReasonError(reason.trim() === '' ? tRoot('admin.merchants.form.required') : undefined);
    if (rateInvalid || reason.trim() === '') return;
    setSaving(true);
    setError(undefined);
    try {
      const tiers: Tier[] = [
        { rateBps, minMillimes: null, maxMillimes: null },
        ...(row.grid?.tiers.filter((tier) => !isDefault(tier)) ?? []),
      ];
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/commission-grids/change-requests',
        { body: { ...row.owner, tiers, reason: reason.trim() } },
      );
      if (data !== undefined) {
        toast.notify('success', t('createdToast'));
        onClose();
        return;
      }
      setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
      title={t('formTitle', { name: row.name })}
      description={
        current === undefined
          ? t('noGrid')
          : t('current', { rate: formatRateBps(current.rateBps, locale) })
      }
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('pending')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <TextField
          label={t('newRate')}
          hint={t('newRateHint')}
          error={rateError}
          inputMode="decimal"
          dir="ltr"
          value={rateText}
          onChange={(event) => {
            setRateText(event.target.value);
          }}
        />
        <TextField
          label={t('reason')}
          hint={t('reasonHint')}
          error={reasonError}
          value={reason}
          maxLength={500}
          onChange={(event) => {
            setReason(event.target.value);
          }}
        />
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
