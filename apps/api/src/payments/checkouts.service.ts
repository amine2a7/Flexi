import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { ENV, KEYS, type Keys } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { canSpend } from '../common/account-lifecycle.js';
import { AuditService } from '../common/audit.service.js';
import { hmac, randomDigits, randomToken, safeEqual, uuidv7 } from '../common/crypto.js';
import { DbService, asService, scopeOf, type Tx } from '../common/db.service.js';
import { fromMillimes, toMillimes } from '../common/money.js';
import { permissionsOf } from '../common/permissions.js';
import { ApiProblem, problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { stickerPdf } from '../common/sticker-pdf.js';
import type { Checkout, CreditType, Register } from '../generated/prisma/client.js';
import { SettingsService } from '../platform/settings.service.js';
import { CheckoutEvents } from './checkout-events.service.js';
import { PaymentsService } from './payments.service.js';

/** Validity of a till request (M4): 120 s. */
export const CHECKOUT_SECONDS = 120;
/** Base of the link written on the NFC sticker and printed as QR. */
export const STICKER_BASE_URL = 'https://pay.flexipay.tn/c/';
const EXPIRY_TICK_MS = 5_000;
const SHORT_CODE_TRIES = 8;

export type CheckoutRefusalReason =
  | 'CREDIT_TYPE_NOT_ACCEPTED'
  | 'MERCHANT_NOT_ACTIVE'
  | 'CHECKOUT_EXPIRED'
  | 'ALREADY_PAID'
  | 'STICKER_INVALID'
  | 'NO_PENDING_CHECKOUT';

const refused = (reason: CheckoutRefusalReason) =>
  new ApiProblem(422, 'CHECKOUT_REFUSED', { reason });

type CheckoutRow = Checkout & { payment?: { reference: string } | null };

/** What the shop sees of a request (contract `Checkout`): never the balance of the customer. */
export function checkoutView(row: CheckoutRow) {
  return {
    id: row.id,
    registerId: row.registerId,
    shortCode: row.shortCode,
    amountMillimes: toMillimes(row.amountMillimes),
    creditType: row.creditType,
    status: row.status,
    createdAt: row.createdAt.toISOString(),
    expiresAt: row.expiresAt.toISOString(),
    ...(row.status === 'PAID' && row.closedAt !== null
      ? { paidAt: row.closedAt.toISOString() }
      : {}),
    ...(row.customerFirstName === null ? {} : { customerFirstName: row.customerFirstName }),
    ...(row.payment === undefined || row.payment === null
      ? {}
      : { paymentReference: row.payment.reference }),
    ...(row.lastRefusalCode === null ||
    row.lastRefusalFirstName === null ||
    row.lastRefusalAt === null
      ? {}
      : {
          lastRefusal: {
            code: row.lastRefusalCode,
            ...(row.lastRefusalReason === null ? {} : { reason: row.lastRefusalReason }),
            customerFirstName: row.lastRefusalFirstName,
            occurredAt: row.lastRefusalAt.toISOString(),
          },
        }),
  };
}

/** Refusals of a confirmation the till is told about (never a PIN error: the customer retries). */
const TILL_REFUSALS = new Set([
  'INSUFFICIENT_FUNDS',
  'LIMIT_EXCEEDED',
  'CHECKOUT_REFUSED',
  'PAYMENT_DECLINED',
]);

function registerView(row: Register) {
  return {
    id: row.id,
    name: row.name,
    status: row.status,
    publicId: row.publicId,
    createdAt: row.createdAt.toISOString(),
  };
}

/**
 * Payment by NFC sticker at the till (montage A, M4). The cashier creates a request (amount, type),
 * one per till, open 120 s, with a 4-digit code; the customer reads the sticker (signed link), sees
 * the request and confirms with the PIN: one SQL transaction locks the request, then the wallets,
 * checks balance and caps, posts the ledger, marks the request paid and writes the outbox.
 */
@Injectable()
export class CheckoutsService implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger('Checkouts');
  private timer: NodeJS.Timeout | undefined;

  constructor(
    @Inject(ENV) private readonly env: Env,
    @Inject(KEYS) private readonly keys: Keys,
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(PaymentsService) private readonly payments: PaymentsService,
    @Inject(CheckoutEvents) private readonly events: CheckoutEvents,
  ) {}

  onApplicationBootstrap(): void {
    if (this.env.NODE_ENV === 'test') return;
    // The till sees « expirée » within seconds (the 10-minute jobs are too slow for 120 s).
    this.timer = setInterval(() => {
      this.expireDue().catch((error: unknown) => {
        this.logger.error(
          `expiry failed: ${error instanceof Error ? error.constructor.name : 'unknown'}`,
        );
      });
    }, EXPIRY_TICK_MS);
    this.timer.unref();
  }

  onApplicationShutdown(): void {
    if (this.timer !== undefined) clearInterval(this.timer);
  }

  // ---------------------------------------------------------------- stickers

  /** Signature of a sticker: bound to the till AND to its shop (a sticker of another shop fails). */
  private signature(publicId: string, merchantId: string): string {
    return hmac(this.keys.session, `sticker|v1|${publicId}|${merchantId}`).slice(0, 32);
  }

  stickerUrl(register: Pick<Register, 'publicId' | 'merchantId'>): string {
    return `${STICKER_BASE_URL}${register.publicId}?s=${this.signature(register.publicId, register.merchantId)}`;
  }

  // ---------------------------------------------------------------- registers (shop)

  private merchantId(): string {
    const id = principal().merchantId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  private isOwner(): boolean {
    const who = principal();
    return permissionsOf(who.role, who.subRole).includes('registers.manage');
  }

  /** Till of the cashier of the request (null for the owner, who may use every till). */
  private async cashierRegister(tx: Tx): Promise<string | null> {
    if (this.isOwner()) return null;
    const user = await tx.user.findUnique({
      where: { id: principal().userId },
      select: { registerId: true },
    });
    // A cashier without a till collects nothing (deny by default).
    if (user?.registerId === null || user === null) throw problems.forbidden();
    return user.registerId;
  }

  /** A till of the shop of the session, that the session may use (cashier: its own only). */
  private async usableRegister(tx: Tx, registerId: string): Promise<Register> {
    const register = await tx.register.findFirst({
      where: { id: registerId, merchantId: this.merchantId() },
    });
    if (register === null) throw problems.notFound();
    const own = await this.cashierRegister(tx);
    if (own !== null && own !== registerId) throw problems.notFound();
    return register;
  }

  async listRegisters() {
    return this.db.user(async (tx) => {
      const own = await this.cashierRegister(tx);
      const rows = await tx.register.findMany({
        where: { merchantId: this.merchantId(), ...(own === null ? {} : { id: own }) },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        take: 200,
      });
      return { data: rows.map(registerView) };
    });
  }

  async createRegister(name: string) {
    return this.db.user(async (tx) => {
      const register = await tx.register.create({
        data: {
          id: uuidv7(),
          merchantId: this.merchantId(),
          name: name.trim(),
          // 128 random bits, base64url: not guessable, not derived from the shop.
          publicId: randomToken(16),
        },
      });
      await this.audit.record(tx, 'registers.create', register.name);
      return registerView(register);
    });
  }

  async updateRegister(registerId: string, input: { name?: string; status?: Register['status'] }) {
    return this.db.user(async (tx) => {
      const register = await tx.register.findFirst({
        where: { id: registerId, merchantId: this.merchantId() },
      });
      if (register === null) throw problems.notFound();
      const updated = await tx.register.update({
        where: { id: registerId },
        data: {
          ...(input.name === undefined ? {} : { name: input.name.trim() }),
          ...(input.status === undefined ? {} : { status: input.status }),
        },
      });
      if (input.status === 'DISABLED') {
        // A disabled till takes no payment: its open request is cancelled.
        const closed = await tx.$queryRaw<{ id: string }[]>`
          UPDATE checkouts SET status = 'CANCELLED', closed_at = now()
           WHERE register_id = ${registerId}::uuid AND status = 'PENDING'
          RETURNING id`;
        for (const row of closed) await this.events.notify(tx, registerId, row.id);
      }
      await this.audit.record(tx, 'registers.update', updated.name);
      return registerView(updated);
    });
  }

  async sticker(registerId: string) {
    return this.db.user(async (tx) => {
      const register = await tx.register.findFirst({
        where: { id: registerId, merchantId: this.merchantId() },
      });
      if (register === null) throw problems.notFound();
      return { url: this.stickerUrl(register) };
    });
  }

  async stickerDocument(registerId: string): Promise<{ data: Buffer; fileName: string }> {
    return this.db.user(async (tx) => {
      const register = await tx.register.findFirst({
        where: { id: registerId, merchantId: this.merchantId() },
        include: { merchant: { select: { name: true } } },
      });
      if (register === null) throw problems.notFound();
      await this.audit.record(tx, 'registers.stickerPdf', register.name);
      return {
        data: stickerPdf({
          merchantName: register.merchant.name,
          registerName: register.name,
          url: this.stickerUrl(register),
          instruction: ['Payez avec FlexiPay :', 'approchez votre téléphone ou scannez'],
        }),
        fileName: `flexipay-caisse-${register.name}.pdf`,
      };
    });
  }

  /** Attaches a cashier of the shop to one of its tills (or detaches it with null). */
  async assignCashier(userId: string, registerId: string | null): Promise<void> {
    await this.db.user(async (tx) => {
      const merchantId = this.merchantId();
      const user = await tx.user.findFirst({ where: { id: userId, merchantId } });
      if (user?.subRole !== 'CASHIER') throw problems.notFound();
      if (registerId !== null) {
        const register = await tx.register.findFirst({ where: { id: registerId, merchantId } });
        if (register === null) throw problems.notFound();
      }
      await tx.user.update({ where: { id: userId }, data: { registerId } });
      await this.audit.record(tx, 'registers.assignCashier', user.displayName);
    });
  }

  // ---------------------------------------------------------------- requests (till)

  /**
   * Closes the open requests past their deadline (any shop: audited server step), so that their
   * short codes are free again and the tills are told.
   */
  async expireDue(tx?: Tx): Promise<void> {
    const run = async (inner: Tx) => {
      const rows = await inner.$queryRaw<{ id: string; register_id: string }[]>`
        UPDATE checkouts SET status = 'EXPIRED', closed_at = now()
         WHERE status = 'PENDING' AND expires_at <= now()
        RETURNING id, register_id`;
      for (const row of rows) await this.events.notify(inner, row.register_id, row.id);
    };
    if (tx === undefined) await this.db.run({ role: 'SYSTEM' }, run);
    else await asService(tx, () => run(tx));
  }

  /**
   * The cashier asks for a payment (financial, idempotent): shop active (KYC validated), type
   * accepted, one open request per till (a new one cancels the previous), 4-digit code, 120 s.
   */
  async create(
    tx: Tx,
    registerId: string,
    input: { amountMillimes: number; creditType: CreditType },
    key: string,
  ) {
    const who = principal();
    const register = await this.usableRegister(tx, registerId);
    if (register.status !== 'ACTIVE') throw problems.conflict();
    const merchant = await tx.merchant.findUniqueOrThrow({ where: { id: register.merchantId } });
    if (merchant.status !== 'APPROVED') throw refused('MERCHANT_NOT_ACTIVE');
    const setting = await this.settings.creditType(tx, input.creditType);
    if (!merchant.acceptedCreditTypes.includes(input.creditType) || !setting.enabled) {
      throw refused('CREDIT_TYPE_NOT_ACCEPTED');
    }
    const amount = fromMillimes(input.amountMillimes);
    // The till is locked: two cashiers of one till create one request after the other.
    await tx.$queryRaw`SELECT id FROM registers WHERE id = ${registerId}::uuid FOR UPDATE`;
    // Idempotency-Key unique per shop: the same key (another cashier, another session) gives back
    // the request it created, never a second one.
    const existing = await tx.checkout.findFirst({
      where: { merchantId: register.merchantId, idempotencyKey: key },
      include: { payment: { select: { reference: true } } },
    });
    if (existing !== null) return checkoutView(existing);
    await this.expireDue(tx);
    const replaced = await tx.$queryRaw<{ id: string }[]>`
      UPDATE checkouts SET status = 'CANCELLED', closed_at = now()
       WHERE register_id = ${registerId}::uuid AND status = 'PENDING'
      RETURNING id`;
    for (const row of replaced) await this.events.notify(tx, registerId, row.id);
    const id = uuidv7();
    const expiresAt = new Date(Date.now() + CHECKOUT_SECONDS * 1000);
    let inserted = false;
    for (let attempt = 0; attempt < SHORT_CODE_TRIES && !inserted; attempt++) {
      // A code taken by an open request of any shop (unique index) is drawn again.
      const count = await tx.$executeRaw`
        INSERT INTO checkouts (id, merchant_id, register_id, amount_millimes, credit_type, short_code,
                               idempotency_key, created_by, expires_at)
        VALUES (${id}::uuid, ${register.merchantId}::uuid, ${registerId}::uuid, ${amount},
                ${input.creditType}::"CreditType", ${randomDigits(4)}, ${key}::uuid,
                ${who.userId}::uuid, ${expiresAt})
        ON CONFLICT DO NOTHING`;
      inserted = count === 1;
    }
    if (!inserted) throw new ApiProblem(503, 'SERVICE_UNAVAILABLE');
    const row = await tx.checkout.findUniqueOrThrow({ where: { id } });
    await asService(tx, () =>
      tx.outboxEvent.create({
        data: {
          id: uuidv7(),
          topic: 'checkout.created',
          aggregateId: id,
          payload: { registerId, amountMillimes: toMillimes(amount), creditType: input.creditType },
        },
      }),
    );
    await this.events.notify(tx, registerId, id);
    await this.audit.record(tx, 'checkouts.create', `${register.name} ${row.shortCode}`);
    return checkoutView(row);
  }

  async cancel(checkoutId: string) {
    return this.db.user(async (tx) => {
      const found = await tx.checkout.findFirst({
        where: { id: checkoutId, merchantId: this.merchantId() },
      });
      if (found === null) throw problems.notFound();
      await this.usableRegister(tx, found.registerId);
      // Conditional: a payment that won the race is never turned into a cancellation.
      const moved = await tx.checkout.updateMany({
        where: { id: checkoutId, status: 'PENDING' },
        data: { status: 'CANCELLED', closedAt: new Date() },
      });
      if (moved.count !== 1) throw problems.conflict();
      await this.events.notify(tx, found.registerId, checkoutId);
      return checkoutView(
        await tx.checkout.findUniqueOrThrow({
          where: { id: checkoutId },
          include: { payment: { select: { reference: true } } },
        }),
      );
    });
  }

  /** Status of a request by its Idempotency-Key (resumption after a network cut). */
  async byKey(key: string) {
    await this.expireDue();
    return this.db.user(async (tx) => {
      const found = await tx.checkout.findFirst({
        where: { merchantId: this.merchantId(), idempotencyKey: key },
        include: { payment: { select: { reference: true } } },
      });
      if (found === null) throw problems.notFound();
      await this.usableRegister(tx, found.registerId);
      return checkoutView(found);
    });
  }

  /** Current request of a till (latest), for the opening of the SSE stream. */
  async latest(registerId: string) {
    return this.db.user(async (tx) => {
      await this.usableRegister(tx, registerId);
      const row = await tx.checkout.findFirst({
        where: { registerId },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        include: { payment: { select: { reference: true } } },
      });
      return row === null ? null : checkoutView(row);
    });
  }

  /** Checks access to the stream of a till and returns the RLS scope to read its events with. */
  async streamScope(registerId: string) {
    await this.db.user((tx) => this.usableRegister(tx, registerId));
    return scopeOf(principal());
  }

  async viewInScope(scope: ReturnType<typeof scopeOf>, checkoutId: string) {
    return this.db.run(scope, async (tx) => {
      const row = await tx.checkout.findUnique({
        where: { id: checkoutId },
        include: { payment: { select: { reference: true } } },
      });
      return row === null ? null : checkoutView(row);
    });
  }

  // ---------------------------------------------------------------- customer

  private customerView(
    row: Checkout & { merchant: { name: string; city: string }; register: { name: string } },
  ) {
    return {
      id: row.id,
      merchantName: row.merchant.name,
      registerName: row.register.name,
      city: row.merchant.city,
      amountMillimes: toMillimes(row.amountMillimes),
      creditType: row.creditType,
      expiresAt: row.expiresAt.toISOString(),
    };
  }

  /**
   * The customer read the sticker (NFC, QR or link): the signature is checked against the till
   * AND its shop, then the open request of that till is shown (audited server step).
   */
  async bySticker(publicId: string, signature: string) {
    return this.db.system(async (tx) => {
      const register = await tx.register.findUnique({
        where: { publicId },
        include: { merchant: { select: { status: true } } },
      });
      if (
        register === null ||
        !safeEqual(signature, this.signature(register.publicId, register.merchantId))
      ) {
        throw refused('STICKER_INVALID');
      }
      if (register.status !== 'ACTIVE') throw refused('STICKER_INVALID');
      if (register.merchant.status !== 'APPROVED') throw refused('MERCHANT_NOT_ACTIVE');
      const row = await tx.checkout.findFirst({
        where: { registerId: register.id },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        include: {
          merchant: { select: { name: true, city: true } },
          register: { select: { name: true } },
        },
      });
      if (row === null) throw refused('NO_PENDING_CHECKOUT');
      const now = Date.now();
      if (row.status === 'PENDING' && row.expiresAt.getTime() > now) return this.customerView(row);
      // A request closed a moment ago explains the refusal; an older one means « nothing to pay ».
      const closedAt = (row.closedAt ?? row.expiresAt).getTime();
      if (now - closedAt > CHECKOUT_SECONDS * 1000) throw refused('NO_PENDING_CHECKOUT');
      if (row.status === 'PAID') throw refused('ALREADY_PAID');
      throw refused(row.status === 'CANCELLED' ? 'NO_PENDING_CHECKOUT' : 'CHECKOUT_EXPIRED');
    });
  }

  /** The customer typed the short code shown at the till. */
  async byCode(shortCode: string) {
    return this.db.system(async (tx) => {
      const row = await tx.checkout.findFirst({
        where: { shortCode, status: 'PENDING', expiresAt: { gt: new Date() } },
        include: {
          merchant: { select: { name: true, city: true, status: true } },
          register: { select: { name: true } },
        },
      });
      if (row === null) throw refused('NO_PENDING_CHECKOUT');
      if (row.merchant.status !== 'APPROVED') throw refused('MERCHANT_NOT_ACTIVE');
      return this.customerView(row);
    });
  }

  /**
   * A confirmation was refused (rolled back, nothing debited): the open request keeps the code and
   * the first name of the customer, and the till is told in real time (audited server step).
   */
  async recordRefusal(checkoutId: string, problem: ApiProblem): Promise<void> {
    if (!TILL_REFUSALS.has(problem.code)) return;
    // « Already paid » or « expired » concern a closed request: nothing to tell the till.
    const reason = problem.details?.reason;
    if (reason === 'ALREADY_PAID' || reason === 'CHECKOUT_EXPIRED') return;
    const employeeId = principal().employeeId;
    if (employeeId === null) return;
    await this.db.system(async (tx) => {
      const employee = await tx.employee.findUnique({
        where: { id: employeeId },
        select: { firstName: true },
      });
      const updated = await tx.checkout.updateMany({
        where: { id: checkoutId, status: 'PENDING' },
        data: {
          lastRefusalCode: problem.code,
          lastRefusalReason: typeof reason === 'string' ? reason : null,
          lastRefusalFirstName: employee?.firstName ?? null,
          lastRefusalAt: new Date(),
        },
      });
      if (updated.count !== 1) return;
      const row = await tx.checkout.findUniqueOrThrow({ where: { id: checkoutId } });
      await this.events.notify(tx, row.registerId, checkoutId);
    });
  }

  /**
   * Confirmation with the PIN (checked before), in ONE SQL transaction: lock of the request (still
   * open?), then of the wallets (debit: balance, daily cap, family cap and end date, FEFO lots, two
   * ledger entries), payment created, request PAID and bound to the customer, outbox event. Any
   * failed check rolls everything back. A second customer gets « already paid ».
   */
  async confirm(tx: Tx, checkoutId: string, key: string) {
    const employeeId = principal().employeeId;
    if (employeeId === null) throw problems.forbidden();
    const locked = await asService(tx, async () => {
      const rows = await tx.$queryRaw<{ id: string }[]>`
        SELECT id FROM checkouts WHERE id = ${checkoutId}::uuid FOR UPDATE`;
      if (rows.length === 0) return null;
      return tx.checkout.findUniqueOrThrow({
        where: { id: checkoutId },
        include: {
          merchant: { select: { status: true, acceptedCreditTypes: true, name: true } },
          register: { select: { status: true } },
        },
      });
    });
    if (locked === null) throw problems.notFound();
    if (locked.status === 'PAID') throw refused('ALREADY_PAID');
    if (locked.status !== 'PENDING' || locked.expiresAt.getTime() <= Date.now()) {
      throw refused('CHECKOUT_EXPIRED');
    }
    if (locked.register.status !== 'ACTIVE') throw refused('CHECKOUT_EXPIRED');
    if (locked.merchant.status !== 'APPROVED') throw refused('MERCHANT_NOT_ACTIVE');
    if (!locked.merchant.acceptedCreditTypes.includes(locked.creditType)) {
      throw refused('CREDIT_TYPE_NOT_ACCEPTED');
    }
    const { employee, ...snapshot } = await this.payments.customerSnapshot(tx, employeeId);
    if (!canSpend(employee, new Date())) throw new ApiProblem(422, 'PAYMENT_DECLINED');
    const reference = await this.payments.nextReference(tx);
    const { transactionId, rateBps } = await this.payments.debit(
      tx,
      {
        employeeId,
        merchantId: locked.merchantId,
        creditType: locked.creditType,
        amount: locked.amountMillimes,
        reference,
      },
      key,
    );
    const now = new Date();
    const paymentId = uuidv7();
    await tx.payment.create({
      data: {
        id: paymentId,
        reference,
        merchantId: locked.merchantId,
        employeeId,
        companyId: employee.companyId,
        creditType: locked.creditType,
        amountMillimes: locked.amountMillimes,
        status: 'CONFIRMED',
        channel: 'REGISTER_CHECKOUT',
        confirmedAt: now,
        commissionRateBps: rateBps,
        settlementDate: await this.settings.settlementDate(tx, now),
        transactionId,
        ...snapshot,
        events: {
          create: [
            { id: uuidv7(), status: 'INITIATED', occurredAt: locked.createdAt },
            { id: uuidv7(), status: 'CONFIRMED', occurredAt: now },
          ],
        },
      },
    });
    await asService(tx, async () => {
      const moved = await tx.checkout.updateMany({
        where: { id: checkoutId, status: 'PENDING' },
        data: {
          status: 'PAID',
          closedAt: now,
          employeeId,
          paymentId,
          customerFirstName: snapshot.customerFirstName,
        },
      });
      if (moved.count !== 1) throw refused('ALREADY_PAID');
      await tx.outboxEvent.create({
        data: {
          id: uuidv7(),
          topic: 'checkout.paid',
          aggregateId: checkoutId,
          payload: { paymentId, reference, registerId: locked.registerId },
        },
      });
    });
    await this.events.notify(tx, locked.registerId, checkoutId);
    return this.payments.operationDetail(tx, `PAYMENT:${paymentId}`);
  }
}
