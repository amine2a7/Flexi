import { hasLocale } from 'next-intl';
import { getRequestConfig } from 'next-intl/server';
import { loadMessages } from './messages';
import { routing } from './routing';

export default getRequestConfig(async (params) => {
  // next-intl deprecates `requestLocale` in favour of next/root-params, which is still behind
  // the experimental `rootParams` flag of Next.js: revisit once it is stable.
  // eslint-disable-next-line @typescript-eslint/no-deprecated
  const requested = await params.requestLocale;
  const locale = hasLocale(routing.locales, requested) ? requested : routing.defaultLocale;
  return { locale, messages: loadMessages(locale) };
});
