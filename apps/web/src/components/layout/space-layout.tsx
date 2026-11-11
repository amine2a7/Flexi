'use client';

import { WEB_CHANNEL_HEADER, type Schemas } from '@flexipay/api-client';
import { CircleHelp, Compass, LogOut, Menu, ShieldOff, X, Zap } from 'lucide-react';
import * as Dialog from '@radix-ui/react-dialog';
import { useTranslations } from 'next-intl';
import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';
import { Link, usePathname, useRouter } from '@/i18n/navigation';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { asProblem } from '@/lib/api/problem';
import { messageKey } from '@/i18n/keys';
import { cn } from '@/lib/cn';
import { resetAuthFlow } from '@/lib/session/auth-flow';
import { SPACE_HOME } from '@/lib/session/return-to';
import { canOpen, firstOpenPage } from '@/lib/session/permissions';
import { SessionProvider, type Me } from '@/lib/session/session-context';
import { buttonClasses } from '@/components/ui/button';
import { PageEyebrowContext } from '@/components/ui/layout-blocks';
import { LoadingBlock } from '@/components/ui/states';
import { ToastProvider } from '@/components/ui/toast';
import { CounterBadge } from './counter-badge';
import { LocaleSwitcher } from './locale-switcher';
import { HELP_ANCHORS } from '@/components/public/help-topics';
import { NAVIGATION, isActive, isGroup, navLinks, type NavEntry } from './nav-config';
import { OnboardingTour, hasTour, useOnboardingTour } from './onboarding-tour';
import { useNavCounters } from './nav-counters';
import { SessionWatch } from './session-watch';
import { SideNav } from './side-nav';
import { SkipLink } from './skip-link';

type Role = Schemas['Role'];

type GateState =
  | { readonly status: 'loading' }
  | { readonly status: 'ready'; readonly me: Me }
  | { readonly status: 'forbidden'; readonly me: Me };

/**
 * Layout of a web space: loads `/v1/me`, sends anonymous users to /login (with a validated
 * returnTo) and shows the 403 page to another role. This is a display comfort: the API refuses
 * every request of the wrong role anyway (guide §7.2).
 */
export function SpaceLayout({ role, children }: { role: Role; children: ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [state, setState] = useState<GateState>({ status: 'loading' });

  useEffect(() => {
    let active = true;
    getApi()
      .GET('/v1/me')
      .then(({ data, error }) => {
        if (!active) return;
        if (data !== undefined) {
          setState(
            data.role === role || (role === 'EMPLOYEE' && data.role === 'FAMILY_MEMBER')
              ? { status: 'ready', me: data }
              : { status: 'forbidden', me: data },
          );
          return;
        }
        const code = asProblem(error)?.code;
        if (code === 'PASSWORD_CHANGE_REQUIRED') router.replace('/login/premiere-connexion');
        else if (code === 'MFA_ENROLLMENT_REQUIRED') router.replace('/login/mfa/activation');
        else router.replace(`/login?returnTo=${encodeURIComponent(pathname)}`);
      })
      .catch(() => {
        if (active) router.replace('/login');
      });
    return () => {
      active = false;
    };
  }, [role, router, pathname]);

  const signOut = useCallback(async () => {
    await getApi()
      .POST('/v1/auth/logout', { params: { header: WEB_CHANNEL_HEADER } })
      .catch(() => undefined);
    setCsrfToken(undefined);
    resetAuthFlow();
    router.replace('/login');
  }, [router]);

  if (state.status === 'loading') {
    return (
      <main id="main-content" className="mx-auto w-full max-w-desktop-max-width p-6">
        <LoadingBlock lines={6} />
      </main>
    );
  }
  if (state.status === 'forbidden') return <Forbidden me={state.me} />;

  return (
    <SessionProvider value={{ me: state.me, signOut }}>
      <ToastProvider>
        <Shell me={state.me} role={role} onSignOut={signOut}>
          {children}
        </Shell>
      </ToastProvider>
    </SessionProvider>
  );
}

function Forbidden({ me }: { me: Me }) {
  const t = useTranslations();
  const home = SPACE_HOME[me.role];
  return (
    <main
      id="main-content"
      className="mx-auto flex max-w-form-max-width flex-col items-center gap-4 px-4 py-12 text-center"
    >
      <ShieldOff aria-hidden="true" className="size-icon-lg text-danger" />
      <h1 className="text-headline text-text">{t('layout.forbidden.title')}</h1>
      <p className="text-body-lg text-text-muted">{t('layout.forbidden.message')}</p>
      {home !== undefined ? (
        <Link href={home} className={buttonClasses('primary')}>
          {t('layout.forbidden.action')}
        </Link>
      ) : null}
    </main>
  );
}

/** A page the sub-role may not open, reached by its URL: said plainly, inside the shell. */
function PageForbidden({ home }: { home: string | undefined }) {
  const t = useTranslations();
  return (
    <div className="mx-auto flex max-w-form-max-width flex-col items-center gap-4 px-4 py-12 text-center">
      <ShieldOff aria-hidden="true" className="size-icon-lg text-danger" />
      <h1 className="text-headline text-text">{t('layout.pageForbidden.title')}</h1>
      <p className="text-body-lg text-text-muted">{t('layout.pageForbidden.message')}</p>
      {home !== undefined ? (
        <Link href={home} className={buttonClasses('primary')}>
          {t('layout.pageForbidden.action')}
        </Link>
      ) : null}
    </div>
  );
}

interface ShellProps {
  readonly me: Me;
  readonly role: Role;
  readonly onSignOut: () => Promise<void>;
  readonly children: ReactNode;
}

function Shell({ me, role, onSignOut, children }: ShellProps) {
  const t = useTranslations();
  const pathname = usePathname();
  const [menuOpen, setMenuOpen] = useState(false);
  const router = useRouter();
  // Only the pages the session may open (decision C); a category left empty is hidden. The API
  // refuses the others anyway.
  const entries = useMemo(
    () =>
      (NAVIGATION[role] ?? []).flatMap((entry): NavEntry[] => {
        if (!isGroup(entry)) return canOpen(me, entry.href) ? [entry] : [];
        const items = entry.items.filter((item) => canOpen(me, item.href));
        return items.length === 0 ? [] : [{ ...entry, items }];
      }),
    [role, me],
  );
  const items = useMemo(() => navLinks(entries), [entries]);
  const home = SPACE_HOME[role] ?? '/';
  const counts = useNavCounters(me, pathname);
  const pageOpen = canOpen(me, pathname);
  // Home denied (support has no dashboard): land on the first page of the menu instead.
  const landing =
    pathname === home && !pageOpen
      ? firstOpenPage(
          me,
          items.map((item) => item.href),
        )
      : undefined;
  useEffect(() => {
    if (landing !== undefined) router.replace(landing);
  }, [landing, router]);
  const tour = useOnboardingTour(role, me);
  const helpHref = `/aide#${HELP_ANCHORS[role === 'FAMILY_MEMBER' ? 'EMPLOYEE' : role]}`;
  const secondary =
    'flex min-h-touch-target-mobile w-full items-center gap-3 rounded-button px-3 text-label text-on-navy-muted transition-colors duration-fast hover:bg-navy-deep hover:text-on-navy focus-visible:focus-ring-on-dark lg:min-h-touch-target-min';

  const navList = (
    <SideNav
      entries={entries}
      pathname={pathname}
      home={home}
      counts={counts}
      userId={me.id}
      onNavigate={() => {
        setMenuOpen(false);
      }}
    />
  );

  const brand = (
    <div className="flex items-center gap-3 px-2">
      <span
        aria-hidden="true"
        className="flex size-avatar-md shrink-0 items-center justify-center rounded-button bg-emerald text-on-emerald"
      >
        <Zap className="size-icon-md" />
      </span>
      <span className="flex flex-col">
        <span className="text-title-sm text-on-navy">{t('app.name')}</span>
        <span className="text-micro uppercase tracking-widest text-on-navy-muted">
          {t('layout.tagline')}
        </span>
      </span>
    </div>
  );

  const sidebar = (
    <>
      {brand}
      <div className="flex flex-1 flex-col gap-3 border-t border-navy-deep pt-5">
        <p className="px-3 text-micro uppercase tracking-widest text-on-navy-muted">
          {t(`layout.space.${role}`)}
        </p>
        <nav aria-label={t('layout.mainNav')}>{navList}</nav>
      </div>
      <div className="flex flex-col gap-1 border-t border-navy-deep pt-4">
        <Link
          href={helpHref}
          onClick={() => {
            setMenuOpen(false);
          }}
          className={secondary}
        >
          <CircleHelp aria-hidden="true" className="size-icon-md shrink-0" />
          {t('layout.helpCentre')}
        </Link>
        {hasTour(role) ? (
          <button
            type="button"
            onClick={() => {
              setMenuOpen(false);
              tour.start();
            }}
            className={secondary}
          >
            <Compass aria-hidden="true" className="size-icon-md shrink-0" />
            {t('layout.replayTour')}
          </button>
        ) : null}
        <button type="button" onClick={() => void onSignOut()} className={secondary}>
          <LogOut aria-hidden="true" className="size-icon-md shrink-0 rtl:rotate-180" />
          {t('layout.signOut')}
        </button>
      </div>
    </>
  );

  return (
    <div className="flex min-h-screen bg-bg">
      <SkipLink />
      <aside className="sticky top-0 hidden h-screen w-sidebar-width shrink-0 flex-col gap-6 overflow-y-auto bg-navy p-4 lg:flex">
        {sidebar}
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex min-h-header-height items-center justify-between gap-3 border-b border-border bg-surface px-4 py-2 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <Dialog.Root open={menuOpen} onOpenChange={setMenuOpen}>
              <Dialog.Trigger
                aria-label={t('layout.openMenu')}
                className="flex size-touch-target-mobile items-center justify-center rounded-button text-navy hover:bg-bg lg:hidden"
              >
                <Menu aria-hidden="true" className="size-icon-md" />
              </Dialog.Trigger>
              <Dialog.Portal>
                <Dialog.Overlay className="fixed inset-0 z-40 bg-overlay backdrop-blur-sm lg:hidden" />
                <Dialog.Content className="fixed inset-y-0 start-0 z-50 flex w-sidebar-width max-w-full flex-col gap-6 overflow-y-auto bg-navy p-4 lg:hidden">
                  <div className="flex justify-end">
                    <Dialog.Close
                      aria-label={t('layout.closeMenu')}
                      className="flex size-touch-target-mobile items-center justify-center rounded-button text-on-navy focus-visible:focus-ring-on-dark"
                    >
                      <X aria-hidden="true" className="size-icon-md" />
                    </Dialog.Close>
                  </div>
                  <Dialog.Title className="sr-only">{t('layout.mainNav')}</Dialog.Title>
                  <Dialog.Description className="sr-only">
                    {t(`layout.space.${role}`)}
                  </Dialog.Description>
                  {sidebar}
                </Dialog.Content>
              </Dialog.Portal>
            </Dialog.Root>
            <div className="flex min-w-0 flex-col">
              <p className="truncate text-label text-text">
                {/* Isolated name: a Latin name never moves the punctuation of an Arabic sentence. */}
                {t('layout.hello', { name: `⁨${me.displayName}⁩` })}
              </p>
              <p className="hidden truncate text-caption text-text-muted sm:block">
                {t('layout.secure', { tenant: me.tenant?.label ?? t('app.name') })}
              </p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <span className="hidden min-h-chip-height items-center rounded-badge bg-emerald-soft px-3 text-caption font-label text-emerald-text md:inline-flex">
              {t(`layout.role.${role}`)}
            </span>
            <div className="hidden flex-col items-end md:flex">
              <span className="text-label text-text">{me.displayName}</span>
              <span className="text-caption text-text-muted">{t('layout.activeAccount')}</span>
            </div>
            <Link
              href={helpHref}
              aria-label={t('layout.help')}
              className="flex size-touch-target-mobile items-center justify-center rounded-button text-navy hover:bg-bg lg:size-touch-target-min"
            >
              <CircleHelp aria-hidden="true" className="size-icon-md" />
            </Link>
            <LocaleSwitcher />
          </div>
        </header>
        <main
          id="main-content"
          tabIndex={-1}
          className="mx-auto w-full max-w-desktop-max-width flex-1 px-4 py-6 lg:px-8 lg:py-8"
        >
          <PageEyebrowContext.Provider value={t(`layout.eyebrow.${role}`)}>
            {/* Animation 1: page content enters in cascade; sidebar and header never move. */}
            <div className="fp-cascade">
              {pageOpen ? (
                children
              ) : landing === undefined ? (
                <PageForbidden home={items[0]?.href} />
              ) : null}
            </div>
          </PageEyebrowContext.Provider>
          {role === 'EMPLOYEE' ? (
            <div aria-hidden="true" className="h-bottom-nav-height lg:hidden" />
          ) : null}
        </main>
      </div>
      {role === 'EMPLOYEE' ? (
        <nav
          aria-label={t('layout.mainNav')}
          className="fixed inset-x-0 bottom-0 z-30 border-t border-border bg-surface lg:hidden"
        >
          <ul className="flex h-bottom-nav-height items-stretch">
            {items.slice(0, 4).map((item) => {
              const active = isActive(item, pathname, home);
              const Icon = item.icon;
              const count = item.counter === undefined ? 0 : (counts[item.counter] ?? 0);
              return (
                <li key={item.href} className="flex flex-1">
                  <Link
                    href={item.href}
                    aria-current={active ? 'page' : undefined}
                    className={cn(
                      'relative flex flex-1 flex-col items-center justify-center gap-1 text-micro',
                      active ? 'text-navy' : 'text-text-muted',
                    )}
                  >
                    <Icon aria-hidden="true" className="size-icon-md" />
                    {t(messageKey(item.labelKey))}
                    {count > 0 ? (
                      <CounterBadge
                        count={count}
                        className="absolute end-1/4 top-2 flex min-w-icon-sm items-center justify-center rounded-badge bg-emerald px-1 text-micro text-on-emerald"
                      />
                    ) : null}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
      ) : null}
      <SessionWatch onExpire={onSignOut} />
      {tour.open && hasTour(role) ? <OnboardingTour role={role} onClose={tour.close} /> : null}
    </div>
  );
}
