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
import { Rate } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';

type Profile = Schemas['CommissionProfile'];

export default function CommissionsPage() {
  const t = useTranslations('admin.commissions');
  const locale = useLocale();
  const profiles = useApiQuery(() => getApi().GET('/v1/admin/commission-profiles'), []);
  const [editing, setEditing] = useState<Profile | undefined>(undefined);

  const columns: Column<Profile>[] = [
    { key: 'name', header: t('name'), cell: (row) => row.name },
    { key: 'rate', header: t('rate'), align: 'end', cell: (row) => <Rate bps={row.rateBps} /> },
    { key: 'merchants', header: t('merchants'), align: 'end', cell: (row) => row.merchantsCount },
    { key: 'updated', header: t('updated'), cell: (row) => formatDateTime(row.updatedAt, locale) },
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
          onClick={() => setEditing(row)}
        >
          {t('change')}
        </Button>
      ),
    },
  ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={profiles.status === 'success' ? profiles.data.data : []}
          rowKey={(row) => row.id}
          loading={profiles.status === 'loading'}
          error={profiles.status === 'error' ? profiles.error : undefined}
          onRetry={profiles.reload}
          empty={{ title: t('title') }}
        />
      </Card>
      {editing !== undefined ? (
        <ChangeRate
          key={editing.id}
          profile={editing}
          locale={locale}
          onClose={() => setEditing(undefined)}
        />
      ) : null}
    </>
  );
}

function ChangeRate({
  profile,
  locale,
  onClose,
}: {
  profile: Profile;
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

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const newRateBps = parseBps(rateText, locale);
    const rateInvalid = newRateBps === undefined || newRateBps > 10_000;
    setRateError(rateInvalid ? t('rateInvalid') : undefined);
    setReasonError(reason.trim() === '' ? tRoot('admin.merchants.form.required') : undefined);
    if (rateInvalid || reason.trim() === '') return;
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/commission-profiles/{profileId}/change-requests',
        {
          params: { path: { profileId: profile.id } },
          body: { newRateBps, reason: reason.trim() },
        },
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
      title={t('formTitle', { name: profile.name })}
      description={t('current', { rate: formatRateBps(profile.rateBps, locale) })}
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
          onChange={(event) => setRateText(event.target.value)}
        />
        <TextField
          label={t('reason')}
          hint={t('reasonHint')}
          error={reasonError}
          value={reason}
          maxLength={500}
          onChange={(event) => setReason(event.target.value)}
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
