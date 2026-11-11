'use client';

import type { Schemas } from '@flexipay/api-client';
import { Landmark, Pencil, Percent } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type ReactNode, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CommissionLabel } from '@/components/ui/credit-type';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';
import { CredentialsDialog, type Credentials } from './credentials-dialog';
import {
  CommissionGridEditor,
  readGrid,
  type GridErrorCode,
  type GridRow,
} from './commission-grid-editor';

type AccountRecord = Schemas['AccountRecord'];
type Owner = { companyId: string } | { merchantId: string };

const CATEGORIES: Schemas['MerchantCategory'][] = [
  'RESTAURANT',
  'CAFE',
  'GROCERY',
  'BAKERY',
  'FAST_FOOD',
  'CLOTHING',
  'FUEL_STATION',
  'GIFT_SHOP',
];

/** Text of a value as the administrator types it (locale decimal separator, no grouping). */
const decimalText = (value: number, digits: number, locale: Locale) => {
  const unit = 10 ** digits;
  const fraction = String(value % unit)
    .padStart(digits, '0')
    .replace(/0+$/, '');
  const whole = String(Math.trunc(value / unit));
  return fraction === '' ? whole : `${whole}${locale === 'en' ? '.' : ','}${fraction}`;
};

/** Lines of the editor from the grid in force (the default line first). */
export function rowsOf(grid: Schemas['CommissionGrid'] | null, locale: Locale): GridRow[] {
  const tiers = grid?.tiers ?? [];
  const fallback = tiers.find((tier) => tier.minMillimes === null && tier.maxMillimes === null);
  const rows: GridRow[] = [
    {
      rate: fallback === undefined ? '' : decimalText(fallback.rateBps, 2, locale),
      from: '',
      to: '',
    },
  ];
  for (const tier of tiers) {
    if (tier === fallback) continue;
    rows.push({
      rate: decimalText(tier.rateBps, 2, locale),
      from: tier.minMillimes === null ? '' : decimalText(tier.minMillimes, 3, locale),
      to: tier.maxMillimes === null ? '' : decimalText(tier.maxMillimes, 3, locale),
    });
  }
  return rows;
}

/**
 * Record of a company or a merchant (decision of 2026-11-03): every information editable at any
 * time; the grid and the RIB through four-eyes requests; history of the changes and requests.
 */
export function AccountRecordPanel({
  owner,
  withHeader = false,
  wrap,
}: {
  owner: Owner;
  withHeader?: boolean;
  /** Puts the record in a tab of the full client record (processus v2). */
  wrap?: (record: ReactNode) => ReactNode;
}) {
  const isCompany = 'companyId' in owner;
  const id = isCompany ? owner.companyId : owner.merchantId;
  const record = useApiQuery(
    () =>
      isCompany
        ? getApi().GET('/v1/admin/companies/{companyId}/record', {
            params: { path: { companyId: id } },
          })
        : getApi().GET('/v1/admin/merchants/{merchantId}/record', {
            params: { path: { merchantId: id } },
          }),
    [id],
  );
  if (record.status === 'loading') return <LoadingBlock lines={6} />;
  if (record.status === 'error') return <ErrorState error={record.error} onRetry={record.reload} />;
  return (
    <>
      {withHeader ? (
        <PageHeader
          title={record.data.name}
          actions={
            <div className="flex items-center gap-3">
              <StatusBadge status={record.data.status} />
              <NewPasswordButton
                email={record.data.email}
                role={isCompany ? 'COMPANY' : 'MERCHANT'}
              />
            </div>
          }
        />
      ) : null}
      {wrap === undefined ? (
        <RecordView record={record.data} owner={owner} onChanged={record.reload} />
      ) : (
        wrap(<RecordView record={record.data} owner={owner} onChanged={record.reload} />)
      )}
    </>
  );
}

/**
 * « Générer un nouveau mot de passe » for the account that signs in with the record's e-mail
 * (processus v2): the old one stops working, the new one is shown once with Copy.
 */
function NewPasswordButton({ email, role }: { email: string; role: 'COMPANY' | 'MERCHANT' }) {
  const t = useTranslations('admin.users.actions');
  const tRoot = useTranslations();
  const canManage = useCan('users.manage');
  const [credentials, setCredentials] = useState<Credentials | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [busy, setBusy] = useState(false);
  if (!canManage) return null;

  async function generate() {
    setBusy(true);
    setError(undefined);
    try {
      const found = await getApi().GET('/v1/admin/users', {
        params: { query: { q: email, role } },
      });
      const user = found.data?.data.find((row) => row.email.toLowerCase() === email.toLowerCase());
      if (user === undefined) {
        setError(found.error ?? 'notFound');
        return;
      }
      const reset = await getApi().POST('/v1/admin/users/{userId}/reset-invitation', {
        params: { path: { userId: user.id } },
      });
      if (reset.data === undefined) setError(reset.error);
      else setCredentials(reset.data.credentials);
    } finally {
      setBusy(false);
    }
  }

  return (
    <>
      <Button size="sm" variant="secondary" loading={busy} onClick={() => void generate()}>
        {t('resend')}
      </Button>
      {error !== undefined ? (
        <span role="alert" className="text-caption text-danger-text">
          {error === 'notFound'
            ? tRoot('errors.notFound')
            : tRoot(messageKey(errorMessageKey(error)))}
        </span>
      ) : null}
      <CredentialsDialog
        credentials={credentials}
        onClose={() => {
          setCredentials(undefined);
        }}
      />
    </>
  );
}

function RecordView({
  record,
  owner,
  onChanged,
}: {
  record: AccountRecord;
  owner: Owner;
  onChanged: () => void;
}) {
  const t = useTranslations('admin.record');
  const tCategory = useTranslations('category');
  const tTypes = useTranslations('admin.approvals.types');
  const locale = useLocale();
  const isCompany = 'companyId' in owner;
  const canEdit = useCan(isCompany ? 'companies.manage' : 'merchants.manage');
  const canGrid = useCan('commissions.request');
  const [open, setOpen] = useState<'info' | 'grid' | 'iban' | undefined>(undefined);
  const close = () => {
    setOpen(undefined);
  };
  const done = () => {
    setOpen(undefined);
    onChanged();
  };
  const fieldName = (field: string) => t(`fields.${field}` as 'fields.name');

  return (
    <div className="flex flex-col gap-6">
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <div className="flex items-start justify-between gap-3">
            <CardTitle>{t('contact')}</CardTitle>
            {canEdit ? (
              <Button
                variant="secondary"
                size="sm"
                icon={<Pencil aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  setOpen('info');
                }}
              >
                {t('edit')}
              </Button>
            ) : null}
          </div>
          <DescriptionList
            items={[
              { label: t('fields.name'), value: record.name },
              ...(record.category === undefined
                ? []
                : [{ label: t('fields.category'), value: tCategory(record.category) }]),
              { label: t('fields.city'), value: record.city },
              ...(record.address === undefined || record.address === ''
                ? []
                : [{ label: t('fields.address'), value: record.address }]),
              { label: t('fields.email'), value: <span dir="ltr">{record.email}</span> },
              ...(record.phone === null
                ? []
                : [{ label: t('fields.phone'), value: <span dir="ltr">{record.phone}</span> }]),
              { label: t('created'), value: formatDateTime(record.createdAt, locale) },
            ]}
          />
        </Card>
        <div className="flex flex-col gap-6">
          <Card>
            <div className="flex items-start justify-between gap-3">
              <CardTitle>{t('commission')}</CardTitle>
              {canGrid && record.commissionGrid !== null ? (
                <Button
                  variant="secondary"
                  size="sm"
                  icon={<Percent aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setOpen('grid');
                  }}
                >
                  {t('changeGrid')}
                </Button>
              ) : null}
            </div>
            <CommissionLabel grid={record.commissionGrid} />
            <p className="mt-2 text-caption text-text-muted">{t('futureOnly')}</p>
          </Card>
          {isCompany ? null : (
            <Card>
              <div className="flex items-start justify-between gap-3">
                <CardTitle>{t('iban')}</CardTitle>
                {canEdit ? (
                  <Button
                    variant="secondary"
                    size="sm"
                    icon={<Landmark aria-hidden="true" className="size-icon-sm" />}
                    onClick={() => {
                      setOpen('iban');
                    }}
                  >
                    {t('changeIban')}
                  </Button>
                ) : null}
              </div>
              <p dir="ltr" className="text-body text-text">
                {record.maskedIban ?? t('noIban')}
              </p>
              <p className="mt-2 text-caption text-text-muted">{t('futureOnly')}</p>
            </Card>
          )}
        </div>
      </div>
      {record.requests.length > 0 ? (
        <Alert tone="info">
          {t('pending', {
            list: record.requests.map((request) => tTypes(request.type)).join(', '),
          })}
        </Alert>
      ) : null}
      <Card>
        <CardTitle>{t('history')}</CardTitle>
        {record.history.length === 0 ? (
          <p className="text-body text-text-muted">{t('noHistory')}</p>
        ) : (
          <Timeline
            entries={record.history.map((change, index) => ({
              key: `${change.occurredAt}-${String(index)}`,
              title: change.fields.map(fieldName).join(', '),
              meta: t('changedBy', {
                date: formatDateTime(change.occurredAt, locale),
                name: change.actorName,
              }),
              ...(change.reason === undefined ? {} : { detail: change.reason }),
            }))}
          />
        )}
      </Card>
      {open === 'info' ? (
        <EditInfo record={record} owner={owner} onClose={close} onDone={done} />
      ) : null}
      {open === 'grid' ? (
        <ChangeGrid record={record} owner={owner} onClose={close} onDone={done} />
      ) : null}
      {open === 'iban' && !isCompany ? (
        <ChangeIban merchantId={owner.merchantId} onClose={close} onDone={done} />
      ) : null}
    </div>
  );
}

function EditInfo({
  record,
  owner,
  onClose,
  onDone,
}: {
  record: AccountRecord;
  owner: Owner;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('admin.record');
  const tRoot = useTranslations();
  const tCategory = useTranslations('category');
  const toast = useToast();
  const isCompany = 'companyId' in owner;
  const [draft, setDraft] = useState({
    name: record.name,
    category: record.category ?? '',
    city: record.city,
    address: record.address ?? '',
    phone: record.phone ?? '',
    email: record.email,
    reason: '',
  });
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const set = (field: keyof typeof draft) => (value: string) => {
    setDraft((current) => ({ ...current, [field]: value }));
  };

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    try {
      const common = {
        name: draft.name,
        city: draft.city,
        email: draft.email.trim(),
        ...(draft.phone === '' ? {} : { phone: draft.phone.replaceAll(' ', '') }),
        ...(draft.reason.trim() === '' ? {} : { reason: draft.reason.trim() }),
      };
      const result =
        'companyId' in owner
          ? await getApi().PATCH('/v1/admin/companies/{companyId}', {
              params: { path: { companyId: owner.companyId } },
              body: common,
            })
          : await getApi().PATCH('/v1/admin/merchants/{merchantId}', {
              params: { path: { merchantId: owner.merchantId } },
              body: {
                ...common,
                address: draft.address,
                category: draft.category as Schemas['MerchantCategory'],
              },
            });
      if (result.data !== undefined) {
        toast.notify('success', t('saved'));
        onDone();
        return;
      }
      setError(result.error);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(value) => {
        if (!value && !saving) onClose();
      }}
      title={t('editTitle', { name: record.name })}
      description={t('editDescription')}
      size="lg"
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('duplicate')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <div className="grid gap-4 sm:grid-cols-2">
          <TextField
            label={t('fields.name')}
            value={draft.name}
            onChange={(event) => {
              set('name')(event.target.value);
            }}
          />
          {isCompany ? null : (
            <SelectField
              label={t('fields.category')}
              options={CATEGORIES.map((value) => ({ value, label: tCategory(value) }))}
              value={draft.category}
              onChange={(event) => {
                set('category')(event.target.value);
              }}
            />
          )}
          <TextField
            label={t('fields.city')}
            value={draft.city}
            onChange={(event) => {
              set('city')(event.target.value);
            }}
          />
          {isCompany ? null : (
            <TextField
              label={t('fields.address')}
              value={draft.address}
              onChange={(event) => {
                set('address')(event.target.value);
              }}
            />
          )}
          <TextField
            label={t('fields.email')}
            type="email"
            dir="ltr"
            value={draft.email}
            onChange={(event) => {
              set('email')(event.target.value);
            }}
          />
          <TextField
            label={t('fields.phone')}
            type="tel"
            dir="ltr"
            value={draft.phone}
            onChange={(event) => {
              set('phone')(event.target.value);
            }}
          />
          <div className="sm:col-span-2">
            <TextField
              label={t('reason')}
              hint={t('reasonOptional')}
              maxLength={500}
              value={draft.reason}
              onChange={(event) => {
                set('reason')(event.target.value);
              }}
            />
          </div>
        </div>
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('save')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}

function ChangeGrid({
  record,
  owner,
  onClose,
  onDone,
}: {
  record: AccountRecord;
  owner: Owner;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('admin.record');
  const tRoot = useTranslations();
  const toast = useToast();
  const locale = useLocale();
  const [rows, setRows] = useState<GridRow[]>(() => rowsOf(record.commissionGrid, locale));
  const [errors, setErrors] = useState<Map<number, GridErrorCode | 'rate' | 'from' | 'to'>>(
    new Map(),
  );
  const [reason, setReason] = useState('');
  const [reasonError, setReasonError] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const read = readGrid(rows, locale);
    setErrors(read.errors);
    setReasonError(reason.trim() === '' ? t('reasonRequired') : undefined);
    if (read.tiers === undefined || reason.trim() === '') return;
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/commission-grids/change-requests',
        { body: { ...owner, tiers: read.tiers, reason: reason.trim() } },
      );
      if (data !== undefined) {
        toast.notify('success', t('requested'));
        onDone();
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
      onOpenChange={(value) => {
        if (!value && !saving) onClose();
      }}
      title={t('gridTitle', { name: record.name })}
      description={t('fourEyes')}
      size="lg"
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('alreadyPending')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <CommissionGridEditor
          kind={'companyId' in owner ? 'company' : 'merchant'}
          rows={rows}
          onChange={(next) => {
            setRows(next);
            setErrors(new Map());
          }}
          errors={errors}
        />
        <TextField
          label={t('reason')}
          error={reasonError}
          maxLength={500}
          value={reason}
          onChange={(event) => {
            setReason(event.target.value);
          }}
        />
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('sendForApproval')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}

function ChangeIban({
  merchantId,
  onClose,
  onDone,
}: {
  merchantId: string;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('admin.record');
  const tRoot = useTranslations();
  const toast = useToast();
  const [iban, setIban] = useState('TN');
  const [reason, setReason] = useState('');
  const [invalid, setInvalid] = useState<{ iban?: string; reason?: string }>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const value = iban.replaceAll(' ', '').toUpperCase();
    const next = {
      ...(/^TN[0-9]{22}$/.test(value) ? {} : { iban: t('ibanInvalid') }),
      ...(reason.trim() === '' ? { reason: t('reasonRequired') } : {}),
    };
    setInvalid(next);
    if (Object.keys(next).length > 0) return;
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/merchants/{merchantId}/iban-change-requests',
        { params: { path: { merchantId } }, body: { iban: value, reason: reason.trim() } },
      );
      if (data !== undefined) {
        toast.notify('success', t('requested'));
        onDone();
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
      onOpenChange={(value) => {
        if (!value && !saving) onClose();
      }}
      title={t('ibanTitle')}
      description={t('fourEyes')}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('alreadyPending')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <TextField
          label={t('ibanLabel')}
          hint={t('ibanHint')}
          error={invalid.iban}
          dir="ltr"
          autoComplete="off"
          value={iban}
          onChange={(event) => {
            setIban(event.target.value);
          }}
        />
        <TextField
          label={t('reason')}
          error={invalid.reason}
          maxLength={500}
          value={reason}
          onChange={(event) => {
            setReason(event.target.value);
          }}
        />
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('sendForApproval')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
