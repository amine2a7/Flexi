'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useSession } from '@/lib/session/session-context';
import { PasswordFields } from '@/components/auth/password-fields';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';

/**
 * Paramètres du compte (commun-parametres-compte.md), shared by the three spaces: profile (read
 * only), language, password change, two-step verification status. Nothing of the tenant here.
 */
export function AccountSettings() {
  const t = useTranslations('account.settings');
  const tRole = useTranslations('layout.role');
  const tSubRole = useTranslations('subRole');
  const tRoot = useTranslations();
  const { me } = useSession();
  const [current, setCurrent] = useState('');
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [done, setDone] = useState(false);

  const ready = current !== '' && password !== '' && password === confirmation;

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    if (!ready) return;
    setSaving(true);
    setError(undefined);
    setDone(false);
    try {
      const { error: problem } = await getApi().POST('/v1/auth/password/change', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { currentPassword: current, newPassword: password },
      });
      if (problem !== undefined) {
        setError(problem);
        return;
      }
      setDone(true);
      setCurrent('');
      setPassword('');
      setConfirmation('');
    } catch (failure) {
      setError(failure);
    } finally {
      setSaving(false);
    }
  }

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle>{t('profile')}</CardTitle>
          <DescriptionList
            items={[
              { label: t('name'), value: me.displayName },
              {
                label: t('role'),
                value:
                  me.subRole === null
                    ? tRole(me.role)
                    : `${tRole(me.role)} · ${tSubRole(me.subRole)}`,
              },
              ...(me.tenant === null ? [] : [{ label: t('space'), value: me.tenant.label }]),
            ]}
          />
          <p className="mt-4 text-caption text-text-muted">{t('profileHint')}</p>
        </Card>
        <Card>
          <CardTitle description={t('languageHint')}>{t('language')}</CardTitle>
          <LocaleSwitcher />
        </Card>
        <Card>
          <CardTitle description={t('passwordHint')}>{t('password')}</CardTitle>
          <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
            <TextField
              label={t('currentPassword')}
              type="password"
              autoComplete="current-password"
              required
              value={current}
              onChange={(event) => {
                setCurrent(event.target.value);
              }}
            />
            <PasswordFields
              password={password}
              confirmation={confirmation}
              onPassword={setPassword}
              onConfirmation={setConfirmation}
            />
            {error !== undefined ? (
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
            ) : null}
            {done ? (
              <div role="status">
                <Alert tone="success">{t('passwordDone')}</Alert>
              </div>
            ) : null}
            <Button type="submit" loading={saving} disabled={!ready} className="self-start">
              {t('passwordSubmit')}
            </Button>
          </form>
        </Card>
        <Card>
          <CardTitle>{t('mfa')}</CardTitle>
          <DescriptionList
            items={[
              { label: t('mfaStatus'), value: me.mfa.enrolled ? t('mfaOn') : t('mfaOff') },
              {
                label: t('recoveryCodes'),
                value: t('recoveryRemaining', { count: me.mfa.recoveryCodesRemaining }),
              },
            ]}
          />
          <p className="mt-4 text-caption text-text-muted">{t('mfaHint')}</p>
        </Card>
      </div>
    </>
  );
}
