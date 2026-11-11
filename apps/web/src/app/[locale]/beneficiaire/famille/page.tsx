'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeftRight, Undo2, UserPlus, UserX } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { CredentialsDialog, type Credentials } from '@/components/admin/credentials-dialog';
import { Amount } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge, CreditTypeSelect, type CreditType } from '@/components/ui/credit-type';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';

type Member = Schemas['FamilyMember'];
type Relationship = Schemas['FamilyRelationship'];
const RELATIONSHIPS: Relationship[] = ['SPOUSE', 'CHILD', 'PARENT'];

/**
 * « Ma famille » (processus v2): up to 5 accounts for relatives; the beneficiary transfers part
 * of a credit type to them (same type, no fee, optional daily cap and end date) and takes it back
 * at any time. A member only sees its own balance, never the beneficiary's.
 */
export default function FamilyPage() {
  const t = useTranslations('beneficiary.family');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [refresh, setRefresh] = useState(0);
  const [adding, setAdding] = useState(false);
  const [transferTo, setTransferTo] = useState<Member | undefined>(undefined);
  const [reclaiming, setReclaiming] = useState<Member | undefined>(undefined);
  const [deleting, setDeleting] = useState<Member | undefined>(undefined);
  const [credentials, setCredentials] = useState<Credentials | undefined>(undefined);
  const [busy, setBusy] = useState(false);
  const family = useApiQuery(() => getApi().GET('/v1/employee/family'), [refresh]);
  const reload = () => {
    setRefresh((value) => value + 1);
  };

  async function reclaim(member: Member) {
    setBusy(true);
    try {
      const { data, error } = await getApi().POST(
        '/v1/employee/family/members/{memberId}/reclaim',
        {
          params: {
            header: { 'Idempotency-Key': newIdempotencyKey() },
            path: { memberId: member.id },
          },
          body: { creditType: null },
        },
      );
      if (data === undefined) toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
      else {
        toast.notify(
          'success',
          t('reclaimed', {
            amount: formatMillimesWithCurrency(data.reclaimedMillimes, locale),
            name: member.firstName,
          }),
        );
        reload();
      }
    } finally {
      setBusy(false);
      setReclaiming(undefined);
    }
  }

  async function remove(member: Member) {
    setBusy(true);
    try {
      const { data, error } = await getApi().DELETE('/v1/employee/family/members/{memberId}', {
        params: {
          header: { 'Idempotency-Key': newIdempotencyKey() },
          path: { memberId: member.id },
        },
      });
      if (data === undefined) toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
      else {
        toast.notify('success', t('deleted', { name: member.firstName }));
        reload();
      }
    } finally {
      setBusy(false);
      setDeleting(undefined);
    }
  }

  if (family.status === 'loading') return <LoadingBlock lines={6} />;
  if (family.status === 'error') return <ErrorState error={family.error} onRetry={family.reload} />;
  const { data: members, maxMembers, enabled } = family.data;
  const full = members.length >= maxMembers;

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description', { max: maxMembers })}
        actions={
          <Button
            disabled={!enabled || full}
            icon={<UserPlus aria-hidden="true" className="size-icon-sm" />}
            onClick={() => {
              setAdding(true);
            }}
          >
            {t('add')}
          </Button>
        }
      />
      <div className="mb-6 flex flex-col gap-3">
        {!enabled ? <Alert tone="warning">{t('disabled')}</Alert> : null}
        {enabled && full ? <Alert tone="info">{t('full', { max: maxMembers })}</Alert> : null}
      </div>
      {members.length === 0 ? (
        <Card>
          <p className="text-body text-text-muted">{t('empty')}</p>
        </Card>
      ) : (
        <div className="grid gap-4 md:grid-cols-2">
          {members.map((member) => (
            <Card key={member.id}>
              <CardTitle description={t(`relationship.${member.relationship}`)}>
                {member.firstName} {member.lastName}
              </CardTitle>
              <p className="mb-3 text-caption text-text-muted">
                {t('login')}{' '}
                <code dir="ltr" className="font-label">
                  {member.login ?? '—'}
                </code>
              </p>
              <ul className="mb-4 flex flex-col gap-2">
                {member.balances
                  .filter((line) => line.amountMillimes > 0 || line.dailyLimitMillimes !== null)
                  .map((line) => (
                    <li key={line.creditType} className="flex flex-col gap-1">
                      <span className="flex items-center justify-between gap-2">
                        <CreditTypeBadge type={line.creditType} />
                        <Amount millimes={line.amountMillimes} />
                      </span>
                      <span className="text-caption text-text-muted">
                        {line.dailyLimitMillimes === null
                          ? t('noCap')
                          : t('cap', {
                              amount: formatMillimesWithCurrency(line.dailyLimitMillimes, locale),
                            })}
                        {line.endsOn === null ? '' : ` · ${t('until', { date: line.endsOn })}`}
                      </span>
                    </li>
                  ))}
                {member.balances.every((line) => line.amountMillimes === 0) ? (
                  <li className="text-caption text-text-muted">{t('noCredit')}</li>
                ) : null}
              </ul>
              <div className="flex flex-wrap gap-2">
                <Button
                  size="sm"
                  disabled={!enabled}
                  icon={<ArrowLeftRight aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setTransferTo(member);
                  }}
                >
                  {t('transfer')}
                </Button>
                <Button
                  size="sm"
                  variant="secondary"
                  icon={<Undo2 aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setReclaiming(member);
                  }}
                >
                  {t('reclaim')}
                </Button>
                <Button
                  size="sm"
                  variant="ghost"
                  icon={<UserX aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setDeleting(member);
                  }}
                >
                  {t('delete')}
                </Button>
              </div>
            </Card>
          ))}
        </div>
      )}
      {adding ? (
        <AddMember
          onClose={() => {
            setAdding(false);
          }}
          onCreated={(created) => {
            setAdding(false);
            setCredentials(created);
            reload();
          }}
        />
      ) : null}
      {transferTo !== undefined ? (
        <TransferDialog
          member={transferTo}
          onClose={() => {
            setTransferTo(undefined);
          }}
          onDone={() => {
            setTransferTo(undefined);
            reload();
          }}
        />
      ) : null}
      {reclaiming !== undefined ? (
        <ConfirmDialog
          open
          onOpenChange={(open) => {
            if (!open) setReclaiming(undefined);
          }}
          title={t('reclaimTitle')}
          description={t('reclaimMessage', { name: reclaiming.firstName })}
          confirmLabel={t('reclaim')}
          loading={busy}
          onConfirm={() => void reclaim(reclaiming)}
        />
      ) : null}
      {deleting !== undefined ? (
        <ConfirmDialog
          open
          onOpenChange={(open) => {
            if (!open) setDeleting(undefined);
          }}
          title={t('deleteTitle')}
          description={t('deleteMessage', { name: deleting.firstName })}
          confirmLabel={t('delete')}
          confirmVariant="danger"
          loading={busy}
          onConfirm={() => void remove(deleting)}
        />
      ) : null}
      <CredentialsDialog
        credentials={credentials}
        notice={t('credentialsNotice')}
        onClose={() => {
          setCredentials(undefined);
        }}
      />
    </>
  );
}

function AddMember({
  onClose,
  onCreated,
}: {
  onClose: () => void;
  onCreated: (credentials: Credentials) => void;
}) {
  const t = useTranslations('beneficiary.family');
  const tRoot = useTranslations();
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [relationship, setRelationship] = useState<Relationship>('CHILD');
  const [phone, setPhone] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const reason = (asProblem(error)?.details as { reason?: string } | undefined)?.reason;

  async function save() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/employee/family/members', {
        body: { firstName: firstName.trim(), lastName: lastName.trim(), relationship, phone },
      });
      if (data === undefined) setError(problem);
      else onCreated(data.credentials);
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
      title={t('addTitle')}
      description={t('addHint')}
      footer={
        <>
          <Button variant="secondary" onClick={onClose} disabled={saving}>
            {t('cancel')}
          </Button>
          <Button
            loading={saving}
            disabled={firstName.trim() === '' || lastName.trim() === '' || phone.trim() === ''}
            onClick={() => void save()}
          >
            {t('add')}
          </Button>
        </>
      }
    >
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">
            {reason === 'FAMILY_LIMIT_REACHED'
              ? t('limitReached')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <TextField
          label={t('firstName')}
          maxLength={60}
          value={firstName}
          onChange={(event) => {
            setFirstName(event.target.value);
          }}
        />
        <TextField
          label={t('lastName')}
          maxLength={60}
          value={lastName}
          onChange={(event) => {
            setLastName(event.target.value);
          }}
        />
        <SelectField
          label={t('relationshipLabel')}
          options={RELATIONSHIPS.map((value) => ({
            value,
            label: t(`relationship.${value}`),
          }))}
          value={relationship}
          onChange={(event) => {
            setRelationship(event.target.value as Relationship);
          }}
        />
        <TextField
          label={t('phone')}
          hint={t('phoneHint')}
          inputMode="tel"
          dir="ltr"
          maxLength={16}
          value={phone}
          onChange={(event) => {
            setPhone(event.target.value);
          }}
        />
      </div>
    </Modal>
  );
}

function TransferDialog({
  member,
  onClose,
  onDone,
}: {
  member: Member;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('beneficiary.family');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [creditType, setCreditType] = useState<CreditType>('RESTAURATION');
  const [amount, setAmount] = useState('');
  const [cap, setCap] = useState('');
  const [endsOn, setEndsOn] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [intentKey] = useState(newIdempotencyKey);
  const millimes = parseMillimes(amount, locale);
  const capMillimes = cap.trim() === '' ? null : parseMillimes(cap, locale);
  const missing = (asProblem(error)?.details as { missingMillimes?: number } | undefined)
    ?.missingMillimes;

  async function send() {
    if (millimes === undefined || capMillimes === undefined) return;
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/employee/family/transfers', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: {
          memberId: member.id,
          creditType,
          amountMillimes: millimes,
          dailyLimitMillimes: capMillimes,
          endsOn: endsOn === '' ? null : endsOn,
        },
      });
      if (data === undefined) setError(problem);
      else {
        toast.notify(
          'success',
          t('transferred', {
            amount: formatMillimesWithCurrency(data.amountMillimes, locale),
            name: member.firstName,
          }),
        );
        onDone();
      }
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
      title={t('transferTitle', { name: member.firstName })}
      description={t('transferHint')}
      footer={
        <>
          <Button variant="secondary" onClick={onClose} disabled={saving}>
            {t('cancel')}
          </Button>
          <Button
            loading={saving}
            disabled={millimes === undefined || millimes === 0 || capMillimes === undefined}
            onClick={() => void send()}
          >
            {t('transfer')}
          </Button>
        </>
      }
    >
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">
            {missing !== undefined
              ? t('insufficient', { amount: formatMillimesWithCurrency(missing, locale) })
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <CreditTypeSelect
          label={t('type')}
          hint={t('typeHint')}
          value={creditType}
          onChange={(value) => {
            if (value !== '') setCreditType(value);
          }}
        />
        <AmountField
          label={t('amount')}
          value={amount}
          onChange={(value) => {
            setAmount(value);
          }}
        />
        <AmountField
          label={t('capLabel')}
          value={cap}
          onChange={(value) => {
            setCap(value);
          }}
        />
        <TextField
          label={t('endsOn')}
          hint={t('endsOnHint')}
          type="date"
          dir="ltr"
          value={endsOn}
          onChange={(event) => {
            setEndsOn(event.target.value);
          }}
        />
      </div>
    </Modal>
  );
}
