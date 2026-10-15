import { Inject, Injectable } from '@nestjs/common';
import type { Response } from 'express';
import { ENV, KEYS, type Keys } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { AuditService } from '../common/audit.service.js';
import { OutboxService } from '../common/outbox.service.js';
import {
  decryptSecret,
  encryptSecret,
  hmac,
  randomDigits,
  randomFrom,
  randomToken,
  safeEqual,
  sha256,
  uuidv7,
} from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { currentContext, principal } from '../common/request-context.js';
import type { Role, SessionStep, SubRole, User } from '../generated/prisma/client.js';
import { brokenRules, dummyHash, hashSecret, verifySecret } from './password.js';
import { type IssuedSession, SessionService } from './session.service.js';
import { matchStep, newSecretBase32, otpauthUri } from './totp.js';

/** MFA is mandatory for these roles (spec 01 §3); optional for beneficiaries (PIN + device). */
const MFA_REQUIRED: ReadonlySet<Role> = new Set(['ADMIN', 'COMPANY', 'MERCHANT']);
const CHALLENGE_TTL_MS = 5 * 60_000;
const ENROLL_TTL_MS = 10 * 60_000;
const RESET_LINK_TTL_MS = 15 * 60_000;
const RESET_OTP_TTL_MS = 10 * 60_000;
/** Lockout (spec 01 §3, DP n° 24). */
const COUPLE_LIMIT = 5;
const COUPLE_BLOCK_MS = 15 * 60_000;
const GLOBAL_LIMIT = 20;
const GLOBAL_BLOCK_MS = 24 * 3_600_000;
const RECOVERY_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/** Permissions computed by the server from the role and sub-role (DP n° 13). */
export function permissionsOf(role: Role, subRole: SubRole | null): string[] {
  switch (role) {
    case 'ADMIN':
      return [
        'merchants.manage',
        'companies.manage',
        'commissions.request',
        'approvals.decide',
        'audit.read',
        'settings.request',
      ];
    case 'COMPANY':
      return subRole === 'OWNER'
        ? ['employees.manage', 'orders.create', 'credits.allocate', 'invoices.read']
        : ['employees.manage', 'credits.allocate'];
    case 'MERCHANT':
      return ['payments.collect', 'sales.read', 'payouts.request', 'settlements.read'];
    case 'EMPLOYEE':
    case 'FAMILY_MEMBER':
      return ['wallet.read', 'payments.pay'];
  }
}

export type LoginOutcome =
  | {
      kind: 'challenge';
      body: { nextStep: 'MFA_CHALLENGE'; challengeId: string; challengeExpiresAt: string };
    }
  | { kind: 'session'; issued: IssuedSession };

@Injectable()
export class AuthService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(KEYS) private readonly keys: Keys,
    @Inject(ENV) private readonly env: Env,
    @Inject(OutboxService) private readonly outbox: OutboxService,
  ) {}

  private ip(): string {
    return currentContext()?.ip ?? 'unknown';
  }

  /** E-mail (lower case) or Tunisian phone number in E.164. */
  private normalize(identifier: string): { email?: string; phone?: string } {
    const value = identifier.trim();
    if (value.includes('@')) return { email: value.toLowerCase() };
    const digits = value.replace(/[\s.-]/g, '');
    if (/^[0-9]{8}$/.test(digits)) return { phone: `+216${digits}` };
    return { phone: digits.replace(/^00/, '+') };
  }

  private async findByIdentifier(tx: Tx, identifier: string): Promise<User | null> {
    const key = this.normalize(identifier);
    if (key.email !== undefined) return tx.user.findUnique({ where: { email: key.email } });
    if (key.phone !== undefined) return tx.user.findUnique({ where: { phone: key.phone } });
    return null;
  }

  private async isBlocked(tx: Tx, user: User): Promise<boolean> {
    const now = Date.now();
    if (user.lockedUntil !== null && user.lockedUntil.getTime() > now) return true;
    const couple = await tx.loginFailure.findUnique({
      where: { userId_ip: { userId: user.id, ip: this.ip() } },
    });
    const until = couple?.blockedUntil;
    return until !== undefined && until !== null && until.getTime() > now;
  }

  /** One more failure for (account, IP) and for the account (sign-in, MFA, current password). */
  private async recordFailure(user: User): Promise<void> {
    await this.db.system(async (tx) => {
      const ip = this.ip();
      const couple = await tx.loginFailure.upsert({
        where: { userId_ip: { userId: user.id, ip } },
        create: { userId: user.id, ip, count: 1 },
        update: { count: { increment: 1 }, updatedAt: new Date() },
      });
      if (couple.count % COUPLE_LIMIT === 0) {
        // Progressive: 15 min, then 30, 60…
        const factor = 2 ** (Math.floor(couple.count / COUPLE_LIMIT) - 1);
        await tx.loginFailure.update({
          where: { userId_ip: { userId: user.id, ip } },
          data: { blockedUntil: new Date(Date.now() + COUPLE_BLOCK_MS * factor) },
        });
      }
      const updated = await tx.user.update({
        where: { id: user.id },
        data: { failedLogins: { increment: 1 } },
      });
      if (updated.failedLogins >= GLOBAL_LIMIT && updated.lockedUntil === null) {
        await tx.user.update({
          where: { id: user.id },
          data: { lockedUntil: new Date(Date.now() + GLOBAL_BLOCK_MS) },
        });
        await tx.mfaChallenge.updateMany({
          where: { userId: user.id, consumedAt: null },
          data: { consumedAt: new Date() },
        });
        await this.audit.record(tx, 'auth.accountLocked', user.displayName, 'Système');
      }
      await this.audit.record(tx, 'auth.signInFailed', user.displayName, 'Système');
    });
  }

  private async clearFailures(tx: Tx, user: User): Promise<void> {
    await tx.loginFailure.deleteMany({ where: { userId: user.id } });
    await tx.user.update({ where: { id: user.id }, data: { failedLogins: 0, lockedUntil: null } });
  }

  private nextStepAfterMfa(user: User): SessionStep {
    return user.mustChangePassword ? 'PASSWORD_CHANGE' : 'NONE';
  }

  private needsEnrolment(user: Pick<User, 'role' | 'mfaSecretEnc'>): boolean {
    return user.mfaSecretEnc === null && MFA_REQUIRED.has(user.role);
  }

  // ---------------------------------------------------------------- sign-in

  async login(identifier: string, password: string): Promise<LoginOutcome> {
    const user = await this.db.system((tx) => this.findByIdentifier(tx, identifier));
    // Same cost whatever the account (contract §10): the hash is always verified first.
    const valid = await verifySecret(user?.passwordHash ?? (await dummyHash()), password);
    if (user === null) throw problems.invalidCredentials();
    if (await this.db.system((tx) => this.isBlocked(tx, user))) throw problems.invalidCredentials();
    if (!valid) {
      await this.recordFailure(user);
      throw problems.invalidCredentials();
    }
    const tempExpired =
      user.mustChangePassword &&
      user.tempPasswordExpiresAt !== null &&
      user.tempPasswordExpiresAt.getTime() < Date.now();
    if (user.status !== 'ACTIVE' || tempExpired) throw problems.invalidCredentials();
    if (user.role === 'FAMILY_MEMBER') {
      await this.db.system((tx) =>
        this.audit.record(tx, 'auth.webRefused', user.displayName, 'Système'),
      );
      throw problems.forbidden();
    }

    return this.db.system(async (tx): Promise<LoginOutcome> => {
      await this.clearFailures(tx, user);
      if (user.mfaSecretEnc !== null) {
        const challenge = await tx.mfaChallenge.create({
          data: {
            id: uuidv7(),
            userId: user.id,
            expiresAt: new Date(Date.now() + CHALLENGE_TTL_MS),
          },
        });
        return {
          kind: 'challenge',
          body: {
            nextStep: 'MFA_CHALLENGE',
            challengeId: challenge.id,
            challengeExpiresAt: challenge.expiresAt.toISOString(),
          },
        };
      }
      let step: SessionStep = 'NONE';
      if (user.mustChangePassword) step = 'PASSWORD_CHANGE';
      else if (this.needsEnrolment(user)) step = 'MFA_ENROLL';
      const issued = await this.sessions.open(tx, user.id, user.role, step);
      await this.audit.record(tx, 'auth.signIn', user.displayName, user.displayName);
      return { kind: 'session', issued };
    });
  }

  /** Checks a TOTP code (or the development demo code) and records its step. */
  private async checkTotp(
    tx: Tx,
    user: User,
    sealedSecret: string,
    code: string,
  ): Promise<boolean> {
    if (
      this.env.DEMO_FIXED_MFA_CODE !== undefined &&
      safeEqual(code, this.env.DEMO_FIXED_MFA_CODE)
    ) {
      return true;
    }
    const secret = decryptSecret(this.keys.data, sealedSecret);
    const step = matchStep(secret, code, user.mfaLastStep);
    if (step === undefined) return false;
    await tx.user.update({ where: { id: user.id }, data: { mfaLastStep: step } });
    return true;
  }

  private recoveryHash(userId: string, code: string): string {
    return hmac(this.keys.session, `recovery|${userId}|${code}`);
  }

  private async useRecoveryCode(tx: Tx, user: User, code: string): Promise<boolean> {
    const result = await tx.recoveryCode.updateMany({
      where: { userId: user.id, usedAt: null, codeHash: this.recoveryHash(user.id, code) },
      data: { usedAt: new Date() },
    });
    return result.count === 1;
  }

  async verifyMfa(
    challengeId: string,
    code: string | undefined,
    recoveryCode: string | undefined,
  ): Promise<IssuedSession> {
    const found = await this.db.system((tx) =>
      tx.mfaChallenge.findUnique({ where: { id: challengeId }, include: { user: true } }),
    );
    if (found?.consumedAt !== null || found.expiresAt.getTime() <= Date.now()) {
      throw new ApiProblem(401, 'MFA_CHALLENGE_EXPIRED');
    }
    const user = found.user;
    if (user.mfaSecretEnc === null) throw new ApiProblem(401, 'MFA_CHALLENGE_EXPIRED');
    if (await this.db.system((tx) => this.isBlocked(tx, user))) {
      throw new ApiProblem(401, 'MFA_CHALLENGE_EXPIRED');
    }
    const secret = user.mfaSecretEnc;
    const ok = await this.db.system((tx) =>
      code !== undefined
        ? this.checkTotp(tx, user, secret, code)
        : this.useRecoveryCode(tx, user, recoveryCode ?? ''),
    );
    if (!ok) {
      await this.recordFailure(user);
      throw new ApiProblem(401, 'MFA_CODE_INVALID');
    }
    return this.db.system(async (tx) => {
      const consumed = await tx.mfaChallenge.updateMany({
        where: { id: challengeId, consumedAt: null },
        data: { consumedAt: new Date() },
      });
      if (consumed.count !== 1) throw new ApiProblem(401, 'MFA_CHALLENGE_EXPIRED');
      await this.clearFailures(tx, user);
      const issued = await this.sessions.open(tx, user.id, user.role, this.nextStepAfterMfa(user));
      await this.audit.record(tx, 'auth.signIn', user.displayName, user.displayName);
      return issued;
    });
  }

  // ---------------------------------------------------------------- MFA enrolment

  async startEnrolment(proof: { currentPassword?: string; currentCode?: string }): Promise<{
    otpauthUri: string;
    secretBase32: string;
    expiresAt: string;
  }> {
    const who = principal();
    const user = await this.db.system((tx) =>
      tx.user.findUniqueOrThrow({ where: { id: who.userId } }),
    );
    if (who.step === 'NONE' && user.mfaSecretEnc !== null) await this.checkProof(user, proof);
    const secret = newSecretBase32();
    const expiresAt = new Date(Date.now() + ENROLL_TTL_MS);
    await this.db.system(async (tx) => {
      await tx.user.update({
        where: { id: user.id },
        data: {
          mfaPendingSecretEnc: encryptSecret(this.keys.data, secret),
          mfaPendingExpiresAt: expiresAt,
        },
      });
      await this.audit.record(tx, 'auth.mfaEnrolmentStarted', user.displayName);
    });
    return {
      otpauthUri: otpauthUri(user.email, secret),
      secretBase32: secret,
      expiresAt: expiresAt.toISOString(),
    };
  }

  /** Current password + current code (TOTP or recovery), counted in the lockout. */
  private async checkProof(
    user: User,
    proof: { currentPassword?: string; currentCode?: string },
  ): Promise<void> {
    const missing = [
      ...(proof.currentPassword === undefined ? ['/currentPassword'] : []),
      ...(proof.currentCode === undefined ? ['/currentCode'] : []),
    ];
    if (missing.length > 0) {
      throw validationFailed(missing.map((pointer) => ({ in: 'body', pointer, code: 'REQUIRED' })));
    }
    if (!(await verifySecret(user.passwordHash, proof.currentPassword ?? ''))) {
      await this.recordFailure(user);
      throw validationFailed([
        { in: 'body', pointer: '/currentPassword', code: 'CURRENT_PASSWORD_INVALID' },
      ]);
    }
    const code = proof.currentCode ?? '';
    const sealed = user.mfaSecretEnc;
    const ok = await this.db.system((tx) =>
      /^[0-9]{6}$/.test(code) && sealed !== null
        ? this.checkTotp(tx, user, sealed, code)
        : this.useRecoveryCode(tx, user, code),
    );
    if (!ok) {
      await this.recordFailure(user);
      throw new ApiProblem(401, 'MFA_CODE_INVALID');
    }
  }

  private async newRecoveryCodes(tx: Tx, userId: string): Promise<string[]> {
    const codes = Array.from({ length: 10 }, () => randomFrom(RECOVERY_ALPHABET, 10));
    await tx.recoveryCode.deleteMany({ where: { userId } });
    await tx.recoveryCode.createMany({
      data: codes.map((code) => ({
        id: uuidv7(),
        userId,
        codeHash: this.recoveryHash(userId, code),
      })),
    });
    return codes;
  }

  async confirmEnrolment(
    code: string,
  ): Promise<{ issued: IssuedSession; recoveryCodes: string[] }> {
    const who = principal();
    const user = await this.db.system((tx) =>
      tx.user.findUniqueOrThrow({ where: { id: who.userId } }),
    );
    const pending = user.mfaPendingSecretEnc;
    if (
      pending === null ||
      user.mfaPendingExpiresAt === null ||
      user.mfaPendingExpiresAt.getTime() <= Date.now()
    ) {
      throw problems.conflict();
    }
    const ok = await this.db.system((tx) => this.checkTotp(tx, user, pending, code));
    if (!ok) {
      await this.recordFailure(user);
      throw new ApiProblem(401, 'MFA_CODE_INVALID');
    }
    return this.db.system(async (tx) => {
      await tx.user.update({
        where: { id: user.id },
        data: { mfaSecretEnc: pending, mfaPendingSecretEnc: null, mfaPendingExpiresAt: null },
      });
      const recoveryCodes = await this.newRecoveryCodes(tx, user.id);
      const session = await tx.session.findUniqueOrThrow({ where: { id: who.sessionId } });
      const issued = await this.sessions.renew(tx, session, user.role, 'NONE');
      await this.audit.record(tx, 'auth.mfaEnrolled', user.displayName);
      return { issued, recoveryCodes };
    });
  }

  async regenerateRecoveryCodes(proof: {
    currentPassword: string;
    currentCode: string;
  }): Promise<string[]> {
    const who = principal();
    const user = await this.db.system((tx) =>
      tx.user.findUniqueOrThrow({ where: { id: who.userId } }),
    );
    if (user.mfaSecretEnc === null) throw problems.conflict();
    await this.checkProof(user, proof);
    return this.db.system(async (tx) => {
      const codes = await this.newRecoveryCodes(tx, user.id);
      await this.audit.record(tx, 'auth.recoveryCodesRenewed', user.displayName);
      return codes;
    });
  }

  // ---------------------------------------------------------------- passwords

  private async assertPolicy(user: User, candidate: string, checkCurrent: boolean): Promise<void> {
    const broken = await brokenRules(
      candidate,
      [user.email, ...(user.phone === null ? [] : [user.phone])],
      checkCurrent ? user.passwordHash : undefined,
    );
    if (broken.length > 0) {
      throw validationFailed(
        broken.map((rule) => ({
          in: 'body',
          pointer: '/newPassword',
          code: 'PASSWORD_POLICY_VIOLATION',
          params: { rule: rule.code, ...(rule.params ?? {}) },
        })),
      );
    }
  }

  async changePassword(
    currentPassword: string | undefined,
    newPassword: string,
  ): Promise<IssuedSession> {
    const who = principal();
    const user = await this.db.system((tx) =>
      tx.user.findUniqueOrThrow({ where: { id: who.userId } }),
    );
    if (who.step === 'NONE') {
      if (currentPassword === undefined) {
        throw validationFailed([{ in: 'body', pointer: '/currentPassword', code: 'REQUIRED' }]);
      }
      if (!(await verifySecret(user.passwordHash, currentPassword))) {
        await this.recordFailure(user);
        throw validationFailed([
          { in: 'body', pointer: '/currentPassword', code: 'CURRENT_PASSWORD_INVALID' },
        ]);
      }
    }
    await this.assertPolicy(user, newPassword, true);
    const passwordHash = await hashSecret(newPassword);
    return this.db.system(async (tx) => {
      const updated = await tx.user.update({
        where: { id: user.id },
        data: { passwordHash, mustChangePassword: false, tempPasswordExpiresAt: null },
      });
      // An invited employee becomes active when it chooses its own password.
      if (updated.employeeId !== null) {
        await tx.employee.updateMany({
          where: { id: updated.employeeId, status: 'INVITED' },
          data: { status: 'ACTIVE' },
        });
      }
      const session = await tx.session.findUniqueOrThrow({ where: { id: who.sessionId } });
      // Every other session of the account is closed (DP n° 12).
      await this.sessions.revokeOthers(tx, user.id, session.familyId);
      const step: SessionStep = this.needsEnrolment(updated) ? 'MFA_ENROLL' : 'NONE';
      const issued = await this.sessions.renew(tx, session, user.role, step);
      await this.audit.record(tx, 'auth.passwordChanged', user.displayName);
      return issued;
    });
  }

  /** Always the same answer (202), whatever the account (anti-enumeration). */
  async forgotPassword(identifier: string): Promise<void> {
    const user = await this.db.system((tx) => this.findByIdentifier(tx, identifier));
    if (user?.status !== 'ACTIVE') return;
    const byPhone = !identifier.includes('@');
    const secret = byPhone ? randomDigits(6) : randomToken();
    await this.db.system(async (tx) => {
      await tx.passwordResetToken.updateMany({
        where: { userId: user.id, usedAt: null },
        data: { usedAt: new Date() },
      });
      await tx.passwordResetToken.create({
        data: {
          id: uuidv7(),
          userId: user.id,
          tokenHash: byPhone ? sha256(`otp|${user.id}|${secret}`) : sha256(secret),
          expiresAt: new Date(Date.now() + (byPhone ? RESET_OTP_TTL_MS : RESET_LINK_TTL_MS)),
        },
      });
      await this.audit.record(tx, 'auth.passwordResetRequested', user.displayName, 'Système');
    });
    await this.deliver(user, byPhone, secret);
  }

  /** Reset code (SMS) or link (e-mail), through the outbox (no provider yet). */
  private async deliver(user: User, byPhone: boolean, secret: string): Promise<void> {
    await this.outbox.send(
      byPhone
        ? {
            to: user.phone ?? '',
            subject: 'Code FlexiPay',
            text: `Votre code FlexiPay est ${secret} (10 min).`,
          }
        : {
            to: user.email,
            subject: 'Réinitialisation de votre mot de passe FlexiPay',
            text: `Choisissez un nouveau mot de passe : ${this.outbox.webOrigin()}/fr/mot-de-passe-oublie/nouveau#token=${secret} (15 min).`,
          },
    );
  }

  async resetPassword(
    input:
      | { token: string; newPassword: string }
      | { identifier: string; otp: string; newPassword: string },
  ): Promise<void> {
    const invalid = (pointer: string) =>
      validationFailed([{ in: 'body', pointer, code: 'INVALID_FORMAT' }]);
    const found = await this.db.system(async (tx) => {
      if ('token' in input) {
        return tx.passwordResetToken.findUnique({
          where: { tokenHash: sha256(input.token) },
          include: { user: true },
        });
      }
      const user = await this.findByIdentifier(tx, input.identifier);
      if (user === null) return null;
      return tx.passwordResetToken.findUnique({
        where: { tokenHash: sha256(`otp|${user.id}|${input.otp}`) },
        include: { user: true },
      });
    });
    const pointer = 'token' in input ? '/token' : '/otp';
    if (found?.usedAt !== null || found.expiresAt.getTime() <= Date.now()) throw invalid(pointer);
    await this.assertPolicy(found.user, input.newPassword, false);
    const passwordHash = await hashSecret(input.newPassword);
    await this.db.system(async (tx) => {
      const used = await tx.passwordResetToken.updateMany({
        where: { id: found.id, usedAt: null },
        data: { usedAt: new Date() },
      });
      if (used.count !== 1) throw invalid(pointer);
      await tx.user.update({
        where: { id: found.userId },
        data: {
          passwordHash,
          mustChangePassword: false,
          tempPasswordExpiresAt: null,
          failedLogins: 0,
          lockedUntil: null,
        },
      });
      await tx.loginFailure.deleteMany({ where: { userId: found.userId } });
      // Every session is closed after a reset (DP n° 12).
      await this.sessions.revokeOthers(tx, found.userId);
      await this.audit.record(
        tx,
        'auth.passwordReset',
        found.user.displayName,
        found.user.displayName,
      );
    });
  }

  // ---------------------------------------------------------------- session lifecycle

  async refresh(refreshToken: string | undefined): Promise<IssuedSession> {
    if (refreshToken === undefined || refreshToken === '') throw problems.unauthenticated();
    const outcome = await this.db.system(async (tx) => {
      const found = await this.sessions.refresh(tx, refreshToken);
      if ('concurrent' in found) return 'CONCURRENT' as const;
      if ('reusedFamilyId' in found) {
        // Theft detection: the whole family is revoked, and this revocation is committed.
        await tx.session.updateMany({
          where: { familyId: found.reusedFamilyId, revokedAt: null },
          data: { revokedAt: new Date() },
        });
        await this.audit.record(tx, 'auth.refreshReused', found.reusedFamilyId, 'Système');
        return undefined;
      }
      return this.sessions.renew(tx, found.session, found.role);
    });
    if (outcome === undefined) throw problems.unauthenticated();
    // Another tab renewed the session a moment ago: retry with its cookie (contract §6).
    if (outcome === 'CONCURRENT') throw problems.conflict();
    return outcome;
  }

  async logout(res: Response): Promise<void> {
    const who = currentContext()?.principal;
    if (who !== undefined) {
      await this.db.system(async (tx) => {
        await this.sessions.revoke(tx, who.sessionId);
        await this.audit.record(tx, 'auth.signOut', who.displayName);
      });
    }
    this.sessions.clearCookies(res);
  }

  async me(): Promise<Record<string, unknown>> {
    const who = principal();
    return this.db.system(async (tx) => {
      const user = await tx.user.findUniqueOrThrow({
        where: { id: who.userId },
        include: {
          company: { select: { id: true, name: true } },
          merchant: { select: { id: true, name: true } },
          employee: { select: { company: { select: { id: true, name: true } } } },
        },
      });
      const tenant = user.company ?? user.merchant ?? user.employee?.company ?? null;
      const remaining = await tx.recoveryCode.count({ where: { userId: user.id, usedAt: null } });
      return {
        id: user.id,
        displayName: user.displayName,
        role: user.role,
        subRole: user.subRole,
        permissions: permissionsOf(user.role, user.subRole),
        tenant: tenant === null ? null : { id: tenant.id, label: tenant.name },
        mfa: {
          required: MFA_REQUIRED.has(user.role),
          enrolled: user.mfaSecretEnc !== null,
          recoveryCodesRemaining: Math.min(remaining, 10),
        },
        onboardingTourDone: user.onboardingTourDone,
      };
    });
  }

  async completeTour(): Promise<void> {
    const who = principal();
    await this.db.system((tx) =>
      tx.user.update({ where: { id: who.userId }, data: { onboardingTourDone: true } }),
    );
  }
}
