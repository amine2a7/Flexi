'use client';

import type { Schemas } from '@flexipay/api-client';
import {
  Building2,
  CalendarCheck,
  HandCoins,
  LockKeyhole,
  QrCode,
  ScanLine,
  ShoppingCart,
  Store,
  Tags,
  Users,
  Wallet,
  type LucideIcon,
} from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useCallback, useEffect, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { cn } from '@/lib/cn';
import { Button } from '@/components/ui/button';
import { Modal } from '@/components/ui/modal';

type Role = Schemas['Role'];
type TourRole = 'MERCHANT' | 'COMPANY' | 'EMPLOYEE';

const STEPS: Record<TourRole, readonly LucideIcon[]> = {
  MERCHANT: [Store, HandCoins, CalendarCheck, Tags],
  COMPANY: [Building2, Users, ShoppingCart, Wallet],
  EMPLOYEE: [Wallet, QrCode, ScanLine, LockKeyhole],
};

export function hasTour(role: Role): role is TourRole {
  return role in STEPS;
}

/** Per user and per browser: a convenience flag only, losing it just shows the tour again. */
const doneKey = (userId: string) => `fp_tour_done_v1:${userId}`;

function readDone(userId: string): boolean {
  try {
    return window.localStorage.getItem(doneKey(userId)) !== null;
  } catch {
    return true;
  }
}

function writeDone(userId: string): void {
  try {
    window.localStorage.setItem(doneKey(userId), '1');
  } catch {
    // Storage blocked: the tour will simply show again next time.
  }
}

/** Opens the tour at the first sign-in of the user; `start` replays it from the Help menu. */
export function useOnboardingTour(role: Role, userId: string) {
  const [open, setOpen] = useState(false);
  useEffect(() => {
    // First visit of this user in this browser (state read from storage after mount).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (hasTour(role) && !readDone(userId)) setOpen(true);
  }, [role, userId]);
  const close = useCallback(() => {
    writeDone(userId);
    setOpen(false);
  }, [userId]);
  const start = useCallback(() => setOpen(true), []);
  return { open, close, start };
}

/** Guided tour of 4 steps, skippable at any time. */
export function OnboardingTour({ role, onClose }: { role: TourRole; onClose: () => void }) {
  const t = useTranslations('tour');
  const tRoot = useTranslations();
  const icons = STEPS[role];
  const [index, setIndex] = useState(0);
  const Icon = icons[index] ?? Wallet;
  const last = index === icons.length - 1;
  const step = `tour.${role}.s${index + 1}`;

  return (
    <Modal
      open
      onOpenChange={(next) => {
        if (!next) onClose();
      }}
      title={tRoot(messageKey(`${step}.title`))}
      description={t('progress', { current: index + 1, total: icons.length })}
    >
      <div className="flex flex-col items-center gap-4 text-center">
        <span
          aria-hidden="true"
          className="flex size-illustration items-center justify-center rounded-card-mobile bg-emerald-soft text-emerald-text"
        >
          <Icon className="size-avatar-lg" strokeWidth={1.5} />
        </span>
        <p className="text-body-lg text-text">{tRoot(messageKey(`${step}.text`))}</p>
        <ol aria-hidden="true" className="flex gap-2">
          {icons.map((_, position) => (
            <li
              key={position}
              className={cn(
                'size-icon-sm rounded-badge',
                position === index ? 'bg-navy' : 'bg-border',
              )}
            />
          ))}
        </ol>
      </div>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Button variant="ghost" onClick={onClose}>
          {t('skip')}
        </Button>
        <div className="flex gap-2">
          {index > 0 ? (
            <Button variant="secondary" onClick={() => setIndex(index - 1)}>
              {t('previous')}
            </Button>
          ) : null}
          <Button onClick={() => (last ? onClose() : setIndex(index + 1))}>
            {last ? t('finish') : t('next')}
          </Button>
        </div>
      </div>
    </Modal>
  );
}
