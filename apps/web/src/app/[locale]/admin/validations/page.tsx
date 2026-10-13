'use client';

import type { Schemas } from '@flexipay/api-client';
import { Check, X } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { formatRateBps } from '@/lib/format/money';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader, Tabs } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

type Approval = Schemas['Approval'];
type Tab = 'pending' | 'history';
interface Decision {
  approval: Approval;
  kind: 'approve' | 'reject';
}

export default function ApprovalsPage() {
  const t = useTranslations('admin.approvals');
  const locale = useLocale();
  const [tab, setTab] = useState<Tab>('pending');
  const [refresh, setRefresh] = useState(0);
  const [decision, setDecision] = useState<Decision | undefined>(undefined);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/approvals', {
        params: {
          query: {
            cursor,
            withCount,
            ...(tab === 'pending' ? { status: 'PENDING' as const } : {}),
          },
        },
      }),
    [tab, refresh],
  );
  const rows = tab === 'pending' ? list.rows : list.rows?.filter((row) => row.status !== 'PENDING');

  const detail = (row: Approval) =>
    row.oldRateBps !== undefined && row.newRateBps !== undefined
      ? t('rateChange', {
          from: formatRateBps(row.oldRateBps, locale),
          to: formatRateBps(row.newRateBps, locale),
        })
      : (row.reason ?? '');

  const columns: Column<Approval>[] = [
    { key: 'type', header: t('type'), cell: (row) => t(`types.${row.type}`) },
    {
      key: 'subject',
      header: t('subject'),
      cell: (row) => row.subject,
      sortValue: (row) => row.subject,
    },
    { key: 'detail', header: t('detail'), cell: (row) => <span dir="auto">{detail(row)}</span> },
    {
      key: 'initiator',
      header: t('initiator'),
      cell: (row) => row.initiatorName,
      sortValue: (row) => row.initiatorName,
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.createdAt, locale),
      sortValue: (row) => row.createdAt,
    },
    tab === 'pending'
      ? {
          key: 'actions',
          header: t('actions'),
          align: 'end',
          cell: (row) =>
            row.initiatedByMe ? (
              <span className="text-caption text-text-muted">{t('own')}</span>
            ) : (
              <span className="flex flex-wrap justify-end gap-2">
                <Button
                  size="sm"
                  variant="secondary"
                  icon={<X aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setDecision({ approval: row, kind: 'reject' });
                  }}
                >
                  {t('reject')}
                </Button>
                <Button
                  size="sm"
                  icon={<Check aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setDecision({ approval: row, kind: 'approve' });
                  }}
                >
                  {t('approve')}
                </Button>
              </span>
            ),
        }
      : {
          key: 'status',
          header: t('status'),
          cell: (row) => <StatusBadge status={row.status} context="approval" />,
        },
  ];

  const done = () => {
    setDecision(undefined);
    setRefresh((value) => value + 1);
  };

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <Tabs
          label={t('title')}
          tabs={[
            { key: 'pending', label: t('tabPending') },
            { key: 'history', label: t('tabHistory') },
          ]}
          value={tab}
          onChange={setTab}
        />
        <DataTable
          caption={tab === 'pending' ? t('tabPending') : t('tabHistory')}
          columns={columns}
          rows={rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: tab === 'pending' ? t('emptyPending') : t('emptyHistory') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
      {decision?.kind === 'approve' ? (
        <ApproveDialog
          key={decision.approval.id}
          approval={decision.approval}
          detail={detail(decision.approval)}
          onClose={() => {
            setDecision(undefined);
          }}
          onDone={done}
        />
      ) : null}
      {decision?.kind === 'reject' ? (
        <RejectDialog
          key={decision.approval.id}
          approval={decision.approval}
          onClose={() => {
            setDecision(undefined);
          }}
          onDone={done}
        />
      ) : null}
    </>
  );
}

function ApproveDialog({
  approval,
  detail,
  onClose,
  onDone,
}: {
  approval: Approval;
  detail: string;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('admin.approvals');
  const tRoot = useTranslations();
  const toast = useToast();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  async function confirm() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/approvals/{approvalId}/approve',
        { params: { path: { approvalId: approval.id } } },
      );
      if (data !== undefined) {
        toast.notify('success', t('approvedToast'));
        onDone();
        return;
      }
      setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <ConfirmDialog
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
      title={t('approveTitle')}
      description={t('approveMessage')}
      confirmLabel={t('approveConfirm')}
      onConfirm={() => void confirm()}
      loading={saving}
    >
      {error !== undefined ? (
        <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
      ) : null}
      <DescriptionList
        items={[
          { label: t('type'), value: t(`types.${approval.type}`) },
          { label: t('subject'), value: approval.subject },
          { label: t('detail'), value: detail },
          { label: t('initiator'), value: approval.initiatorName },
        ]}
      />
    </ConfirmDialog>
  );
}

function RejectDialog({
  approval,
  onClose,
  onDone,
}: {
  approval: Approval;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('admin.approvals');
  const tRoot = useTranslations();
  const toast = useToast();
  const [reason, setReason] = useState('');
  const [reasonError, setReasonError] = useState<string | undefined>(undefined);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (reason.trim() === '') {
      setReasonError(tRoot('admin.merchants.form.required'));
      return;
    }
    setReasonError(undefined);
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/approvals/{approvalId}/reject',
        { params: { path: { approvalId: approval.id } }, body: { reason: reason.trim() } },
      );
      if (data !== undefined) {
        toast.notify('success', t('rejectedToast'));
        onDone();
        return;
      }
      setError(problem);
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
      title={t('rejectTitle')}
      description={approval.subject}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          label={t('rejectReason')}
          error={reasonError}
          value={reason}
          maxLength={500}
          onChange={(event) => {
            setReason(event.target.value);
          }}
        />
        <div className="flex justify-end">
          <Button type="submit" variant="danger" loading={saving}>
            {t('rejectConfirm')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
