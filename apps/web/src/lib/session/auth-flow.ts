// In-memory state of the sign-in sequence (contract §10). Nothing here is ever written to browser
// storage or to the URL: a page reload simply restarts the sequence at /login.

interface AuthFlowState {
  challengeId?: string;
  challengeExpiresAt?: string;
  restrictedUntil?: string;
  returnTo?: string;
  /** Shown once on /login after the restricted first-login window expired (decision 20, N-02). */
  passwordWindowExpired?: boolean;
  /** Recovery codes returned once by the MFA enrolment, displayed then forgotten (decision 10). */
  recoveryCodes?: readonly string[];
}

let state: AuthFlowState = {};

export function getAuthFlow(): Readonly<AuthFlowState> {
  return state;
}

export function updateAuthFlow(patch: AuthFlowState): void {
  state = { ...state, ...patch };
}

export function resetAuthFlow(): void {
  state = {};
}

/** Returns the recovery codes and forgets them (displayed a single time). */
export function takeRecoveryCodes(): readonly string[] | undefined {
  const codes = state.recoveryCodes;
  state = { ...state, recoveryCodes: undefined };
  return codes;
}
