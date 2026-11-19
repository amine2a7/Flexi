'use client';

import type { Schemas } from '@flexipay/api-client';
import { Link2, Pencil, Plus } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Button } from '@/components/ui/button';
import { DataTable } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { QrCode } from '@/components/ui/qr-code';
import { LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

type Register = Schemas['Register'];
type Dialog =
  | { readonly kind: 'create' }
  | { readonly kind: 'rename'; readonly register: Register }
  | { readonly kind: 'status'; readonly register: Register }
  | { readonly kind: 'sticker'; readonly register: Register };

/**
 * Tills of the shop and their NFC sticker (M4, W-FIN): the owner adds, renames, switches off or
 * on a till, reads the signed link of its sticker (QR) and downloads the printable sticker
 * (8 × 8 cm PDF).
 */
export default function RegistersPage() {
  const t = useTranslations('merchant.registers');
  const registers = useApiQuery(() => getApi().GET('/v1/merchant/registers'), []);
  const [dialog, setDialog] = useState<Dialog | undefined>(undefined);
  const close = () => {
    setDialog(undefined);
  };
  const done = () => {
    setDialog(undefined);
    registers.reload();
  };

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Button
            icon={<Plus aria-hidden="true" className="size-icon-sm" />}
            onClick={() => {
              setDialog({ kind: 'create' });
            }}
          >
            {t('add')}
          </Button>
        }
      />
      <DataTable<Register>
        caption={t('title')}
        rows={registers.status === 'success' ? registers.data.data : undefined}
        rowKey={(register) => register.id}
        loading={registers.status === 'loading'}
        error={registers.status === 'error' ? registers.error : undefined}
        onRetry={registers.reload}
        empty={{ title: t('empty') }}
        columns={[
          { key: 'name', header: t('name'), card: 'title', cell: (register) => register.name },
          {
            key: 'status',
            header: t('status'),
            cell: (register) => (
              <StatusBadge
                status={register.status === 'ACTIVE' ? 'ACTIVE' : 'DEACTIVATED'}
                context="user"
              />
            ),
          },
          {
            key: 'sticker',
            header: t('sticker'),
            cell: (register) =>
              register.status === 'ACTIVE' ? (
                <div className="flex flex-wrap gap-2">
                  <Button
                    variant="secondary"
                    size="sm"
                    icon={<Link2 aria-hidden="true" className="size-icon-sm" />}
                    aria-label={t('linkOf', { name: register.name })}
                    onClick={() => {
                      setDialog({ kind: 'sticker', register });
                    }}
                  >
                    {t('link')}
                  </Button>
                  <PdfDownloadButton
                    label={t('download')}
                    fileName={`autocollant-${register.name}.pdf`}
                    load={() =>
                      getApi().GET('/v1/merchant/registers/{registerId}/sticker/pdf', {
                        params: { path: { registerId: register.id } },
                        parseAs: 'blob',
                      })
                    }
                  />
                </div>
              ) : null,
          },
          {
            key: 'actions',
            header: t('actions'),
            align: 'end',
            card: 'footer',
            cell: (register) => (
              <div className="flex flex-wrap justify-end gap-2">
                <Button
                  variant="ghost"
                  size="sm"
                  icon={<Pencil aria-hidden="true" className="size-icon-sm" />}
                  aria-label={t('renameOf', { name: register.name })}
                  onClick={() => {
                    setDialog({ kind: 'rename', register });
                  }}
                >
                  {t('rename')}
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => {
                    setDialog({ kind: 'status', register });
                  }}
                >
                  {register.status === 'ACTIVE' ? t('disable') : t('enable')}
                </Button>
              </div>
            ),
          },
        ]}
      />
      {dialog?.kind === 'create' || dialog?.kind === 'rename' ? (
        <NameDialog
          {...(dialog.kind === 'rename' ? { register: dialog.register } : {})}
          onClose={close}
          onDone={done}
        />
      ) : null}
      {dialog?.kind === 'status' ? (
        <StatusDialog register={dialog.register} onClose={close} onDone={done} />
      ) : null}
      {dialog?.kind === 'sticker' ? (
        <StickerDialog register={dialog.register} onClose={close} />
      ) : null}
    </>
  );
}

function NameDialog({
  register,
  onClose,
  onDone,
}: {
  register?: Register;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('merchant.registers');
  const tRoot = useTranslations();
  const toast = useToast();
  const [name, setName] = useState(register?.name ?? '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    try {
      const result =
        register === undefined
          ? await getApi().POST('/v1/merchant/registers', { body: { name: name.trim() } })
          : await getApi().PATCH('/v1/merchant/registers/{registerId}', {
              params: { path: { registerId: register.id } },
              body: { name: name.trim() },
            });
      if (result.data !== undefined) {
        toast.notify('success', t('saved', { name: result.data.name }));
        onDone();
      } else {
        setError(result.error);
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={register === undefined ? t('createTitle') : t('renameTitle', { name: register.name })}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          label={t('name')}
          hint={t('nameHint')}
          maxLength={60}
          value={name}
          onChange={(event) => {
            setName(event.target.value);
          }}
        />
        <div className="flex justify-end gap-3">
          <Button type="button" variant="secondary" onClick={onClose} disabled={saving}>
            {t('cancel')}
          </Button>
          <Button type="submit" loading={saving} disabled={name.trim() === ''}>
            {t('save')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}

function StatusDialog({
  register,
  onClose,
  onDone,
}: {
  register: Register;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('merchant.registers');
  const tRoot = useTranslations();
  const toast = useToast();
  const [saving, setSaving] = useState(false);
  const active = register.status === 'ACTIVE';
  return (
    <ConfirmDialog
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={
        active
          ? t('disableTitle', { name: register.name })
          : t('enableTitle', { name: register.name })
      }
      description={active ? t('disableText') : t('enableText')}
      confirmLabel={active ? t('disable') : t('enable')}
      confirmVariant={active ? 'danger' : 'primary'}
      loading={saving}
      onConfirm={() => {
        setSaving(true);
        void getApi()
          .PATCH('/v1/merchant/registers/{registerId}', {
            params: { path: { registerId: register.id } },
            body: { status: active ? 'DISABLED' : 'ACTIVE' },
          })
          .then(({ data, error }) => {
            if (data !== undefined) {
              toast.notify('success', t('saved', { name: data.name }));
              onDone();
            } else {
              toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
            }
          })
          .finally(() => {
            setSaving(false);
          });
      }}
    />
  );
}

/** The signed link written on the NFC sticker, also printed as a QR (never typed by hand). */
function StickerDialog({ register, onClose }: { register: Register; onClose: () => void }) {
  const t = useTranslations('merchant.registers');
  const sticker = useApiQuery(
    () =>
      getApi().GET('/v1/merchant/registers/{registerId}/sticker', {
        params: { path: { registerId: register.id } },
      }),
    [register.id],
  );
  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
      title={t('linkTitle', { name: register.name })}
      description={t('linkText')}
    >
      {sticker.status === 'loading' ? <LoadingBlock lines={3} /> : null}
      {sticker.status === 'error' ? <Alert tone="danger">{t('linkError')}</Alert> : null}
      {sticker.status === 'success' ? (
        <div className="flex flex-col items-center gap-4">
          <QrCode value={sticker.data.url} label={t('qrLabel', { name: register.name })} />
          <p dir="ltr" className="break-all text-center text-caption text-text-muted">
            {sticker.data.url}
          </p>
        </div>
      ) : null}
    </Modal>
  );
}
