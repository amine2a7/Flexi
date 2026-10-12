import type { Messages } from './i18n/messages';
import type { Locale } from './i18n/routing';

declare module 'next-intl' {
  interface AppConfig {
    Locale: Locale;
    Messages: Messages;
  }
}
