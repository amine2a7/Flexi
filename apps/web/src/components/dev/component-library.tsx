'use client';

import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { Check, Plus, Trash2 } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useState, type ReactNode } from 'react';
import { Link } from '@/i18n/navigation';
import { cn } from '@/lib/cn';
import { Amount, AmountBreakdown, Rate } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button, type ButtonVariant } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { Countdown } from '@/components/ui/countdown';
import { CreditTypeBadges, CreditTypeCheckboxes } from '@/components/ui/credit-type';
import { DataTable } from '@/components/ui/data-table';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { Alert, DescriptionList, Tabs } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { QrCode } from '@/components/ui/qr-code';
import { ResultScreen } from '@/components/ui/result-screen';
import { EmptyState, ErrorState, LoadingBlock, Skeleton } from '@/components/ui/states';
import { KNOWN_STATUSES, StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';
import { ToastProvider, useToast } from '@/components/ui/toast';

/** Marker of the library: the build test fails if it ever reaches a production bundle. */
export const DEV_LIBRARY_MARKER = '__FLEXIPAY_DEV_LIBRARY__';

// Synthetic values of the glossary only (spec §2.4): never data of a real environment.
const MAX_MILLIMES = 9_007_199_254_740_991;
const LOCALES = [
  { code: 'fr', label: 'Français' },
  { code: 'ar', label: 'العربية' },
  { code: 'en', label: 'English' },
] as const;
const SCREENS = (tokensPreset.theme as { screens: Record<string, string> }).screens;
const SIZES = (tokensPreset.theme as { size: Record<string, string> }).size;
const WIDTHS: Record<string, string | undefined> = {
  'viewport-min': SIZES['viewport-min'],
  md: SCREENS.md,
  lg: SCREENS.lg,
  xl: SCREENS.xl,
  full: undefined,
};
// Test factors of the tool (WCAG 1.4.4 / 1.4.10), not design values (spec §3.1).
const TEXT_SIZES = ['100', '150', '200'] as const;
const VARIANTS: readonly ButtonVariant[] = ['primary', 'secondary', 'ghost', 'danger', 'success'];
const LONG_TEXT = 'Restaurantdelamedinaavecunnomtrèslongsansaucunespacepourtester';

interface Row {
  readonly id: string;
  readonly reference: string;
  readonly millimes: number;
  readonly status: string;
}
const ROWS: readonly Row[] = [
  {
    id: '1',
    reference: 'PAY-2026-0001',
    millimes: 45_000,
    status: 'COMPLETED',
  },
  { id: '2', reference: 'PAY-2026-0002', millimes: 900, status: 'PENDING' },
  { id: '3', reference: 'PAY-2026-0003', millimes: 44_100, status: 'REJECTED' },
];

function Section({ id, title, children }: { id: string; title: string; children: ReactNode }) {
  return (
    <section id={id} aria-labelledby={`${id}-title`} className="flex scroll-mt-8 flex-col gap-4">
      <h2 id={`${id}-title`} className="text-title-sm text-text">
        {title}
      </h2>
      {children}
    </section>
  );
}

function DemoRow({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-caption text-text-muted">{label}</p>
      <div className="flex flex-wrap items-center gap-3">{children}</div>
    </div>
  );
}

function ToastDemo() {
  const t = useTranslations('dev.library');
  const toast = useToast();
  return (
    <div className="flex flex-wrap gap-3">
      <Button
        variant="secondary"
        onClick={() => {
          toast.notify('success', t('toast.success'));
        }}
      >
        {t('toast.showSuccess')}
      </Button>
      <Button
        variant="secondary"
        onClick={() => {
          toast.notify('info', t('toast.info'));
        }}
      >
        {t('toast.showInfo')}
      </Button>
      <Button
        variant="secondary"
        onClick={() => {
          toast.notify('error', t('toast.error'));
        }}
      >
        {t('toast.showError')}
      </Button>
    </div>
  );
}

export function ComponentLibrary() {
  const t = useTranslations('dev.library');
  const locale = useLocale();
  const [width, setWidth] = useState('full');
  const [textSize, setTextSize] = useState<(typeof TEXT_SIZES)[number]>('100');
  const [reducedMotion, setReducedMotion] = useState(false);
  const [text, setText] = useState('');
  const [amount, setAmount] = useState('');
  const [types, setTypes] = useState<readonly ('RESTAURATION' | 'CADEAUX')[]>(['RESTAURATION']);
  const [tab, setTab] = useState<'one' | 'two'>('one');
  const [modalOpen, setModalOpen] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [expiresAt] = useState(() => new Date(Date.now() + 60_000).toISOString());

  // The text size control changes the root font size (rem), restored when leaving the page.
  useEffect(() => {
    const root = document.documentElement;
    const previous = root.style.fontSize;
    root.style.fontSize = textSize === '100' ? previous : `${textSize}%`;
    return () => {
      root.style.fontSize = previous;
    };
  }, [textSize]);

  const sections = [
    'buttons',
    'fields',
    'badges',
    'cards',
    'toasts',
    'amounts',
    'skeletons',
    'states',
    'table',
    'dialogs',
    'navigation',
    'misc',
  ] as const;

  return (
    <ToastProvider>
      <a href="#components" className="sr-only focus:not-sr-only">
        {t('skip')}
      </a>
      <header className="sticky top-0 z-10 flex flex-col gap-4 border-b border-border bg-surface p-4">
        <h1 className="text-headline text-text">{t('title')}</h1>
        <p className="text-body text-text-muted">{t('description')}</p>
        <div className="flex flex-wrap items-end gap-4">
          <nav aria-label={t('controls.language')} className="flex gap-2">
            {LOCALES.map((item) => (
              <Link
                key={item.code}
                href="/dev/composants"
                locale={item.code}
                lang={item.code}
                aria-current={item.code === locale ? 'true' : undefined}
                className={cn(
                  'rounded-button px-3 py-2 text-label',
                  item.code === locale ? 'bg-navy text-on-navy' : 'text-navy underline',
                )}
              >
                {item.label}
              </Link>
            ))}
          </nav>
          <SelectField
            label={t('controls.width')}
            value={width}
            onChange={(event) => {
              setWidth(event.target.value);
            }}
            options={Object.keys(WIDTHS).map((key) => ({
              value: key,
              label: t(`controls.widths.${key}` as 'controls.widths.full'),
            }))}
          />
          <SelectField
            label={t('controls.textSize')}
            value={textSize}
            onChange={(event) => {
              setTextSize(event.target.value as (typeof TEXT_SIZES)[number]);
            }}
            options={TEXT_SIZES.map((size) => ({
              value: size,
              label: `${size} %`,
            }))}
          />
          <label className="flex min-h-touch-target-min items-center gap-2 text-label text-text">
            <input
              type="checkbox"
              checked={reducedMotion}
              onChange={(event) => {
                setReducedMotion(event.target.checked);
              }}
              className="size-icon-md accent-navy"
            />
            {t('controls.reducedMotion')}
          </label>
        </div>
      </header>

      <div className="flex flex-col gap-8 p-4 lg:flex-row">
        <nav aria-label={t('summary')} className="lg:w-sidebar-width lg:shrink-0">
          <ul className="flex flex-wrap gap-2 lg:sticky lg:top-40 lg:flex-col">
            {sections.map((key) => (
              <li key={key}>
                <a href={`#${key}`} className="text-label text-navy underline">
                  {t(`sections.${key}`)}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        <main
          id="components"
          data-motion={reducedMotion ? 'reduced' : undefined}
          className="mx-auto flex w-full min-w-0 flex-col gap-10"
          style={{ maxWidth: WIDTHS[width] }}
        >
          <Section id="buttons" title={t('sections.buttons')}>
            {VARIANTS.map((variant) => (
              <DemoRow key={variant} label={variant}>
                <Button variant={variant}>{t('sample.action')}</Button>
                <Button
                  variant={variant}
                  icon={<Plus aria-hidden="true" className="size-icon-sm" />}
                >
                  {t('sample.withIcon')}
                </Button>
                <Button variant={variant} size="sm">
                  {t('sample.small')}
                </Button>
                <Button variant={variant} disabled>
                  {t('state.disabled')}
                </Button>
                <Button variant={variant} loading>
                  {t('state.loading')}
                </Button>
                <Button variant={variant} succeeded>
                  {t('state.succeeded')}
                </Button>
              </DemoRow>
            ))}
            <DemoRow label={t('state.longText')}>
              <Button className="max-w-full break-all">{LONG_TEXT}</Button>
            </DemoRow>
          </Section>

          <Section id="fields" title={t('sections.fields')}>
            <div className="grid gap-4 md:grid-cols-2">
              <TextField
                label={t('sample.label')}
                hint={t('sample.hint')}
                value={text}
                onChange={(event) => {
                  setText(event.target.value);
                }}
              />
              <TextField
                label={t('sample.label')}
                error={t('sample.error')}
                defaultValue={LONG_TEXT}
              />
              <TextField label={t('sample.label')} disabled defaultValue={t('state.disabled')} />
              <TextField label={t('sample.password')} type="password" autoComplete="new-password" />
              <SelectField
                label={t('sample.select')}
                placeholder={t('sample.placeholder')}
                options={[
                  { value: 'a', label: t('sample.optionA') },
                  { value: 'b', label: t('sample.optionB') },
                ]}
                defaultValue=""
              />
              <TextAreaField label={t('sample.textarea')} />
              <AmountField
                label={t('sample.amount')}
                value={amount}
                onChange={(next) => {
                  setAmount(next);
                }}
              />
              <CreditTypeCheckboxes
                legend={t('sample.creditTypes')}
                value={types}
                onChange={(next) => {
                  setTypes(next as readonly ('RESTAURATION' | 'CADEAUX')[]);
                }}
              />
            </div>
          </Section>

          <Section id="badges" title={t('sections.badges')}>
            <div className="flex flex-wrap gap-2">
              {KNOWN_STATUSES.map((status) => (
                <StatusBadge key={status} status={status} />
              ))}
              <StatusBadge status="UNKNOWN_STATUS" />
            </div>
            <CreditTypeBadges types={['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX']} />
          </Section>

          <Section id="cards" title={t('sections.cards')}>
            <div className="grid gap-4 md:grid-cols-3">
              <StatCard
                label={t('sample.kpi')}
                value={<Amount millimes={48_250_000} size="title" />}
              />
              <StatCard
                label={t('sample.kpi')}
                value={<Amount millimes={45_000} size="title" />}
                hint={t('sample.hint')}
                tone="positive"
              />
              <StatCard label={t('sample.kpi')} value="12" tone="attention" />
            </div>
            <Card>
              <CardTitle description={t('sample.hint')}>{t('sample.cardTitle')}</CardTitle>
              <DescriptionList
                items={[
                  { label: t('sample.label'), value: 'PAY-2026-0001' },
                  {
                    label: t('sample.amount'),
                    value: <Amount millimes={45_000} />,
                  },
                  { label: t('sample.rate'), value: <Rate bps={200} /> },
                ]}
              />
            </Card>
          </Section>

          <Section id="toasts" title={t('sections.toasts')}>
            <ToastDemo />
          </Section>

          <Section id="amounts" title={t('sections.amounts')}>
            <DemoRow label={t('sample.sizes')}>
              <Amount millimes={45_000} />
              <Amount millimes={45_000} size="title" />
              <Amount millimes={45_000} size="amount" />
              <Amount millimes={45_000} size="amount-xl" />
            </DemoRow>
            <DemoRow label={t('sample.signs')}>
              <Amount millimes={44_100} sign="credit" />
              <Amount millimes={900} sign="debit" />
            </DemoRow>
            <DemoRow label={t('state.limits')}>
              <Amount millimes={0} />
              <Amount millimes={MAX_MILLIMES} />
            </DemoRow>
            <Card>
              <AmountBreakdown
                lines={[
                  { label: t('sample.gross'), millimes: 45_000 },
                  {
                    label: t('sample.commission'),
                    millimes: 900,
                    sign: 'debit',
                    note: t('sample.rateNote'),
                  },
                ]}
                total={{ label: t('sample.net'), millimes: 44_100 }}
              />
            </Card>
          </Section>

          <Section id="skeletons" title={t('sections.skeletons')}>
            <Skeleton className="h-6 w-1/2" />
            <LoadingBlock lines={4} />
          </Section>

          <Section id="states" title={t('sections.states')}>
            <EmptyState title={t('sample.emptyTitle')} message={t('sample.emptyMessage')} />
            <ErrorState error={new Error('demo')} onRetry={() => undefined} />
            {(['info', 'success', 'warning', 'danger'] as const).map((tone) => (
              <Alert key={tone} tone={tone} title={tone}>
                {t('sample.hint')}
              </Alert>
            ))}
            <ResultScreen
              tone="success"
              title={t('sample.resultTitle')}
              description={t('sample.hint')}
              actions={<Button>{t('sample.action')}</Button>}
            />
          </Section>

          <Section id="table" title={t('sections.table')}>
            <DataTable<Row>
              caption={t('sample.tableCaption')}
              columns={[
                {
                  key: 'reference',
                  header: t('sample.label'),
                  cell: (row) => row.reference,
                  sortValue: (row) => row.reference,
                },
                {
                  key: 'amount',
                  header: t('sample.amount'),
                  align: 'end',
                  cell: (row) => <Amount millimes={row.millimes} />,
                  sortValue: (row) => row.millimes,
                },
                {
                  key: 'status',
                  header: t('sample.status'),
                  cell: (row) => <StatusBadge status={row.status} />,
                },
              ]}
              rows={ROWS}
              rowKey={(row) => row.id}
              empty={{ title: t('sample.emptyTitle') }}
            />
            <DataTable<Row>
              caption={t('state.loading')}
              columns={[
                {
                  key: 'reference',
                  header: t('sample.label'),
                  cell: (row) => row.reference,
                },
              ]}
              rows={undefined}
              loading
              rowKey={(row) => row.id}
              empty={{ title: t('sample.emptyTitle') }}
            />
            <DataTable<Row>
              caption={t('sample.emptyTitle')}
              columns={[
                {
                  key: 'reference',
                  header: t('sample.label'),
                  cell: (row) => row.reference,
                },
              ]}
              rows={[]}
              rowKey={(row) => row.id}
              empty={{
                title: t('sample.emptyTitle'),
                message: t('sample.emptyMessage'),
              }}
            />
          </Section>

          <Section id="dialogs" title={t('sections.dialogs')}>
            <div className="flex flex-wrap gap-3">
              <Button
                variant="secondary"
                onClick={() => {
                  setModalOpen(true);
                }}
              >
                {t('sample.openModal')}
              </Button>
              <Button
                variant="danger"
                icon={<Trash2 aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  setConfirmOpen(true);
                }}
              >
                {t('sample.openConfirm')}
              </Button>
            </div>
            <Modal
              open={modalOpen}
              onOpenChange={setModalOpen}
              title={t('sample.modalTitle')}
              description={t('sample.hint')}
              footer={
                <Button
                  icon={<Check aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setModalOpen(false);
                  }}
                >
                  {t('sample.action')}
                </Button>
              }
            >
              <p className="text-body text-text">{t('sample.emptyMessage')}</p>
            </Modal>
            <ConfirmDialog
              open={confirmOpen}
              onOpenChange={setConfirmOpen}
              title={t('sample.confirmTitle')}
              description={t('sample.hint')}
              confirmLabel={t('sample.action')}
              confirmVariant="danger"
              onConfirm={() => {
                setConfirmOpen(false);
              }}
            />
          </Section>

          <Section id="navigation" title={t('sections.navigation')}>
            <Tabs
              label={t('sections.navigation')}
              tabs={[
                { key: 'one', label: t('sample.optionA') },
                { key: 'two', label: t('sample.optionB') },
              ]}
              value={tab}
              onChange={setTab}
            />
            <Timeline
              entries={[
                {
                  key: '1',
                  title: t('sample.stepOne'),
                  meta: '25/10/2026 · Leïla M.',
                },
                {
                  key: '2',
                  title: t('sample.stepTwo'),
                  meta: '26/10/2026 · Sami B.',
                  detail: t('sample.hint'),
                },
                {
                  key: '3',
                  title: t('sample.stepRefused'),
                  meta: '27/10/2026',
                  tone: 'danger',
                },
              ]}
            />
          </Section>

          <Section id="misc" title={t('sections.misc')}>
            <div className="flex flex-wrap items-start gap-6">
              <Countdown expiresAt={expiresAt} total={60} />
              <QrCode value="FXP-DEMO-0000" label={t('sample.qr')} />
            </div>
          </Section>
        </main>
      </div>
    </ToastProvider>
  );
}
