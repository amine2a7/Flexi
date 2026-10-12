// Message catalogues: one JSON file per namespace and per locale (src/messages/<locale>/<namespace>.json).
// The top-level key of a message is the namespace (e.g. `common.button.retry` lives in common.json).
import frApp from '../messages/fr/app.json';
import frCommon from '../messages/fr/common.json';
import frErrors from '../messages/fr/errors.json';
import frLanguage from '../messages/fr/language.json';
import frNav from '../messages/fr/nav.json';
import frShell from '../messages/fr/shell.json';
import arApp from '../messages/ar/app.json';
import arCommon from '../messages/ar/common.json';
import arErrors from '../messages/ar/errors.json';
import arLanguage from '../messages/ar/language.json';
import arNav from '../messages/ar/nav.json';
import arShell from '../messages/ar/shell.json';
import enApp from '../messages/en/app.json';
import enCommon from '../messages/en/common.json';
import enErrors from '../messages/en/errors.json';
import enLanguage from '../messages/en/language.json';
import enNav from '../messages/en/nav.json';
import enShell from '../messages/en/shell.json';
import type { Locale } from './routing';

/** French is the reference catalogue: it defines the key set every other locale must match. */
const fr = {
  app: frApp,
  common: frCommon,
  errors: frErrors,
  language: frLanguage,
  nav: frNav,
  shell: frShell,
};

export type Messages = typeof fr;

const catalogues: Record<Locale, Messages> = {
  fr,
  ar: {
    app: arApp,
    common: arCommon,
    errors: arErrors,
    language: arLanguage,
    nav: arNav,
    shell: arShell,
  },
  en: {
    app: enApp,
    common: enCommon,
    errors: enErrors,
    language: enLanguage,
    nav: enNav,
    shell: enShell,
  },
};

export function loadMessages(locale: Locale): Messages {
  return catalogues[locale];
}
