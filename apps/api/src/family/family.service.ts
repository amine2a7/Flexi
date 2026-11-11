import { randomBytes } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { InvitationService, credentialsOf } from '../auth/invitation.service.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { fromMillimes, toMillimes } from '../common/money.js';
import { PiiService } from '../common/pii.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import type { CreditType } from '../generated/prisma/client.js';
import { InsufficientFundsError, LedgerService, accounts } from '../ledger/ledger.service.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';

export type Relationship = 'SPOUSE' | 'CHILD' | 'PARENT';

export interface NewMember {
  firstName: string;
  lastName: string;
  relationship: Relationship;
  phone: string;
}

export interface TransferInput {
  memberId: string;
  creditType: CreditType;
  amountMillimes: number;
  dailyLimitMillimes: number | null;
  endsOn: string | null;
}

const familyRefused = (reason: string) =>
  new ApiProblem(409, 'RESOURCE_STATE_CONFLICT', { reason });

/** Login of a family member: generated, never a real address (a child often has none). */
function memberLogin(firstName: string): string {
  const base =
    firstName
      .normalize('NFD')
      .replace(/[^a-zA-Z]/g, '')
      .toLowerCase()
      .slice(0, 20) || 'membre';
  return `${base}.${randomBytes(3).toString('hex')}@famille.flexipay.tn`;
}

/**
 * Family accounts (processus v2): a beneficiary creates up to N accounts (platform setting, 5) for
 * relatives, transfers part of a credit type to them (same type, no fee, lots keep their expiry),
 * with an optional daily cap and end date, and takes it back at any time. A member is an employee
 * row held by the beneficiary: it pays with its own wallet and PIN; the company never sees it
 * (RLS, migration 0040). Every move of money is a balanced ledger posting under lock.
 */
@Injectable()
export class FamilyService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(InvitationService) private readonly invitations: InvitationService,
    @Inject(PiiService) private readonly pii: PiiService,
  ) {}

  /** The beneficiary himself (a family member never manages a family). */
  private holderId(): string {
    const who = principal();
    if (who.role !== 'EMPLOYEE' || who.employeeId === null) throw problems.forbidden();
    return who.employeeId;
  }

  /** The holder, active, in a company that allows family accounts. */
  private async activeHolder(tx: Tx, holderId: string) {
    const holder = await tx.employee.findUnique({
      where: { id: holderId },
      include: { company: { select: { familyAccountsEnabled: true } } },
    });
    if (holder === null) throw problems.notFound();
    if (!holder.company.familyAccountsEnabled) throw familyRefused('FAMILY_DISABLED');
    if (holder.status !== 'ACTIVE') throw familyRefused('HOLDER_NOT_ACTIVE');
    return holder;
  }

  private async member(tx: Tx, holderId: string, memberId: string) {
    const member = await tx.employee.findFirst({
      where: { id: memberId, holderEmployeeId: holderId, status: { not: 'DEACTIVATED' } },
    });
    if (member === null) throw problems.notFound();
    return member;
  }

  async list() {
    const holderId = this.holderId();
    return this.db.system(async (tx) => {
      const holder = await tx.employee.findUnique({
        where: { id: holderId },
        include: { company: { select: { familyAccountsEnabled: true } } },
      });
      if (holder === null) throw problems.notFound();
      const members = await tx.employee.findMany({
        where: { holderEmployeeId: holderId, status: { not: 'DEACTIVATED' } },
        include: { memberGrants: true, user: { select: { email: true } } },
        orderBy: { createdAt: 'asc' },
      });
      const { maxFamilyMembers } = await tx.platformSettings.findUniqueOrThrow({
        where: { id: 1 },
      });
      const data = [];
      for (const member of members) {
        const found = await this.ledger.balances(
          tx,
          CREDIT_TYPES.map((type) => accounts.employeeWallet(member.id, type)),
        );
        data.push({
          id: member.id,
          firstName: member.firstName,
          lastName: member.lastName,
          relationship: (member.relationship ?? 'CHILD') as Relationship,
          login: member.user?.email ?? null,
          status: member.status,
          balances: CREDIT_TYPES.map((creditType) => {
            const grant = member.memberGrants.find((row) => row.creditType === creditType);
            return {
              creditType,
              amountMillimes: toMillimes(
                found.get(accounts.employeeWallet(member.id, creditType).code) ?? 0n,
              ),
              dailyLimitMillimes:
                grant?.dailyLimitMillimes === null || grant === undefined
                  ? null
                  : toMillimes(grant.dailyLimitMillimes),
              endsOn: grant?.endsOn?.toISOString().slice(0, 10) ?? null,
            };
          }),
        });
      }
      return {
        enabled: holder.company.familyAccountsEnabled,
        maxMembers: maxFamilyMembers,
        data,
      };
    });
  }

  /** « Ajouter un membre »: its account, with a login and a temporary password shown once. */
  async create(input: NewMember) {
    const holderId = this.holderId();
    const login = memberLogin(input.firstName);
    const [prepared] = await this.invitations.prepare([
      {
        role: 'FAMILY_MEMBER',
        subRole: null,
        displayName: `${input.firstName} ${input.lastName}`,
        email: login,
      },
    ]);
    if (prepared === undefined) throw new Error('no invitation prepared');
    return this.db.system(async (tx) => {
      // Serialises the creations of one holder (the maximum is checked under this lock).
      await tx.$queryRaw`SELECT id FROM employees WHERE id = ${holderId}::uuid FOR UPDATE`;
      const holder = await this.activeHolder(tx, holderId);
      const { maxFamilyMembers } = await tx.platformSettings.findUniqueOrThrow({
        where: { id: 1 },
      });
      const count = await tx.employee.count({
        where: { holderEmployeeId: holderId, status: { not: 'DEACTIVATED' } },
      });
      if (count >= maxFamilyMembers)
        throw new ApiProblem(409, 'RESOURCE_STATE_CONFLICT', {
          reason: 'FAMILY_LIMIT_REACHED',
          maxMembers: maxFamilyMembers,
        });
      const id = uuidv7();
      await tx.employee.create({
        data: {
          id,
          companyId: holder.companyId,
          employeeNumber: `FAM-${randomBytes(4).toString('hex').toUpperCase()}`,
          firstName: input.firstName,
          lastName: input.lastName,
          email: login,
          phone: this.pii.seal(input.phone),
          status: 'ACTIVE',
          holderEmployeeId: holderId,
          relationship: input.relationship,
        },
      });
      await this.invitations.create(tx, [
        { ...prepared, invitee: { ...prepared.invitee, employeeId: id } },
      ]);
      await this.audit.record(tx, 'family.create', `${input.firstName} ${input.lastName}`);
      return {
        id,
        firstName: input.firstName,
        lastName: input.lastName,
        relationship: input.relationship,
        credentials: credentialsOf(prepared),
      };
    });
  }

  /**
   * « Transférer »: from the holder's wallet of the type to the member's wallet of the SAME type,
   * no fee. The lots taken (first to expire first) are recreated for the member with the same
   * expiry. Sets the daily cap and the end date of that type (empty = none).
   */
  async transfer(tx: Tx, input: TransferInput, key: string) {
    const holderId = this.holderId();
    await this.activeHolder(tx, holderId);
    const member = await this.member(tx, holderId, input.memberId);
    if (member.status !== 'ACTIVE') throw familyRefused('MEMBER_NOT_ACTIVE');
    const setting = await this.settings.creditType(tx, input.creditType);
    if (!setting.enabled)
      throw validationFailed([{ in: 'body', pointer: '/creditType', code: 'INVALID_ENUM' }]);
    const amount = fromMillimes(input.amountMillimes);
    const posted = await this.move(
      tx,
      [
        {
          from: accounts.employeeWallet(holderId, input.creditType),
          to: accounts.employeeWallet(member.id, input.creditType),
          creditType: input.creditType,
          amount,
        },
      ],
      'FAMILY_TRANSFER',
      key,
    );
    const grant = {
      dailyLimitMillimes:
        input.dailyLimitMillimes === null ? null : fromMillimes(input.dailyLimitMillimes),
      endsOn: input.endsOn === null ? null : new Date(`${input.endsOn}T00:00:00Z`),
      updatedAt: new Date(),
    };
    await tx.familyGrant.upsert({
      where: {
        memberEmployeeId_creditType: { memberEmployeeId: member.id, creditType: input.creditType },
      },
      create: {
        memberEmployeeId: member.id,
        holderEmployeeId: holderId,
        creditType: input.creditType,
        ...grant,
      },
      update: grant,
    });
    await this.audit.record(tx, 'family.transfer', member.firstName);
    return {
      memberId: member.id,
      creditType: input.creditType,
      amountMillimes: toMillimes(amount),
      transactionId: posted,
    };
  }

  /** « Reprendre le crédit »: everything still usable comes back to the holder (one type or all). */
  async reclaim(tx: Tx, memberId: string, creditType: CreditType | null, key: string) {
    const holderId = this.holderId();
    const member = await this.member(tx, holderId, memberId);
    const types = creditType === null ? CREDIT_TYPES : [creditType];
    await this.ledger.lockAccounts(
      tx,
      types.flatMap((type) => [
        accounts.employeeWallet(holderId, type),
        accounts.employeeWallet(member.id, type),
      ]),
    );
    const legs = [];
    for (const type of types) {
      const from = accounts.employeeWallet(member.id, type);
      const usable = await this.ledger.usable(tx, from, new Date());
      if (usable > 0n)
        legs.push({
          from,
          to: accounts.employeeWallet(holderId, type),
          creditType: type,
          amount: usable,
        });
    }
    if (legs.length > 0) await this.move(tx, legs, 'FAMILY_RECLAIM', key);
    await this.audit.record(tx, 'family.reclaim', member.firstName);
    return {
      memberId: member.id,
      reclaimedMillimes: toMillimes(legs.reduce((sum, leg) => sum + leg.amount, 0n)),
    };
  }

  /** « Supprimer le membre »: its credit comes back first, then its account is closed. */
  async remove(tx: Tx, memberId: string, key: string) {
    const outcome = await this.reclaim(tx, memberId, null, key);
    await tx.employee.update({
      where: { id: memberId },
      data: { status: 'DEACTIVATED' },
    });
    await this.audit.record(tx, 'family.delete', memberId);
    return outcome;
  }

  /** Closes the sign-in of a deleted member (after the commit: platform write). */
  async closeAccount(memberId: string): Promise<void> {
    await this.db.system(async (tx) => {
      await tx.user.updateMany({
        where: { employeeId: memberId, role: 'FAMILY_MEMBER' },
        data: { status: 'DEACTIVATED', deactivatedAt: new Date() },
      });
      const users = await tx.user.findMany({
        where: { employeeId: memberId },
        select: { id: true },
      });
      await tx.session.updateMany({
        where: { userId: { in: users.map((user) => user.id) }, revokedAt: null },
        data: { revokedAt: new Date() },
      });
    });
  }

  /** The company switches family accounts on or off for its employees (parameter). */
  async setEnabled(enabled: boolean) {
    const companyId = principal().companyId;
    if (companyId === null) throw problems.forbidden();
    return this.db.system(async (tx) => {
      await tx.company.update({
        where: { id: companyId },
        data: { familyAccountsEnabled: enabled },
      });
      await this.audit.record(tx, 'family.setEnabled', enabled ? 'activés' : 'désactivés');
      return { enabled };
    });
  }

  async enabled() {
    const companyId = principal().companyId;
    if (companyId === null) throw problems.forbidden();
    return this.db.system(async (tx) => {
      const company = await tx.company.findUniqueOrThrow({ where: { id: companyId } });
      return { enabled: company.familyAccountsEnabled };
    });
  }

  /**
   * Moves between wallets of the same type (one leg per type): FEFO lots taken from each source,
   * recreated at the destination with their expiry; one balanced posting (a debit per lot, a
   * credit per leg).
   */
  private async move(
    tx: Tx,
    legs: readonly {
      from: ReturnType<typeof accounts.employeeWallet>;
      to: ReturnType<typeof accounts.employeeWallet>;
      creditType: CreditType;
      amount: bigint;
    }[],
    type: 'FAMILY_TRANSFER' | 'FAMILY_RECLAIM',
    key: string,
  ): Promise<string> {
    const who = principal();
    await this.ledger.lockAccounts(
      tx,
      legs.flatMap((leg) => [leg.from, leg.to]),
    );
    const taken: { leg: (typeof legs)[number]; parts: { lotId: string; amount: bigint }[] }[] = [];
    for (const leg of legs) {
      try {
        taken.push({
          leg,
          parts: await this.ledger.consumeFefo(tx, leg.from, leg.amount, new Date()),
        });
      } catch (error) {
        if (error instanceof InsufficientFundsError)
          throw new ApiProblem(422, 'INSUFFICIENT_FUNDS', {
            missingMillimes: toMillimes(error.missing),
          });
        throw error;
      }
    }
    const lotIds = taken.flatMap((item) => item.parts.map((part) => part.lotId));
    const expiries = await tx.$queryRaw<{ id: string; expires_at: Date }[]>`
      SELECT id, expires_at FROM credit_lots WHERE id = ANY(${lotIds}::uuid[])`;
    const posted = await this.ledger.post(tx, {
      type,
      reference: `FAM-${key.slice(0, 8)}`,
      tenantId: who.companyId,
      userId: who.userId,
      idempotencyKey: key,
      entries: taken.flatMap(({ leg, parts }) => [
        ...parts.map((part) => ({
          account: leg.from,
          direction: 'D' as const,
          amount: part.amount,
          lotId: part.lotId,
        })),
        { account: leg.to, direction: 'C' as const, amount: leg.amount },
      ]),
    });
    for (const { leg, parts } of taken) {
      for (const part of parts) {
        const expiresAt = expiries.find((row) => row.id === part.lotId)?.expires_at;
        if (expiresAt === undefined) throw new Error('lot without expiry');
        await this.ledger.addLot(tx, {
          account: leg.to,
          creditType: leg.creditType,
          amount: part.amount,
          expiresAt,
          sourceTransactionId: posted.transactionId,
        });
      }
    }
    return posted.transactionId;
  }
}
