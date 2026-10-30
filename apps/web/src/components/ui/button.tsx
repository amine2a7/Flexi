import { Check, Loader2 } from 'lucide-react';
import type { ButtonHTMLAttributes, ReactNode, Ref } from 'react';
import { cn } from '@/lib/cn';

export type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'success';
export type ButtonSize = 'md' | 'sm';

const VARIANTS: Record<ButtonVariant, string> = {
  primary: 'bg-navy text-on-navy hover:bg-navy-deep',
  secondary: 'border border-border-strong bg-surface text-navy hover:bg-bg',
  ghost: 'text-navy hover:bg-border',
  danger: 'bg-danger text-on-danger hover:opacity-hover',
  success: 'bg-emerald text-on-emerald hover:opacity-hover',
};

const SIZES: Record<ButtonSize, string> = {
  // 48 px on touch screens, 44 px from the desktop breakpoint (UX: no 28 px buttons).
  md: 'min-h-touch-target-mobile px-5 text-label lg:min-h-button-height',
  sm: 'min-h-touch-target-mobile px-3 text-label lg:min-h-touch-target-min',
};

/** Shared look of buttons and button-like links (animation 7: pressed at .97). */
export function buttonClasses(
  variant: ButtonVariant = 'primary',
  size: ButtonSize = 'md',
  extra?: string,
): string {
  return cn(
    'inline-flex items-center justify-center gap-2 rounded-button font-title transition duration-fast ease-out',
    'active:scale-press disabled:cursor-not-allowed disabled:border-border disabled:bg-border disabled:text-text-muted disabled:shadow-none disabled:active:scale-100',
    VARIANTS[variant],
    SIZES[size],
    extra,
  );
}

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  readonly variant?: ButtonVariant;
  readonly size?: ButtonSize;
  /** Shows a spinner, disables the button and keeps its label (screen readers hear aria-busy). */
  readonly loading?: boolean;
  /** Success of the action just done: green with a check for 1,6 s (useSuccessFlash). */
  readonly succeeded?: boolean;
  readonly icon?: ReactNode;
  readonly ref?: Ref<HTMLButtonElement>;
}

/**
 * Button. Waiting (spinner) and success (check) never change its width: they take the place of
 * the icon, or sit over the hidden label when there is no icon. A money action never waits for
 * the success animation: it only follows the answer.
 */
export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  succeeded = false,
  icon,
  className,
  children,
  disabled,
  type = 'button',
  ...rest
}: ButtonProps) {
  const indicator = loading ? (
    <Loader2 aria-hidden="true" className="size-icon-sm animate-spin motion-reduce:animate-none" />
  ) : succeeded ? (
    <Check aria-hidden="true" className="size-icon-sm animate-pop-fast" />
  ) : undefined;
  const overlay = indicator !== undefined && icon === undefined;
  return (
    <button
      type={type}
      className={buttonClasses(
        succeeded && !loading ? 'success' : variant,
        size,
        cn('relative', className),
      )}
      disabled={disabled === true || loading}
      aria-busy={loading || undefined}
      {...rest}
    >
      {overlay ? (
        <span aria-hidden="true" className="absolute inset-0 flex items-center justify-center">
          {indicator}
        </span>
      ) : (
        (indicator ?? icon)
      )}
      {overlay ? <span className="text-transparent">{children}</span> : children}
    </button>
  );
}
