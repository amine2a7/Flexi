'use client';

import type { Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { DataTable } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { StatusBadge } from '@/components/ui/status-badge';

type Register = Schemas['Register'];

/**
 * Tills of the shop and their NFC sticker (M4): the owner downloads the printable sticker
 * (8 × 8 cm PDF, QR of the signed link) of each till.
 */
export default function RegistersPage() {
  const t = useTranslations('merchant.registers');
  const registers = useApiQuery(() => getApi().GET('/v1/merchant/registers'), []);

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <DataTable<Register>
        caption={t('title')}
        rows={registers.status === 'success' ? registers.data.data : undefined}
        rowKey={(register) => register.id}
        loading={registers.status === 'loading'}
        error={registers.status === 'error' ? registers.error : undefined}
        onRetry={registers.reload}
        empty={{ title: t('empty') }}
        columns={[
          { key: 'name', header: t('name'), cell: (register) => register.name },
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
              ) : null,
          },
        ]}
      />
    </>
  );
}
