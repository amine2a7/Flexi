'use client';

import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import {
  Ban,
  Banknote,
  CalendarClock,
  CheckCheck,
  CircleCheck,
  CircleDashed,
  CircleHelp,
  CirclePause,
  CircleX,
  Clock,
  FileText,
  Scale,
  Send,
  ShieldAlert,
  ShieldCheck,
  TimerOff,
  ArrowLeftRight,
  Hourglass,
  Mail,
  UserX,
  type LucideIcon,
} from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { messageKey } from '@/i18n/keys';
import { cn } from '@/lib/cn';
import { useReplay } from '@/lib/motion';
import { formatCalendarDate } from '@/lib/format/date';
import { useState } from 'react';

interface StatusToken {
  readonly labelKey: string;
  readonly icon: string;
  readonly bg: string;
  readonly fg: string;
}

const STATUS = (tokensPreset.theme as { status: Record<string, StatusToken> }).status;

// Icons named by the `status` tokens; a status is never shown by colour only (icon + text).
const ICONS: Record<string, LucideIcon> = {
  Clock,
  CircleCheck,
  CalendarClock,
  CheckCheck,
  CircleX,
  CirclePause,
  Scale,
  TimerOff,
  ShieldAlert,
  FileText,
  Banknote,
  ArrowLeftRight,
  Ban,
  CircleDashed,
  ShieldCheck,
  Send,
  CircleHelp,
  Hourglass,
  Mail,
  UserX,
};

/** Statuses of the contract (English enums) -> status tokens of the charter (glossary names). */
const API_TO_TOKEN: Record<string, string> = {
  // AccountStatus
  PENDING_KYC: 'EN_ATTENTE_KYC',
  APPROVED: 'VALIDE',
  REJECTED: 'REJETE',
  SUSPENDED: 'SUSPENDU',
  // OrderStatus
  CREATED: 'CREEE',
  PAID: 'PAYEE',
  RECONCILED: 'RAPPROCHEE',
  CREDITED: 'CREDITEE',
  CANCELLED: 'ANNULEE',
  // PaymentStatus
  INITIATED: 'INITIE',
  CONFIRMED: 'CONFIRME',
  COMPLETED: 'CONFIRME',
  SETTLED: 'REGLE',
  REFUSED: 'REFUSE',
  DISPUTED: 'EN_LITIGE',
  // PayoutRequestStatus
  REQUESTED: 'DEMANDEE',
  CHECKED: 'CONTROLEE',
  SENT: 'ENVOYEE',
  EXECUTED: 'EXECUTEE',
  // ApprovalStatus
  PENDING: 'EN_ATTENTE',
  // Settlement, invoice, employee and receivable states
  SCHEDULED: 'A_REGLER',
  UNPAID: 'A_REGLER',
  RECEIVABLE: 'A_REGLER',
  ACTIVE: 'VALIDE',
  INVITED: 'EN_ATTENTE',
  EXPIRED: 'EXPIRE',
};

/** Every API status the badge knows (shown together by the component library). */
export const KNOWN_STATUSES: readonly string[] = Object.keys(API_TO_TOKEN);

/** Credit orders (OrderStatus): colour and icon of an existing token, label of the order circuit. */
const ORDER_TOKENS: Record<string, string> = {
  AWAITING_CONFIRMATION: 'EN_ATTENTE',
  AWAITING_PAYMENT: 'A_REGLER',
  AWAITING_VALIDATION: 'PAYEE',
  VALIDATED: 'CREDITEE',
  REFUSED: 'REFUSEE',
  CANCELLED: 'ANNULEE',
};

/** Contract enums whose glossary token differs by context (approval REJECTED -> REFUSEE). */
const CONTEXT_OVERRIDES: Record<string, Record<string, string>> = {
  approval: { REJECTED: 'REFUSEE', APPROVED: 'APPROUVEE' },
  payout: { REJECTED: 'REJETEE' },
  // Account lifecycle (commun-statut-utilisateur.md §3.1).
  user: { ACTIVE: 'ACTIF', INVITED: 'INVITE', SUSPENDED: 'SUSPENDU', DEACTIVATED: 'DESACTIVE' },
};

interface StatusBadgeProps {
  /** Status as sent by the API. */
  readonly status: string;
  readonly context?: 'approval' | 'payout' | 'order' | 'user';
  /** i18n key replacing the default label (e.g. merchant wording of A_REGLER, decision 2). */
  readonly labelKey?: string;
}

export function StatusBadge({ status, context, labelKey }: StatusBadgeProps) {
  const t = useTranslations();
  // Animation 11: when the status changes, the colours cross-fade (320 ms) and the badge pulses.
  const pulse = useReplay(status);
  const orderToken = context === 'order' ? ORDER_TOKENS[status] : undefined;
  const tokenKey =
    orderToken ??
    (context === undefined ? undefined : CONTEXT_OVERRIDES[context]?.[status]) ??
    API_TO_TOKEN[status] ??
    'INCONNU';
  const token = STATUS[tokenKey] ?? STATUS.INCONNU;
  if (token === undefined) return null;
  const Icon = ICONS[token.icon] ?? CircleHelp;
  return (
    <span
      className={cn(
        'inline-flex min-h-chip-height items-center gap-1 whitespace-nowrap rounded-badge px-2 text-caption font-label transition-colors duration-slow ease-out',
        pulse.active && 'animate-pulse',
        `bg-${token.bg}`,
        `text-${token.fg}`,
      )}
      onAnimationEnd={pulse.onAnimationEnd}
    >
      <Icon aria-hidden="true" className="size-icon-sm" />
      {t(
        messageKey(
          labelKey ?? (orderToken === undefined ? token.labelKey : `orders.status.${status}`),
        ),
      )}
    </span>
  );
}

/**
 * Status of an account (commun-statut-utilisateur.md §3.1): a deactivated employee still in its
 * grace period shows the end date as sent by the API (never a computed number of days).
 */
export function UserStatusBadge({
  status,
  graceUntil,
}: {
  status: string;
  graceUntil?: string | null | undefined;
}) {
  const t = useTranslations();
  const locale = useLocale();
  // Moment of the first display (React rules: no clock read while rendering).
  const [now] = useState(() => Date.now());
  const inGrace =
    status === 'DEACTIVATED' &&
    graceUntil !== null &&
    graceUntil !== undefined &&
    Date.parse(graceUntil) > now;
  const token = STATUS.DESACTIVE_GRACE;
  if (!inGrace || token === undefined) return <StatusBadge status={status} context="user" />;
  const Icon = ICONS[token.icon] ?? CircleHelp;
  return (
    <span
      className={cn(
        'inline-flex min-h-chip-height max-w-full items-start gap-1 rounded-badge px-2 py-1 text-caption font-label',
        `bg-${token.bg}`,
        `text-${token.fg}`,
      )}
    >
      <Icon aria-hidden="true" className="size-icon-sm shrink-0" />
      {t('status.DESACTIVE_GRACE', {
        date: formatCalendarDate(graceUntil.slice(0, 10), locale),
      })}
    </span>
  );
}
