'use client';

import type { Schemas } from '@flexipay/api-client';
import { AlarmClock, ArrowLeft, Inbox, Send, Siren, Timer } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useRef, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { useCan } from '@/lib/session/session-context';
import { LIST_PARAMS, useUrlFilters } from '@/lib/ui/use-url-filters';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SEARCH_DELAY_MS } from '@/components/ui/filter-bar';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import {
  ATTACHMENT_TYPES,
  MAX_ATTACHMENT_BYTES,
  RedactedNote,
  TICKET_CATEGORIES,
  TICKET_STATUSES,
  TICKET_TEAMS,
  TicketAttachments,
  TicketMessages,
  TicketStatusBadge,
  supportErrorKey,
  type TicketCategory,
  type TicketStatus,
  type TicketTeam,
} from './ticket-parts';

type Row = Schemas['AgentTicketSummary'];
const QUEUE_PARAMS = {
  ...LIST_PARAMS,
  category: 'categorie',
  priority: 'priorite',
  team: 'equipe',
  assignee: 'assignee',
  overdue: 'retard',
} as const;

/** Queue of the support tickets (W-SUP): counters, filters kept in the URL, server pages. */
export function SupportQueue() {
  const t = useTranslations('support');
  const locale = useLocale();
  const [filters, setFilters] = useUrlFilters(QUEUE_PARAMS);
  const [text, setText] = useState(filters.q);
  const stats = useApiQuery(() => getApi().GET('/v1/admin/support-tickets/stats'), []);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/support-tickets', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status as TicketStatus }),
            ...(filters.category === '' ? {} : { category: filters.category as TicketCategory }),
            ...(filters.priority === ''
              ? {}
              : { priority: filters.priority as Schemas['TicketPriority'] }),
            ...(filters.team === '' ? {} : { team: filters.team as TicketTeam }),
            ...(filters.assignee === '' ? {} : { assignee: filters.assignee }),
            ...(filters.overdue === 'true' ? { overdue: 'true' as const } : {}),
          },
        },
      }),
    [
      filters.q,
      filters.status,
      filters.category,
      filters.priority,
      filters.team,
      filters.assignee,
      filters.overdue,
    ],
  );
  // The text typed reaches the URL (and the list) 300 ms after the last key.
  useDebouncedQuery(text, filters.q, (q) => {
    setFilters({ q });
  });

  const columns: Column<Row>[] = [
    {
      key: 'reference',
      header: t('list.reference'),
      card: 'title',
      cell: (row) => (
        <Link
          href={`/admin/support/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'subject',
      header: t('list.subject'),
      cell: (row) => (
        <span className="flex flex-col">
          <bdi>{row.subject}</bdi>
          <span className="text-caption text-text-muted">{t(`category.${row.category}`)}</span>
        </span>
      ),
    },
    {
      key: 'client',
      header: t('queue.client'),
      cell: (row) => (
        <span className="flex flex-col">
          <bdi>{row.clientName ?? '—'}</bdi>
          <bdi className="text-caption text-text-muted">{row.requesterName}</bdi>
        </span>
      ),
    },
    {
      key: 'priority',
      header: t('queue.priority'),
      cell: (row) => (
        <span className={row.priority === 'HIGH' ? 'font-label text-danger-text' : undefined}>
          {t(`priority.${row.priority}`)}
          {row.overdue ? ` · ${t('queue.late')}` : ''}
        </span>
      ),
      sortValue: (row) => (row.priority === 'HIGH' ? 0 : 1),
    },
    { key: 'team', header: t('queue.team'), cell: (row) => t(`team.${row.team}`) },
    {
      key: 'assignee',
      header: t('queue.assignee'),
      cell: (row) => <bdi>{row.assignee?.name ?? t('queue.nobody')}</bdi>,
    },
    {
      key: 'created',
      header: t('queue.created'),
      cell: (row) => formatDateTime(row.createdAt, locale),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'status',
      header: t('queue.status'),
      cell: (row) => <TicketStatusBadge status={row.status} agent />,
    },
  ];

  const select = (
    key: keyof typeof QUEUE_PARAMS,
    label: string,
    placeholder: string,
    options: readonly { value: string; label: string }[],
  ) => (
    <SelectField
      label={label}
      placeholder={placeholder}
      options={options}
      value={filters[key]}
      onChange={(event) => {
        setFilters({ [key]: event.target.value });
      }}
    />
  );

  return (
    <>
      <PageHeader title={t('queue.title')} description={t('queue.description')} />
      <div className="mb-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label={t('queue.open')}
          value={stats.status === 'success' ? stats.data.open : '…'}
          icon={<Inbox aria-hidden="true" className="size-icon-md" />}
        />
        <StatCard
          label={t('queue.overdue')}
          value={stats.status === 'success' ? stats.data.overdue : '…'}
          tone={stats.status === 'success' && stats.data.overdue > 0 ? 'attention' : 'default'}
          icon={<AlarmClock aria-hidden="true" className="size-icon-md" />}
        />
        <StatCard
          label={t('queue.highPriority')}
          value={stats.status === 'success' ? stats.data.highPriority : '…'}
          icon={<Siren aria-hidden="true" className="size-icon-md" />}
        />
        <StatCard
          label={t('queue.averageFirstResponse')}
          value={
            stats.status !== 'success'
              ? '…'
              : stats.data.averageFirstResponseMinutes === null
                ? t('queue.noAverage')
                : t('queue.minutes', { value: stats.data.averageFirstResponseMinutes })
          }
          icon={<Timer aria-hidden="true" className="size-icon-md" />}
        />
      </div>
      <Card>
        <form
          role="search"
          onSubmit={(event) => {
            event.preventDefault();
            setFilters({ q: text });
          }}
          className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-4"
        >
          <TextField
            label={t('queue.search')}
            type="search"
            value={text}
            onChange={(event) => {
              setText(event.target.value);
            }}
          />
          {select(
            'status',
            t('queue.status'),
            t('queue.anyone'),
            TICKET_STATUSES.map((value) => ({ value, label: t(`agentStatus.${value}`) })),
          )}
          {select(
            'category',
            t('queue.category'),
            t('queue.allCategories'),
            TICKET_CATEGORIES.map((value) => ({ value, label: t(`category.${value}`) })),
          )}
          {select('priority', t('queue.priority'), t('queue.allPriorities'), [
            { value: 'HIGH', label: t('priority.HIGH') },
            { value: 'NORMAL', label: t('priority.NORMAL') },
          ])}
          {select(
            'team',
            t('queue.team'),
            t('queue.allTeams'),
            TICKET_TEAMS.map((value) => ({ value, label: t(`team.${value}`) })),
          )}
          {select('assignee', t('queue.assignee'), t('queue.anyone'), [
            { value: 'me', label: t('queue.me') },
            { value: 'none', label: t('queue.nobody') },
          ])}
          {select('overdue', t('queue.overdue'), t('queue.anyone'), [
            { value: 'true', label: t('queue.overdueOnly') },
          ])}
          <div>
            <Button
              variant="ghost"
              onClick={() => {
                setText('');
                setFilters({
                  q: '',
                  status: '',
                  category: '',
                  priority: '',
                  team: '',
                  assignee: '',
                  overdue: '',
                });
              }}
            >
              {t('queue.reset')}
            </Button>
          </div>
        </form>
        <DataTable
          caption={t('queue.title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('queue.empty') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}

/** Calls `apply` 300 ms after the last change of `text` (when it differs from `current`). */
function useDebouncedQuery(text: string, current: string, apply: (q: string) => void) {
  const latest = useRef(apply);
  useEffect(() => {
    latest.current = apply;
  }, [apply]);
  useEffect(() => {
    if (text.trim() === current) return;
    const timer = setTimeout(() => {
      latest.current(text.trim());
    }, SEARCH_DELAY_MS);
    return () => {
      clearTimeout(timer);
    };
  }, [text, current]);
}

/**
 * A ticket seen by FlexiPay: the conversation with the internal notes, the answer (or note), the
 * assignment, the transfer to Finance or Opérations, the status; the linked operation is read
 * only (Support never changes money).
 */
export function AgentTicketView({ ticketId }: { ticketId: string }) {
  const t = useTranslations('support');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const canManage = useCan('tickets.manage');
  const ticket = useApiQuery(
    () => getApi().GET('/v1/admin/support-tickets/{ticketId}', { params: { path: { ticketId } } }),
    [ticketId],
  );
  const team = ticket.status === 'success' ? ticket.data.team : undefined;
  const agents = useApiQuery(
    () =>
      team === undefined
        ? Promise.resolve({ data: { data: [] } })
        : getApi().GET('/v1/admin/support-tickets/agents', { params: { query: { team } } }),
    [team],
  );
  const [body, setBody] = useState('');
  const [internal, setInternal] = useState(false);
  const [waiting, setWaiting] = useState(false);
  const [file, setFile] = useState<File | undefined>(undefined);
  const [assignee, setAssignee] = useState('');
  const [transferTeam, setTransferTeam] = useState('');
  const [transferNote, setTransferNote] = useState('');
  const [status, setStatus] = useState('');
  const [busy, setBusy] = useState(false);

  if (ticket.status === 'loading') return <LoadingBlock lines={8} />;
  if (ticket.status === 'error') return <ErrorState error={ticket.error} onRetry={ticket.reload} />;
  const data = ticket.data;
  const closed = data.status === 'CLOSED';

  async function run(
    action: () => Promise<{ data?: unknown; error?: unknown }>,
    success: string,
  ): Promise<boolean> {
    setBusy(true);
    try {
      const { data: done, error } = await action();
      if (done !== undefined) toast.notify('success', success);
      else
        toast.notify(
          'error',
          tRoot(messageKey(supportErrorKey(asProblem(error)?.code, errorMessageKey(error)))),
        );
      ticket.reload();
      return done !== undefined;
    } finally {
      setBusy(false);
    }
  }

  async function send(event: SyntheticEvent) {
    event.preventDefault();
    if (body.trim() === '') return;
    if (file !== undefined && file.size > MAX_ATTACHMENT_BYTES) {
      toast.notify('error', t('form.fileTooLarge'));
      return;
    }
    const form = new FormData();
    form.set('body', body.trim());
    form.set('internal', String(internal));
    form.set('waitingCustomer', String(!internal && waiting));
    if (file !== undefined) form.set('attachment', file, file.name);
    const ok = await run(
      () =>
        getApi().POST('/v1/admin/support-tickets/{ticketId}/messages', {
          params: { path: { ticketId } },
          body: form as never,
          bodySerializer: (value: unknown) => value as FormData,
        }),
      t('agent.sent'),
    );
    if (ok) {
      setBody('');
      setFile(undefined);
      setWaiting(false);
    }
  }

  const linked = data.linked;
  return (
    <>
      <Link
        href="/admin/support"
        className="mb-4 inline-flex min-h-touch-target-min items-center gap-2 text-label text-navy underline-offset-2 hover:underline"
      >
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('agent.back')}
      </Link>
      <PageHeader
        title={data.subject}
        eyebrow={data.reference}
        description={`${t(`category.${data.category}`)} · ${t(`priority.${data.priority}`)}`}
        actions={<TicketStatusBadge status={data.status} agent />}
      />
      <div className="grid gap-6 lg:grid-cols-3">
        <div className="flex flex-col gap-6 lg:col-span-2">
          <Card>
            <CardTitle>{t('thread.description')}</CardTitle>
            <p className="whitespace-pre-line text-body text-text">{data.description}</p>
            {data.redacted ? <RedactedNote /> : null}
            <TicketAttachments ticketId={ticketId} attachments={data.attachments} agent />
          </Card>
          <Card>
            <CardTitle>{t('thread.conversation')}</CardTitle>
            <TicketMessages ticketId={ticketId} messages={data.messages} agent />
          </Card>
          {canManage && !closed ? (
            <Card>
              <form onSubmit={(event) => void send(event)} className="flex flex-col gap-4">
                <SelectField
                  label={t('agent.reply')}
                  options={[
                    { value: 'reply', label: t('agent.reply') },
                    { value: 'note', label: t('agent.note') },
                  ]}
                  value={internal ? 'note' : 'reply'}
                  onChange={(event) => {
                    setInternal(event.target.value === 'note');
                  }}
                />
                {internal ? <Alert tone="warning">{t('agent.internalHint')}</Alert> : null}
                <TextAreaField
                  label={internal ? t('agent.note') : t('agent.reply')}
                  value={body}
                  maxLength={4000}
                  rows={4}
                  onChange={(event) => {
                    setBody(event.target.value);
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
                {internal ? null : (
                  <label className="flex min-h-touch-target-min items-center gap-2 text-label text-text">
                    <input
                      type="checkbox"
                      className="size-icon-sm accent-emerald"
                      checked={waiting}
                      onChange={(event) => {
                        setWaiting(event.target.checked);
                      }}
                    />
                    {t('agent.waitingCustomer')}
                  </label>
                )}
                <div>
                  <Button
                    type="submit"
                    loading={busy}
                    disabled={body.trim() === ''}
                    icon={<Send aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />}
                  >
                    {t('agent.send')}
                  </Button>
                </div>
              </form>
            </Card>
          ) : null}
        </div>
        <div className="flex flex-col gap-6">
          <Card>
            <DescriptionList
              items={[
                { label: t('agent.client'), value: <bdi>{data.clientName ?? '—'}</bdi> },
                { label: t('agent.requester'), value: <bdi>{data.requesterName}</bdi> },
                { label: t('agent.team'), value: t(`team.${data.team}`) },
                {
                  label: t('agent.assignee'),
                  value: <bdi>{data.assignee?.name ?? t('agent.nobody')}</bdi>,
                },
              ]}
            />
            <p className="text-caption text-text-muted">
              {data.firstResponseAt === null
                ? t('agent.firstResponseDue', {
                    date: formatDateTime(data.firstResponseDueAt, locale),
                  })
                : t('agent.firstResponseAt', {
                    date: formatDateTime(data.firstResponseAt, locale),
                  })}
            </p>
          </Card>
          {linked === null ? null : (
            <Card>
              <CardTitle description={t('agent.readOnly')}>{t('agent.linked')}</CardTitle>
              <DescriptionList
                items={[
                  {
                    label: t(`linkType.${linked.type}`),
                    value: <bdi dir="ltr">{linked.reference}</bdi>,
                  },
                  { label: t('agent.amount'), value: <Amount millimes={linked.amountMillimes} /> },
                  { label: t('agent.counterparty'), value: <bdi>{linked.counterparty}</bdi> },
                  { label: t('agent.date'), value: formatDateTime(linked.occurredAt, locale) },
                  {
                    label: t('queue.status'),
                    value: tRoot(messageKey(`statusLabel.${linked.status}`)),
                  },
                ]}
              />
            </Card>
          )}
          {canManage && !closed ? (
            <Card>
              <form
                className="flex flex-col gap-3"
                onSubmit={(event) => {
                  event.preventDefault();
                  void run(
                    () =>
                      getApi().POST('/v1/admin/support-tickets/{ticketId}/assignment', {
                        params: { path: { ticketId } },
                        body: { assigneeId: assignee === '' ? null : assignee },
                      }),
                    t('agent.assigned'),
                  );
                }}
              >
                <SelectField
                  label={t('agent.assignTo')}
                  placeholder={t('agent.nobody')}
                  options={(agents.status === 'success' ? agents.data.data : []).map((agent) => ({
                    value: agent.id,
                    label: agent.displayName,
                  }))}
                  value={assignee}
                  onChange={(event) => {
                    setAssignee(event.target.value);
                  }}
                />
                <Button type="submit" variant="secondary" loading={busy}>
                  {t('agent.assign')}
                </Button>
              </form>
              <form
                className="mt-4 flex flex-col gap-3 border-t border-border pt-4"
                onSubmit={(event) => {
                  event.preventDefault();
                  if (transferTeam === '') return;
                  void run(
                    () =>
                      getApi().POST('/v1/admin/support-tickets/{ticketId}/transfer', {
                        params: { path: { ticketId } },
                        body: {
                          team: transferTeam as TicketTeam,
                          ...(transferNote.trim() === '' ? {} : { note: transferNote.trim() }),
                        },
                      }),
                    t('agent.transferred'),
                  ).then((ok) => {
                    if (ok) {
                      setTransferTeam('');
                      setTransferNote('');
                    }
                  });
                }}
              >
                <SelectField
                  label={t('agent.transferTo')}
                  placeholder={t('queue.allTeams')}
                  options={TICKET_TEAMS.filter((value) => value !== data.team).map((value) => ({
                    value,
                    label: t(`team.${value}`),
                  }))}
                  value={transferTeam}
                  onChange={(event) => {
                    setTransferTeam(event.target.value);
                  }}
                />
                <TextAreaField
                  label={t('agent.transferNote')}
                  rows={2}
                  maxLength={4000}
                  value={transferNote}
                  onChange={(event) => {
                    setTransferNote(event.target.value);
                  }}
                />
                <Button
                  type="submit"
                  variant="secondary"
                  loading={busy}
                  disabled={transferTeam === ''}
                >
                  {t('agent.transfer')}
                </Button>
              </form>
              <form
                className="mt-4 flex flex-col gap-3 border-t border-border pt-4"
                onSubmit={(event) => {
                  event.preventDefault();
                  if (status === '') return;
                  void run(
                    () =>
                      getApi().POST('/v1/admin/support-tickets/{ticketId}/status', {
                        params: { path: { ticketId } },
                        body: { status: status as Schemas['TicketStatusChange']['status'] },
                      }),
                    t('agent.statusChanged'),
                  ).then((ok) => {
                    if (ok) setStatus('');
                  });
                }}
              >
                <SelectField
                  label={t('agent.setStatus')}
                  placeholder={t(`agentStatus.${data.status}`)}
                  options={TICKET_STATUSES.filter(
                    (value) => value !== 'OPEN' && value !== data.status,
                  ).map((value) => ({ value, label: t(`agentStatus.${value}`) }))}
                  value={status}
                  onChange={(event) => {
                    setStatus(event.target.value);
                  }}
                />
                <Button type="submit" variant="secondary" loading={busy} disabled={status === ''}>
                  {t('agent.setStatus')}
                </Button>
              </form>
            </Card>
          ) : null}
        </div>
      </div>
    </>
  );
}
