'use client';

import type { Schemas } from '@flexipay/api-client';
import { Check, Circle } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { getApi } from '@/lib/api/client';
import { TextField } from '@/components/ui/field';

type Rule = Schemas['PasswordPolicyRule'];

interface PasswordFieldsProps {
  readonly password: string;
  readonly confirmation: string;
  readonly onPassword: (value: string) => void;
  readonly onConfirmation: (value: string) => void;
  readonly serverError?: string;
}

/**
 * New password + confirmation, with the rules published by the server (GET
 * /v1/auth/password-policy, decision 9). The length rules are shown as a checklist while typing;
 * the server stays the judge (it alone knows the compromised-password list).
 */
export function PasswordFields({
  password,
  confirmation,
  onPassword,
  onConfirmation,
  serverError,
}: PasswordFieldsProps) {
  const t = useTranslations('auth.password');
  const [rules, setRules] = useState<readonly Rule[]>([]);

  useEffect(() => {
    let active = true;
    getApi()
      .GET('/v1/auth/password-policy')
      .then(({ data }) => {
        if (active && data !== undefined) setRules(data.rules);
      })
      .catch(() => undefined);
    return () => {
      active = false;
    };
  }, []);

  const min = rules.find((rule) => rule.code === 'MIN_LENGTH')?.params?.min;
  const max = rules.find((rule) => rule.code === 'MAX_LENGTH')?.params?.max;
  const mismatch = confirmation !== '' && confirmation !== password;

  return (
    <div className="flex flex-col gap-5">
      <TextField
        label={t('new')}
        type="password"
        autoComplete="new-password"
        value={password}
        error={serverError}
        onChange={(event) => {
          onPassword(event.target.value);
        }}
      />
      {rules.length > 0 ? (
        <ul
          aria-label={t('rulesTitle')}
          className="flex flex-col gap-1 text-caption text-text-muted"
        >
          {min !== undefined ? (
            <RuleItem ok={password.length >= min} label={t('minLength', { min })} />
          ) : null}
          {max !== undefined ? (
            <RuleItem ok={password.length > 0 && password.length <= max} label={t('maxLength', { max })} />
          ) : null}
          {rules.some((rule) => rule.code === 'NOT_COMPROMISED') ? (
            <RuleItem ok={undefined} label={t('notCompromised')} />
          ) : null}
          {rules.some((rule) => rule.code === 'NOT_IDENTIFIER') ? (
            <RuleItem ok={undefined} label={t('notIdentifier')} />
          ) : null}
        </ul>
      ) : null}
      <TextField
        label={t('confirm')}
        type="password"
        autoComplete="new-password"
        value={confirmation}
        error={mismatch ? t('mismatch') : undefined}
        onChange={(event) => {
          onConfirmation(event.target.value);
        }}
      />
    </div>
  );
}

function RuleItem({ ok, label }: { ok: boolean | undefined; label: string }) {
  return (
    <li className="flex items-center gap-2">
      {ok === true ? (
        <Check aria-hidden="true" className="size-icon-sm text-emerald-text" />
      ) : (
        <Circle aria-hidden="true" className="size-icon-sm" />
      )}
      <span>{label}</span>
    </li>
  );
}
