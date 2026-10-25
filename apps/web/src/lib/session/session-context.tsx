'use client';

import type { Schemas } from '@flexipay/api-client';
import { createContext, useContext, type ReactNode } from 'react';
import { can, canOpen } from './permissions';

export type Me = Schemas['Me'];

interface SessionValue {
  readonly me: Me;
  readonly signOut: () => Promise<void>;
}

const SessionContext = createContext<SessionValue | null>(null);

export function SessionProvider({ value, children }: { value: SessionValue; children: ReactNode }) {
  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

/** The signed-in user of the current space (only available inside a guarded space layout). */
export function useSession(): SessionValue {
  const value = useContext(SessionContext);
  if (value === null) throw new Error('useSession must be used inside a space layout');
  return value;
}

/** True when the session holds one of the permissions (an action is shown only then). */
export function useCan(...required: readonly string[]): boolean {
  return can(useSession().me, ...required);
}

/** True when the session may open the page (a link to it is shown only then). */
export function useCanOpen(pathname: string): boolean {
  return canOpen(useSession().me, pathname);
}
