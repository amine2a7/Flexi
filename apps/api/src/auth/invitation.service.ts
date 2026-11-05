import { Inject, Injectable } from '@nestjs/common';
import { randomFrom } from '../common/crypto.js';
import type { Tx } from '../common/db.service.js';
import { OutboxService } from '../common/outbox.service.js';
import { problems } from '../common/problem.js';
import type { Role, SubRole } from '../generated/prisma/client.js';
import { hashSecret } from './password.js';

/**
 * End of a temporary password (invitation): the validity of the settings (7 days by default,
 * request of 2026-11-05), read in the transaction that writes the account.
 */
export async function invitationExpiry(tx: Tx, now = Date.now()): Promise<Date> {
  const settings = await tx.platformSettings.findUniqueOrThrow({
    where: { id: 1 },
    select: { invitationValidityDays: true },
  });
  return new Date(now + settings.invitationValidityDays * 86_400_000);
}

// No look-alike characters (0/O, 1/l/I): the password is typed from an e-mail.
const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789';

/** 16 random characters (about 93 bits) in 4 groups, with a capital, a small letter and a digit. */
export function temporaryPassword(): string {
  for (;;) {
    const raw = randomFrom(ALPHABET, 16);
    if (/[A-Z]/.test(raw) && /[a-z]/.test(raw) && /[2-9]/.test(raw)) {
      return raw.match(/.{4}/g)?.join('-') ?? raw;
    }
  }
}

export interface Invitee {
  readonly role: Role;
  readonly subRole: SubRole | null;
  readonly displayName: string;
  readonly email: string;
  readonly companyId?: string;
  readonly merchantId?: string;
  readonly employeeId?: string;
}

/** An account ready to be written: the temporary password is kept in memory until delivery. */
export interface PreparedInvitation {
  readonly invitee: Invitee;
  readonly passwordHash: string;
  readonly temporaryPassword: string;
}

/**
 * Sign-in account created with its owner (employee, merchant, company) and its invitation
 * (decision of 2026-10-14). Three steps so that nothing is sent for an account that was not
 * created: `prepare` (Argon2id hashing, before the SQL transaction), `create` (in the
 * transaction of the owner), `deliver` (after the commit).
 */
@Injectable()
export class InvitationService {
  constructor(@Inject(OutboxService) private readonly outbox: OutboxService) {}

  async prepare(invitees: readonly Invitee[]): Promise<PreparedInvitation[]> {
    return Promise.all(
      invitees.map(async (invitee) => {
        const password = temporaryPassword();
        return {
          invitee: { ...invitee, email: invitee.email.trim().toLowerCase() },
          passwordHash: await hashSecret(password),
          temporaryPassword: password,
        };
      }),
    );
  }

  /**
   * Writes the accounts (no RETURNING: a company may create its employees' accounts but not read
   * them, migration 0009). An e-mail that already signs in aborts the transaction: 409.
   */
  async create(tx: Tx, prepared: readonly PreparedInvitation[]): Promise<void> {
    if (prepared.length === 0) return;
    const expires = await invitationExpiry(tx);
    try {
      await tx.user.createMany({
        data: prepared.map(({ invitee, passwordHash }) => ({
          role: invitee.role,
          subRole: invitee.subRole,
          displayName: invitee.displayName.slice(0, 120),
          email: invitee.email,
          passwordHash,
          mustChangePassword: true,
          tempPasswordExpiresAt: expires,
          companyId: invitee.companyId ?? null,
          merchantId: invitee.merchantId ?? null,
          employeeId: invitee.employeeId ?? null,
        })),
      });
    } catch (error) {
      if (isUniqueViolation(error)) throw problems.conflict();
      throw error;
    }
  }

  /**
   * E-mails of the list that already sign in (checked by the platform, never shown to the tenant:
   * securite B5-S04, the company gets the same answer as for a fresh address).
   */
  async emailsInUse(tx: Tx, emails: readonly string[]): Promise<Set<string>> {
    const rows = await tx.user.findMany({
      where: { email: { in: emails.map((email) => email.trim().toLowerCase()) } },
      select: { email: true },
    });
    return new Set(rows.map((row) => row.email));
  }

  /** Notices to the holders of addresses that already sign in (see `existingAccountNotice`). */
  async notifyExisting(emails: readonly string[]): Promise<void> {
    for (const email of emails) await this.outbox.send(existingAccountNotice(email));
  }

  async deliver(prepared: readonly PreparedInvitation[]): Promise<void> {
    for (const { invitee, temporaryPassword: password } of prepared) {
      await this.outbox.send({
        to: invitee.email,
        subject: 'Votre accès FlexiPay',
        text: [
          `Bonjour ${invitee.displayName},`,
          '',
          'Votre compte FlexiPay est prêt.',
          `Adresse de connexion : ${this.outbox.signInUrl()}`,
          `Identifiant : ${invitee.email}`,
          `Mot de passe temporaire : ${password}`,
          '',
          'Ce mot de passe est valable 72 heures. Vous choisirez le vôtre à la première connexion.',
          "Si vous n'attendiez pas ce message, ignorez-le.",
        ].join('\n'),
      });
    }
  }
}

/**
 * Tells the holder of an address that already signs in that someone tried to register it (instead
 * of an invitation: no account is created, and the company is not told).
 */
export function existingAccountNotice(email: string) {
  return {
    to: email.trim().toLowerCase(),
    subject: "Tentative d'inscription FlexiPay",
    text: [
      'Bonjour,',
      '',
      'Une entreprise a demandé un accès FlexiPay pour votre adresse, qui a déjà un compte.',
      "Aucun nouveau compte n'a été créé.",
      "Si vous changez d'employeur ou si vous n'attendiez pas ce message, contactez le support FlexiPay.",
    ].join('\n'),
  };
}

function isUniqueViolation(error: unknown): boolean {
  if (typeof error !== 'object' || error === null) return false;
  const value = error as { code?: unknown; message?: unknown };
  return (
    value.code === 'P2002' ||
    (typeof value.message === 'string' && value.message.includes('Unique constraint'))
  );
}
