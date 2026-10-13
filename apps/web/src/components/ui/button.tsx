import { Loader2 } from 'lucide-react';
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

/** Shared look of buttons and button-like links. */
export function buttonClasses(
  variant: ButtonVariant = 'primary',
  size: ButtonSize = 'md',
  extra?: string,
): string {
  return cn(
    'inline-flex items-center justify-center gap-2 rounded-button font-title transition-colors duration-fast',
    'disabled:cursor-not-allowed disabled:opacity-disabled',
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
  readonly icon?: ReactNode;
  readonly ref?: Ref<HTMLButtonElement>;
}

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  icon,
  className,
  children,
  disabled,
  type = 'button',
  ...rest
}: ButtonProps) {
  return (
    <button
      type={type}
      className={buttonClasses(variant, size, className)}
      disabled={disabled === true || loading}
      aria-busy={loading || undefined}
      {...rest}
    >
      {loading ? <Loader2 aria-hidden="true" className="size-icon-sm animate-spin" /> : icon}
      {children}
    </button>
  );
}
