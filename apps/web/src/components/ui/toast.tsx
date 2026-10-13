'use client';

import { CircleCheck, CircleX, Info, X } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react';
import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { cn } from '@/lib/cn';

type ToastTone = 'success' | 'info' | 'error';

interface ToastItem {
  readonly id: number;
  readonly tone: ToastTone;
  readonly message: string;
}

interface ToastApi {
  readonly notify: (tone: ToastTone, message: string) => void;
}

const TONE_CLASSES: Record<ToastTone, string> = {
  success: 'border-emerald bg-emerald-soft text-emerald-text',
  info: 'border-info bg-info-soft text-info-text',
  error: 'border-danger bg-danger-soft text-danger-text',
};

const ToastContext = createContext<ToastApi | null>(null);
const DURATION = (tokensPreset.theme as { motion: { 'toast-duration': number } }).motion[
  'toast-duration'
];

/**
 * Success toasts close by themselves; error toasts stay until closed (WCAG 2.2.1, decision of
 * 2026-10-09). Announced through a polite live region.
 */
export function ToastProvider({ children }: { children: ReactNode }) {
  const t = useTranslations('ui.modal');
  const [items, setItems] = useState<readonly ToastItem[]>([]);
  const dismiss = useCallback((id: number) => {
    setItems((current) => current.filter((item) => item.id !== id));
  }, []);
  const notify = useCallback(
    (tone: ToastTone, message: string) => {
      const id = Date.now() + Math.floor(Math.random() * 1000);
      setItems((current) => [...current, { id, tone, message }]);
      if (tone !== 'error') setTimeout(() => { dismiss(id); }, DURATION);
    },
    [dismiss],
  );
  const api = useMemo(() => ({ notify }), [notify]);

  return (
    <ToastContext.Provider value={api}>
      {children}
      <div
        aria-live="polite"
        className="fixed end-0 top-4 z-50 flex w-full max-w-toast-max-width flex-col gap-3 px-4"
      >
        {items.map((item) => (
          <div
            key={item.id}
            role={item.tone === 'error' ? 'alert' : 'status'}
            className={cn(
              'flex items-center gap-3 rounded-card-desktop border p-4 shadow-raised',
              TONE_CLASSES[item.tone],
            )}
          >
            {item.tone === 'success' ? (
              <CircleCheck aria-hidden="true" className="size-icon-md shrink-0" />
            ) : item.tone === 'info' ? (
              <Info aria-hidden="true" className="size-icon-md shrink-0" />
            ) : (
              <CircleX aria-hidden="true" className="size-icon-md shrink-0" />
            )}
            <p className="flex-1 text-label">{item.message}</p>
            <button
              type="button"
              onClick={() => { dismiss(item.id); }}
              aria-label={t('close')}
              className="flex size-touch-target-min items-center justify-center rounded-button"
            >
              <X aria-hidden="true" className="size-icon-sm" />
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastApi {
  const api = useContext(ToastContext);
  if (api === null) throw new Error('useToast must be used inside <ToastProvider>');
  return api;
}
