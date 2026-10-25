'use client';

import { ArrowLeft, CheckCheck, Mail } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { ContactStatusBadge } from '@/components/admin/contact-status-badge';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextAreaField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

const NOTE_MAX = 500;

/** One contact message: sender, text, and "mark as handled" with an optional internal note. */
export default function ContactMessagePage() {
  const { messageId } = useParams<{ messageId: string }>();
  const t = useTranslations('adminMessages');
  const tContact = useTranslations('contact');
  const tRoot = useTranslations();
  const canHandle = useCan('messages.handle');
  const locale = useLocale();
  const toast = useToast();
  const message = useApiQuery(
    () =>
      getApi().GET('/v1/admin/contact-messages/{messageId}', {
        params: { path: { messageId } },
      }),
    [messageId],
  );
  const [confirming, setConfirming] = useState(false);
  const [note, setNote] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  async function handle() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/contact-messages/{messageId}/handle',
        {
          params: { path: { messageId } },
          body: note.trim() === '' ? {} : { note: note.trim() },
        },
      );
      if (data === undefined) {
        setError(problem);
        return;
      }
      setConfirming(false);
      toast.notify('success', t('handled'));
      message.reload();
    } finally {
      setSaving(false);
    }
  }

  return (
    <>
      <Link href="/admin/messages" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {message.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {message.status === 'error' ? (
        <ErrorState error={message.error} onRetry={message.reload} />
      ) : null}
      {message.status === 'success' ? (
        <>
          <PageHeader
            title={t('detailTitle', { reference: message.data.reference })}
            description={formatDateTime(message.data.receivedAt, locale)}
            actions={<ContactStatusBadge status={message.data.status} />}
          />
          <div className="grid gap-6 lg:grid-cols-3">
            <Card className="lg:col-span-2">
              <CardTitle>{t('message')}</CardTitle>
              <p className="whitespace-pre-line text-body text-text">{message.data.message}</p>
              {message.data.status === 'HANDLED' ? (
                <div className="mt-6 flex flex-col gap-3">
                  <Alert tone="success">
                    {t('handledBy', {
                      name: message.data.handledBy ?? '',
                      date:
                        message.data.handledAt === null
                          ? ''
                          : formatDateTime(message.data.handledAt, locale),
                    })}
                  </Alert>
                  {message.data.note !== null ? (
                    <DescriptionList items={[{ label: t('note'), value: message.data.note }]} />
                  ) : null}
                </div>
              ) : !canHandle ? null : (
                <div className="mt-6 flex flex-wrap gap-3">
                  <a
                    href={`mailto:${message.data.email}?subject=${encodeURIComponent(message.data.reference)}`}
                    className={buttonClasses('secondary')}
                  >
                    <Mail aria-hidden="true" className="size-icon-md" />
                    {t('reply')}
                  </a>
                  <Button
                    icon={<CheckCheck aria-hidden="true" className="size-icon-md" />}
                    onClick={() => {
                      setConfirming(true);
                    }}
                  >
                    {t('handle')}
                  </Button>
                </div>
              )}
            </Card>
            <Card>
              <CardTitle>{t('sender')}</CardTitle>
              <DescriptionList
                items={[
                  { label: t('name'), value: message.data.name },
                  { label: t('type'), value: tContact(`types.${message.data.requesterType}`) },
                  { label: t('company'), value: message.data.companyName ?? t('none') },
                  { label: t('email'), value: <span dir="ltr">{message.data.email}</span> },
                  {
                    label: t('phone'),
                    value:
                      message.data.phone === null ? (
                        t('none')
                      ) : (
                        <span dir="ltr">{message.data.phone}</span>
                      ),
                  },
                  { label: t('reference'), value: <span dir="ltr">{message.data.reference}</span> },
                ]}
              />
            </Card>
          </div>
          <ConfirmDialog
            open={confirming}
            onOpenChange={setConfirming}
            title={t('handleTitle')}
            description={t('handleText')}
            confirmLabel={t('handle')}
            loading={saving}
            onConfirm={() => void handle()}
          >
            <div className="flex flex-col gap-4">
              {error !== undefined ? (
                <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
              ) : null}
              <TextAreaField
                label={t('note')}
                hint={t('noteHint')}
                rows={3}
                maxLength={NOTE_MAX}
                value={note}
                error={note.length > NOTE_MAX ? t('noteTooLong') : undefined}
                onChange={(event) => {
                  setNote(event.target.value);
                }}
              />
            </div>
          </ConfirmDialog>
        </>
      ) : null}
    </>
  );
}
