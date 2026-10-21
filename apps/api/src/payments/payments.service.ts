import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { randomDigits, uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { commissionOf, fromMillimes, toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { permissionsOf } from '../common/permissions.js';
import { principal } from '../common/request-context.js';
import { addDays, businessDay, dateOnly, dayOf, startOfBusinessDay } from '../common/tunis.js';
import type { CreditType, Payment, PaymentEvent } from '../generated/prisma/client.js';
import { InsufficientFundsError, LedgerService, accounts } from '../ledger/ledger.service.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';
import { PinService } from './pin.service.js';

/** Validity of a beneficiary payment code and of a merchant request (DP n° 8: 60 s). */
export const CODE_VALIDITY_SECONDS = 60;
const REQUEST_VALIDITY_MS = 60_000;
/** Expiry alert window (cahier §5: J-30). */
const EXPIRY_ALERT_DAYS = 30;

function customerOf(payment: Payment) {
  return {
    firstName: payment.customerFirstName,
    lastInitial: payment.customerLastInitial,
    maskedEmployeeNumber: payment.customerMaskedNumber,
  };
}

/** What the merchant sees of a payment (never the balance of the customer). */
export function merchantPayment(payment: Payment) {
  return {
    id: payment.id,
    reference: payment.reference,
    status: payment.status,
    creditType: payment.creditType,
    amountMillimes: toMillimes(payment.amountMillimes),
    customer: customerOf(payment),
    createdAt: payment.createdAt.toISOString(),
    expiresAt:
      payment.status === 'INITIATED' && payment.expiresAt !== null
        ? payment.expiresAt.toISOString()
        : null,
  };
}

@Injectable()
export class PaymentsService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(PinService) private readonly pins: PinService,
  ) {}

  private employeeId(): string {
    const id = principal().employeeId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  private merchantId(): string {
    const id = principal().merchantId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  /** Requests not confirmed in time become REFUSED (server status, contract §9). */
  async expireStale(): Promise<void> {
    await this.db.system(async (tx) => {
      const stale = await tx.payment.findMany({
        where: { status: 'INITIATED', expiresAt: { lt: new Date() } },
        select: { id: true },
        take: 500,
      });
      if (stale.length === 0) return;
      // Only the requests actually moved get a REFUSED event (a confirmation may have won).
      const moved = await tx.$queryRaw<{ id: string }[]>`
        UPDATE payments SET status = 'REFUSED'
         WHERE id = ANY(${stale.map((row) => row.id)}::uuid[]) AND status = 'INITIATED'
        RETURNING id`;
      const ids = moved.map((row) => row.id);
      await tx.paymentEvent.createMany({
        data: ids.map((paymentId) => ({ id: uuidv7(), paymentId, status: 'REFUSED' as const })),
      });
    });
  }

  // ---------------------------------------------------------------- beneficiary

  async wallet() {
    const employeeId = this.employeeId();
    return this.db.user(async (tx) => {
      const employee = await tx.employee.findUniqueOrThrow({
        where: { id: employeeId },
        include: { company: { select: { name: true } } },
      });
      const types = await this.settings.creditTypes(tx);
      const balances = await this.ledger.balances(
        tx,
        CREDIT_TYPES.map((type) => accounts.employeeWallet(employeeId, type)),
      );
      const spent = await this.spentToday(tx, employeeId);
      const horizon = new Date(Date.now() + EXPIRY_ALERT_DAYS * 86_400_000);
      // One transaction = one connection: the lots of each type are read one after the other.
      const lotsByType = new Map<CreditType, Awaited<ReturnType<LedgerService['lots']>>>();
      for (const type of CREDIT_TYPES)
        lotsByType.set(type, await this.ledger.lots(tx, accounts.employeeWallet(employeeId, type)));
      const rows = CREDIT_TYPES.map((type) => {
        const lots = (lotsByType.get(type) ?? []).filter(
          (lot) => lot.remaining > 0n && lot.expiresAt > new Date(),
        );
        const expiring = lots.filter((lot) => lot.expiresAt <= horizon);
        const setting = types.find((row) => row.creditType === type);
        return {
          creditType: type,
          balanceMillimes: toMillimes(
            balances.get(accounts.employeeWallet(employeeId, type).code) ?? 0n,
          ),
          expiringMillimes: toMillimes(expiring.reduce((sum, lot) => sum + lot.remaining, 0n)),
          nextExpiryDate: expiring[0] === undefined ? null : businessDay(expiring[0].expiresAt),
          dailyLimitMillimes: toMillimes(setting?.dailyLimitMillimes ?? 0n),
          todaySpentMillimes: toMillimes(spent.get(type) ?? 0n),
          enabled: setting?.enabled ?? false,
        };
      });
      return {
        companyName: employee.company.name,
        totalBalanceMillimes: rows.reduce((sum, row) => sum + row.balanceMillimes, 0),
        balances: rows,
      };
    });
  }

  /** Confirmed payments of the business day, per type (daily limit). */
  private async spentToday(tx: Tx, employeeId: string): Promise<Map<CreditType, bigint>> {
    const rows = await tx.payment.groupBy({
      by: ['creditType'],
      where: {
        employeeId,
        status: { in: ['CONFIRMED', 'SETTLED'] },
        confirmedAt: { gte: startOfBusinessDay(businessDay()) },
      },
      _sum: { amountMillimes: true },
    });
    return new Map(rows.map((row) => [row.creditType, row._sum.amountMillimes ?? 0n]));
  }

  /** A new code cancels the previous one (contract). */
  async newCode() {
    const employeeId = this.employeeId();
    return this.db.user(async (tx) => {
      await tx.paymentCode.updateMany({
        where: { employeeId, consumedAt: null },
        data: { consumedAt: new Date() },
      });
      const code = randomDigits(8);
      const expiresAt = new Date(Date.now() + CODE_VALIDITY_SECONDS * 1000);
      await tx.paymentCode.create({ data: { id: uuidv7(), employeeId, code, expiresAt } });
      return {
        code,
        qrPayload: `flexipay:pay:${code}`,
        expiresAt: expiresAt.toISOString(),
        validitySeconds: CODE_VALIDITY_SECONDS,
      };
    });
  }

  async requests() {
    const employeeId = this.employeeId();
    await this.expireStale();
    return this.db.user(async (tx) => {
      const rows = await tx.payment.findMany({
        where: { employeeId, status: 'INITIATED', expiresAt: { gt: new Date() } },
        include: { merchant: { select: { name: true } } },
        orderBy: { createdAt: 'desc' },
      });
      return {
        data: rows.map((row) => ({
          id: row.id,
          reference: row.reference,
          merchantName: row.merchant.name,
          amountMillimes: toMillimes(row.amountMillimes),
          creditType: row.creditType,
          createdAt: row.createdAt.toISOString(),
          expiresAt: (row.expiresAt ?? row.createdAt).toISOString(),
        })),
      };
    });
  }

  /**
   * Debits the employee wallet of ONE type for a payment (never another type): type enabled,
   * daily limit, FEFO lots, then one ledger transaction (one debit per lot, credit of the
   * merchant wallet of the same type). Exposes INSUFFICIENT_FUNDS / LIMIT_EXCEEDED to the payer.
   */
  private async debit(
    tx: Tx,
    payment: {
      employeeId: string;
      merchantId: string;
      creditType: CreditType;
      amount: bigint;
      reference: string;
    },
    key: string,
  ) {
    const who = principal();
    const setting = await this.settings.creditType(tx, payment.creditType);
    if (!setting.enabled)
      throw validationFailed([{ in: 'body', pointer: '/creditType', code: 'INVALID_ENUM' }]);
    const wallet = accounts.employeeWallet(payment.employeeId, payment.creditType);
    // Lock the wallet first: the daily limit and the lots are read under the same lock.
    await this.ledger.lockAccounts(tx, [
      wallet,
      accounts.merchantWallet(payment.merchantId, payment.creditType),
    ]);
    const spent = (await this.spentToday(tx, payment.employeeId)).get(payment.creditType) ?? 0n;
    if (spent + payment.amount > setting.dailyLimitMillimes) {
      const remaining = setting.dailyLimitMillimes - spent;
      throw new ApiProblem(422, 'LIMIT_EXCEEDED', {
        limitType: 'DAILY',
        remainingMillimes: toMillimes(remaining > 0n ? remaining : 0n),
      });
    }
    let parts: { lotId: string; amount: bigint }[];
    try {
      parts = await this.ledger.consumeFefo(tx, wallet, payment.amount, new Date());
    } catch (error) {
      if (error instanceof InsufficientFundsError) {
        throw new ApiProblem(422, 'INSUFFICIENT_FUNDS', {
          missingMillimes: toMillimes(error.missing),
        });
      }
      throw error;
    }
    const posted = await this.ledger.post(tx, {
      type: 'PAYMENT',
      reference: payment.reference,
      tenantId: who.companyId,
      userId: who.userId,
      idempotencyKey: key,
      entries: [
        ...parts.map((part) => ({
          account: wallet,
          direction: 'D' as const,
          amount: part.amount,
          lotId: part.lotId,
        })),
        {
          account: accounts.merchantWallet(payment.merchantId, payment.creditType),
          direction: 'C',
          amount: payment.amount,
        },
      ],
    });
    return {
      transactionId: posted.transactionId,
      rateBps: await this.settings.commissionRate(tx, payment.merchantId, payment.creditType),
    };
  }

  /** Confirmation by PIN of a merchant request (financial, idempotent). */
  async confirmRequest(tx: Tx, paymentId: string, key: string) {
    const employeeId = this.employeeId();
    const locked = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM payments WHERE id = ${paymentId}::uuid FOR UPDATE`;
    if (locked.length === 0) throw problems.notFound();
    const payment = await tx.payment.findUnique({ where: { id: paymentId } });
    if (payment?.employeeId !== employeeId) throw problems.notFound();
    if (
      payment.status !== 'INITIATED' ||
      payment.expiresAt === null ||
      payment.expiresAt.getTime() <= Date.now()
    ) {
      throw problems.conflict();
    }
    const { transactionId, rateBps } = await this.debit(
      tx,
      {
        employeeId,
        merchantId: payment.merchantId,
        creditType: payment.creditType,
        amount: payment.amountMillimes,
        reference: payment.reference,
      },
      key,
    );
    const now = new Date();
    await tx.payment.update({
      where: { id: paymentId },
      data: {
        status: 'CONFIRMED',
        confirmedAt: now,
        transactionId,
        commissionRateBps: rateBps,
        settlementDate: dateOnly(addDays(businessDay(now), 2)),
      },
    });
    await tx.paymentEvent.create({
      data: { id: uuidv7(), paymentId, status: 'CONFIRMED', occurredAt: now },
    });
    return this.operationDetail(tx, `PAYMENT:${paymentId}`);
  }

  async refuseRequest(paymentId: string): Promise<void> {
    const employeeId = this.employeeId();
    await this.db.user(async (tx) => {
      const payment = await tx.payment.findUnique({ where: { id: paymentId } });
      if (payment?.employeeId !== employeeId) throw problems.notFound();
      // Conditional: a confirmation that won the race is never turned into a refusal (C4).
      const moved = await tx.payment.updateMany({
        where: { id: paymentId, status: 'INITIATED' },
        data: { status: 'REFUSED' },
      });
      if (moved.count !== 1) throw problems.conflict();
      await tx.paymentEvent.create({ data: { id: uuidv7(), paymentId, status: 'REFUSED' } });
    });
  }

  async lookupMerchant(code: string) {
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUnique({ where: { paymentCode: code } });
      if (merchant?.status !== 'APPROVED') throw problems.notFound();
      return {
        merchantCode: merchant.paymentCode,
        merchantName: merchant.name,
        city: merchant.city,
        category: merchant.category,
        acceptedCreditTypes: CREDIT_TYPES.filter((type) =>
          merchant.acceptedCreditTypes.includes(type),
        ),
      };
    });
  }

  private async nextReference(tx: Tx): Promise<string> {
    const [sequence] = await tx.$queryRaw<
      { value: bigint }[]
    >`SELECT nextval('payment_reference_seq') AS value`;
    return `PAY-${String(sequence?.value ?? 0n)}`;
  }

  private async customerSnapshot(tx: Tx, employeeId: string) {
    const employee = await tx.employee.findUniqueOrThrow({ where: { id: employeeId } });
    return {
      employee,
      customerFirstName: employee.firstName,
      customerLastInitial: employee.lastName.charAt(0),
      customerMaskedNumber: `•••${employee.employeeNumber.slice(-4)}`,
    };
  }

  /** The beneficiary pays a merchant by its code (financial, idempotent). */
  async payMerchant(
    tx: Tx,
    input: { merchantCode: string; creditType: CreditType; amountMillimes: number },
    key: string,
  ) {
    const employeeId = this.employeeId();
    const merchant = await tx.merchant.findUnique({ where: { paymentCode: input.merchantCode } });
    if (merchant?.status !== 'APPROVED') throw problems.notFound();
    // Only a type accepted by the merchant (no payment with another type).
    if (!merchant.acceptedCreditTypes.includes(input.creditType)) {
      throw validationFailed([{ in: 'body', pointer: '/creditType', code: 'INVALID_ENUM' }]);
    }
    const amount = fromMillimes(input.amountMillimes);
    const reference = await this.nextReference(tx);
    const { employee, ...snapshot } = await this.customerSnapshot(tx, employeeId);
    const { transactionId, rateBps } = await this.debit(
      tx,
      { employeeId, merchantId: merchant.id, creditType: input.creditType, amount, reference },
      key,
    );
    const now = new Date();
    const id = uuidv7();
    await tx.payment.create({
      data: {
        id,
        reference,
        merchantId: merchant.id,
        employeeId,
        companyId: employee.companyId,
        creditType: input.creditType,
        amountMillimes: amount,
        status: 'CONFIRMED',
        channel: 'MERCHANT_CODE',
        confirmedAt: now,
        commissionRateBps: rateBps,
        settlementDate: dateOnly(addDays(businessDay(now), 2)),
        transactionId,
        ...snapshot,
        events: {
          create: [
            { id: uuidv7(), status: 'INITIATED', occurredAt: now },
            { id: uuidv7(), status: 'CONFIRMED', occurredAt: now },
          ],
        },
      },
    });
    return this.operationDetail(tx, `PAYMENT:${id}`);
  }

  // ---------------------------------------------------------------- operations (history, receipt)

  /** Union of payments, allocations and expiries of the beneficiary, newest first. */
  private async operations(
    tx: Tx,
    employeeId: string,
    filters: { type?: string; creditType?: CreditType; from?: Date; to?: Date; id?: string },
    offset: number,
    limit: number,
  ) {
    const rows = await tx.$queryRaw<
      {
        id: string;
        reference: string;
        type: 'PAYMENT' | 'ALLOCATION' | 'EXPIRY';
        direction: 'DEBIT' | 'CREDIT';
        amount: bigint;
        credit_type: CreditType;
        counterparty: string;
        city: string | null;
        status: 'COMPLETED' | 'PENDING' | 'REFUSED';
        occurred_at: Date;
        transaction_id: string | null;
      }[]
    >`
      SELECT * FROM (
        SELECT 'PAYMENT:' || p.id AS id, p.reference, 'PAYMENT' AS type, 'DEBIT' AS direction, p.amount_millimes AS amount,
               p.credit_type::text AS credit_type, m.name AS counterparty, m.city,
               CASE p.status WHEN 'INITIATED' THEN 'PENDING' WHEN 'REFUSED' THEN 'REFUSED' ELSE 'COMPLETED' END AS status,
               coalesce(p.confirmed_at, p.created_at) AS occurred_at, p.transaction_id
          FROM payments p JOIN merchants m ON m.id = p.merchant_id
         WHERE p.employee_id = ${employeeId}::uuid
        UNION ALL
        SELECT 'ALLOCATION:' || a.id, 'ATT-' || upper(substr(a.id::text, 1, 8)), 'ALLOCATION', 'CREDIT', a.amount_millimes,
               a.credit_type::text, c.name, c.city, 'COMPLETED', a.created_at, a.transaction_id
          FROM allocations a JOIN companies c ON c.id = a.company_id
         WHERE a.employee_id = ${employeeId}::uuid
        UNION ALL
        SELECT 'EXPIRY:' || x.id, 'EXP-' || upper(substr(x.id::text, 1, 8)), 'EXPIRY', 'DEBIT', x.amount_millimes,
               x.credit_type::text, c.name, c.city, 'COMPLETED', x.occurred_at, x.transaction_id
          FROM credit_expiries x JOIN companies c ON c.id = x.company_id
         WHERE x.employee_id = ${employeeId}::uuid
      ) o
      WHERE (${filters.type ?? null}::text IS NULL OR o.type = ${filters.type ?? null}::text)
        AND (${filters.creditType ?? null}::text IS NULL OR o.credit_type = ${filters.creditType ?? null}::text)
        AND (${filters.from ?? null}::timestamptz IS NULL OR o.occurred_at >= ${filters.from ?? null}::timestamptz)
        AND (${filters.to ?? null}::timestamptz IS NULL OR o.occurred_at < ${filters.to ?? null}::timestamptz)
        AND (${filters.id ?? null}::text IS NULL OR o.id = ${filters.id ?? null}::text)
      ORDER BY o.occurred_at DESC, o.id DESC
      OFFSET ${offset} LIMIT ${limit}`;
    return rows;
  }

  /** Public id of an operation: the UUID of its row (prefix kept server side). */
  private static publicId(id: string): string {
    return id.slice(id.indexOf(':') + 1);
  }

  async listOperations(
    query: Record<string, unknown>,
    filters: { type?: 'PAYMENT' | 'ALLOCATION' | 'EXPIRY'; creditType?: CreditType },
  ): Promise<Page<unknown>> {
    const employeeId = this.employeeId();
    await this.expireStale();
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const rows = await this.operations(
        tx,
        employeeId,
        {
          ...filters,
          ...(request.createdFrom === undefined ? {} : { from: request.createdFrom }),
          ...(request.createdTo === undefined ? {} : { to: request.createdTo }),
        },
        request.offset,
        request.limit + 1,
      );
      const count = request.withCount
        ? (await this.operations(tx, employeeId, filters, 0, 10_001)).length
        : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: PaymentsService.publicId(row.id),
          reference: row.reference,
          type: row.type,
          direction: row.direction,
          amountMillimes: toMillimes(row.amount),
          creditType: row.credit_type,
          counterpartyName: row.counterparty,
          status: row.status,
          occurredAt: row.occurred_at.toISOString(),
        })),
        filters,
        count,
      );
    });
  }

  /** Receipt of an operation, with the balance of the type right after it. */
  private async operationDetail(tx: Tx, prefixedId: string) {
    const employeeId = this.employeeId();
    const [row] = await this.operations(tx, employeeId, { id: prefixedId }, 0, 1);
    if (row === undefined) throw problems.notFound();
    const wallet = accounts.employeeWallet(employeeId, row.credit_type);
    let balanceAfter: bigint;
    if (row.transaction_id === null) {
      balanceAfter = await this.ledger.balance(tx, wallet);
    } else {
      const [entry] = await tx.$queryRaw<
        { balance: bigint }[]
      >`SELECT e.balance_after_millimes AS balance
        FROM ledger_entries e JOIN ledger_accounts a ON a.id = e.account_id
       WHERE e.transaction_id = ${row.transaction_id}::uuid AND a.code = ${wallet.code}
       ORDER BY e.id DESC LIMIT 1`;
      balanceAfter = entry?.balance ?? (await this.ledger.balance(tx, wallet));
    }
    return {
      id: PaymentsService.publicId(row.id),
      reference: row.reference,
      type: row.type,
      direction: row.direction,
      amountMillimes: toMillimes(row.amount),
      creditType: row.credit_type,
      counterpartyName: row.counterparty,
      counterpartyCity: row.city,
      status: row.status,
      occurredAt: row.occurred_at.toISOString(),
      balanceAfterMillimes: toMillimes(balanceAfter),
    };
  }

  async operation(id: string) {
    return this.db.user(async (tx) => {
      for (const prefix of ['PAYMENT', 'ALLOCATION', 'EXPIRY']) {
        const found = await this.operations(tx, this.employeeId(), { id: `${prefix}:${id}` }, 0, 1);
        if (found.length > 0) return this.operationDetail(tx, `${prefix}:${id}`);
      }
      throw problems.notFound();
    });
  }

  async profile() {
    const employeeId = this.employeeId();
    return this.db.user(async (tx) => {
      const employee = await tx.employee.findUniqueOrThrow({
        where: { id: employeeId },
        include: { company: { select: { name: true } } },
      });
      return {
        firstName: employee.firstName,
        lastName: employee.lastName,
        employeeNumber: employee.employeeNumber,
        email: employee.email,
        phone: employee.phone,
        companyName: employee.company.name,
        pinSet: employee.pinHash !== null,
      };
    });
  }

  async verifyPin(pin: string): Promise<void> {
    await this.pins.verify(this.employeeId(), pin);
  }

  async changePin(currentPin: string, newPin: string): Promise<void> {
    await this.pins.change(this.employeeId(), currentPin, newPin);
  }

  // ---------------------------------------------------------------- merchant

  /**
   * The merchant types the customer code: a request INITIATED for 60 s, confirmed by the customer
   * with the PIN. Unknown, expired or used code: generic PAYMENT_DECLINED (nothing revealed).
   */
  async initiate(
    tx: Tx,
    input: { customerCode: string; creditType: CreditType; amountMillimes: number },
  ) {
    const merchantId = this.merchantId();
    const merchant = await tx.merchant.findUniqueOrThrow({ where: { id: merchantId } });
    if (merchant.status !== 'APPROVED') throw problems.forbidden();
    if (!merchant.acceptedCreditTypes.includes(input.creditType)) {
      throw validationFailed([{ in: 'body', pointer: '/creditType', code: 'INVALID_ENUM' }]);
    }
    // The code belongs to a beneficiary of another tenant: audited server step.
    const code = await this.db.system(async (system) => {
      const found = await system.paymentCode.findFirst({
        where: { code: input.customerCode, consumedAt: null, expiresAt: { gt: new Date() } },
        orderBy: { createdAt: 'desc' },
      });
      if (found === null) return null;
      // One initiation per code (E12): consumed now, whatever happens next.
      const consumed = await system.paymentCode.updateMany({
        where: { id: found.id, consumedAt: null },
        data: { consumedAt: new Date() },
      });
      if (consumed.count !== 1) return null;
      const employee = await system.employee.findUniqueOrThrow({ where: { id: found.employeeId } });
      return { employee };
    });
    if (code === null || code.employee.status === 'SUSPENDED')
      throw new ApiProblem(422, 'PAYMENT_DECLINED');
    const now = new Date();
    const id = uuidv7();
    const reference = await this.nextReference(tx);
    // Created in the idempotent transaction of the merchant (RLS: its own merchant id only).
    const created = await tx.payment.create({
      data: {
        id,
        reference,
        merchantId,
        employeeId: code.employee.id,
        companyId: code.employee.companyId,
        creditType: input.creditType,
        amountMillimes: fromMillimes(input.amountMillimes),
        status: 'INITIATED',
        channel: 'CUSTOMER_CODE',
        expiresAt: new Date(now.getTime() + REQUEST_VALIDITY_MS),
        customerFirstName: code.employee.firstName,
        customerLastInitial: code.employee.lastName.charAt(0),
        customerMaskedNumber: `•••${code.employee.employeeNumber.slice(-4)}`,
        events: { create: [{ id: uuidv7(), status: 'INITIATED', occurredAt: now }] },
      },
    });
    await this.audit.record(tx, 'payments.initiate', created.reference);
    return merchantPayment(created);
  }

  async cancel(paymentId: string) {
    return this.db.user(async (tx) => {
      const payment = await tx.payment.findUnique({ where: { id: paymentId } });
      if (payment === null) throw problems.notFound();
      // Conditional: a confirmation that won the race is never turned into a refusal (C4).
      const moved = await tx.payment.updateMany({
        where: { id: paymentId, status: 'INITIATED' },
        data: { status: 'REFUSED' },
      });
      if (moved.count !== 1) throw problems.conflict();
      await tx.paymentEvent.create({ data: { id: uuidv7(), paymentId, status: 'REFUSED' } });
      return merchantPayment(await tx.payment.findUniqueOrThrow({ where: { id: paymentId } }));
    });
  }

  async merchantPayments(
    query: Record<string, unknown>,
    filters: { status?: Payment['status']; creditType?: CreditType; q?: string },
  ) {
    await this.expireStale();
    const request = this.paginator.request(query, filters);
    const since = this.dayOnlySince();
    // A cashier only sees the payments of the day, whatever the period asked for (B5-S02).
    const from =
      since === undefined
        ? request.createdFrom
        : request.createdFrom === undefined || request.createdFrom < since
          ? since
          : request.createdFrom;
    return this.db.user(async (tx) => {
      const needle = filters.q?.trim();
      const where = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.creditType === undefined ? {} : { creditType: filters.creditType }),
        ...(needle === undefined || needle === ''
          ? {}
          : {
              OR: [
                { reference: { contains: needle, mode: 'insensitive' as const } },
                { customerFirstName: { contains: needle, mode: 'insensitive' as const } },
              ],
            }),
        ...(from === undefined && request.createdTo === undefined
          ? {}
          : {
              createdAt: {
                ...(from === undefined ? {} : { gte: from }),
                ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
              },
            }),
      };
      const rows = await tx.payment.findMany({
        where,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.payment.count({ where, take: 10_001 }) : undefined;
      return this.paginator.page(request, rows.map(merchantPayment), filters, count);
    });
  }

  /** Detail: rate of the type, commission and net (integers), D+2 date, steps reached. */
  /** Start of the business day when the session may only read the day's sales (cashier). */
  private dayOnlySince(): Date | undefined {
    const who = principal();
    return permissionsOf(who.role, who.subRole).includes('sales.read')
      ? undefined
      : startOfBusinessDay(businessDay());
  }

  async merchantPaymentDetail(paymentId: string) {
    await this.expireStale();
    const since = this.dayOnlySince();
    return this.db.user(async (tx) => {
      const payment = await tx.payment.findUnique({
        where: { id: paymentId },
        include: { events: { orderBy: { occurredAt: 'asc' } } },
      });
      if (payment === null) throw problems.notFound();
      // A cashier only sees the payments of the day (securite B5-S02).
      if (since !== undefined && payment.createdAt < since) throw problems.notFound();
      const collected = payment.status === 'CONFIRMED' || payment.status === 'SETTLED';
      const rate =
        payment.commissionRateBps ??
        (await this.settings.commissionRate(tx, payment.merchantId, payment.creditType));
      const commission = collected ? commissionOf(payment.amountMillimes, rate) : 0n;
      return {
        ...merchantPayment(payment),
        commissionRateBps: rate,
        commissionMillimes: toMillimes(commission),
        netMillimes: toMillimes(collected ? payment.amountMillimes - commission : 0n),
        settlementDate:
          collected && payment.settlementDate !== null ? dayOf(payment.settlementDate) : null,
        history: payment.events.map((event: PaymentEvent) => ({
          status: event.status,
          occurredAt: event.occurredAt.toISOString(),
        })),
      };
    });
  }

  /** Development only: a request from a random shop reaches the beneficiary (one-tab demo). */
  async demoRequest(): Promise<void> {
    const employeeId = this.employeeId();
    await this.db.system(async (tx) => {
      const merchants = await tx.merchant.findMany({ where: { status: 'APPROVED' }, take: 50 });
      const merchant = merchants[Math.floor(Math.random() * merchants.length)];
      if (merchant === undefined) return;
      const type =
        merchant.acceptedCreditTypes[
          Math.floor(Math.random() * merchant.acceptedCreditTypes.length)
        ] ?? 'RESTAURATION';
      const snapshot = await this.customerSnapshot(tx, employeeId);
      const now = new Date();
      await tx.payment.create({
        data: {
          id: uuidv7(),
          reference: await this.nextReference(tx),
          merchantId: merchant.id,
          employeeId,
          companyId: snapshot.employee.companyId,
          creditType: type,
          amountMillimes: BigInt((25 + Math.floor(Math.random() * 46)) * 500),
          status: 'INITIATED',
          channel: 'CUSTOMER_CODE',
          expiresAt: new Date(now.getTime() + REQUEST_VALIDITY_MS),
          customerFirstName: snapshot.customerFirstName,
          customerLastInitial: snapshot.customerLastInitial,
          customerMaskedNumber: snapshot.customerMaskedNumber,
          events: { create: [{ id: uuidv7(), status: 'INITIATED', occurredAt: now }] },
        },
      });
    });
  }
}
