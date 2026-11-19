'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Plus, RotateCcw, Send } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useSearchParams } from 'next/navigation';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link, useRouter } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { useSession } from '@/lib/session/session-context';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import {
  ATTACHMENT_TYPES,
  MAX_ATTACHMENT_BYTES,
  RedactedNote,
  TICKET_CATEGORIES,
  TICKET_STATUSES,
  TicketAttachments,
  TicketMessages,
  TicketStatusBadge,
  supportErrorKey,
  type TicketCategory,
  type TicketStatus,
} from './ticket-parts';

type Ticket = Schemas['SupportTicketSummary'];
type LinkType = Schemas['TicketLinkType'];

/**
 * « Mes demandes » (W-SUP), every user of a company or a shop: its own tickets, those of the
 * whole account for the owner; instant search and status kept in the URL.
 */
export function ClientTicketList({ base }: { base: string }) {
  const t = useTranslations('support');
  const locale = useLocale();
  const { me } = useSession();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/support/tickets', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status as TicketStatus }),
          },
        },
      }),
    [filters],
  );
  const filtered = filters.q !== '' || filters.status !== '';
  const columns: Column<Ticket>[] = [
    {
      key: 'reference',
      header: t('list.reference'),
      card: 'title',
      cell: (row) => (
        <Link
          href={`${base}/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    { key: 'subject', header: t('list.subject'), cell: (row) => <bdi>{row.subject}</bdi> },
    {
      key: 'category',
      header: t('list.category'),
      cell: (row) => t(`category.${row.category}`),
    },
    ...(me.subRole === 'OWNER'
      ? [
          {
            key: 'requester',
            header: t('list.requester'),
            cell: (row: Ticket) => <bdi>{row.requesterName}</bdi>,
          },
        ]
      : []),
    {
      key: 'updated',
      header: t('list.updated'),
      cell: (row) => formatDateTime(row.updatedAt, locale),
      sortValue: (row) => row.updatedAt,
    },
    {
      key: 'status',
      header: t('list.status'),
      cell: (row) => <TicketStatusBadge status={row.status} />,
    },
  ];
  return (
    <Card>
      <CardTitle
        description={me.subRole === 'OWNER' ? t('list.ownerDescription') : t('list.description')}
      >
        {t('list.title')}
      </CardTitle>
      <FilterBar
        searchLabel={t('list.search')}
        statusLabel={t('list.status')}
        statusOptions={TICKET_STATUSES.map((value) => ({
          value,
          label: t(`status.${value}`),
        }))}
        onApply={setFilters}
      />
      <DataTable
        caption={t('list.title')}
        columns={columns}
        rows={list.rows}
        rowKey={(row) => row.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.reload}
        empty={{
          title: filtered ? t('list.emptyFiltered') : t('list.empty'),
          action: filtered ? undefined : (
            <Link href={`${base}/nouvelle`} className={buttonClasses('primary')}>
              {t('list.new')}
            </Link>
          ),
        }}
        page={list.page}
        pageNumber={list.pageNumber}
        onNext={list.next}
        onPrevious={list.previous}
      />
    </Card>
  );
}

export function NewTicketLink({ base }: { base: string }) {
  const t = useTranslations('support.list');
  return (
    <Link href={`${base}/nouvelle`} className={buttonClasses('primary')}>
      <Plus aria-hidden="true" className="size-icon-sm" />
      {t('new')}
    </Link>
  );
}

const LINK_TYPES: readonly LinkType[] = ['PAYMENT', 'ORDER', 'PAYOUT'];
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * New ticket (W-SUP): category, subject, description, optional piece; an operation can be linked
 * from its page (`?lien=PAYMENT&id=…&ref=…`). A PIN, a password or a card number is masked by
 * the server before saving; the form says so before sending.
 */
export function NewTicketForm({ base }: { base: string }) {
  const t = useTranslations('support');
  const tRoot = useTranslations();
  const router = useRouter();
  const toast = useToast();
  const params = useSearchParams();
  const linkType = LINK_TYPES.find((type) => type === params.get('lien'));
  const linkId = params.get('id') ?? '';
  const linkReference = params.get('ref')?.slice(0, 32) ?? '';
  const linked = linkType !== undefined && UUID.test(linkId);
  const [category, setCategory] = useState<TicketCategory | ''>(
    linked && linkType === 'PAYMENT' ? 'PAYMENT_DECLINED' : '',
  );
  const [subject, setSubject] = useState('');
  const [body, setBody] = useState('');
  const [file, setFile] = useState<File | undefined>(undefined);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [sending, setSending] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const found: Record<string, string> = {};
    if (category === '') found.category = t('form.categoryRequired');
    if (subject.trim().length < 3) found.subject = t('form.subjectHint');
    if (body.trim().length < 10) found.body = t('form.bodyTooShort');
    if (file !== undefined && file.size > MAX_ATTACHMENT_BYTES) found.file = t('form.fileTooLarge');
    setErrors(found);
    if (Object.keys(found).length > 0 || category === '') return;
    setSending(true);
    try {
      const form = new FormData();
      form.set('category', category);
      form.set('subject', subject.trim());
      form.set('description', body.trim());
      if (linked) {
        form.set('linkType', linkType);
        form.set('linkId', linkId);
      }
      if (file !== undefined) form.set('attachment', file, file.name);
      const { data, error } = await getApi().POST('/v1/support/tickets', {
        // Multipart body (contract): the browser sets the boundary.
        body: form as never,
        bodySerializer: (value: unknown) => value as FormData,
      });
      if (data !== undefined) {
        toast.notify('success', t('form.sent', { reference: data.reference }));
        router.push(`${base}/${data.id}`);
        return;
      }
      const code = asProblem(error)?.code;
      toast.notify('error', tRoot(messageKey(supportErrorKey(code, errorMessageKey(error)))));
    } finally {
      setSending(false);
    }
  }

  return (
    <>
      <PageHeader title={t('form.title')} description={t('form.description')} />
      <Card className="max-w-form-max-width">
        <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
          {linked ? (
            <Alert tone="info">
              {t('form.linked', { type: t(`linkType.${linkType}`), reference: linkReference })}
            </Alert>
          ) : null}
          <SelectField
            label={t('form.category')}
            placeholder={t('form.chooseCategory')}
            options={TICKET_CATEGORIES.map((value) => ({
              value,
              label: t(`category.${value}`),
            }))}
            value={category}
            required
            {...(errors.category === undefined ? {} : { error: errors.category })}
            onChange={(event) => {
              setCategory(event.target.value as TicketCategory | '');
            }}
          />
          <TextField
            label={t('form.subject')}
            hint={t('form.subjectHint')}
            value={subject}
            maxLength={160}
            required
            {...(errors.subject === undefined ? {} : { error: errors.subject })}
            onChange={(event) => {
              setSubject(event.target.value);
            }}
          />
          <TextAreaField
            label={t('form.body')}
            hint={t('form.bodyHint')}
            value={body}
            maxLength={4000}
            required
            {...(errors.body === undefined ? {} : { error: errors.body })}
            onChange={(event) => {
              setBody(event.target.value);
            }}
          />
          <TextField
            label={t('form.attachment')}
            hint={t('form.attachmentHint')}
            type="file"
            accept={ATTACHMENT_TYPES}
            {...(errors.file === undefined ? {} : { error: errors.file })}
            onChange={(event) => {
              setFile(event.target.files?.[0]);
            }}
          />
          <div className="flex flex-wrap gap-3">
            <Button
              type="submit"
              loading={sending}
              icon={<Send aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />}
            >
              {t('form.submit')}
            </Button>
            <Link href={base} className={buttonClasses('ghost')}>
              {t('form.cancel')}
            </Link>
          </div>
        </form>
      </Card>
    </>
  );
}

/** A ticket seen by its client: the conversation, the answer box, reopening when resolved. */
export function ClientTicketThread({ base, ticketId }: { base: string; ticketId: string }) {
  const t = useTranslations('support');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const ticket = useApiQuery(
    () => getApi().GET('/v1/support/tickets/{ticketId}', { params: { path: { ticketId } } }),
    [ticketId],
  );
  const [reply, setReply] = useState('');
  const [file, setFile] = useState<File | undefined>(undefined);
  const [busy, setBusy] = useState(false);

  if (ticket.status === 'loading') return <LoadingBlock lines={6} />;
  if (ticket.status === 'error') return <ErrorState error={ticket.error} onRetry={ticket.reload} />;
  const data = ticket.data;

  async function send(event: SyntheticEvent) {
    event.preventDefault();
    if (reply.trim() === '') return;
    if (file !== undefined && file.size > MAX_ATTACHMENT_BYTES) {
      toast.notify('error', t('form.fileTooLarge'));
      return;
    }
    setBusy(true);
    try {
      const form = new FormData();
      form.set('body', reply.trim());
      if (file !== undefined) form.set('attachment', file, file.name);
      const { data: sent, error } = await getApi().POST('/v1/support/tickets/{ticketId}/messages', {
        params: { path: { ticketId } },
        body: form as never,
        bodySerializer: (value: unknown) => value as FormData,
      });
      if (sent !== undefined) {
        setReply('');
        setFile(undefined);
        toast.notify('success', t('thread.sent'));
      } else {
        toast.notify(
          'error',
          tRoot(messageKey(supportErrorKey(asProblem(error)?.code, errorMessageKey(error)))),
        );
      }
      ticket.reload();
    } finally {
      setBusy(false);
    }
  }

  async function reopen() {
    setBusy(true);
    try {
      const { data: reopened, error } = await getApi().POST(
        '/v1/support/tickets/{ticketId}/reopen',
        { params: { path: { ticketId } } },
      );
      if (reopened !== undefined) toast.notify('success', t('thread.reopened'));
      else
        toast.notify(
          'error',
          tRoot(messageKey(supportErrorKey(asProblem(error)?.code, errorMessageKey(error)))),
        );
      ticket.reload();
    } finally {
      setBusy(false);
    }
  }

  return (
    <>
      <Link
        href={base}
        className="mb-4 inline-flex min-h-touch-target-min items-center gap-2 text-label text-navy underline-offset-2 hover:underline"
      >
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('thread.back')}
      </Link>
      <PageHeader
        title={data.subject}
        eyebrow={data.reference}
        description={t('thread.opened', {
          date: formatDateTime(data.createdAt, locale),
          name: data.requesterName,
        })}
        actions={<TicketStatusBadge status={data.status} />}
      />
      <div className="grid gap-6 lg:grid-cols-3">
        <div className="flex flex-col gap-6 lg:col-span-2">
          <Card>
            <CardTitle>{t('thread.description')}</CardTitle>
            <p className="whitespace-pre-line text-body text-text">{data.description}</p>
            {data.redacted ? <RedactedNote /> : null}
            <TicketAttachments ticketId={ticketId} attachments={data.attachments} agent={false} />
          </Card>
          <Card>
            <CardTitle>{t('thread.conversation')}</CardTitle>
            <TicketMessages ticketId={ticketId} messages={data.messages} agent={false} />
          </Card>
          {data.canReply ? (
            <Card>
              <form onSubmit={(event) => void send(event)} className="flex flex-col gap-4">
                <TextAreaField
                  label={t('thread.reply')}
                  hint={t('form.bodyHint')}
                  value={reply}
                  maxLength={4000}
                  rows={4}
                  onChange={(event) => {
                    setReply(event.target.value);
                  }}
                />
                <TextField
                  label={t('form.attachment')}
                  hint={t('form.attachmentHint')}
                  type="file"
                  accept={ATTACHMENT_TYPES}
                  onChange={(event) => {
                    setFile(event.target.files?.[0]);
                  }}
                />
                <div>
                  <Button
                    type="submit"
                    loading={busy}
                    disabled={reply.trim() === ''}
                    icon={<Send aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />}
                  >
                    {t('thread.send')}
                  </Button>
                </div>
              </form>
            </Card>
          ) : (
            <Alert tone="info">{t('thread.closedHint')}</Alert>
          )}
        </div>
        <div className="flex flex-col gap-6">
          {data.link === null ? null : (
            <Card>
              <CardTitle>{t('thread.linked')}</CardTitle>
              <p className="text-body text-text">
                {t(`linkType.${data.link.type}`)} <bdi dir="ltr">{data.link.reference}</bdi>
              </p>
            </Card>
          )}
          {data.canReopen ? (
            <Card>
              <p className="text-body text-text-muted">{t('thread.resolvedHint')}</p>
              <Button
                variant="secondary"
                loading={busy}
                icon={<RotateCcw aria-hidden="true" className="size-icon-sm" />}
                onClick={() => void reopen()}
              >
                {t('thread.reopen')}
              </Button>
            </Card>
          ) : null}
          <Card>
            <p className="text-caption text-text-muted">{t(`category.${data.category}`)}</p>
          </Card>
        </div>
      </div>
    </>
  );
}
