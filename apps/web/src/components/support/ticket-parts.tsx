'use client';

import type { Schemas } from '@flexipay/api-client';
import { Paperclip, ShieldAlert } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { cn } from '@/lib/cn';
import { formatDateTime } from '@/lib/format/date';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { StatusBadge } from '@/components/ui/status-badge';

export type TicketStatus = Schemas['TicketStatus'];
export type TicketCategory = Schemas['TicketCategory'];
export type TicketTeam = Schemas['TicketTeam'];

export const TICKET_STATUSES: readonly TicketStatus[] = [
  'OPEN',
  'IN_PROGRESS',
  'WAITING_CUSTOMER',
  'RESOLVED',
  'CLOSED',
];
export const TICKET_CATEGORIES: readonly TicketCategory[] = [
  'PAYMENT_DECLINED',
  'DISPUTED_TRANSACTION',
  'ACCOUNT_ACCESS',
  'ORDER_TRANSFER',
  'PAYOUT',
  'KYC',
  'OTHER',
];
export const TICKET_TEAMS: readonly TicketTeam[] = ['SUPPORT', 'FINANCE', 'OPERATIONS'];

/** PDF, JPG or PNG, 5 MB (checked again by the server from the bytes). */
export const MAX_ATTACHMENT_BYTES = 5 * 1024 * 1024;
export const ATTACHMENT_TYPES = 'application/pdf,image/jpeg,image/png';

/** Status of a ticket: the client reads « En attente de votre réponse », an agent « client ». */
export function TicketStatusBadge({
  status,
  agent = false,
}: {
  status: TicketStatus;
  agent?: boolean;
}) {
  return (
    <StatusBadge
      status={status}
      context="ticket"
      labelKey={`support.${agent ? 'agentStatus' : 'status'}.${status}`}
    />
  );
}

type Attachment = Schemas['TicketAttachment'];

/** Pieces of a ticket, each fetched through its signed link (5 minutes, this user). */
export function TicketAttachments({
  ticketId,
  attachments,
  agent,
}: {
  ticketId: string;
  attachments: readonly Attachment[];
  agent: boolean;
}) {
  const t = useTranslations('support.thread');
  if (attachments.length === 0) return null;
  return (
    <ul className="flex flex-wrap gap-2" aria-label={t('attachments')}>
      {attachments.map((piece) => (
        <li key={piece.id} className="flex items-center gap-2">
          <Paperclip aria-hidden="true" className="size-icon-sm text-text-muted" />
          <PdfDownloadButton
            label={t('download', { name: piece.fileName })}
            fileName={piece.fileName}
            load={async () => {
              const path = { ticketId, attachmentId: piece.id };
              const link = agent
                ? await getApi().GET(
                    '/v1/admin/support-tickets/{ticketId}/attachments/{attachmentId}/link',
                    { params: { path } },
                  )
                : await getApi().GET(
                    '/v1/support/tickets/{ticketId}/attachments/{attachmentId}/link',
                    { params: { path } },
                  );
              if (link.data === undefined) return { error: link.error };
              const query = { expires: link.data.expires, signature: link.data.signature };
              return agent
                ? getApi().GET('/v1/admin/support-tickets/{ticketId}/attachments/{attachmentId}', {
                    params: { path, query },
                    parseAs: 'blob',
                  })
                : getApi().GET('/v1/support/tickets/{ticketId}/attachments/{attachmentId}', {
                    params: { path, query },
                    parseAs: 'blob',
                  });
            }}
          />
        </li>
      ))}
    </ul>
  );
}

type Message = Schemas['TicketMessage'] & { internal?: boolean };

/** The conversation: the client's messages at the end, FlexiPay's at the start. */
export function TicketMessages({
  ticketId,
  messages,
  agent,
}: {
  ticketId: string;
  messages: readonly Message[];
  agent: boolean;
}) {
  const t = useTranslations('support');
  const locale = useLocale();
  if (messages.length === 0)
    return <p className="text-body text-text-muted">{t('thread.noMessages')}</p>;
  return (
    <ol className="flex flex-col gap-3">
      {messages.map((message) => {
        const mine = agent ? message.fromAgent : !message.fromAgent;
        return (
          <li
            key={message.id}
            className={cn(
              'flex max-w-form-max-width flex-col gap-2 rounded-card-desktop border p-4',
              mine ? 'ms-auto border-emerald-soft bg-emerald-soft' : 'me-auto border-border bg-bg',
              message.internal === true && 'border-warning-soft bg-warning-soft',
            )}
          >
            <p className="flex flex-wrap items-center gap-2 text-caption text-text-muted">
              <bdi className="font-label text-text">
                {!agent && message.fromAgent ? t('thread.flexipay') : message.authorName}
              </bdi>
              <span>{formatDateTime(message.createdAt, locale)}</span>
              {message.internal === true ? (
                <span className="rounded-badge bg-surface px-2 text-micro text-warning-text">
                  {t('agent.internalBadge')}
                </span>
              ) : null}
            </p>
            <p className="whitespace-pre-line text-body text-text">{message.body}</p>
            {message.redacted ? <RedactedNote /> : null}
            <TicketAttachments
              ticketId={ticketId}
              attachments={message.attachments}
              agent={agent}
            />
          </li>
        );
      })}
    </ol>
  );
}

export function RedactedNote() {
  const t = useTranslations('support.thread');
  return (
    <p className="flex items-center gap-1 text-caption text-warning-text">
      <ShieldAlert aria-hidden="true" className="size-icon-sm" />
      {t('redacted')}
    </p>
  );
}

/** Problem codes of the support forms, as translated messages. */
export function supportErrorKey(code: string | undefined, fallback: string): string {
  if (code === 'PAYLOAD_TOO_LARGE') return 'support.form.fileTooLarge';
  if (code === 'UNSUPPORTED_MEDIA_TYPE') return 'support.form.fileType';
  if (code === 'RATE_LIMITED') return 'support.form.rateLimited';
  if (code === 'NOT_FOUND') return 'support.form.linkNotFound';
  if (code === 'RESOURCE_STATE_CONFLICT') return 'support.thread.conflict';
  return fallback;
}

export { messageKey };
