'use client';

import { useLocale } from 'next-intl';
import { getApi } from './client';
import { termValues } from './platform-terms';
import { useApiQuery } from './use-api-query';

/** Values of the settings quoted by the texts of a client page (see `termValues`). */
export function usePlatformTerms(): ReturnType<typeof termValues> {
  const locale = useLocale();
  const terms = useApiQuery(() => getApi().GET('/v1/public/terms'), []);
  return termValues(terms.status === 'success' ? terms.data : undefined, locale);
}
