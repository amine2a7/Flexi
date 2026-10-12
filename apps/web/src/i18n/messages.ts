// Message catalogues: one JSON file per namespace and per locale (src/messages/<locale>/<namespace>.json),
// assembled by src/messages/<locale>/index.ts. The top-level key of a message is the namespace
// (e.g. `common.button.retry` lives in common.json).
import ar from '../messages/ar';
import en from '../messages/en';
import fr from '../messages/fr';
import type { Locale } from './routing';

/** French is the reference catalogue: it defines the key set every other locale must match. */
export type Messages = typeof fr;

const catalogues: Record<Locale, Messages> = { fr, ar, en };

export function loadMessages(locale: Locale): Messages {
  return catalogues[locale];
}
