import { PiiService } from '../common/pii.js';
import { randomInt } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { InvitationService } from '../auth/invitation.service.js';
import { AuditService } from '../common/audit.service.js';
import { FourEyesService } from '../common/four-eyes.service.js';
import { DisputesService } from '../risk/disputes.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { problems, validationFailed } from '../common/problem.js';
import { allows } from '../common/permissions.js';
import { principal } from '../common/request-context.js';
import { FILE_STORAGE, type FileStorage } from '../common/storage.js';
import {
  businessDay,
  lastMonths,
  startOfBusinessDay,
  startOfBusinessMonth,
} from '../common/tunis.js';
import type {
  AccountStatus,
  Approval,
  ApprovalStatus,
  CommissionGrid,
  CommissionTier as TierRow,
  CreditType,
  KycAccountType,
  KycStatus,
  Merchant,
  MerchantCategory,
  PaymentStatus,
  Prisma,
} from '../generated/prisma/client.js';
import type { CommissionTier } from '@flexipay/shared';
import {
  currentGrid,
  currentGridInclude,
  gridBody,
  installGrid,
  tierBody,
  type GridOwner,
} from '../platform/commission-grids.js';
import { CREDIT_TYPES, SettingsService, typeSettingsBody } from '../platform/settings.service.js';

type GridRows = (CommissionGrid & { tiers: TierRow[] })[];
type MerchantRow = Merchant & { commissionGrids: GridRows };

/** Payload of a RIB change request: the new IBAN sealed (never in clear in the approvals). */
interface IbanChangePayload {
  owner: { merchantId: string };
  iban: string;
}

/** Editable fields of a record (decision of 2026-11-03); the grid and the RIB go through four eyes. */
export interface AccountUpdate {
  name?: string | undefined;
  city?: string | undefined;
  phone?: string | undefined;
  email?: string | undefined;
  address?: string | undefined;
  category?: MerchantCategory | undefined;
}

/** Payload of a grid change request (decision of 2026-11-03). */
interface GridChangePayload {
  owner: GridOwner;
  tiers: CommissionTier[];
  previous: CommissionTier[] | null;
}

/** Grids are commercial terms: shown with commissions.read only (securite S-GC-04). */
function visibleGrid(grids: GridRows) {
  const who = principal();
  return allows(who.role, who.subRole, ['commissions.read']) ? gridBody(grids) : null;
}

function merchantAccount(merchant: MerchantRow) {
  return {
    id: merchant.id,
    name: merchant.name,
    category: merchant.category,
    acceptedCreditTypes: CREDIT_TYPES.filter((type) => merchant.acceptedCreditTypes.includes(type)),
    city: merchant.city,
    status: merchant.status,
    commissionGrid: visibleGrid(merchant.commissionGrids),
    createdAt: merchant.createdAt.toISOString(),
  };
}

function approvalBody(approval: Approval, userId: string, pii?: PiiService) {
  return {
    id: approval.id,
    type: approval.type,
    status: approval.status,
    subject: approval.subject,
    ...(approval.oldRateBps === null ? {} : { oldRateBps: approval.oldRateBps }),
    ...(approval.newRateBps === null ? {} : { newRateBps: approval.newRateBps }),
    ...(approval.type === 'IBAN_CHANGE' && pii !== undefined
      ? { maskedIban: pii.maskedIban((approval.payload as unknown as IbanChangePayload).iban) }
      : {}),
    ...(approval.type === 'COMMISSION_GRID_CHANGE'
      ? {
          commissionGrid: {
            previous: (approval.payload as unknown as GridChangePayload).previous,
            proposed: (approval.payload as unknown as GridChangePayload).tiers,
          },
        }
      : {}),
    reason: approval.reason,
    initiatorName: approval.initiatorName,
    initiatedByMe: approval.initiatorId === userId,
    createdAt: approval.createdAt.toISOString(),
  };
}

export interface PlatformSettingsInput {
  payoutMinimumMillimes: number;
  creditValidityMonths: number;
  maxFamilyMembers: number;
  orderFeeRateBps: number;
  vatRateBps: number;
  stampDutyMillimes: number;
  expiredCreditsDestination: 'PLATFORM_REVENUE' | 'COMPANY_RETURN';
  creditTypes: {
    creditType: CreditType;
    enabled: boolean;
    commissionRateBps: number;
    validityMonths: number;
    dailyLimitMillimes: number;
  }[];
}

const textSearch = (needle: string | undefined, fields: string[]) =>
  needle === undefined || needle.trim() === ''
    ? {}
    : {
        OR: fields.map((field) => ({
          [field]: { contains: needle.trim(), mode: 'insensitive' as const },
        })),
      };

@Injectable()
export class AdminService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(FILE_STORAGE) private readonly storage: FileStorage,
    @Inject(FourEyesService) private readonly fourEyes: FourEyesService,
    @Inject(DisputesService) private readonly disputes: DisputesService,
    @Inject(PiiService) private readonly pii: PiiService,
    @Inject(InvitationService) private readonly invitations: InvitationService,
  ) {}

  private period(request: { createdFrom?: Date; createdTo?: Date }, field = 'createdAt') {
    return request.createdFrom === undefined && request.createdTo === undefined
      ? {}
      : {
          [field]: {
            ...(request.createdFrom === undefined ? {} : { gte: request.createdFrom }),
            ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
          },
        };
  }

  // ---------------------------------------------------------------- dashboard

  async dashboard() {
    return this.db.user(async (tx) => {
      const collected = { status: { in: ['CONFIRMED' as const, 'SETTLED' as const] } };
      // One transaction = one connection: its queries run one after the other.
      const merchantsCount = await tx.merchant.count();
      const companiesCount = await tx.company.count();
      const pendingApprovalsCount = await tx.approval.count({ where: { status: 'PENDING' } });
      const pendingKycCount = await tx.kycFile.count({ where: { status: 'PENDING' } });
      const today = await tx.payment.aggregate({
        where: { ...collected, confirmedAt: { gte: startOfBusinessDay(businessDay()) } },
        _sum: { amountMillimes: true },
      });
      const next = await tx.settlementBatch.findFirst({
        where: { status: 'SCHEDULED' },
        orderBy: { settlementDate: 'asc' },
        include: { payouts: true },
      });
      const months = lastMonths(6);
      const since = startOfBusinessMonth(months[0]);
      const validated = await tx.creditOrderEvent.findMany({
        where: { action: 'VALIDATED', occurredAt: { gte: since } },
        include: { order: { select: { amountMillimes: true } } },
      });
      const payments = await tx.payment.findMany({
        where: { ...collected, confirmedAt: { gte: since } },
        select: { amountMillimes: true, confirmedAt: true, creditType: true },
      });
      const index = (date: Date) => months.indexOf(businessDay(date).slice(0, 7));
      const flows = months.map((month) => ({ month, credited: 0n, payments: 0n }));
      const byType = new Map<CreditType, bigint>();
      for (const event of validated) {
        const flow = flows[index(event.occurredAt)];
        if (flow !== undefined) flow.credited += event.order.amountMillimes;
      }
      for (const payment of payments) {
        if (payment.confirmedAt === null) continue;
        const flow = flows[index(payment.confirmedAt)];
        if (flow !== undefined) flow.payments += payment.amountMillimes;
        if (index(payment.confirmedAt) === months.length - 1)
          byType.set(
            payment.creditType,
            (byType.get(payment.creditType) ?? 0n) + payment.amountMillimes,
          );
      }
      return {
        merchantsCount,
        companiesCount,
        todayVolumeMillimes: toMillimes(today._sum.amountMillimes ?? 0n),
        pendingApprovalsCount,
        pendingKycCount,
        nextSettlementNetMillimes: toMillimes(
          next?.payouts.reduce((sum, payout) => sum + payout.netMillimes, 0n) ?? 0n,
        ),
        monthlyFlows: flows.map((flow) => ({
          month: flow.month,
          creditedMillimes: toMillimes(flow.credited),
          paymentsMillimes: toMillimes(flow.payments),
        })),
        monthByCreditType: CREDIT_TYPES.map((creditType) => ({
          creditType,
          amountMillimes: toMillimes(byType.get(creditType) ?? 0n),
        })),
      };
    });
  }

  // ---------------------------------------------------------------- merchants and companies

  async merchants(query: Record<string, unknown>, filters: { status?: AccountStatus; q?: string }) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.MerchantWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...textSearch(filters.q, ['name', 'city']),
        ...this.period(request),
      };
      const rows = await tx.merchant.findMany({
        where,
        include: { commissionGrids: currentGridInclude },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.merchant.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(request, rows.map(merchantAccount), filters, count);
    });
  }

  async merchant(id: string) {
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUnique({
        where: { id },
        include: { commissionGrids: currentGridInclude },
      });
      if (merchant === null) throw problems.notFound();
      return merchantAccount(merchant);
    });
  }

  /** New merchant: PENDING_KYC (inactive until its KYC file is approved), unique payment code. */
  async createMerchant(input: {
    name: string;
    category: MerchantCategory;
    city: string;
    phone: string;
    email: string;
    commissionGrid: CommissionTier[];
    acceptedCreditTypes: CreditType[];
  }) {
    const id = uuidv7();
    // The owner's sign-in account and invitation come with the shop (decision of 2026-10-14).
    const invitations = await this.invitations.prepare([
      {
        role: 'MERCHANT',
        subRole: 'OWNER',
        displayName: input.name.trim(),
        email: input.email,
        merchantId: id,
      },
    ]);
    const body = await this.db.user(async (tx) => {
      const exists = await tx.merchant.findFirst({
        where: { name: { equals: input.name.trim(), mode: 'insensitive' } },
      });
      if (exists !== null) throw problems.conflict();
      let paymentCode = String(randomInt(100_000, 1_000_000));
      while ((await tx.merchant.findUnique({ where: { paymentCode } })) !== null)
        paymentCode = String(randomInt(100_000, 1_000_000));
      await tx.merchant.create({
        data: {
          id,
          name: input.name.trim(),
          category: input.category,
          city: input.city.trim(),
          phone: this.pii.seal(input.phone),
          email: input.email.toLowerCase(),
          acceptedCreditTypes: [...new Set(input.acceptedCreditTypes)],
          paymentCode,
          status: 'PENDING_KYC',
          createdBy: principal().userId,
        },
      });
      // The grid is entered at creation (step 2): no shop without a grid (decision 2026-11-04).
      await installGrid(tx, { merchantId: id }, input.commissionGrid, {
        createdBy: principal().userId,
      });
      const merchant = await tx.merchant.findUniqueOrThrow({
        where: { id },
        include: { commissionGrids: currentGridInclude },
      });
      await this.invitations.create(tx, invitations);
      await this.openKyc(tx, 'MERCHANT', { merchantId: merchant.id });
      await this.audit.record(tx, 'merchants.create', merchant.name);
      return merchantAccount(merchant);
    });
    await this.invitations.deliver(invitations);
    return body;
  }

  async setMerchantTypes(id: string, types: CreditType[]) {
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUnique({ where: { id } });
      if (merchant === null) throw problems.notFound();
      const updated = await tx.merchant.update({
        where: { id },
        data: { acceptedCreditTypes: [...new Set(types)] },
        include: { commissionGrids: currentGridInclude },
      });
      await this.audit.record(tx, 'merchants.creditTypes', merchant.name);
      return merchantAccount(updated);
    });
  }

  async companies(query: Record<string, unknown>, filters: { status?: AccountStatus; q?: string }) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.CompanyWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...textSearch(filters.q, ['name', 'city']),
        ...this.period(request),
      };
      const rows = await tx.company.findMany({
        where,
        include: {
          _count: { select: { employees: true } },
          commissionGrids: currentGridInclude,
        },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.company.count({ where, take: 10_001 }) : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: row.id,
          name: row.name,
          city: row.city,
          status: row.status,
          employeesCount: row._count.employees,
          commissionGrid: visibleGrid(row.commissionGrids),
          createdAt: row.createdAt.toISOString(),
        })),
        filters,
        count,
      );
    });
  }

  async createCompany(input: {
    name: string;
    city: string;
    phone: string;
    email: string;
    commissionGrid: CommissionTier[];
  }) {
    const id = uuidv7();
    const invitations = await this.invitations.prepare([
      {
        role: 'COMPANY',
        subRole: 'OWNER',
        displayName: input.name.trim(),
        email: input.email,
        companyId: id,
      },
    ]);
    const body = await this.db.user(async (tx) => {
      const exists = await tx.company.findFirst({
        where: { name: { equals: input.name.trim(), mode: 'insensitive' } },
      });
      if (exists !== null) throw problems.conflict();
      const company = await tx.company.create({
        data: {
          id,
          name: input.name.trim(),
          city: input.city.trim(),
          phone: this.pii.seal(input.phone),
          email: input.email.toLowerCase(),
          status: 'PENDING_KYC',
        },
      });
      await this.invitations.create(tx, invitations);
      // No company without a grid (decision of 2026-11-04).
      await installGrid(tx, { companyId: id }, input.commissionGrid, {
        createdBy: principal().userId,
      });
      await this.openKyc(tx, 'COMPANY', { companyId: company.id });
      await this.audit.record(tx, 'companies.create', company.name);
      return {
        id: company.id,
        name: company.name,
        city: company.city,
        status: company.status,
        employeesCount: 0,
        commissionGrid: await currentGrid(tx, { companyId: id }),
        createdAt: company.createdAt.toISOString(),
      };
    });
    await this.invitations.deliver(invitations);
    return body;
  }

  private async openKyc(
    tx: Tx,
    accountType: KycAccountType,
    owner: { merchantId?: string; companyId?: string },
  ): Promise<void> {
    const file = await tx.kycFile.create({
      data: {
        id: uuidv7(),
        accountType,
        ...owner,
        status: 'PENDING',
        createdBy: principal().userId,
      },
    });
    await tx.kycEvent.create({
      data: {
        id: uuidv7(),
        fileId: file.id,
        action: 'SUBMITTED',
        actorName: principal().displayName,
      },
    });
  }

  // ---------------------------------------------------------------- commissions, approvals, settings

  /**
   * A grid change is a request, applied only when ANOTHER administrator approves it (decision of
   * 2026-11-03); the new version applies to future orders and payouts only.
   */
  async requestGridChange(owner: GridOwner, tiers: CommissionTier[], reason: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const found =
        'companyId' in owner
          ? await tx.company.findUnique({ where: { id: owner.companyId } })
          : await tx.merchant.findUnique({ where: { id: owner.merchantId } });
      if (found === null) throw problems.notFound();
      // One pending request per owner, even for two requests at the same time.
      if ('companyId' in owner)
        await tx.$queryRaw`SELECT id FROM companies WHERE id = ${found.id}::uuid FOR UPDATE`;
      else await tx.$queryRaw`SELECT id FROM merchants WHERE id = ${found.id}::uuid FOR UPDATE`;
      const key = 'companyId' in owner ? 'companyId' : 'merchantId';
      const pending = await tx.approval.findFirst({
        where: {
          status: 'PENDING',
          type: 'COMMISSION_GRID_CHANGE',
          payload: { path: ['owner', key], equals: found.id },
        },
      });
      if (pending !== null) throw problems.conflict();
      const payload: GridChangePayload = {
        owner,
        tiers,
        previous: (await currentGrid(tx, owner))?.tiers ?? null,
      };
      const approval = await tx.approval.create({
        data: {
          id: uuidv7(),
          type: 'COMMISSION_GRID_CHANGE',
          subject: found.name,
          payload: payload as unknown as Prisma.InputJsonValue,
          reason,
          initiatorId: who.userId,
          initiatorName: who.displayName,
        },
      });
      await this.audit.record(tx, 'commissions.request', found.name);
      return approvalBody(approval, who.userId);
    });
  }

  // ---------------------------------------------------------------- records (decision of 2026-11-03)

  /** Change of a record, field names only (no personal data in the history). */
  private async recordChange(
    tx: Tx,
    owner: GridOwner,
    fields: string[],
    reason: string | null,
  ): Promise<void> {
    const who = principal();
    await tx.accountChange.create({
      data: {
        id: uuidv7(),
        ...owner,
        fields,
        reason,
        actorId: who.userId,
        actorName: who.displayName,
      },
    });
  }

  /** Record of a company or a merchant: contact, grid, history of the changes, open requests. */
  async accountRecord(owner: GridOwner) {
    const who = principal();
    const isCompany = 'companyId' in owner;
    const id = isCompany ? owner.companyId : owner.merchantId;
    const manage = allows(who.role, who.subRole, [isCompany ? 'companies.manage' : 'merchants.manage']);
    const commercial = allows(who.role, who.subRole, ['commissions.read']);
    return this.db.user(async (tx) => {
      const found = isCompany
        ? await tx.company.findUnique({
            where: { id },
            include: { commissionGrids: currentGridInclude },
          })
        : await tx.merchant.findUnique({
            where: { id },
            include: { commissionGrids: currentGridInclude },
          });
      if (found === null) throw problems.notFound();
      const changes = await tx.accountChange.findMany({
        where: owner,
        orderBy: [{ occurredAt: 'desc' }, { id: 'desc' }],
        take: 100,
      });
      const versions = commercial
        ? await tx.commissionGrid.findMany({
            where: owner,
            orderBy: [{ effectiveFrom: 'desc' }, { id: 'desc' }],
            take: 50,
            include: { tiers: { orderBy: { position: 'asc' } } },
          })
        : [];
      const key = isCompany ? 'companyId' : 'merchantId';
      const requests = await tx.approval.findMany({
        where: {
          status: 'PENDING',
          type: { in: ['COMMISSION_GRID_CHANGE', 'IBAN_CHANGE'] },
          payload: { path: ['owner', key], equals: id },
        },
        orderBy: { createdAt: 'desc' },
      });
      const merchant = isCompany ? null : (found as unknown as Merchant);
      return {
        id,
        kind: isCompany ? ('COMPANY' as const) : ('MERCHANT' as const),
        name: found.name,
        city: found.city,
        status: found.status,
        email: found.email,
        // The phone is personal data: shown to the administrators who may change it only.
        phone: manage ? this.pii.open(found.phone) : null,
        ...(merchant === null
          ? {}
          : {
              category: merchant.category,
              address: merchant.address,
              maskedIban: merchant.iban === null ? null : this.pii.maskedIban(merchant.iban),
            }),
        commissionGrid: commercial ? gridBody(found.commissionGrids) : null,
        gridVersions: versions.map((version) => ({
          tiers: version.tiers.map(tierBody),
          effectiveFrom: version.effectiveFrom.toISOString(),
        })),
        history: changes.map((change) => ({
          occurredAt: change.occurredAt.toISOString(),
          actorName: change.actorName,
          fields: change.fields,
          ...(change.reason === null ? {} : { reason: change.reason }),
        })),
        requests: requests.map((approval) => approvalBody(approval, who.userId, this.pii)),
        createdAt: found.createdAt.toISOString(),
      };
    });
  }

  /** The administrator changes the record at any time (decision of 2026-11-03); audited, history. */
  async updateAccount(owner: GridOwner, input: AccountUpdate, reason: string | undefined) {
    const isCompany = 'companyId' in owner;
    const id = isCompany ? owner.companyId : owner.merchantId;
    await this.db.user(async (tx) => {
      if (isCompany)
        await tx.$queryRaw`SELECT id FROM companies WHERE id = ${id}::uuid FOR UPDATE`;
      else await tx.$queryRaw`SELECT id FROM merchants WHERE id = ${id}::uuid FOR UPDATE`;
      const found = isCompany
        ? await tx.company.findUnique({ where: { id } })
        : await tx.merchant.findUnique({ where: { id } });
      if (found === null) throw problems.notFound();
      const name = input.name?.trim();
      if (name !== undefined && name.toLowerCase() !== found.name.toLowerCase()) {
        const same = isCompany
          ? await tx.company.findFirst({
              where: { name: { equals: name, mode: 'insensitive' }, id: { not: id } },
            })
          : await tx.merchant.findFirst({
              where: { name: { equals: name, mode: 'insensitive' }, id: { not: id } },
            });
        if (same !== null) throw problems.conflict();
      }
      const data: Record<string, string> = {};
      const fields: string[] = [];
      const take = (field: string, next: string | undefined, current: string) => {
        if (next !== undefined && next !== current) {
          fields.push(field);
          return next;
        }
        return undefined;
      };
      const changed = {
        name: take('name', name, found.name),
        city: take('city', input.city?.trim(), found.city),
        email: take('email', input.email?.toLowerCase(), found.email),
        phone:
          input.phone !== undefined && input.phone !== this.pii.open(found.phone)
            ? (fields.push('phone'), this.pii.seal(input.phone))
            : undefined,
        ...(isCompany
          ? {}
          : {
              address: take('address', input.address?.trim(), (found as Merchant).address),
              category: take('category', input.category, (found as Merchant).category),
            }),
      };
      for (const [field, value] of Object.entries(changed)) if (value !== undefined) data[field] = value;
      if (fields.length === 0) return;
      if (isCompany) await tx.company.update({ where: { id }, data });
      else await tx.merchant.update({ where: { id }, data });
      await this.recordChange(tx, owner, fields, reason ?? null);
      await this.audit.record(
        tx,
        isCompany ? 'companies.update' : 'merchants.update',
        (data.name ?? found.name).slice(0, 120),
      );
    });
    return this.accountRecord(owner);
  }

  /** A RIB change is a request applied when ANOTHER administrator approves it (four eyes). */
  async requestIbanChange(merchantId: string, iban: string, reason: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      await tx.$queryRaw`SELECT id FROM merchants WHERE id = ${merchantId}::uuid FOR UPDATE`;
      const merchant = await tx.merchant.findUnique({ where: { id: merchantId } });
      if (merchant === null) throw problems.notFound();
      const pending = await tx.approval.findFirst({
        where: {
          status: 'PENDING',
          type: 'IBAN_CHANGE',
          payload: { path: ['owner', 'merchantId'], equals: merchantId },
        },
      });
      if (pending !== null) throw problems.conflict();
      const payload: IbanChangePayload = { owner: { merchantId }, iban: this.pii.seal(iban) };
      const approval = await tx.approval.create({
        data: {
          id: uuidv7(),
          type: 'IBAN_CHANGE',
          subject: merchant.name,
          payload: payload as unknown as Prisma.InputJsonValue,
          reason,
          initiatorId: who.userId,
          initiatorName: who.displayName,
        },
      });
      await this.audit.record(tx, 'merchants.ibanRequest', merchant.name);
      return approvalBody(approval, who.userId, this.pii);
    });
  }

  async approvals(query: Record<string, unknown>, filters: { status?: ApprovalStatus }) {
    const who = principal();
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.ApprovalWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...this.period(request),
      };
      const rows = await tx.approval.findMany({
        where,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.approval.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => approvalBody(row, who.userId, this.pii)),
        filters,
        count,
      );
    });
  }

  /** Four-eyes (rule 12): the initiator can never approve its own request. */
  async approve(id: string) {
    return this.db.user((tx) => this.approveIn(tx, id));
  }

  /** Type of a request (a refund moves money: its approval needs an Idempotency-Key). */
  async approvalType(id: string) {
    const approval = await this.db.user((tx) =>
      tx.approval.findUnique({ where: { id }, select: { type: true } }),
    );
    if (approval === null) throw problems.notFound();
    return approval.type;
  }

  async approveIn(tx: Tx, id: string) {
    const who = principal();
    {
      // Approve and reject of the same request are served one after the other (securite S03).
      await tx.$queryRaw`SELECT id FROM approvals WHERE id = ${id}::uuid FOR UPDATE`;
      const approval = await tx.approval.findUnique({ where: { id } });
      if (approval === null) throw problems.notFound();
      await this.fourEyes.ensureNotAuthor(approval.initiatorId, `approbation ${approval.subject}`);
      if (approval.status !== 'PENDING') throw problems.conflict();
      if (approval.type === 'COMMISSION_RATE_CHANGE') {
        // Profiles were replaced by grids (migration 0024 closed the pending requests).
        throw problems.conflict();
      } else if (approval.type === 'COMMISSION_GRID_CHANGE') {
        const payload = approval.payload as unknown as GridChangePayload;
        await installGrid(tx, payload.owner, payload.tiers, {
          approvalId: approval.id,
          createdBy: approval.initiatorId,
        });
        await this.recordChange(tx, payload.owner, ['commissionGrid'], approval.reason);
      } else if (approval.type === 'IBAN_CHANGE') {
        // The RIB applies to the payouts requested from now on (a request keeps its IBAN).
        const payload = approval.payload as unknown as IbanChangePayload;
        await tx.merchant.update({
          where: { id: payload.owner.merchantId },
          data: { iban: payload.iban },
        });
        await this.recordChange(tx, payload.owner, ['iban'], approval.reason);
      } else if (approval.type === 'DISPUTE_REFUND') {
        // Second validation of an accepted dispute: refund of the employee (N2).
        await this.disputes.refund(tx, (approval.payload as { disputeId: string }).disputeId);
      } else {
        await this.applySettings(tx, approval.payload as unknown as PlatformSettingsInput);
      }
      const updated = await tx.approval.update({
        where: { id },
        data: { status: 'APPROVED', deciderId: who.userId, decidedAt: new Date() },
      });
      await this.audit.record(tx, 'approvals.approve', approval.subject);
      return approvalBody(updated, who.userId);
    }
  }

  async reject(id: string, reason: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      // Approve and reject of the same request are served one after the other (securite S03).
      await tx.$queryRaw`SELECT id FROM approvals WHERE id = ${id}::uuid FOR UPDATE`;
      const approval = await tx.approval.findUnique({ where: { id } });
      if (approval === null) throw problems.notFound();
      if (approval.status !== 'PENDING') throw problems.conflict();
      const updated = await tx.approval.update({
        where: { id },
        data: {
          status: 'REJECTED',
          deciderId: who.userId,
          decidedAt: new Date(),
          rejectReason: reason,
        },
      });
      if (approval.type === 'DISPUTE_REFUND') {
        // Refund refused: the dispute goes back to investigation (N2).
        await this.disputes.reopen(tx, (approval.payload as { disputeId: string }).disputeId);
      }
      await this.audit.record(tx, 'approvals.reject', approval.subject);
      return approvalBody(updated, who.userId);
    });
  }

  async platformSettings() {
    return this.db.user(async (tx) => {
      const platform = await this.settings.platform(tx);
      const types = await this.settings.creditTypes(tx);
      return {
        payoutMinimumMillimes: toMillimes(platform.payoutMinimumMillimes),
        creditValidityMonths: platform.creditValidityMonths,
        maxFamilyMembers: platform.maxFamilyMembers,
        orderFeeRateBps: platform.orderFeeRateBps,
        vatRateBps: platform.vatRateBps,
        stampDutyMillimes: toMillimes(platform.stampDutyMillimes),
        expiredCreditsDestination: platform.expiredCreditsDestination,
        creditTypes: types.map(typeSettingsBody),
      };
    });
  }

  /** A settings change is a request (202), applied when another administrator approves it. */
  async requestSettingsChange(settings: PlatformSettingsInput, reason: string) {
    const who = principal();
    if (new Set(settings.creditTypes.map((item) => item.creditType)).size !== CREDIT_TYPES.length) {
      throw validationFailed([
        { in: 'body', pointer: '/settings/creditTypes', code: 'INVALID_FORMAT' },
      ]);
    }
    return this.db.user(async (tx) => {
      const pending = await tx.approval.findFirst({
        where: { status: 'PENDING', type: 'SETTINGS_CHANGE' },
      });
      if (pending !== null) throw problems.conflict();
      const approval = await tx.approval.create({
        data: {
          id: uuidv7(),
          type: 'SETTINGS_CHANGE',
          subject: 'Paramétrage de la plateforme',
          payload: settings as unknown as Prisma.InputJsonValue,
          reason,
          initiatorId: who.userId,
          initiatorName: who.displayName,
        },
      });
      await this.audit.record(tx, 'settings.request', approval.subject);
      return approvalBody(approval, who.userId);
    });
  }

  private async applySettings(tx: Tx, settings: PlatformSettingsInput): Promise<void> {
    await tx.platformSettings.update({
      where: { id: 1 },
      data: {
        payoutMinimumMillimes: BigInt(settings.payoutMinimumMillimes),
        creditValidityMonths: settings.creditValidityMonths,
        maxFamilyMembers: settings.maxFamilyMembers,
        orderFeeRateBps: settings.orderFeeRateBps,
        vatRateBps: settings.vatRateBps,
        stampDutyMillimes: BigInt(settings.stampDutyMillimes),
        expiredCreditsDestination: settings.expiredCreditsDestination,
        updatedAt: new Date(),
      },
    });
    for (const item of settings.creditTypes) {
      await tx.creditTypeSetting.update({
        where: { creditType: item.creditType },
        data: {
          enabled: item.enabled,
          commissionRateBps: item.commissionRateBps,
          validityMonths: item.validityMonths,
          dailyLimitMillimes: BigInt(item.dailyLimitMillimes),
        },
      });
    }
  }

  // ---------------------------------------------------------------- supervision

  async transactions(
    query: Record<string, unknown>,
    filters: { status?: PaymentStatus; creditType?: CreditType; q?: string },
  ) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const needle = filters.q?.trim();
      const where: Prisma.PaymentWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.creditType === undefined ? {} : { creditType: filters.creditType }),
        ...(needle === undefined || needle === ''
          ? {}
          : {
              OR: [
                { reference: { contains: needle, mode: 'insensitive' } },
                { merchant: { name: { contains: needle, mode: 'insensitive' } } },
                { employee: { company: { name: { contains: needle, mode: 'insensitive' } } } },
              ],
            }),
        ...this.period(request),
      };
      const rows = await tx.payment.findMany({
        where,
        include: {
          merchant: { select: { name: true } },
          employee: { select: { company: { select: { name: true } } } },
        },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.payment.count({ where, take: 10_001 }) : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: row.id,
          reference: row.reference,
          merchantName: row.merchant.name,
          companyName: row.employee.company.name,
          creditType: row.creditType,
          amountMillimes: toMillimes(row.amountMillimes),
          status: row.status,
          createdAt: row.createdAt.toISOString(),
        })),
        filters,
        count,
      );
    });
  }

  async auditLogs(query: Record<string, unknown>, filters: { q?: string }): Promise<Page<unknown>> {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.AuditLogWhereInput = {
        ...textSearch(filters.q, ['actorName', 'action', 'target']),
        ...this.period(request, 'occurredAt'),
      };
      const rows = await tx.auditLog.findMany({
        where,
        orderBy: [{ occurredAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.auditLog.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: row.id,
          occurredAt: row.occurredAt.toISOString(),
          actorName: row.actorName,
          action: row.action,
          target: row.target,
        })),
        filters,
        count,
      );
    });
  }

  // ---------------------------------------------------------------- KYC

  private kycInclude = {
    merchant: { select: { name: true, city: true } },
    company: { select: { name: true, city: true } },
    documents: { orderBy: { uploadedAt: 'asc' } },
    events: { orderBy: { occurredAt: 'asc' } },
  } as const satisfies Prisma.KycFileInclude;

  private kycSummary(file: Prisma.KycFileGetPayload<{ include: AdminService['kycInclude'] }>) {
    const account = file.merchant ?? file.company;
    return {
      id: file.id,
      accountType: file.accountType,
      accountId: file.merchantId ?? file.companyId ?? '',
      accountName: account?.name ?? '',
      city: account?.city ?? '',
      status: file.status,
      submittedAt: file.submittedAt.toISOString(),
      documentsCount: file.documents.length,
    };
  }

  private kycDetail(file: Prisma.KycFileGetPayload<{ include: AdminService['kycInclude'] }>) {
    return {
      ...this.kycSummary(file),
      documents: file.documents.map((document) => ({
        id: document.id,
        type: document.type,
        fileName: document.fileName,
        contentType: document.contentType,
        sizeBytes: document.sizeBytes,
        uploadedAt: document.uploadedAt.toISOString(),
      })),
      ...(file.rejectionReason === null ? {} : { rejectionReason: file.rejectionReason }),
      history: file.events.map((event) => ({
        action: event.action,
        occurredAt: event.occurredAt.toISOString(),
        actorName: event.actorName,
        ...(event.reason === null ? {} : { reason: event.reason }),
      })),
    };
  }

  async kycFiles(
    query: Record<string, unknown>,
    filters: { status?: KycStatus; accountType?: KycAccountType },
  ) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.KycFileWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.accountType === undefined ? {} : { accountType: filters.accountType }),
      };
      const all = await tx.kycFile.findMany({
        where,
        select: { id: true, status: true, submittedAt: true },
      });
      const ranked = all
        .sort(
          (a, b) =>
            Number(b.status === 'PENDING') - Number(a.status === 'PENDING') ||
            b.submittedAt.getTime() - a.submittedAt.getTime(),
        )
        .slice(request.offset, request.offset + request.limit + 1)
        .map((row) => row.id);
      const rows = await tx.kycFile.findMany({
        where: { id: { in: ranked } },
        include: this.kycInclude,
      });
      const byId = new Map(rows.map((row) => [row.id, row]));
      return this.paginator.page(
        request,
        ranked.flatMap((id) => {
          const row = byId.get(id);
          return row === undefined ? [] : [this.kycSummary(row)];
        }),
        filters,
        request.withCount ? all.length : undefined,
      );
    });
  }

  async kycFile(id: string) {
    return this.db.user(async (tx) => {
      const file = await tx.kycFile.findUnique({ where: { id }, include: this.kycInclude });
      if (file === null) throw problems.notFound();
      return this.kycDetail(file);
    });
  }

  async kycDocument(
    fileId: string,
    documentId: string,
  ): Promise<{ data: Buffer; contentType: string; fileName: string }> {
    const document = await this.db.user((tx) =>
      tx.kycDocument.findFirst({ where: { id: documentId, fileId } }),
    );
    if (document === null) throw problems.notFound();
    return {
      data: await this.storage.get(document.storageKey),
      contentType: document.contentType,
      fileName: document.fileName,
    };
  }

  /** KYC decision: the account becomes active (approved) or stays inactive (rejected). */
  async decideKyc(id: string, decision: 'APPROVED' | 'REJECTED', reason?: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      // Two decisions on the same file are served one after the other (securite QY-04).
      await tx.$queryRaw`SELECT id FROM kyc_files WHERE id = ${id}::uuid FOR UPDATE`;
      const file = await tx.kycFile.findUnique({ where: { id }, include: this.kycInclude });
      if (file === null) throw problems.notFound();
      if (file.status !== 'PENDING') throw problems.conflict();
      // The administrator who opened the file (created the account) never decides it.
      await this.fourEyes.ensureNotAuthor(file.createdBy, `dossier KYC ${id}`, {
        authorRequired: true,
      });
      await tx.kycFile.update({
        where: { id },
        data: { status: decision, rejectionReason: reason ?? null },
      });
      await tx.kycEvent.create({
        data: {
          id: uuidv7(),
          fileId: id,
          action: decision,
          actorName: who.displayName,
          reason: reason ?? null,
        },
      });
      if (file.merchantId !== null)
        await tx.merchant.update({ where: { id: file.merchantId }, data: { status: decision } });
      if (file.companyId !== null)
        await tx.company.update({ where: { id: file.companyId }, data: { status: decision } });
      await this.audit.record(
        tx,
        decision === 'APPROVED' ? 'kyc.approve' : 'kyc.reject',
        file.merchant?.name ?? file.company?.name ?? id,
      );
      const updated = await tx.kycFile.findUniqueOrThrow({
        where: { id },
        include: this.kycInclude,
      });
      return this.kycDetail(updated);
    });
  }
}
