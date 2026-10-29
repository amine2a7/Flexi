'use client';

import { useTranslations } from 'next-intl';
import { useCallback, useEffect, useRef, useState } from 'react';
import { useRouter } from '@/i18n/navigation';
import { Button } from '@/components/ui/button';
import { Modal } from '@/components/ui/modal';

// Decision 18: 15 min of inactivity, warning 2 min before (WCAG 2.2.1). The server enforces the
// real limit; this watch only warns the user and leaves cleanly.
const IDLE_MS = 15 * 60 * 1000;
const WARNING_MS = 2 * 60 * 1000;
const ACTIVITY_EVENTS = ['pointerdown', 'keydown'] as const;

export function SessionWatch({ onExpire }: { onExpire: () => Promise<void> }) {
  const t = useTranslations('layout.session');
  const router = useRouter();
  const lastActivity = useRef(0);
  const [warning, setWarning] = useState(false);

  const stayConnected = useCallback(() => {
    lastActivity.current = Date.now();
    setWarning(false);
  }, []);

  useEffect(() => {
    if (lastActivity.current === 0) lastActivity.current = Date.now();
    const onActivity = () => {
      if (!warning) lastActivity.current = Date.now();
    };
    for (const event of ACTIVITY_EVENTS) window.addEventListener(event, onActivity);
    const timer = setInterval(() => {
      const idle = Date.now() - lastActivity.current;
      if (idle >= IDLE_MS) {
        void onExpire().then(() => {
          router.replace('/session-expiree');
        });
      } else if (idle >= IDLE_MS - WARNING_MS) {
        setWarning(true);
      }
    }, 5000);
    return () => {
      for (const event of ACTIVITY_EVENTS) window.removeEventListener(event, onActivity);
      clearInterval(timer);
    };
  }, [warning, onExpire, router]);

  return (
    <Modal
      open={warning}
      onOpenChange={(open) => {
        if (!open) stayConnected();
      }}
      title={t('warningTitle')}
      description={t('warningMessage')}
      footer={
        <>
          <Button variant="secondary" onClick={() => void onExpire()}>
            {t('signOut')}
          </Button>
          <Button onClick={stayConnected}>{t('stay')}</Button>
        </>
      }
    />
  );
}
