import { Inject, Injectable } from '@nestjs/common';
import type { Response } from 'express';
import { ENV, KEYS, type Keys } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { hmac, randomToken, safeEqual, sha256, uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { ACCESS_COOKIE, REFRESH_COOKIE } from '../common/http.js';
import { ApiProblem, problems } from '../common/problem.js';
import type { Role, Session, SessionStep } from '../generated/prisma/client.js';
import { canSignIn } from '../common/account-lifecycle.js';

/** Session durations (DP n° 18): 15 min idle; 4 h absolute (admin), 8 h otherwise. */
export const IDLE_TIMEOUT_SECONDS = 15 * 60;
const ABSOLUTE_HOURS: Record<Role, number> = {
  ADMIN: 4,
  COMPANY: 8,
  MERCHANT: 8,
  EMPLOYEE: 8,
  FAMILY_MEMBER: 8,
};
/** Restricted PASSWORD_CHANGE session: 10 min at most, absolute (contract §10). */
const RESTRICTED_MINUTES = 10;
const TOUCH_EVERY_MS = 30_000;
/**
 * Window in which the reuse of a just-rotated refresh token is another tab of the same browser
 * refreshing at the same time (shared cookies), not a theft: answered 409, nothing issued.
 */
const CONCURRENT_REFRESH_MS = 30_000;

/** Mobile session (M4): access token of 15 min, refresh token rotated until the deadline. */
export const MOBILE_ACCESS_SECONDS = 15 * 60;
/**
 * Absolute deadline of a mobile session (provisional, 2026-11-17, to confirm): the daily quick
 * sign-in by PIN needs a session longer than the 8 h of the web (DP n° 18).
 */
export const MOBILE_ABSOLUTE_DAYS = 30;

/** Device of a mobile session (the app keeps its id in the Keychain / Keystore). */
export interface MobileDevice {
  readonly deviceId: string;
}

export interface IssuedSession {
  readonly session: Session;
  readonly accessToken: string;
  readonly refreshToken: string;
}

/** Session body of the mobile contract (`MobileSession`): tokens in the body, never cookies. */
export interface MobileSessionBody {
  nextStep: SessionStep;
  accessToken: string;
  refreshToken: string;
  accessExpiresAt: string;
  refreshExpiresAt: string;
  restrictedUntil?: string;
}

export interface SessionResultBody {
  nextStep: SessionStep;
  csrfToken: string;
  idleTimeoutSeconds: number;
  absoluteExpiresAt: string;
  restrictedUntil?: string;
}

@Injectable()
export class SessionService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(KEYS) private readonly keys: Keys,
    @Inject(ENV) private readonly env: Env,
  ) {}

  /** CSRF token bound to the session row (renewed with it): HMAC, never stored. */
  csrfToken(sessionId: string): string {
    return hmac(this.keys.session, `csrf|${sessionId}`);
  }

  checkCsrf(sessionId: string, token: string | undefined): boolean {
    return token !== undefined && safeEqual(token, this.csrfToken(sessionId));
  }

  /** Opens a new session (new family) for `userId` in state `step` (mobile with `device`). */
  async open(
    tx: Tx,
    userId: string,
    role: Role,
    step: SessionStep,
    device?: MobileDevice,
  ): Promise<IssuedSession> {
    const now = Date.now();
    const restrictedUntil =
      step === 'PASSWORD_CHANGE' ? new Date(now + RESTRICTED_MINUTES * 60_000) : null;
    return this.insert(tx, {
      familyId: uuidv7(),
      userId,
      step,
      absoluteExpiresAt: new Date(
        now +
          (device === undefined
            ? ABSOLUTE_HOURS[role] * 3_600_000
            : MOBILE_ABSOLUTE_DAYS * 86_400_000),
      ),
      restrictedUntil,
      channel: device === undefined ? 'WEB' : 'MOBILE',
      deviceId: device?.deviceId ?? null,
    });
  }

  /**
   * Renews the session (new id, tokens and CSRF token), optionally in a new state; the previous row
   * is marked rotated. The absolute deadline never moves.
   */
  async renew(
    tx: Tx,
    previous: Session,
    role: Role,
    step: SessionStep = previous.step,
  ): Promise<IssuedSession> {
    await tx.session.update({ where: { id: previous.id }, data: { rotatedAt: new Date() } });
    const now = Date.now();
    let restrictedUntil: Date | null = null;
    if (step === 'PASSWORD_CHANGE') {
      restrictedUntil = previous.restrictedUntil ?? new Date(now + RESTRICTED_MINUTES * 60_000);
    }
    const mobile = previous.channel === 'MOBILE';
    const absolute =
      previous.step === 'NONE' || step !== 'NONE'
        ? previous.absoluteExpiresAt
        : new Date(
            now + (mobile ? MOBILE_ABSOLUTE_DAYS * 86_400_000 : ABSOLUTE_HOURS[role] * 3_600_000),
          );
    return this.insert(tx, {
      familyId: previous.familyId,
      userId: previous.userId,
      step,
      absoluteExpiresAt: absolute,
      restrictedUntil,
      channel: previous.channel,
      deviceId: previous.deviceId,
    });
  }

  private async insert(
    tx: Tx,
    data: Pick<
      Session,
      | 'familyId'
      | 'userId'
      | 'step'
      | 'absoluteExpiresAt'
      | 'restrictedUntil'
      | 'channel'
      | 'deviceId'
    >,
  ): Promise<IssuedSession> {
    const accessToken = randomToken();
    const refreshToken = randomToken();
    const session = await tx.session.create({
      data: {
        ...data,
        id: uuidv7(),
        accessTokenHash: sha256(accessToken),
        refreshTokenHash: sha256(refreshToken),
        accessExpiresAt:
          data.channel === 'MOBILE' ? new Date(Date.now() + MOBILE_ACCESS_SECONDS * 1000) : null,
      },
    });
    return { session, accessToken, refreshToken };
  }

  /** Session body of the mobile contract (`MobileSession`). */
  mobileResult(issued: IssuedSession): MobileSessionBody {
    const { session } = issued;
    return {
      nextStep: session.step,
      accessToken: issued.accessToken,
      refreshToken: issued.refreshToken,
      accessExpiresAt: (session.accessExpiresAt ?? session.absoluteExpiresAt).toISOString(),
      refreshExpiresAt: (session.restrictedUntil ?? session.absoluteExpiresAt).toISOString(),
      ...(session.restrictedUntil === null
        ? {}
        : { restrictedUntil: session.restrictedUntil.toISOString() }),
    };
  }

  /** Session body of the contract (`SessionResult`). */
  result(issued: IssuedSession): SessionResultBody {
    return {
      nextStep: issued.session.step,
      csrfToken: this.csrfToken(issued.session.id),
      idleTimeoutSeconds: IDLE_TIMEOUT_SECONDS,
      absoluteExpiresAt: issued.session.absoluteExpiresAt.toISOString(),
      ...(issued.session.restrictedUntil === null
        ? {}
        : { restrictedUntil: issued.session.restrictedUntil.toISOString() }),
    };
  }

  /** HttpOnly, Secure, SameSite=Strict cookies, no Domain (contract §6). */
  setCookies(res: Response, issued: IssuedSession): void {
    const maxAge = issued.session.absoluteExpiresAt.getTime() - Date.now();
    res.cookie(ACCESS_COOKIE, issued.accessToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      path: '/',
      maxAge,
    });
    res.cookie(REFRESH_COOKIE, issued.refreshToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      path: `${this.env.PUBLIC_PATH_PREFIX}/v1/auth`,
      maxAge,
    });
  }

  clearCookies(res: Response): void {
    res.clearCookie(ACCESS_COOKIE, { httpOnly: true, secure: true, sameSite: 'strict', path: '/' });
    res.clearCookie(REFRESH_COOKIE, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      path: `${this.env.PUBLIC_PATH_PREFIX}/v1/auth`,
    });
  }

  /**
   * Session of an access token: live (not rotated, not revoked), within its absolute deadline,
   * its inactivity window and, for a restricted state, its restricted deadline.
   */
  async authenticate(accessToken: string): Promise<Session> {
    const session = await this.db.system((tx) =>
      tx.session.findUnique({ where: { accessTokenHash: sha256(accessToken) } }),
    );
    const now = Date.now();
    if (session?.revokedAt !== null) throw problems.unauthenticated();
    // A rotated session stays usable for a few seconds (requests already in flight).
    if (session.rotatedAt !== null && now - session.rotatedAt.getTime() > 10_000) {
      throw problems.unauthenticated();
    }
    if (session.absoluteExpiresAt.getTime() <= now) throw problems.unauthenticated();
    if (session.restrictedUntil !== null && session.restrictedUntil.getTime() <= now) {
      throw problems.unauthenticated();
    }
    if (session.channel === 'MOBILE') {
      // Mobile: the access token lives 15 min; the app renews it with its refresh token.
      if ((session.accessExpiresAt?.getTime() ?? 0) <= now) {
        throw new ApiProblem(401, 'SESSION_EXPIRED');
      }
    } else if (now - session.lastSeenAt.getTime() > IDLE_TIMEOUT_SECONDS * 1000) {
      throw new ApiProblem(401, 'SESSION_EXPIRED');
    }
    if (now - session.lastSeenAt.getTime() > TOUCH_EVERY_MS) {
      await this.db.system((tx) =>
        tx.session.update({ where: { id: session.id }, data: { lastSeenAt: new Date(now) } }),
      );
    }
    return session;
  }

  /**
   * Refresh token rotation: a live refresh token gives a renewed session; the reuse of a rotated
   * or revoked one revokes the whole family (theft detection, spec 01 §3).
   */
  async refresh(
    tx: Tx,
    refreshToken: string,
    /** Mobile refresh: the device the session is bound to. Absent: web refresh (cookie). */
    device?: MobileDevice,
  ): Promise<{ session: Session; role: Role } | { reusedFamilyId: string } | { concurrent: true }> {
    const hash = sha256(refreshToken);
    // Two tabs refreshing at once are served one after the other.
    await tx.$queryRaw`SELECT id FROM sessions WHERE refresh_token_hash = ${hash} FOR UPDATE`;
    const session = await tx.session.findUnique({
      where: { refreshTokenHash: hash },
      include: {
        user: {
          select: {
            role: true,
            status: true,
            employee: { select: { status: true, graceUntil: true } },
          },
        },
      },
    });
    const now = Date.now();
    if (session === null) throw problems.unauthenticated();
    const mobile = session.channel === 'MOBILE';
    // A web token on the mobile route, or a mobile token on the web route: refused.
    if (mobile !== (device !== undefined)) throw problems.unauthenticated();
    // A mobile refresh token presented by another device: treated as a theft (whole session).
    if (mobile && !safeEqual(session.deviceId ?? '', device?.deviceId ?? '')) {
      return { reusedFamilyId: session.familyId };
    }
    // Token rotated a moment ago by another tab of the same browser (cookies are shared): no new
    // token for it, no revocation either; the tab retries with the cookie the other one received.
    // A mobile app has no other tab: a reuse there is a theft.
    if (
      !mobile &&
      session.revokedAt === null &&
      session.rotatedAt !== null &&
      now - session.rotatedAt.getTime() <= CONCURRENT_REFRESH_MS
    ) {
      return { concurrent: true };
    }
    // Reuse of a rotated or revoked token: the caller revokes the family (committed), then refuses.
    if (session.revokedAt !== null || session.rotatedAt !== null)
      return { reusedFamilyId: session.familyId };
    const expired =
      session.absoluteExpiresAt.getTime() <= now ||
      (session.restrictedUntil !== null && session.restrictedUntil.getTime() <= now) ||
      (!mobile && now - session.lastSeenAt.getTime() > IDLE_TIMEOUT_SECONDS * 1000) ||
      !canSignIn(session.user, session.user.employee, new Date(now));
    if (expired) throw problems.unauthenticated();
    return { session, role: session.user.role };
  }

  async revoke(tx: Tx, sessionId: string): Promise<void> {
    const session = await tx.session.findUnique({ where: { id: sessionId } });
    if (session === null) return;
    await tx.session.updateMany({
      where: { familyId: session.familyId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  /** Closes every session of the user except `keepFamilyId` (DP n° 12). */
  async revokeOthers(tx: Tx, userId: string, keepFamilyId?: string): Promise<void> {
    await tx.session.updateMany({
      where: {
        userId,
        revokedAt: null,
        ...(keepFamilyId === undefined ? {} : { familyId: { not: keepFamilyId } }),
      },
      data: { revokedAt: new Date() },
    });
  }

  get isProduction(): boolean {
    return this.env.NODE_ENV === 'production';
  }
}
