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
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useCallback, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
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

/**
 * Opens the tour while the server says it was never seen (Me.onboardingTourDone); closing it
 * (finished or skipped) records that once. `start` replays it from the Help menu.
 */
export function useOnboardingTour(role: Role, me: Schemas['Me']) {
  const [open, setOpen] = useState(() => hasTour(role) && !me.onboardingTourDone);
  const [recorded, setRecorded] = useState(me.onboardingTourDone);
  const close = useCallback(() => {
    setOpen(false);
    if (recorded) return;
    setRecorded(true);
    getApi()
      .POST('/v1/me/onboarding-tour')
      .catch(() => undefined);
  }, [recorded]);
  const start = useCallback(() => {
    setOpen(true);
  }, []);
  return { open, close, start };
}

/** Guided tour of 4 steps, skippable at any time. */
export function OnboardingTour({ role, onClose }: { role: TourRole; onClose: () => void }) {
  const t = useTranslations('tour');
  const tRoot = useTranslations();
  const { settlementDays } = usePlatformTerms();
  const icons = STEPS[role];
  const [index, setIndex] = useState(0);
  const Icon = icons[index] ?? Wallet;
  const last = index === icons.length - 1;
  const step = `tour.${role}.s${String(index + 1)}`;

  return (
    <Modal
      open
      onOpenChange={(next) => {
        if (!next) onClose();
      }}
      title={tRoot(messageKey(`${step}.title`), { days: settlementDays })}
      description={t('progress', { current: index + 1, total: icons.length })}
    >
      {/* Animation 16: each step slides in (320 ms) when the tour moves on. */}
      <div key={index} className="flex animate-rise flex-col items-center gap-4 text-center">
        <span
          aria-hidden="true"
          className="flex size-illustration items-center justify-center rounded-card-mobile bg-emerald-soft text-emerald-text"
        >
          <Icon className="size-avatar-lg" strokeWidth={1.5} />
        </span>
        <p className="text-body-lg text-text">{tRoot(messageKey(`${step}.text`), { days: settlementDays })}</p>
        <ol aria-hidden="true" className="flex gap-2">
          {icons.map((_, position) => (
            <li
              key={position}
              className={cn(
                'size-icon-sm rounded-badge transition-colors duration-slow ease-out',
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
            <Button
              variant="secondary"
              onClick={() => {
                setIndex(index - 1);
              }}
            >
              {t('previous')}
            </Button>
          ) : null}
          <Button
            onClick={() => {
              if (last) onClose();
              else setIndex(index + 1);
            }}
          >
            {last ? t('finish') : t('next')}
          </Button>
        </div>
      </div>
    </Modal>
  );
}
