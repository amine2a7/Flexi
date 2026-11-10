'use client';

import type { Schemas } from '@flexipay/api-client';
import { Upload } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Link } from '@/i18n/navigation';
import { useCan } from '@/lib/session/session-context';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

const MAX_BYTES = 5 * 1024 * 1024;
const TYPES = ['image/jpeg', 'image/png', 'application/pdf'];

/**
 * « Compte › Mon dossier » (processus v2): the four KYC documents with their status; the client
 * files each one (PDF or image, 5 MB) and files it again when FlexiPay asks a correction.
 */
export function KycFilePage() {
  const t = useTranslations('account.kyc');
  const file = useApiQuery(() => getApi().GET('/v1/account/kyc'), []);
  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={file.status === 'success' ? <StatusBadge status={file.data.status} /> : undefined}
      />
      {file.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {file.status === 'error' ? <ErrorState error={file.error} onRetry={file.reload} /> : null}
      {file.status === 'success' ? (
        <div className="flex flex-col gap-4">
          {file.data.status === 'APPROVED' ? (
            <Alert tone="success">{t('approved')}</Alert>
          ) : file.data.documents.some((piece) => piece.status === 'TO_CORRECT') ? (
            <Alert tone="warning">{t('toCorrect')}</Alert>
          ) : file.data.documents.some((piece) => piece.status === 'MISSING') ? (
            <Alert tone="info">{t('missing')}</Alert>
          ) : (
            <Alert tone="info">{t('underReview')}</Alert>
          )}
          {file.data.documents.map((piece) => (
            <PieceCard
              key={piece.type}
              piece={piece}
              locked={file.data.status === 'APPROVED'}
              onDone={file.reload}
            />
          ))}
        </div>
      ) : null}
    </>
  );
}

function PieceCard({
  piece,
  locked,
  onDone,
}: {
  piece: Schemas['KycPiece'];
  locked: boolean;
  onDone: () => void;
}) {
  const t = useTranslations('account.kyc');
  const tRoot = useTranslations();
  const toast = useToast();
  const [error, setError] = useState<string | undefined>(undefined);
  const [sending, setSending] = useState(false);
  const inputId = `kyc-${piece.type}`;

  async function send(file: File | undefined) {
    if (file === undefined) return;
    if (!TYPES.includes(file.type)) {
      setError(t('fileType'));
      return;
    }
    if (file.size > MAX_BYTES) {
      setError(t('fileTooLarge'));
      return;
    }
    setError(undefined);
    setSending(true);
    try {
      const form = new FormData();
      form.set('type', piece.type);
      form.set('document', file, file.name);
      const { data, error: problem } = await getApi().POST('/v1/account/kyc/documents', {
        // Multipart body (contract exception): the browser sets the boundary.
        body: form as never,
        bodySerializer: (body: unknown) => body as FormData,
      });
      if (data !== undefined) {
        toast.notify('success', t('uploaded', { name: t(`types.${piece.type}`) }));
        onDone();
        return;
      }
      const code = asProblem(problem)?.code;
      setError(
        code === 'PAYLOAD_TOO_LARGE'
          ? t('fileTooLarge')
          : code === 'UNSUPPORTED_MEDIA_TYPE'
            ? t('fileType')
            : tRoot(messageKey(errorMessageKey(problem))),
      );
    } finally {
      setSending(false);
    }
  }

  return (
    <Card>
      <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
        <div className="flex flex-col gap-1">
          <CardTitle>{t(`types.${piece.type}`)}</CardTitle>
          <p className="text-caption text-text-muted">{t(`hints.${piece.type}`)}</p>
          {piece.fileName === undefined ? null : (
            <p className="text-body text-text" dir="ltr">
              {piece.fileName}
            </p>
          )}
          {piece.correctionReason === undefined ? null : (
            <Alert tone="warning">{t('reason', { reason: piece.correctionReason })}</Alert>
          )}
          {error === undefined ? null : (
            <p role="alert" className="text-caption text-danger-text">
              {error}
            </p>
          )}
        </div>
        <div className="flex items-center gap-3">
          <StatusBadge
            status={piece.status}
            context="kyc"
            labelKey={`account.kyc.status.${piece.status}`}
          />
          {locked ? null : (
            <>
              <input
                id={inputId}
                type="file"
                className="sr-only"
                accept=".jpg,.jpeg,.png,.pdf,image/jpeg,image/png,application/pdf"
                onChange={(event) => {
                  void send(event.target.files?.[0]);
                  event.target.value = '';
                }}
              />
              <Button
                size="sm"
                variant={
                  piece.status === 'MISSING' || piece.status === 'TO_CORRECT'
                    ? 'primary'
                    : 'secondary'
                }
                loading={sending}
                icon={<Upload aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  document.getElementById(inputId)?.click();
                }}
              >
                {piece.status === 'MISSING' ? t('upload') : t('replace')}
              </Button>
            </>
          )}
        </div>
      </div>
    </Card>
  );
}

/** Dashboard banner « Complétez votre dossier » while the KYC file is not validated. */
export function KycBanner({ href }: { href: '/entreprise/dossier' | '/commercant/dossier' }) {
  const canFile = useCan('kyc.submit');
  return canFile ? <KycBannerLoaded href={href} /> : null;
}

function KycBannerLoaded({ href }: { href: '/entreprise/dossier' | '/commercant/dossier' }) {
  const t = useTranslations('account.kyc');
  const file = useApiQuery(() => getApi().GET('/v1/account/kyc'), []);
  if (file.status !== 'success' || file.data.status === 'APPROVED') return null;
  return (
    <div className="mb-6">
      <Alert tone="warning">
        <span className="flex flex-wrap items-center justify-between gap-3">
          {t('banner')}
          <Link href={href} className={buttonClasses('secondary', 'sm')}>
            {t('bannerAction')}
          </Link>
        </span>
      </Alert>
    </div>
  );
}
