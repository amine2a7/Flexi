'use client';

import { Download, FileText } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { buttonClasses } from './button';
import { Alert } from './layout-blocks';

export type FileLoader = () => Promise<{ data?: Blob; error?: unknown }>;

/**
 * File fetched by the app (transfer proof, KYC document): inline preview of an image (CSP
 * img-src blob:), download link for every type. The object URL is revoked on unmount.
 */
export function FileViewer({
  load,
  fileName,
  sizeBytes,
  alt,
}: {
  load: FileLoader;
  fileName: string;
  sizeBytes: number;
  alt: string;
}) {
  const t = useTranslations('ui.file');
  const [state, setState] = useState<
    { status: 'loading' } | { status: 'error' } | { status: 'ready'; url: string; image: boolean }
  >({ status: 'loading' });

  useEffect(() => {
    let active = true;
    let url: string | undefined;
    load()
      .then(({ data }) => {
        if (!active) return;
        if (data === undefined) {
          setState({ status: 'error' });
          return;
        }
        url = URL.createObjectURL(data);
        setState({ status: 'ready', url, image: data.type.startsWith('image/') });
      })
      .catch(() => {
        if (active) setState({ status: 'error' });
      });
    return () => {
      active = false;
      if (url !== undefined) URL.revokeObjectURL(url);
    };
  }, [load]);

  const sizeKb = Math.max(1, Math.round(sizeBytes / 1024));
  return (
    <div className="flex flex-col gap-3">
      <p className="flex items-center gap-2 text-caption text-text-muted">
        <FileText aria-hidden="true" className="size-icon-sm" />
        <span dir="ltr">{t('size', { name: fileName, size: sizeKb })}</span>
      </p>
      {state.status === 'loading' ? (
        <p className="text-body text-text-muted">{t('loading')}</p>
      ) : null}
      {state.status === 'error' ? <Alert tone="danger">{t('error')}</Alert> : null}
      {state.status === 'ready' ? (
        <>
          {state.image ? (
            <img
              src={state.url}
              alt={alt}
              className="w-full max-w-form-max-width rounded-card-desktop border border-border object-contain"
            />
          ) : (
            <p className="text-body text-text-muted">{t('pdf')}</p>
          )}
          <a
            href={state.url}
            download={fileName}
            className={buttonClasses('secondary', 'sm', 'self-start')}
          >
            <Download aria-hidden="true" className="size-icon-sm" />
            {t('download')}
          </a>
        </>
      ) : null}
    </div>
  );
}
