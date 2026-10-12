'use client';

import { WEB_CHANNEL_HEADER, type Schemas } from '@flexipay/api-client';
import { LogOut, Menu, ShieldOff, X } from 'lucide-react';
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
import { SessionProvider, type Me } from '@/lib/session/session-context';
import { buttonClasses } from '@/components/ui/button';
import { LoadingBlock } from '@/components/ui/states';
import { ToastProvider } from '@/components/ui/toast';
import { LocaleSwitcher } from './locale-switcher';
import { NAVIGATION, isActive } from './nav-config';
import { SessionWatch } from './session-watch';
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
            data.role === role ? { status: 'ready', me: data } : { status: 'forbidden', me: data },
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
  const items = useMemo(() => NAVIGATION[role] ?? [], [role]);
  const home = SPACE_HOME[role] ?? '/';
  const current = items.find((item) => isActive(item, pathname, home));

  const navList = (
    <ul className="flex flex-col gap-1">
      {items.map((item) => {
        const active = isActive(item, pathname, home);
        const Icon = item.icon;
        return (
          <li key={item.href}>
            <Link
              href={item.href}
              onClick={() => {
                setMenuOpen(false);
              }}
              aria-current={active ? 'page' : undefined}
              className={cn(
                'flex min-h-touch-target-min items-center gap-3 rounded-button px-3 text-label transition-colors duration-fast focus-visible:focus-ring-on-dark',
                active
                  ? 'bg-navy-deep text-on-navy'
                  : 'text-on-navy-muted hover:bg-navy-deep hover:text-on-navy',
              )}
            >
              <Icon aria-hidden="true" className="size-icon-md shrink-0" />
              {t(messageKey(item.labelKey))}
            </Link>
          </li>
        );
      })}
    </ul>
  );

  const brand = (
    <div className="flex flex-col gap-1 px-3">
      <span className="text-title text-on-navy">{t('app.name')}</span>
      <span className="text-caption text-on-navy-muted">{t(`layout.space.${role}`)}</span>
    </div>
  );

  return (
    <div className="flex min-h-screen bg-bg">
      <SkipLink />
      <aside className="hidden w-sidebar-width shrink-0 flex-col gap-6 bg-navy p-4 lg:flex">
        {brand}
        <nav aria-label={t('layout.mainNav')}>{navList}</nav>
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex h-header-height items-center justify-between gap-3 border-b border-border bg-surface px-4 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <Dialog.Root open={menuOpen} onOpenChange={setMenuOpen}>
              <Dialog.Trigger
                aria-label={t('layout.openMenu')}
                className="flex size-touch-target-min items-center justify-center rounded-button text-navy hover:bg-bg lg:hidden"
              >
                <Menu aria-hidden="true" className="size-icon-md" />
              </Dialog.Trigger>
              <Dialog.Portal>
                <Dialog.Overlay className="fixed inset-0 z-40 bg-overlay lg:hidden" />
                <Dialog.Content className="fixed inset-y-0 start-0 z-50 flex w-sidebar-width max-w-full flex-col gap-6 overflow-y-auto bg-navy p-4 lg:hidden">
                  <div className="flex items-start justify-between">
                    {brand}
                    <Dialog.Close
                      aria-label={t('layout.closeMenu')}
                      className="flex size-touch-target-min items-center justify-center rounded-button text-on-navy focus-visible:focus-ring-on-dark"
                    >
                      <X aria-hidden="true" className="size-icon-md" />
                    </Dialog.Close>
                  </div>
                  <Dialog.Title className="sr-only">{t('layout.mainNav')}</Dialog.Title>
                  <Dialog.Description className="sr-only">
                    {t(`layout.space.${role}`)}
                  </Dialog.Description>
                  <nav aria-label={t('layout.mainNav')}>{navList}</nav>
                </Dialog.Content>
              </Dialog.Portal>
            </Dialog.Root>
            <p className="truncate text-label text-text">
              {current !== undefined ? t(messageKey(current.labelKey)) : t(`layout.space.${role}`)}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <div className="hidden flex-col items-end sm:flex">
              <span className="text-label text-text">{me.displayName}</span>
              <span className="text-caption text-text-muted">
                {me.tenant?.label ?? t(`layout.space.${role}`)}
              </span>
            </div>
            <LocaleSwitcher />
            <button
              type="button"
              onClick={() => void onSignOut()}
              className={buttonClasses('ghost', 'sm')}
            >
              <LogOut aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
              <span className="hidden sm:inline">{t('layout.signOut')}</span>
              <span className="sr-only sm:hidden">{t('layout.signOut')}</span>
            </button>
          </div>
        </header>
        <main
          id="main-content"
          tabIndex={-1}
          className="mx-auto w-full max-w-desktop-max-width flex-1 px-4 py-6 lg:px-8"
        >
          {children}
        </main>
      </div>
      <SessionWatch onExpire={onSignOut} />
    </div>
  );
}
