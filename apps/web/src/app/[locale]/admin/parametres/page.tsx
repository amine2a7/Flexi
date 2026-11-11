'use client';

import type { Schemas } from '@flexipay/api-client';
import { SlidersHorizontal } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { formatMillimes } from '@/lib/format/money';
import { parseBps, parseMillimes } from '@/lib/format/money-input';
import { Amount, Rate } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge, useCreditTypeLabel } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

type Settings = Schemas['PlatformSettings'];
type Approval = Schemas['Approval'];
const DESTINATIONS: readonly Schemas['ExpiredCreditsDestination'][] = [
  'PLATFORM_REVENUE',
  'COMPANY_RETURN',
];

/** Basis points as the user types them (percent, locale decimal separator), integers only. */
const KYC_DOCUMENTS: Schemas['KycDocumentType'][] = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID',
  'BANK_DETAILS',
  'COMPANY_STATUTES',
  'PROOF_OF_ADDRESS',
];
const DEFAULT_KYC = KYC_DOCUMENTS.slice(0, 4);

function bpsToText(bps: number, locale: Locale): string {
  const fraction = bps % 100;
  if (fraction === 0) return String(Math.trunc(bps / 100));
  return `${String(Math.trunc(bps / 100))}${locale === 'en' ? '.' : ','}${String(fraction).padStart(2, '0')}`;
}

function integerIn(text: string, min: number, max: number): number | undefined {
  if (!/^[0-9]{1,4}$/.test(text.trim())) return undefined;
  const value = Number(text.trim());
  return value >= min && value <= max ? value : undefined;
}

/** « 15, 30, 60 » → [15, 30, 60]: 1 to 5 durations of 1 to 1 440 minutes. */
function minutesList(text: string): number[] | undefined {
  const parts = text.split(/[,;\s]+/).filter((part) => part !== '');
  const values = parts.map((part) => integerIn(part, 1, 1440));
  if (values.length < 1 || values.length > 5) return undefined;
  return values.every((value) => value !== undefined) ? values : undefined;
}

/**
 * Settings of the platform, grouped by theme (request of 2026-11-05): every business value lives
 * here, none in the code. A change is a request that another administrator approves.
 */
export default function SettingsPage() {
  const t = useTranslations('admin.settings');
  const canRequest = useCan('settings.request');
  const canReadApprovals = useCan('approvals.read');
  const locale = useLocale();
  const settings = useApiQuery(() => getApi().GET('/v1/admin/settings'), []);
  const [editing, setEditing] = useState(false);

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          settings.status === 'success' && canRequest ? (
            <Button
              icon={<SlidersHorizontal aria-hidden="true" className="size-icon-sm" />}
              onClick={() => {
                setEditing(true);
              }}
            >
              {t('request')}
            </Button>
          ) : null
        }
      />
      {settings.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {settings.status === 'error' ? (
        <ErrorState error={settings.error} onRetry={settings.reload} />
      ) : null}
      {settings.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <CurrentSettings settings={settings.data} />
          {canReadApprovals ? <SettingsHistory locale={locale} /> : null}
          {editing ? (
            <ChangeSettings
              current={settings.data}
              locale={locale}
              onClose={() => {
                setEditing(false);
              }}
            />
          ) : null}
        </div>
      ) : null}
    </>
  );
}

function CurrentSettings({ settings }: { settings: Settings }) {
  const tKyc = useTranslations('admin.kyc');
  const t = useTranslations('admin.settings');
  const tTypes = useTranslations('ui.creditTypes');
  const typeColumns: Column<Schemas['CreditTypeSettings']>[] = [
    {
      key: 'type',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
    },
    {
      key: 'enabled',
      header: t('typeStatus'),
      cell: (row) => (
        <StatusBadge
          status={row.enabled ? 'ACTIVE' : 'SUSPENDED'}
          labelKey={row.enabled ? 'admin.settings.typeOn' : 'admin.settings.typeOff'}
        />
      ),
    },
    {
      key: 'commission',
      header: t('typeCommission'),
      align: 'end',
      cell: (row) => <Rate bps={row.commissionRateBps} />,
    },
    {
      key: 'validity',
      header: t('typeValidity'),
      align: 'end',
      cell: (row) => t('creditValidityValue', { months: row.validityMonths }),
    },
    {
      key: 'limit',
      header: t('typeDailyLimit'),
      align: 'end',
      cell: (row) => <Amount millimes={row.dailyLimitMillimes} />,
    },
  ];
  const funding = settings.fundingAccount;
  return (
    <>
      <Card>
        <CardTitle description={t('groupHints.finance')}>{t('groups.finance')}</CardTitle>
        <DescriptionList
          items={[
            { label: t('orderFee'), value: <Rate bps={settings.orderFeeRateBps} /> },
            { label: t('vat'), value: <Rate bps={settings.vatRateBps} /> },
            { label: t('stamp'), value: <Amount millimes={settings.stampDutyMillimes} /> },
            {
              label: t('transferFee'),
              value: <Amount millimes={settings.transferFeeMillimes ?? 0} />,
            },
            {
              label: t('withholdingThreshold'),
              value: <Amount millimes={settings.withholding?.thresholdMillimes ?? 0} />,
            },
            {
              label: t('withholdingPpCin'),
              value: <Rate bps={settings.withholding?.ppCinBps ?? 0} />,
            },
            {
              label: t('withholdingPpMf'),
              value: <Rate bps={settings.withholding?.ppMfBps ?? 0} />,
            },
            {
              label: t('withholdingPmMf'),
              value: <Rate bps={settings.withholding?.pmMfBps ?? 0} />,
            },
            {
              label: t('payoutMinimum'),
              value: <Amount millimes={settings.payoutMinimumMillimes} />,
            },
            {
              label: t('secondThreshold'),
              value: <Amount millimes={settings.secondValidationThresholdMillimes} />,
            },
            {
              label: t('expiredDestination'),
              value: t(`destinations.${settings.expiredCreditsDestination}`),
            },
            {
              label: t('funding'),
              value: (
                <span className="flex flex-col">
                  <span>{`${funding.bankName} · ${funding.holder}`}</span>
                  <span dir="ltr" className="tabular-nums">
                    {funding.iban}
                  </span>
                </span>
              ),
            },
          ]}
        />
      </Card>
      <Card>
        <CardTitle description={t('groupHints.security')}>{t('groups.security')}</CardTitle>
        <DescriptionList
          items={[
            {
              label: t('otpValidity'),
              value: t('minutesValue', { count: settings.otpValidityMinutes }),
            },
            {
              label: t('pinLocks'),
              value: t('pinLocksValue', { steps: settings.pinLockMinutes.join(' → ') }),
            },
            {
              label: t('invitationValidity'),
              value: t('daysValue', { count: settings.invitationValidityDays }),
            },
            {
              label: t('kycDocuments'),
              value: (settings.kycRequiredDocuments ?? DEFAULT_KYC)
                .map((type) => tKyc(`documentTypes.${type}`))
                .join(' · '),
            },
          ]}
        />
      </Card>
      <Card>
        <CardTitle description={t('groupHints.delays')}>{t('groups.delays')}</CardTitle>
        <DescriptionList
          items={[
            {
              label: t('quoteValidity'),
              value: t('daysValue', { count: settings.quoteValidityDays }),
            },
            {
              label: t('cancelHours'),
              value: t('hoursValue', { count: settings.paymentCancelHours }),
            },
            {
              label: t('settlementDelay'),
              value: t('settlementValue', { days: settings.settlementDelayDays }),
            },
            {
              label: t('creditValidity'),
              value: t('creditValidityValue', { months: settings.creditValidityMonths }),
            },
          ]}
        />
      </Card>
      <Card>
        <CardTitle description={t('groupHints.types')}>{t('groups.types')}</CardTitle>
        <DescriptionList items={[{ label: t('maxFamily'), value: settings.maxFamilyMembers }]} />
        <div className="mt-4">
          <DataTable
            caption={t('typesTitle')}
            columns={typeColumns}
            rows={settings.creditTypes}
            rowKey={(row) => row.creditType}
            empty={{ title: t('typesTitle') }}
          />
        </div>
      </Card>
    </>
  );
}

/** Requests to change the settings and their decision (the audit log keeps the field names). */
function SettingsHistory({ locale }: { locale: Locale }) {
  const t = useTranslations('admin.settings');
  const approvals = useApiQuery(
    () => getApi().GET('/v1/admin/approvals', { params: { query: { limit: 100 } } }),
    [],
  );
  const rows =
    approvals.status === 'success'
      ? approvals.data.data.filter((item) => item.type === 'SETTINGS_CHANGE')
      : [];
  const columns: Column<Approval>[] = [
    { key: 'date', header: t('historyDate'), cell: (row) => formatDateTime(row.createdAt, locale) },
    { key: 'by', header: t('historyBy'), cell: (row) => row.initiatorName },
    { key: 'reason', header: t('historyReason'), cell: (row) => row.reason ?? '' },
    {
      key: 'status',
      header: t('historyStatus'),
      cell: (row) => <StatusBadge status={row.status} />,
    },
  ];
  return (
    <Card>
      <CardTitle description={t('historyHint')}>{t('history')}</CardTitle>
      {approvals.status === 'loading' ? <LoadingBlock lines={2} /> : null}
      {approvals.status === 'error' ? (
        <ErrorState error={approvals.error} onRetry={approvals.reload} />
      ) : null}
      {approvals.status === 'success' ? (
        <DataTable
          caption={t('history')}
          columns={columns}
          rows={rows}
          rowKey={(row) => row.id}
          empty={{ title: t('historyEmpty') }}
        />
      ) : null}
    </Card>
  );
}

type DraftKey =
  | 'payoutMinimum'
  | 'creditValidity'
  | 'maxFamily'
  | 'orderFee'
  | 'vat'
  | 'stamp'
  | 'transferFee'
  | 'withholdingThreshold'
  | 'withholdingPpCin'
  | 'withholdingPpMf'
  | 'withholdingPmMf'
  | 'threshold'
  | 'bankName'
  | 'holder'
  | 'rib'
  | 'iban'
  | 'otp'
  | 'pinLocks'
  | 'invitation'
  | 'quote'
  | 'cancel'
  | 'settlement'
  | 'reason';

function ChangeSettings({
  current,
  locale,
  onClose,
}: {
  current: Settings;
  locale: Locale;
  onClose: () => void;
}) {
  const t = useTranslations('admin.settings');
  const tRoot = useTranslations();
  const typeLabel = useCreditTypeLabel();
  const toast = useToast();
  const [draft, setDraft] = useState<Record<DraftKey, string>>({
    payoutMinimum: formatMillimes(current.payoutMinimumMillimes, locale),
    creditValidity: String(current.creditValidityMonths),
    maxFamily: String(current.maxFamilyMembers),
    orderFee: bpsToText(current.orderFeeRateBps, locale),
    vat: bpsToText(current.vatRateBps, locale),
    stamp: formatMillimes(current.stampDutyMillimes, locale),
    transferFee: formatMillimes(current.transferFeeMillimes ?? 0, locale),
    withholdingThreshold: formatMillimes(current.withholding?.thresholdMillimes ?? 0, locale),
    withholdingPpCin: bpsToText(current.withholding?.ppCinBps ?? 0, locale),
    withholdingPpMf: bpsToText(current.withholding?.ppMfBps ?? 0, locale),
    withholdingPmMf: bpsToText(current.withholding?.pmMfBps ?? 0, locale),
    threshold: formatMillimes(current.secondValidationThresholdMillimes, locale),
    bankName: current.fundingAccount.bankName,
    holder: current.fundingAccount.holder,
    rib: current.fundingAccount.rib,
    iban: current.fundingAccount.iban,
    otp: String(current.otpValidityMinutes),
    pinLocks: current.pinLockMinutes.join(', '),
    invitation: String(current.invitationValidityDays),
    quote: String(current.quoteValidityDays),
    cancel: String(current.paymentCancelHours),
    settlement: String(current.settlementDelayDays),
    reason: '',
  });
  const [destination, setDestination] = useState(current.expiredCreditsDestination);
  const tKyc = useTranslations('admin.kyc');
  const [kycDocs, setKycDocs] = useState<Schemas['KycDocumentType'][]>([
    ...(current.kycRequiredDocuments ?? DEFAULT_KYC),
  ]);
  const [types, setTypes] = useState(() =>
    current.creditTypes.map((item) => ({
      creditType: item.creditType,
      enabled: item.enabled,
      commission: bpsToText(item.commissionRateBps, locale),
      validity: String(item.validityMonths),
      limit: formatMillimes(item.dailyLimitMillimes, locale),
    })),
  );
  const [typeErrors, setTypeErrors] = useState<Record<string, string>>({});
  const [invalid, setInvalid] = useState<Partial<Record<DraftKey, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  const field = (
    key: DraftKey,
    label: string,
    options: { hint?: string; numeric?: boolean } = {},
  ) => (
    <TextField
      label={label}
      hint={options.hint}
      error={invalid[key]}
      inputMode={options.numeric === false ? undefined : 'decimal'}
      dir="ltr"
      value={draft[key]}
      onChange={(event) => {
        const value = event.target.value;
        setDraft((previous) => ({ ...previous, [key]: value }));
      }}
    />
  );

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const vat = parseBps(draft.vat, locale);
    const threshold = parseMillimes(draft.threshold, locale);
    const parsed = {
      payoutMinimum: parseMillimes(draft.payoutMinimum, locale),
      creditValidity: integerIn(draft.creditValidity, 1, 60),
      maxFamily: integerIn(draft.maxFamily, 0, 10),
      orderFee: parseBps(draft.orderFee, locale),
      vat: vat !== undefined && vat <= 10_000 ? vat : undefined,
      stamp: parseMillimes(draft.stamp, locale),
      transferFee: parseMillimes(draft.transferFee, locale),
      withholdingThreshold: parseMillimes(draft.withholdingThreshold, locale),
      withholdingPpCin: parseBps(draft.withholdingPpCin, locale),
      withholdingPpMf: parseBps(draft.withholdingPpMf, locale),
      withholdingPmMf: parseBps(draft.withholdingPmMf, locale),
      threshold: threshold !== undefined && threshold > 0 ? threshold : undefined,
      bankName: draft.bankName.trim() === '' ? undefined : draft.bankName.trim(),
      holder: draft.holder.trim() === '' ? undefined : draft.holder.trim(),
      rib: /^[0-9]{20}$/.test(draft.rib.trim()) ? draft.rib.trim() : undefined,
      iban: /^TN[0-9]{22}$/.test(draft.iban.replaceAll(' ', ''))
        ? draft.iban.replaceAll(' ', '')
        : undefined,
      otp: integerIn(draft.otp, 1, 30),
      pinLocks: minutesList(draft.pinLocks),
      invitation: integerIn(draft.invitation, 1, 30),
      quote: integerIn(draft.quote, 1, 90),
      cancel: integerIn(draft.cancel, 0, 72),
      settlement: integerIn(draft.settlement, 1, 10),
    };
    const message = t('invalid');
    const errors: Partial<Record<DraftKey, string>> = Object.fromEntries(
      Object.entries(parsed)
        .filter(([, value]) => value === undefined)
        .map(([key]) => [key, message]),
    );
    if (draft.reason.trim() === '') errors.reason = tRoot('admin.merchants.form.required');
    const parsedTypes = types.map((item) => ({
      creditType: item.creditType,
      enabled: item.enabled,
      commissionRateBps: parseBps(item.commission, locale),
      validityMonths: integerIn(item.validity, 1, 60),
      dailyLimitMillimes: parseMillimes(item.limit, locale),
    }));
    const nextTypeErrors: Record<string, string> = {};
    for (const item of parsedTypes) {
      if (item.commissionRateBps === undefined)
        nextTypeErrors[`${item.creditType}.commission`] = message;
      if (item.validityMonths === undefined)
        nextTypeErrors[`${item.creditType}.validity`] = message;
      if (item.dailyLimitMillimes === undefined || item.dailyLimitMillimes === 0)
        nextTypeErrors[`${item.creditType}.limit`] = message;
    }
    setTypeErrors(nextTypeErrors);
    setInvalid(errors);
    const validTypes = parsedTypes.flatMap((item) =>
      item.commissionRateBps === undefined ||
      item.validityMonths === undefined ||
      item.dailyLimitMillimes === undefined
        ? []
        : [
            {
              creditType: item.creditType,
              enabled: item.enabled,
              commissionRateBps: item.commissionRateBps,
              validityMonths: item.validityMonths,
              dailyLimitMillimes: item.dailyLimitMillimes,
            },
          ],
    );
    const {
      payoutMinimum,
      creditValidity,
      maxFamily,
      orderFee,
      stamp,
      bankName,
      holder,
      rib,
      iban,
      otp,
      pinLocks,
      invitation,
      quote,
      cancel,
      settlement,
      transferFee,
      withholdingThreshold,
      withholdingPpCin,
      withholdingPpMf,
      withholdingPmMf,
    } = parsed;
    if (
      Object.keys(errors).length > 0 ||
      Object.keys(nextTypeErrors).length > 0 ||
      validTypes.length !== types.length ||
      payoutMinimum === undefined ||
      creditValidity === undefined ||
      maxFamily === undefined ||
      orderFee === undefined ||
      parsed.vat === undefined ||
      stamp === undefined ||
      parsed.threshold === undefined ||
      bankName === undefined ||
      holder === undefined ||
      rib === undefined ||
      iban === undefined ||
      otp === undefined ||
      pinLocks === undefined ||
      invitation === undefined ||
      quote === undefined ||
      cancel === undefined ||
      settlement === undefined ||
      transferFee === undefined ||
      withholdingThreshold === undefined ||
      withholdingPpCin === undefined ||
      withholdingPpMf === undefined ||
      withholdingPmMf === undefined ||
      kycDocs.length === 0
    ) {
      return;
    }
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().PUT('/v1/admin/settings', {
        body: {
          settings: {
            payoutMinimumMillimes: payoutMinimum,
            creditValidityMonths: creditValidity,
            maxFamilyMembers: maxFamily,
            orderFeeRateBps: orderFee,
            vatRateBps: parsed.vat,
            stampDutyMillimes: stamp,
            withholding: {
              thresholdMillimes: withholdingThreshold,
              ppCinBps: withholdingPpCin,
              ppMfBps: withholdingPpMf,
              pmMfBps: withholdingPmMf,
            },
            transferFeeMillimes: transferFee,
            kycRequiredDocuments: KYC_DOCUMENTS.filter((type) => kycDocs.includes(type)),
            expiredCreditsDestination: destination,
            fundingAccount: { bankName, holder, rib, iban },
            secondValidationThresholdMillimes: parsed.threshold,
            quoteValidityDays: quote,
            invitationValidityDays: invitation,
            otpValidityMinutes: otp,
            pinLockMinutes: pinLocks,
            paymentCancelHours: cancel,
            settlementDelayDays: settlement,
            creditTypes: validTypes,
          },
          reason: draft.reason.trim(),
        },
      });
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
        if (!open && !saving) onClose();
      }}
      title={t('formTitle')}
      description={t('description')}
      size="lg"
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-6" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('pending')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <fieldset className="flex flex-col gap-4">
          <legend className="mb-2 text-title-sm text-text">{t('groups.finance')}</legend>
          <div className="grid gap-4 sm:grid-cols-2">
            {field('orderFee', t('orderFeeLabel'))}
            {field('vat', t('vat'), { hint: t('vatHint') })}
            {field('stamp', t('stamp'), { hint: t('stampHint') })}
            {field('transferFee', t('transferFee'))}
            {field('withholdingThreshold', t('withholdingThreshold'), {
              hint: t('withholdingThresholdHint'),
            })}
            {field('withholdingPpCin', t('withholdingPpCin'))}
            {field('withholdingPpMf', t('withholdingPpMf'))}
            {field('withholdingPmMf', t('withholdingPmMf'))}
            {field('payoutMinimum', t('payoutMinimumLabel'))}
            {field('threshold', t('secondThresholdLabel'))}
            <SelectField
              label={t('expiredDestinationLabel')}
              hint={t('expiredDestinationHint')}
              options={DESTINATIONS.map((value) => ({ value, label: t(`destinations.${value}`) }))}
              value={destination}
              onChange={(event) => {
                const value = DESTINATIONS.find((item) => item === event.target.value);
                if (value !== undefined) setDestination(value);
              }}
            />
            {field('bankName', t('fundingBank'), { numeric: false })}
            {field('holder', t('fundingHolder'), { numeric: false })}
            {field('rib', t('fundingRib'))}
            {field('iban', t('fundingIban'), { numeric: false })}
          </div>
        </fieldset>
        <fieldset className="flex flex-col gap-4">
          <legend className="mb-2 text-title-sm text-text">{t('groups.security')}</legend>
          <div className="grid gap-4 sm:grid-cols-2">
            {field('otp', t('otpValidityLabel'))}
            {field('pinLocks', t('pinLocksLabel'), { hint: t('pinLocksHint'), numeric: false })}
            {field('invitation', t('invitationValidityLabel'))}
          </div>
          <div className="flex flex-col gap-2">
            <p className="text-label text-text">{t('kycDocuments')}</p>
            <p className="text-caption text-text-muted">{t('kycDocumentsHint')}</p>
            <div className="flex flex-wrap gap-3">
              {KYC_DOCUMENTS.map((type) => (
                <label key={type} className="flex items-center gap-2 text-body text-text">
                  <input
                    type="checkbox"
                    className="size-icon-sm accent-navy"
                    checked={kycDocs.includes(type)}
                    onChange={(event) => {
                      setKycDocs((list) =>
                        event.target.checked
                          ? [...list, type]
                          : list.filter((item) => item !== type),
                      );
                    }}
                  />
                  {tKyc(`documentTypes.${type}`)}
                </label>
              ))}
            </div>
            {kycDocs.length === 0 ? (
              <p className="text-caption text-danger-text">{t('kycDocumentsRequired')}</p>
            ) : null}
          </div>
        </fieldset>
        <fieldset className="flex flex-col gap-4">
          <legend className="mb-2 text-title-sm text-text">{t('groups.delays')}</legend>
          <div className="grid gap-4 sm:grid-cols-2">
            {field('quote', t('quoteValidityLabel'))}
            {field('cancel', t('cancelHoursLabel'))}
            {field('settlement', t('settlementDelayLabel'))}
            {field('creditValidity', t('creditValidityLabel'))}
          </div>
        </fieldset>
        <fieldset className="flex flex-col gap-4">
          <legend className="mb-2 text-title-sm text-text">{t('groups.types')}</legend>
          {field('maxFamily', t('maxFamilyLabel'))}
          {types.map((item, index) => {
            const label = typeLabel(item.creditType);
            const update = (patch: Partial<(typeof types)[number]>) => {
              setTypes((previous) =>
                previous.map((entry, position) =>
                  position === index ? { ...entry, ...patch } : entry,
                ),
              );
            };
            return (
              <div
                key={item.creditType}
                className="flex flex-col gap-3 rounded-card-desktop border border-border p-4"
              >
                <label className="flex min-h-touch-target-min items-center gap-3">
                  <input
                    type="checkbox"
                    className="size-icon-sm accent-navy"
                    checked={item.enabled}
                    onChange={(event) => {
                      update({ enabled: event.target.checked });
                    }}
                  />
                  <CreditTypeBadge type={item.creditType} />
                  <span className="text-caption text-text-muted">
                    {t('typeEnabledLabel', { type: label })}
                  </span>
                </label>
                <div className="grid gap-3 sm:grid-cols-3">
                  <TextField
                    label={t('typeCommissionLabel', { type: label })}
                    error={typeErrors[`${item.creditType}.commission`]}
                    inputMode="decimal"
                    dir="ltr"
                    value={item.commission}
                    onChange={(event) => {
                      update({ commission: event.target.value });
                    }}
                  />
                  <TextField
                    label={t('typeValidityLabel', { type: label })}
                    error={typeErrors[`${item.creditType}.validity`]}
                    inputMode="numeric"
                    dir="ltr"
                    value={item.validity}
                    onChange={(event) => {
                      update({ validity: event.target.value });
                    }}
                  />
                  <TextField
                    label={t('typeLimitLabel', { type: label })}
                    error={typeErrors[`${item.creditType}.limit`]}
                    inputMode="decimal"
                    dir="ltr"
                    value={item.limit}
                    onChange={(event) => {
                      update({ limit: event.target.value });
                    }}
                  />
                </div>
              </div>
            );
          })}
        </fieldset>
        <TextField
          label={t('reason')}
          error={invalid.reason}
          value={draft.reason}
          maxLength={500}
          onChange={(event) => {
            const value = event.target.value;
            setDraft((previous) => ({ ...previous, reason: value }));
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
