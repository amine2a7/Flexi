'use client';

import {
  useId,
  type InputHTMLAttributes,
  type ReactNode,
  type Ref,
  type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';
import { cn } from '@/lib/cn';
import { useReplay } from '@/lib/motion';

/** Animation 13: the field shakes when an error appears or changes (not when it goes away). */
function useShakeOnError(error: string | undefined) {
  return useReplay(error, error !== undefined);
}

const CONTROL =
  'h-input-height w-full rounded-input border bg-surface px-4 text-body text-text placeholder:text-text-faint focus-visible:focus-ring disabled:opacity-disabled';

interface FieldFrameProps {
  readonly id: string;
  readonly label: string;
  readonly hint?: string;
  readonly error?: string;
  readonly children: ReactNode;
}

function FieldFrame({ id, label, hint, error, children }: FieldFrameProps) {
  return (
    <div className="flex flex-col gap-2">
      <label htmlFor={id} className="text-label text-text">
        {label}
      </label>
      {children}
      {hint !== undefined && error === undefined ? (
        <p id={`${id}-hint`} className="text-caption text-text-muted">
          {hint}
        </p>
      ) : null}
      {error !== undefined ? (
        <p id={`${id}-error`} className="animate-fade text-caption text-danger-text">
          {error}
        </p>
      ) : null}
    </div>
  );
}

function describedBy(id: string, hint?: string, error?: string): string | undefined {
  if (error !== undefined) return `${id}-error`;
  if (hint !== undefined) return `${id}-hint`;
  return undefined;
}

export interface TextFieldProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'id'> {
  readonly label: string;
  readonly hint?: string;
  readonly error?: string;
  readonly ref?: Ref<HTMLInputElement>;
}

/** Labelled input with hint and error message linked for screen readers. */
export function TextField({ label, hint, error, className, ...rest }: TextFieldProps) {
  const id = useId();
  const shake = useShakeOnError(error);
  return (
    <FieldFrame id={id} label={label} hint={hint} error={error}>
      <input
        id={id}
        aria-invalid={error !== undefined || undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(
          CONTROL,
          error === undefined ? 'border-border-strong' : 'border-danger',
          shake.active && 'animate-shake',
          className,
        )}
        onAnimationEnd={shake.onAnimationEnd}
        {...rest}
      />
    </FieldFrame>
  );
}

export interface SelectFieldProps extends Omit<SelectHTMLAttributes<HTMLSelectElement>, 'id'> {
  readonly label: string;
  readonly hint?: string;
  readonly error?: string;
  readonly options: readonly { readonly value: string; readonly label: string }[];
  readonly placeholder?: string;
}

/** Native select (best keyboard and screen reader support), styled like the inputs. */
export function SelectField({
  label,
  hint,
  error,
  options,
  placeholder,
  className,
  ...rest
}: SelectFieldProps) {
  const id = useId();
  const shake = useShakeOnError(error);
  return (
    <FieldFrame id={id} label={label} hint={hint} error={error}>
      <select
        id={id}
        aria-invalid={error !== undefined || undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(
          CONTROL,
          error === undefined ? 'border-border-strong' : 'border-danger',
          shake.active && 'animate-shake',
          className,
        )}
        onAnimationEnd={shake.onAnimationEnd}
        {...rest}
      >
        {placeholder !== undefined ? <option value="">{placeholder}</option> : null}
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </FieldFrame>
  );
}

export interface TextAreaFieldProps extends Omit<
  TextareaHTMLAttributes<HTMLTextAreaElement>,
  'id'
> {
  readonly label: string;
  readonly hint?: string;
  readonly error?: string;
}

/** Labelled multi-line input (messages, notes), same frame as the other fields. */
export function TextAreaField({
  label,
  hint,
  error,
  className,
  rows = 5,
  ...rest
}: TextAreaFieldProps) {
  const id = useId();
  const shake = useShakeOnError(error);
  return (
    <FieldFrame id={id} label={label} hint={hint} error={error}>
      <textarea
        id={id}
        rows={rows}
        aria-invalid={error !== undefined || undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(
          CONTROL,
          'h-auto py-3',
          error === undefined ? 'border-border-strong' : 'border-danger',
          shake.active && 'animate-shake',
          className,
        )}
        onAnimationEnd={shake.onAnimationEnd}
        {...rest}
      />
    </FieldFrame>
  );
}
