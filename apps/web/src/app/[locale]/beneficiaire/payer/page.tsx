'use client';

import type { Schemas } from '@flexipay/api-client';
import { Check, FlaskConical, QrCode as QrIcon, RefreshCw, X } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useCallback, useEffect, useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { getApiOrigin } from '@/lib/env';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { useFundsMessage } from '@/components/beneficiaire/funds-message';
import { PinDialog } from '@/components/beneficiaire/pin-dialog';
import { QrScanner } from '@/components/beneficiaire/qr-scanner';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { Countdown } from '@/components/ui/countdown';
import {
  CreditTypeBadge,
  CreditTypeBadges,
  CreditTypeSelect,
  type CreditType,
} from '@/components/ui/credit-type';
import { TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader, Tabs } from '@/components/ui/layout-blocks';
import { QrCode } from '@/components/ui/qr-code';
import { ResultScreen } from '@/components/ui/result-screen';
import { useToast } from '@/components/ui/toast';

type Operation = Schemas['EmployeeOperationDetail'];
type Request = Schemas['EmployeePaymentRequest'];
const POLL_MS = 2000;
const DEV = process.env.NODE_ENV !== 'production';
const MERCHANT_QR = /^flexipay:merchant:([0-9]{6})$/;

/** Pay: show my dynamic code (QR + 8 digits) and confirm requests, or pay a merchant by its code. */
export default function PayPage() {
  const t = useTranslations('beneficiary.pay');
  const [tab, setTab] = useState<'code' | 'merchant'>('code');
  const [paid, setPaid] = useState<Operation | undefined>(undefined);

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Tabs
        label={t('title')}
        tabs={[
          { key: 'code', label: t('tabCode') },
          { key: 'merchant', label: t('tabMerchant') },
        ]}
        value={tab}
        onChange={setTab}
      />
      {tab === 'code' ? <MyCode onPaid={setPaid} /> : <PayMerchant onPaid={setPaid} />}
      {paid !== undefined ? (
        <PaidScreen operation={paid} onClose={() => setPaid(undefined)} />
      ) : null}
    </>
  );
}

function PaidScreen({ operation, onClose }: { operation: Operation; onClose: () => void }) {
  const t = useTranslations('beneficiary.pay');
  const locale = useLocale();
  return (
    <ResultScreen
      tone="success"
      title={t('paidTitle')}
      description={t('paidMessage', {
        amount: formatMillimesWithCurrency(operation.amountMillimes, locale),
        merchant: operation.counterpartyName,
      })}
      actions={
        <>
          <Link
            href={`/beneficiaire/historique/${operation.id}`}
            className={buttonClasses('secondary')}
          >
            {t('receipt')}
          </Link>
          <Button variant="ghost" className="text-current" onClick={onClose}>
            {t('backHome')}
          </Button>
        </>
      }
    >
      <p className="text-amount-xl tabular-nums" dir="ltr">
        {formatMillimesWithCurrency(operation.amountMillimes, locale)}
      </p>
      <p className="text-body-lg">
        {t('newBalance', {
          amount: formatMillimesWithCurrency(operation.balanceAfterMillimes, locale),
        })}
      </p>
    </ResultScreen>
  );
}

function MyCode({ onPaid }: { onPaid: (operation: Operation) => void }) {
  const t = useTranslations('beneficiary.pay');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const fundsMessage = useFundsMessage();
  const [code, setCode] = useState<Schemas['PaymentCode'] | undefined>(undefined);
  const [expired, setExpired] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [requests, setRequests] = useState<Request[]>([]);
  const [confirming, setConfirming] = useState<Request | undefined>(undefined);

  const loadRequests = useCallback(async () => {
    const { data } = await getApi().GET('/v1/employee/payment-requests');
    if (data !== undefined) setRequests(data.data);
  }, []);

  useEffect(() => {
    void loadRequests();
    const timer = setInterval(() => void loadRequests(), POLL_MS);
    return () => {
      clearInterval(timer);
    };
  }, [loadRequests]);

  useEffect(() => {
    if (code === undefined) return undefined;
    const left = new Date(code.expiresAt).getTime() - Date.now();
    const timer = setTimeout(() => setExpired(true), Math.max(left, 0));
    return () => {
      clearTimeout(timer);
    };
  }, [code]);

  async function generate() {
    setLoading(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/employee/payment-codes');
      if (data === undefined) setError(problem);
      else {
        setCode(data);
        setExpired(false);
      }
    } finally {
      setLoading(false);
    }
  }

  async function refuse(request: Request) {
    const { error: problem } = await getApi().POST(
      '/v1/employee/payment-requests/{requestId}/refuse',
      { params: { path: { requestId: request.id } } },
    );
    if (problem === undefined) toast.notify('info', t('refusedToast'));
    void loadRequests();
  }

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      <Card>
        <CardTitle description={t('codeHint')}>{t('codeTitle')}</CardTitle>
        <div className="flex flex-col items-center gap-4 text-center">
          {error !== undefined ? (
            <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
          ) : null}
          {code !== undefined && !expired ? (
            <>
              <QrCode value={code.qrPayload} label={t('qrLabel', { code: code.code })} />
              <p className="text-caption text-text-muted">{t('codeLabel')}</p>
              <p className="text-amount font-label tracking-widest text-text" dir="ltr">
                {`${code.code.slice(0, 4)} ${code.code.slice(4)}`}
              </p>
              <div className="w-full">
                <Countdown expiresAt={code.expiresAt} total={code.validitySeconds} />
              </div>
            </>
          ) : null}
          {expired ? <Alert tone="info">{t('expired')}</Alert> : null}
          <Button
            loading={loading}
            className="w-full"
            icon={
              code === undefined ? (
                <QrIcon aria-hidden="true" className="size-icon-md" />
              ) : (
                <RefreshCw aria-hidden="true" className="size-icon-md" />
              )
            }
            onClick={() => void generate()}
          >
            {code === undefined ? t('generate') : t('regenerate')}
          </Button>
        </div>
      </Card>
      <Card>
        <CardTitle>{t('requestsTitle')}</CardTitle>
        {requests.length === 0 ? (
          <p className="text-body text-text-muted">{t('requestsEmpty')}</p>
        ) : (
          <ul className="flex flex-col gap-3">
            {requests.map((request) => (
              <li
                key={request.id}
                className="flex flex-col gap-3 rounded-card-desktop border border-border p-4"
              >
                <div className="flex items-start justify-between gap-3">
                  <span className="flex flex-col gap-1">
                    <span className="text-label text-text">{request.merchantName}</span>
                    <CreditTypeBadge type={request.creditType} />
                  </span>
                  <Amount millimes={request.amountMillimes} size="title" />
                </div>
                <div className="flex gap-3">
                  <Button
                    variant="secondary"
                    className="flex-1"
                    icon={<X aria-hidden="true" className="size-icon-md" />}
                    onClick={() => void refuse(request)}
                  >
                    {t('refuse')}
                  </Button>
                  <Button
                    className="flex-1"
                    icon={<Check aria-hidden="true" className="size-icon-md" />}
                    onClick={() => setConfirming(request)}
                  >
                    {t('confirm')}
                  </Button>
                </div>
              </li>
            ))}
          </ul>
        )}
        {DEV ? <DemoRequest onCreated={() => void loadRequests()} /> : null}
      </Card>
      {confirming !== undefined ? (
        <ConfirmRequest
          request={confirming}
          describe={(problem) => fundsMessage(problem, confirming.creditType)}
          locale={locale}
          onClose={() => setConfirming(undefined)}
          onPaid={(operation) => {
            setConfirming(undefined);
            void loadRequests();
            onPaid(operation);
          }}
        />
      ) : null}
    </div>
  );
}

function ConfirmRequest({
  request,
  describe,
  locale,
  onClose,
  onPaid,
}: {
  request: Request;
  describe: (error: unknown) => string | undefined;
  locale: string;
  onClose: () => void;
  onPaid: (operation: Operation) => void;
}) {
  const t = useTranslations('beneficiary.pay');
  const [intentKey] = useState(newIdempotencyKey);
  return (
    <PinDialog
      title={t('confirmTitle')}
      describe={describe}
      confirmLabel={t('confirmAction', {
        amount: formatMillimesWithCurrency(request.amountMillimes, locale as 'fr'),
      })}
      recap={
        <DescriptionList
          items={[
            { label: t('merchant'), value: request.merchantName },
            { label: t('category'), value: <CreditTypeBadge type={request.creditType} /> },
            {
              label: t('amount'),
              value: <Amount millimes={request.amountMillimes} size="title" />,
            },
          ]}
        />
      }
      onClose={onClose}
      onSubmit={async (pin) => {
        const { data, error } = await getApi().POST(
          '/v1/employee/payment-requests/{requestId}/confirm',
          {
            params: { path: { requestId: request.id }, header: { 'Idempotency-Key': intentKey } },
            body: { pin },
          },
        );
        if (data !== undefined) {
          onPaid(data);
          return undefined;
        }
        return error;
      }}
    />
  );
}

/** Development only: a merchant request arrives, as if a shop had typed the code. */
function DemoRequest({ onCreated }: { onCreated: () => void }) {
  const t = useTranslations('beneficiary.pay');
  return (
    <div className="mt-4 flex flex-col gap-2 rounded-card-desktop border border-warning bg-warning-soft p-3 text-warning-text">
      <Button
        variant="secondary"
        size="sm"
        icon={<FlaskConical aria-hidden="true" className="size-icon-sm" />}
        onClick={() =>
          void fetch(`${getApiOrigin() ?? ''}/__demo/employee/payment-request`, {
            method: 'POST',
            credentials: 'include',
          }).then(onCreated)
        }
      >
        {t('demo')}
      </Button>
      <p className="text-caption">{t('demoPin', { pin: '1234' })}</p>
    </div>
  );
}

function PayMerchant({ onPaid }: { onPaid: (operation: Operation) => void }) {
  const t = useTranslations('beneficiary.pay');
  const tRoot = useTranslations();
  const locale = useLocale();
  const fundsMessage = useFundsMessage();
  const wallet = useApiQuery(() => getApi().GET('/v1/employee/wallet'), []);
  const [codeText, setCodeText] = useState('');
  const [merchant, setMerchant] = useState<Schemas['MerchantLookup'] | undefined>(undefined);
  const [scanError, setScanError] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [looking, setLooking] = useState(false);
  const [creditType, setCreditType] = useState<CreditType | ''>('');
  const [amountText, setAmountText] = useState('');
  const [paying, setPaying] = useState(false);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);
  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);

  const lookup = useCallback(async (code: string) => {
    setLooking(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().GET('/v1/employee/merchants/{merchantCode}', {
        params: { path: { merchantCode: code } },
      });
      if (data === undefined) {
        setError(problem);
        return;
      }
      setMerchant(data);
      setCreditType(
        data.acceptedCreditTypes.length === 1 ? (data.acceptedCreditTypes[0] ?? '') : '',
      );
      setIntentKey(newIdempotencyKey());
    } finally {
      setLooking(false);
    }
  }, []);

  const onScan = useCallback(
    (value: string) => {
      const match = MERCHANT_QR.exec(value);
      if (match?.[1] === undefined) {
        setScanError(true);
        return;
      }
      setScanError(false);
      setCodeText(match[1]);
      void lookup(match[1]);
    },
    [lookup],
  );

  function onFind(event: SyntheticEvent) {
    event.preventDefault();
    if (/^[0-9]{6}$/.test(codeText)) void lookup(codeText);
  }

  const balances = wallet.status === 'success' ? wallet.data.balances : [];
  const balanceOf = (type: CreditType) =>
    balances.find((item) => item.creditType === type)?.balanceMillimes;

  if (merchant === undefined) {
    return (
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle>{t('merchantTitle')}</CardTitle>
          <div className="flex flex-col gap-4">
            <QrScanner onCode={onScan} />
            {scanError ? <Alert tone="warning">{t('scanInvalid')}</Alert> : null}
            <p className="text-center text-caption text-text-muted">{t('or')}</p>
            <form onSubmit={onFind} className="flex flex-col gap-4" noValidate>
              {error !== undefined ? (
                <Alert tone="danger">
                  {(error as { code?: string }).code === 'NOT_FOUND'
                    ? t('merchantNotFound')
                    : tRoot(messageKey(errorMessageKey(error)))}
                </Alert>
              ) : null}
              <TextField
                label={t('merchantCode')}
                hint={t('merchantCodeHint')}
                inputMode="numeric"
                autoComplete="off"
                maxLength={6}
                dir="ltr"
                value={codeText}
                onChange={(event) => setCodeText(event.target.value.replace(/\D/g, ''))}
              />
              <Button type="submit" loading={looking} disabled={!/^[0-9]{6}$/.test(codeText)}>
                {t('find')}
              </Button>
            </form>
          </div>
        </Card>
      </div>
    );
  }

  const ready = creditType !== '' && millimes !== undefined && millimes > 0;
  return (
    <div className="grid gap-6 lg:grid-cols-2">
      <Card>
        <CardTitle
          description={merchant.city}
          action={
            <Button
              variant="ghost"
              size="sm"
              onClick={() => {
                setMerchant(undefined);
                setAmountText('');
              }}
            >
              {t('change')}
            </Button>
          }
        >
          {t('payTitle', { merchant: merchant.merchantName })}
        </CardTitle>
        <div className="flex flex-col gap-4">
          <CreditTypeBadges types={merchant.acceptedCreditTypes} />
          <CreditTypeSelect
            label={t('category')}
            types={merchant.acceptedCreditTypes}
            placeholder={t('category')}
            value={creditType}
            onChange={setCreditType}
          />
          {creditType !== '' && balanceOf(creditType) !== undefined ? (
            <p className="flex items-center gap-2 text-caption text-text-muted">
              <CreditTypeBadge type={creditType} />
              <Amount millimes={balanceOf(creditType) ?? 0} />
            </p>
          ) : null}
          <TextField
            label={t('amountLabel')}
            hint={
              millimes === undefined || millimes === 0
                ? t('amountHint')
                : t('amountPreview', { amount: formatMillimesWithCurrency(millimes, locale) })
            }
            error={amountText !== '' && millimes === undefined ? t('amountInvalid') : undefined}
            inputMode="decimal"
            dir="ltr"
            value={amountText}
            onChange={(event) => setAmountText(event.target.value)}
          />
          <Button disabled={!ready} onClick={() => setPaying(true)}>
            {millimes === undefined || !ready
              ? t('continue')
              : t('confirmAction', { amount: formatMillimesWithCurrency(millimes, locale) })}
          </Button>
        </div>
      </Card>
      {paying && ready ? (
        <PinDialog
          title={t('confirmTitle')}
          describe={(problem) => fundsMessage(problem, creditType)}
          confirmLabel={t('confirmAction', {
            amount: formatMillimesWithCurrency(millimes, locale),
          })}
          recap={
            <DescriptionList
              items={[
                { label: t('merchant'), value: merchant.merchantName },
                { label: t('category'), value: <CreditTypeBadge type={creditType} /> },
                { label: t('amount'), value: <Amount millimes={millimes} size="title" /> },
              ]}
            />
          }
          onClose={() => setPaying(false)}
          onSubmit={async (pin) => {
            const { data, error: problem } = await getApi().POST('/v1/employee/payments', {
              params: { header: { 'Idempotency-Key': intentKey } },
              body: {
                merchantCode: merchant.merchantCode,
                creditType,
                amountMillimes: millimes,
                pin,
              },
            });
            if (data !== undefined) {
              setPaying(false);
              setMerchant(undefined);
              setAmountText('');
              wallet.reload();
              onPaid(data);
              return undefined;
            }
            return problem;
          }}
        />
      ) : null}
    </div>
  );
}
