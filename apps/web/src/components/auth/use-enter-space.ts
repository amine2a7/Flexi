'use client';

import { useCallback, useState } from 'react';
import { useRouter } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { getAuthFlow, resetAuthFlow } from '@/lib/session/auth-flow';
import { landingPath } from '@/lib/session/return-to';

/** After a complete session: reads `/v1/me` and opens the user's space (or the requested page). */
export function useEnterSpace() {
  const router = useRouter();
  const [error, setError] = useState<unknown>(undefined);

  const enter = useCallback(async () => {
    const { data, error: problem } = await getApi().GET('/v1/me');
    if (data === undefined) {
      setError(problem);
      return;
    }
    const target = landingPath(data.role, getAuthFlow().returnTo);
    resetAuthFlow();
    if (target === undefined) {
      setError({ forbidden: true });
      return;
    }
    router.replace(target);
  }, [router]);

  return { enter, error };
}
