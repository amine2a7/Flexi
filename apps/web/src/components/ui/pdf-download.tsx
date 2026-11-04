'use client';

import { FileDown } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { errorMessageKey } from '@/lib/api/problem';
import { Button } from './button';
import { useToast } from './toast';

/**
 * Download of a PDF produced by the API (invoices, task 10): the file is fetched with the session,
 * saved under its name, the object URL revoked at once. An API error is shown in a toast.
 */
export function PdfDownloadButton({
  load,
  fileName,
  label,
}: {
  load: () => Promise<{ data?: Blob; error?: unknown }>;
  fileName: string;
  label: string;
}) {
  const tRoot = useTranslations();
  const toast = useToast();
  const [loading, setLoading] = useState(false);
  return (
    <Button
      variant="secondary"
      size="sm"
      loading={loading}
      icon={<FileDown aria-hidden="true" className="size-icon-sm" />}
      onClick={() => {
        setLoading(true);
        void load()
          .then(({ data, error }) => {
            if (data === undefined) {
              toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
              return;
            }
            const url = URL.createObjectURL(data);
            const link = document.createElement('a');
            link.href = url;
            link.download = fileName;
            link.click();
            URL.revokeObjectURL(url);
          })
          .finally(() => {
            setLoading(false);
          });
      }}
    >
      {label}
    </Button>
  );
}
