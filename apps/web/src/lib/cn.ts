import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { clsx, type ClassValue } from 'clsx';
import { extendTailwindMerge } from 'tailwind-merge';

// tailwind-merge must know the token type scale: otherwise `text-label` is read as a text colour
// and silently removes `text-on-navy` (invisible button labels).
const theme = tokensPreset.theme as { fontSize: Record<string, unknown> };
const twMerge = extendTailwindMerge({
  extend: {
    classGroups: {
      'font-size': [{ text: Object.keys(theme.fontSize) }],
    },
  },
});

/** Merges class names; later Tailwind utilities win over earlier conflicting ones. */
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
