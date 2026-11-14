'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type ReactNode } from 'react';
import { Link } from '@/i18n/navigation';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { useCan } from '@/lib/session/session-context';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { CreditTypeBadge, CreditTypeBalanceCards } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { Tabs } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { AdminAddEmployee, AdminArchiveTemplate } from './client-actions';
import { KycStatusBadge } from './kyc-status-badge';
import { TeamUsers, type TeamScope } from '@/components/team/team-users';

type CompanyOverview = Schemas['CompanyOverview'];
type MerchantOverview = Schemas['MerchantOverview'];
type CompanyTab =
  | 'info'
  | 'kyc'
  | 'users'
  | 'departments'
  | 'employees'
  | 'balances'
  | 'orders'
  | 'allocations'
  | 'invoices';
type MerchantTab = 'info' | 'kyc' | 'users' | 'sales' | 'payouts';

const linkClass = 'font-label text-navy underline-offset-2 hover:underline';

/**
 * Full company record (processus v2): one tab per subject; « Informations » keeps the editable
 * record (grid and RIB in four eyes, history). Each line opens the page with its actions.
 */
export function CompanyTabs({ companyId, info }: { companyId: string; info: ReactNode }) {
  const t = useTranslations('admin.clientTabs');
  const [tab, setTab] = useState<CompanyTab>('info');
  const overview = useApiQuery(
    () =>
      getApi().GET('/v1/admin/companies/{companyId}/overview', {
        params: { path: { companyId } },
      }),
    [companyId],
  );
  const keys: CompanyTab[] = [
    'info',
    'kyc',
    'users',
    'departments',
    'employees',
    'balances',
    'orders',
    'allocations',
    'invoices',
  ];
  return (
    <>
      <Tabs
        label={t('label')}
        tabs={keys.map((key) => ({ key, label: t(`tabs.${key}`) }))}
        value={tab}
        onChange={setTab}
      />
      {tab === 'info' ? (
        info
      ) : overview.status === 'loading' ? (
        <LoadingBlock lines={6} />
      ) : overview.status === 'error' ? (
        <ErrorState error={overview.error} onRetry={overview.reload} />
      ) : (
        <CompanyTabContent
          tab={tab}
          data={overview.data}
          companyId={companyId}
          reload={overview.reload}
        />
      )}
    </>
  );
}

function CompanyTabContent({
  tab,
  data,
  companyId,
  reload,
}: {
  tab: CompanyTab;
  data: CompanyOverview;
  companyId: string;
  reload: () => void;
}) {
  const t = useTranslations('admin.clientTabs');
  const locale = useLocale();
  // Adding an employee and switching a template off: the super-admin (companies.manage).
  const canManage = useCan('companies.manage');
  switch (tab) {
    case 'kyc':
      return <KycTab kyc={data.kyc} />;
    case 'users':
      return (
        <UsersTab
          users={data.users}
          scope={{ kind: 'admin', tenant: 'COMPANY', tenantId: companyId }}
          onChange={reload}
        />
      );
    case 'departments': {
      const columns: Column<Schemas['Department']>[] = [
        { key: 'name', header: t('name'), cell: (row) => row.name },
        {
          key: 'count',
          header: t('employeeCount'),
          align: 'end',
          cell: (row) => row.employeeCount,
        },
        {
          key: 'state',
          header: t('state'),
          cell: (row) => (row.archived ? t('archived') : t('open')),
        },
      ];
      return (
        <Card>
          <DataTable
            caption={t('tabs.departments')}
            columns={columns}
            rows={data.departments}
            rowKey={(row) => row.id}
            empty={{ title: t('empty') }}
          />
        </Card>
      );
    }
    case 'employees': {
      const columns: Column<Schemas['OverviewEmployee']>[] = [
        { key: 'number', header: t('number'), cell: (row) => row.employeeNumber },
        { key: 'name', header: t('name'), cell: (row) => `${row.firstName} ${row.lastName}` },
        { key: 'department', header: t('department'), cell: (row) => row.departmentName ?? '—' },
        { key: 'position', header: t('position'), cell: (row) => row.position ?? '—' },
        {
          key: 'status',
          header: t('status'),
          cell: (row) => <StatusBadge status={row.status} context="user" />,
        },
      ];
      return (
        <Card>
          <div className="mb-3 flex flex-wrap items-center justify-between gap-3">
            <p className="text-caption text-text-muted">
              {t('employeesShown', { shown: data.employees.length, total: data.employeeCount })}
            </p>
            {canManage ? (
              <AdminAddEmployee
                companyId={companyId}
                departments={data.departments}
                onCreated={reload}
              />
            ) : null}
          </div>
          <DataTable
            caption={t('tabs.employees')}
            columns={columns}
            rows={data.employees}
            rowKey={(row) => row.id}
            empty={{ title: t('empty') }}
          />
        </Card>
      );
    }
    case 'balances':
      return (
        <div className="flex flex-col gap-3">
          <CreditTypeBalanceCards balances={data.balances} progress="share" />
          <p className="text-caption text-text-muted">{t('balancesHint')}</p>
        </div>
      );
    case 'orders': {
      const columns: Column<Schemas['OverviewOrder']>[] = [
        {
          key: 'reference',
          header: t('reference'),
          cell: (row) => (
            <Link href={`/admin/commandes/${row.id}`} className={linkClass}>
              {row.reference}
            </Link>
          ),
        },
        { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.createdAt, locale) },
        {
          key: 'status',
          header: t('status'),
          cell: (row) => <StatusBadge status={row.status} context="order" />,
        },
        {
          key: 'amount',
          header: t('credits'),
          align: 'end',
          cell: (row) => <Amount millimes={row.amountMillimes} />,
        },
        {
          key: 'total',
          header: t('total'),
          align: 'end',
          cell: (row) => <Amount millimes={row.totalMillimes} />,
        },
      ];
      return (
        <Card>
          <DataTable
            caption={t('tabs.orders')}
            columns={columns}
            rows={data.orders}
            rowKey={(row) => row.id}
            empty={{ title: t('empty') }}
          />
        </Card>
      );
    }
    case 'allocations': {
      const history: Column<Schemas['OverviewAllocation']>[] = [
        {
          key: 'date',
          header: t('date'),
          cell: (row) => formatDateTime(row.allocatedAt, locale),
        },
        { key: 'lines', header: t('lines'), align: 'end', cell: (row) => row.lineCount },
        {
          key: 'total',
          header: t('total'),
          align: 'end',
          cell: (row) => <Amount millimes={row.totalMillimes} />,
        },
        { key: 'template', header: t('template'), cell: (row) => row.templateName ?? '—' },
      ];
      const templates: Column<Schemas['AllocationTemplate']>[] = [
        { key: 'name', header: t('name'), cell: (row) => row.name },
        {
          key: 'filters',
          header: t('filters'),
          cell: (row) =>
            `${row.departmentName ?? t('allDepartments')} · ${row.position ?? t('allPositions')}`,
        },
        {
          key: 'amounts',
          header: t('amounts'),
          cell: (row) => (
            <span className="flex flex-wrap gap-2">
              {row.amounts.map((amount) => (
                <span key={amount.creditType} className="flex items-center gap-1">
                  <CreditTypeBadge type={amount.creditType} />
                  <Amount millimes={amount.amountMillimes} />
                </span>
              ))}
            </span>
          ),
        },
        {
          key: 'lastRun',
          header: t('lastRun'),
          cell: (row) =>
            row.lastRunAt === null ? t('never') : formatDateTime(row.lastRunAt, locale),
        },
        ...(canManage
          ? [
              {
                key: 'actions',
                header: t('actions'),
                cell: (row: Schemas['AllocationTemplate']) => (
                  <AdminArchiveTemplate companyId={companyId} template={row} onDone={reload} />
                ),
              },
            ]
          : []),
      ];
      return (
        <div className="flex flex-col gap-6">
          <Card>
            <DataTable
              caption={t('history')}
              columns={history}
              rows={data.allocations}
              rowKey={(row) => row.transactionId}
              empty={{ title: t('empty') }}
            />
          </Card>
          <Card>
            <DataTable
              caption={t('templates')}
              columns={templates}
              rows={data.templates}
              rowKey={(row) => row.id}
              empty={{ title: t('empty') }}
            />
          </Card>
        </div>
      );
    }
    case 'invoices': {
      const columns: Column<Schemas['OverviewInvoice']>[] = [
        { key: 'number', header: t('number'), cell: (row) => row.number },
        { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.issuedAt, locale) },
        { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
        {
          key: 'total',
          header: t('total'),
          align: 'end',
          cell: (row) => <Amount millimes={row.totalMillimes} />,
        },
      ];
      return (
        <Card>
          <DataTable
            caption={t('tabs.invoices')}
            columns={columns}
            rows={data.invoices}
            rowKey={(row) => row.id}
            empty={{ title: t('empty') }}
          />
        </Card>
      );
    }
    default:
      return null;
  }
}

/** Full merchant record (processus v2): Informations, Dossier KYC, Utilisateurs, Ventes, Virements. */
export function MerchantTabs({ merchantId, info }: { merchantId: string; info: ReactNode }) {
  const t = useTranslations('admin.clientTabs');
  const locale = useLocale();
  const [tab, setTab] = useState<MerchantTab>('info');
  const overview = useApiQuery(
    () =>
      getApi().GET('/v1/admin/merchants/{merchantId}/overview', {
        params: { path: { merchantId } },
      }),
    [merchantId],
  );
  const keys: MerchantTab[] = ['info', 'kyc', 'users', 'sales', 'payouts'];
  let content: ReactNode = info;
  if (tab !== 'info') {
    if (overview.status === 'loading') content = <LoadingBlock lines={6} />;
    else if (overview.status === 'error')
      content = <ErrorState error={overview.error} onRetry={overview.reload} />;
    else
      content = (
        <MerchantTabContent
          tab={tab}
          data={overview.data}
          locale={locale}
          merchantId={merchantId}
          reload={overview.reload}
        />
      );
  }
  return (
    <>
      <Tabs
        label={t('label')}
        tabs={keys.map((key) => ({ key, label: t(`tabs.${key}`) }))}
        value={tab}
        onChange={setTab}
      />
      {content}
    </>
  );
}

function MerchantTabContent({
  tab,
  data,
  locale,
  merchantId,
  reload,
}: {
  tab: MerchantTab;
  data: MerchantOverview;
  locale: Locale;
  merchantId: string;
  reload: () => void;
}) {
  const t = useTranslations('admin.clientTabs');
  if (tab === 'kyc') return <KycTab kyc={data.kyc} />;
  if (tab === 'users')
    return (
      <UsersTab
        users={data.users}
        scope={{ kind: 'admin', tenant: 'MERCHANT', tenantId: merchantId }}
        onChange={reload}
      />
    );
  if (tab === 'sales') {
    const columns: Column<Schemas['OverviewSale']>[] = [
      { key: 'reference', header: t('reference'), cell: (row) => row.reference },
      { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.createdAt, locale) },
      { key: 'type', header: t('type'), cell: (row) => <CreditTypeBadge type={row.creditType} /> },
      { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
      {
        key: 'amount',
        header: t('amount'),
        align: 'end',
        cell: (row) => <Amount millimes={row.amountMillimes} />,
      },
    ];
    return (
      <Card>
        <DataTable
          caption={t('tabs.sales')}
          columns={columns}
          rows={data.sales}
          rowKey={(row) => row.id}
          empty={{ title: t('empty') }}
        />
      </Card>
    );
  }
  const columns: Column<Schemas['OverviewPayout']>[] = [
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link href={`/admin/virements/${row.id}`} className={linkClass}>
          {row.reference}
        </Link>
      ),
    },
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.requestedAt, locale) },
    { key: 'type', header: t('type'), cell: (row) => <CreditTypeBadge type={row.creditType} /> },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} context="payout" />,
    },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
    },
    {
      key: 'net',
      header: t('net'),
      align: 'end',
      cell: (row) => <Amount millimes={row.netMillimes} />,
    },
    { key: 'bank', header: t('bankReference'), cell: (row) => row.bankReference ?? '—' },
  ];
  return (
    <Card>
      <DataTable
        caption={t('tabs.payouts')}
        columns={columns}
        rows={data.payouts}
        rowKey={(row) => row.id}
        empty={{ title: t('empty') }}
      />
    </Card>
  );
}

function KycTab({ kyc }: { kyc: Schemas['OverviewKyc'] | null }) {
  const t = useTranslations('admin.clientTabs');
  if (kyc === null) return <Card>{t('noKyc')}</Card>;
  return (
    <Card>
      <div className="flex flex-wrap items-center gap-3">
        <KycStatusBadge status={kyc.status} />
        <Link href={`/admin/kyc/${kyc.fileId}`} className={linkClass}>
          {t('openKyc')}
        </Link>
      </div>
      <p className="mt-3 text-caption text-text-muted">{t('kycHint')}</p>
    </Card>
  );
}

/**
 * « Utilisateurs » tab (request of 2026-11-14): every sign-in account of the client. The
 * super-admin creates, edits (name, role), deactivates and generates a new password, each action
 * in the audit log; Opérations, Finance and Support read only.
 */
function UsersTab({
  users,
  scope,
  onChange,
}: {
  users: readonly Schemas['OverviewUser'][];
  scope: TeamScope;
  onChange: () => void;
}) {
  const t = useTranslations('account.team');
  const canManage = useCan('users.manage');
  return (
    <Card>
      <p className="mb-3 text-caption text-text-muted">
        {canManage ? t('adminHint') : t('readOnlyHint')}
      </p>
      <TeamUsers scope={scope} users={users} canManage={canManage} onChange={onChange} />
    </Card>
  );
}
