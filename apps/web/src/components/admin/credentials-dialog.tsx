'use client';

import { Check, Copy, TriangleAlert } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Alert, DescriptionList } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';

export interface Credentials {
  readonly email: string;
  readonly temporaryPassword: string;
}

/**
 * E-mail and temporary password shown ONCE (processus v2): the administrator copies them and
 * hands them to the client. Never stored by the page; once closed, only a new generation shows a
 * password again.
 */
export function CredentialsDialog({
  credentials,
  onClose,
}: {
  credentials: Credentials | undefined;
  onClose: () => void;
}) {
  const t = useTranslations('admin.credentials');
  const [copied, setCopied] = useState(false);
  if (credentials === undefined) return null;
  const text = t('copyText', {
    email: credentials.email,
    password: credentials.temporaryPassword,
  });
  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open) {
          setCopied(false);
          onClose();
        }
      }}
      title={t('title')}
      footer={
        <div className="flex justify-end gap-2">
          <Button
            variant="secondary"
            icon={
              copied ? (
                <Check aria-hidden="true" className="size-icon-sm" />
              ) : (
                <Copy aria-hidden="true" className="size-icon-sm" />
              )
            }
            onClick={() => {
              void navigator.clipboard.writeText(text).then(() => {
                setCopied(true);
              });
            }}
          >
            {copied ? t('copied') : t('copy')}
          </Button>
          <Button
            onClick={() => {
              setCopied(false);
              onClose();
            }}
          >
            {t('done')}
          </Button>
        </div>
      }
    >
      <div className="flex flex-col gap-4">
        <DescriptionList
          items={[
            {
              label: t('email'),
              value: (
                <code dir="ltr" className="font-label">
                  {credentials.email}
                </code>
              ),
            },
            {
              label: t('password'),
              value: (
                <code dir="ltr" className="font-label text-title">
                  {credentials.temporaryPassword}
                </code>
              ),
            },
          ]}
        />
        <Alert tone="warning">
          <span className="flex items-start gap-2">
            <TriangleAlert aria-hidden="true" className="size-icon-sm shrink-0" />
            {t('once')}
          </span>
        </Alert>
      </div>
    </Modal>
  );
}
