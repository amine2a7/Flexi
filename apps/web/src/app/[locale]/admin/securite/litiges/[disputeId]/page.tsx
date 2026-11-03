'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useParams } from 'next/navigation';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { useCan } from '@/lib/session/session-context';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { TextAreaField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';

type Dispute = Schemas['DisputeDetail'];

/**
 * Admin › Sécurité › dossier de litige (admin-securite.md §5): Opérations instructs and decides,
 * Finance reads the file and gives the second validation in Validations.
 */
export default function DisputePage() {
  const { disputeId } = useParams<{ disputeId: string }>();
  const t = useTranslations('admin.security');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/disputes/{disputeId}', { params: { path: { disputeId } } }),
    [disputeId],
  );
  return (
    <>
      <Link href="/admin/securite" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />
        {t('back')}
      </Link>
      {query.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {query.status === 'error' ? <ErrorState error={query.error} onRetry={query.reload} /> : null}
      {query.status === 'success' ? (
        <DisputeView dispute={query.data} onChange={query.reload} />
      ) : null}
    </>
  );
}

function DisputeView({ dispute, onChange }: { dispute: Dispute; onChange: () => void }) {
  const t = useTranslations('admin.security');
  const tRoot = useTranslations();
  const locale = useLocale();
  const canManage = useCan('disputes.manage');
  const canApprove = useCan('approvals.decide');
  const [dialog, setDialog] = useState<'reject' | 'accept' | undefined>(undefined);
  const [note, setNote] = useState('');
  const [sending, setSending] = useState(false);
  const [noteError, setNoteError] = useState<string | undefined>(undefined);
  const open = dispute.status === 'OPEN';
  const active = open || dispute.status === 'ACCEPTANCE_PENDING';

  async function addNote(event: SyntheticEvent) {
    event.preventDefault();
    if (note.trim() === '') return;
    setSending(true);
    setNoteError(undefined);
    const { error } = await getApi().POST('/v1/admin/disputes/{disputeId}/notes', {
      params: { path: { disputeId: dispute.id } },
      body: { text: note },
    });
    setSending(false);
    if (error !== undefined) {
      setNoteError(tRoot(messageKey(errorMessageKey(error))));
      return;
    }
    setNote('');
    onChange();
  }

  async function decide(action: 'reject' | 'accept', reason: string) {
    const params = {
      path: { disputeId: dispute.id },
      header: { 'Idempotency-Key': newIdempotencyKey() },
    };
    const { error } =
      action === 'reject'
        ? await getApi().POST('/v1/admin/disputes/{disputeId}/reject', {
            params,
            body: { reason },
          })
        : await getApi().POST('/v1/admin/disputes/{disputeId}/accept', {
            params,
            body: { reason },
          });
    if (error === undefined) {
      setDialog(undefined);
      onChange();
    }
    return error;
  }

  return (
    <>
      <PageHeader
        title={t('disputeTitle', { reference: dispute.reference })}
        description={t('disputeDescription')}
      />
      <div className="flex flex-col gap-6">
        {dispute.status === 'ACCEPTANCE_PENDING' ? (
          <Alert tone="info" title={t('pendingTitle')}>
            {t('pendingText')}{' '}
            {canApprove ? (
              <Link href="/admin/validations" className="text-navy underline">
                {t('pendingLink')}
              </Link>
            ) : null}
          </Alert>
        ) : null}
        <Card>
          <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
            <Amount millimes={dispute.amountMillimes} size="amount" />
            <StatusBadge
              context="risk"
              status={dispute.status}
              labelKey={`admin.security.disputeStatuses.${dispute.status}`}
            />
          </div>
          <DescriptionList
            items={[
              { label: t('payment'), value: <span dir="ltr">{dispute.paymentReference}</span> },
              { label: t('merchant'), value: <bdi>{dispute.merchantName}</bdi> },
              { label: t('creditType'), value: <CreditTypeBadge type={dispute.creditType} /> },
              { label: t('reason'), value: dispute.reason },
              { label: t('openedBy'), value: <bdi>{dispute.openedByName}</bdi> },
              { label: t('openedAt'), value: formatDateTime(dispute.openedAt, locale) },
              { label: t('dueAt'), value: formatDateTime(dispute.dueAt, locale) },
              ...(dispute.decisionReason === null
                ? []
                : [{ label: t('decisionReason'), value: dispute.decisionReason }]),
              ...(dispute.decidedAt === null
                ? []
                : [{ label: t('decidedAt'), value: formatDateTime(dispute.decidedAt, locale) }]),
            ]}
          />
          {canManage && open ? (
            <div className="mt-6 flex flex-wrap gap-3">
              <Button
                onClick={() => {
                  setDialog('accept');
                }}
              >
                {t('accept')}
              </Button>
              <Button
                variant="secondary"
                onClick={() => {
                  setDialog('reject');
                }}
              >
                {t('reject')}
              </Button>
            </div>
          ) : null}
        </Card>
        <Card>
          <CardTitle>{t('notes')}</CardTitle>
          {dispute.notes.length === 0 ? (
            <p className="text-body text-text-muted">{t('notesEmpty')}</p>
          ) : (
            <Timeline
              entries={dispute.notes.map((item) => ({
                key: item.id,
                title: item.authorName,
                meta: formatDateTime(item.createdAt, locale),
                detail: item.text,
              }))}
            />
          )}
          {canManage && active ? (
            <form onSubmit={(event) => void addNote(event)} className="mt-6 flex flex-col gap-3">
              <TextAreaField
                label={t('noteLabel')}
                name="note"
                maxLength={2000}
                rows={3}
                error={noteError}
                value={note}
                onChange={(event) => {
                  setNote(event.target.value);
                }}
              />
              <div>
                <Button type="submit" variant="secondary" loading={sending}>
                  {t('noteAdd')}
                </Button>
              </div>
            </form>
          ) : null}
        </Card>
      </div>
      {dialog !== undefined ? (
        <ReasonDialog
          open
          onOpenChange={(value) => {
            if (!value) setDialog(undefined);
          }}
          title={t(`${dialog}Title`, { reference: dispute.reference })}
          summary={[
            { label: t('merchant'), value: <bdi>{dispute.merchantName}</bdi> },
            { label: t('amount'), value: <Amount millimes={dispute.amountMillimes} /> },
          ]}
          effects={[t(`${dialog}Effect`)]}
          confirmLabel={t(dialog)}
          confirmVariant={dialog === 'reject' ? 'secondary' : 'primary'}
          onConfirm={(reason) => decide(dialog, reason)}
        />
      ) : null}
    </>
  );
}
