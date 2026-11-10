'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Check, X } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useCallback, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { isStateConflict, ReasonDialog } from '@/components/orders/order-parts';
import { KycStatusBadge } from '@/components/admin/kyc-status-badge';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { FileViewer } from '@/components/ui/file-viewer';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

type KycFile = Schemas['KycFile'];

/** KYC file: documents, decision (approve / reject with a reason) and history. */
export default function KycFilePage() {
  const { fileId } = useParams<{ fileId: string }>();
  const t = useTranslations('admin.kyc');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/kyc-files/{fileId}', { params: { path: { fileId } } }),
    [fileId],
  );
  const [updated, setUpdated] = useState<KycFile | undefined>(undefined);
  const file = updated ?? (query.status === 'success' ? query.data : undefined);
  const { reload: reloadQuery } = query;
  const reload = useCallback(() => {
    setUpdated(undefined);
    reloadQuery();
  }, [reloadQuery]);

  return (
    <>
      <Link href="/admin/kyc" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {file === undefined && query.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {file === undefined && query.status === 'error' ? (
        <ErrorState error={query.error} onRetry={query.reload} />
      ) : null}
      {file !== undefined ? (
        <KycView file={file} onChange={setUpdated} onConflict={reload} />
      ) : null}
    </>
  );
}

function KycView({
  file,
  onChange,
  onConflict,
}: {
  file: KycFile;
  onChange: (file: KycFile) => void;
  onConflict: () => void;
}) {
  const t = useTranslations('admin.kyc');
  const tRoot = useTranslations();
  const canDecide = useCan('kyc.decide');
  const locale = useLocale();
  const toast = useToast();
  const [dialog, setDialog] = useState<'approve' | 'reject' | undefined>(undefined);
  // Document whose correction is being asked (processus v2: a reason per document).
  const [correcting, setCorrecting] = useState<Schemas['KycDocument'] | undefined>(undefined);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  function settle(result: { data?: KycFile; error?: unknown }, message: string): unknown {
    if (result.data !== undefined) {
      setDialog(undefined);
      toast.notify('success', message);
      onChange(result.data);
      return undefined;
    }
    if (isStateConflict(result.error)) {
      setDialog(undefined);
      toast.notify('error', tRoot('orders.conflict'));
      onConflict();
      return undefined;
    }
    return result.error;
  }

  async function approve() {
    setSaving(true);
    setError(undefined);
    try {
      const problem = settle(
        await getApi().POST('/v1/admin/kyc-files/{fileId}/approve', {
          params: { path: { fileId: file.id } },
        }),
        t('approvedToast'),
      );
      if (problem !== undefined) {
        setDialog(undefined);
        setError(problem);
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <>
      <PageHeader
        title={t('detailTitle', { name: file.accountName })}
        description={t(`types.${file.accountType}`)}
        actions={<KycStatusBadge status={file.status} />}
      />
      <div className="flex flex-col gap-6">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        {file.status === 'PENDING' && canDecide ? (
          <Card>
            <div className="flex flex-col gap-4">
              <Alert tone="warning">{t('pendingInfo')}</Alert>
              <div className="flex flex-wrap justify-end gap-3">
                <Button
                  variant="secondary"
                  icon={<X aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setDialog('reject');
                  }}
                >
                  {t('reject')}
                </Button>
                <Button
                  variant="success"
                  icon={<Check aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setDialog('approve');
                  }}
                >
                  {t('approve')}
                </Button>
              </div>
            </div>
          </Card>
        ) : null}
        {file.status === 'REJECTED' && file.rejectionReason !== undefined ? (
          <Alert tone="danger">
            <span dir="auto">{t('rejectedInfo', { reason: file.rejectionReason })}</span>
          </Alert>
        ) : null}
        <Card>
          <DescriptionList
            items={[
              { label: t('type'), value: t(`types.${file.accountType}`) },
              { label: t('city'), value: file.city },
              { label: t('submittedAt'), value: formatDateTime(file.submittedAt, locale) },
              { label: t('documents'), value: file.documentsCount },
            ]}
          />
        </Card>
        <Card>
          <CardTitle>{t('documentsTitle')}</CardTitle>
          <div className="grid gap-6 md:grid-cols-2">
            {(file.pieces ?? [])
              .filter((piece) => piece.status === 'MISSING')
              .map((piece) => (
                <section
                  key={piece.type}
                  className="flex items-center justify-between gap-3 rounded-card-desktop border border-dashed border-border p-4"
                >
                  <h3 className="text-label font-title text-text">
                    {t(`documentTypes.${piece.type}`)}
                  </h3>
                  <StatusBadge
                    status="MISSING"
                    context="kyc"
                    labelKey="account.kyc.status.MISSING"
                  />
                </section>
              ))}
            {file.documents.map((document) => (
              <KycDocumentView
                key={document.id}
                fileId={file.id}
                document={document}
                {...(file.status === 'PENDING' && canDecide && document.status !== 'TO_CORRECT'
                  ? {
                      onCorrect: () => {
                        setCorrecting(document);
                      },
                    }
                  : {})}
              />
            ))}
          </div>
        </Card>
        <Card>
          <CardTitle>{t('historyTitle')}</CardTitle>
          <Timeline
            entries={file.history.map((event, index) => ({
              key: `${event.action}-${String(index)}`,
              title: t(`event.${event.action}`),
              meta: `${formatDateTime(event.occurredAt, locale)} · ${t('by', { name: event.actorName })}`,
              ...(event.reason === undefined ? {} : { detail: event.reason }),
              tone: event.action === 'REJECTED' ? 'danger' : 'default',
            }))}
          />
        </Card>
      </div>
      <ConfirmDialog
        open={dialog === 'approve'}
        onOpenChange={(open) => {
          setDialog(open ? 'approve' : undefined);
        }}
        title={t('approveTitle', { name: file.accountName })}
        description={t('approveMessage')}
        confirmLabel={t('approve')}
        confirmVariant="success"
        loading={saving}
        onConfirm={() => void approve()}
      />
      {correcting !== undefined ? (
        <ReasonDialog
          title={t('correctionTitle', { type: t(`documentTypes.${correcting.type}`) })}
          label={t('correctionReason')}
          confirmLabel={t('askCorrection')}
          onClose={() => {
            setCorrecting(undefined);
          }}
          onSubmit={async (reason) => {
            const problem = settle(
              await getApi().POST('/v1/admin/kyc-files/{fileId}/corrections', {
                params: { path: { fileId: file.id } },
                body: { corrections: [{ documentId: correcting.id, reason }] },
              }),
              t('correctionToast'),
            );
            if (problem === undefined) setCorrecting(undefined);
            return problem;
          }}
        />
      ) : null}
      {dialog === 'reject' ? (
        <ReasonDialog
          title={t('rejectTitle', { name: file.accountName })}
          label={t('rejectReason')}
          confirmLabel={t('reject')}
          onClose={() => {
            setDialog(undefined);
          }}
          onSubmit={async (reason) =>
            settle(
              await getApi().POST('/v1/admin/kyc-files/{fileId}/reject', {
                params: { path: { fileId: file.id } },
                body: { reason },
              }),
              t('rejectedToast'),
            )
          }
        />
      ) : null}
    </>
  );
}

function KycDocumentView({
  fileId,
  document,
  onCorrect,
}: {
  fileId: string;
  document: Schemas['KycDocument'];
  onCorrect?: () => void;
}) {
  const t = useTranslations('admin.kyc');
  const load = useCallback(
    () =>
      getApi().GET('/v1/admin/kyc-files/{fileId}/documents/{documentId}', {
        params: { path: { fileId, documentId: document.id } },
        parseAs: 'blob',
      }),
    [fileId, document.id],
  );
  const title = t(`documentTypes.${document.type}`);
  return (
    <section className="flex flex-col gap-3 rounded-card-desktop border border-border p-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h3 className="text-label font-title text-text">{title}</h3>
        {document.status === undefined ? null : (
          <StatusBadge
            status={document.status}
            context="kyc"
            labelKey={`account.kyc.status.${document.status}`}
          />
        )}
      </div>
      {document.correctionReason === undefined ? null : (
        <Alert tone="warning">{document.correctionReason}</Alert>
      )}
      {onCorrect === undefined ? null : (
        <Button size="sm" variant="secondary" onClick={onCorrect}>
          {t('askCorrection')}
        </Button>
      )}
      <FileViewer
        load={load}
        fileName={document.fileName}
        sizeBytes={document.sizeBytes}
        alt={title}
      />
    </section>
  );
}
