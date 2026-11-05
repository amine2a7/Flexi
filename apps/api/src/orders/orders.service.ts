import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { FourEyesService } from '../common/four-eyes.service.js';
import { randomDigits, uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { FILE_STORAGE, type FileStorage } from '../common/storage.js';
import { feesOf, toMillimes } from '../common/money.js';
import type { Page, PageRequest } from '../common/pagination.js';
import { Paginator } from '../common/pagination.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { businessDay, dateOnly, dayOf } from '../common/tunis.js';
import type {
  CreditOrder,
  CreditOrderEvent,
  CreditOrderLine,
  CreditType,
  OrderEventAction,
  OrderStatus,
  Prisma,
} from '../generated/prisma/client.js';
import { LedgerService, accounts } from '../ledger/ledger.service.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';

type OrderRow = CreditOrder & {
  lines: CreditOrderLine[];
  events: CreditOrderEvent[];
  company: { name: string };
};

const INCLUDE = {
  lines: true,
  events: { orderBy: { occurredAt: 'asc' } },
  company: { select: { name: true } },
} as const satisfies Prisma.CreditOrderInclude;

/** Statuses waiting for an administrator (listed first in the admin space). */
const NEEDS_ADMIN: readonly OrderStatus[] = ['AWAITING_CONFIRMATION', 'AWAITING_VALIDATION'];
/** Orders still in progress (company dashboard). */
export const OPEN_ORDER_STATUSES: readonly OrderStatus[] = [...NEEDS_ADMIN, 'AWAITING_PAYMENT'];
const MAX_PROOF_BYTES = 5 * 1024 * 1024;
/** Smallest order (all types together): 100 TND. */
const MIN_ORDER_MILLIMES = 100_000n;

export interface OrderLineInput {
  creditType: CreditType;
  amountMillimes: number;
}

function sortedLines(lines: readonly CreditOrderLine[]) {
  return CREDIT_TYPES.flatMap((type) => lines.filter((line) => line.creditType === type)).map(
    (line) => ({
      creditType: line.creditType,
      amountMillimes: toMillimes(line.amountMillimes),
    }),
  );
}

/**
 * The quote of an order ends after the validity of the settings (frozen at creation), as long as
 * no transfer was declared: past it, neither the confirmation nor a declaration is accepted.
 */
export function quoteExpired(order: CreditOrder, now = new Date()): boolean {
  return (
    (order.status === 'AWAITING_CONFIRMATION' || order.status === 'AWAITING_PAYMENT') &&
    order.declaredAt === null &&
    order.quoteExpiresAt.getTime() <= now.getTime()
  );
}

export function orderSummary(order: OrderRow) {
  return {
    id: order.id,
    reference: order.reference,
    status: order.status,
    lines: sortedLines(order.lines),
    companyId: order.companyId,
    companyName: order.company.name,
    amountMillimes: toMillimes(order.amountMillimes),
    feeRateBps: order.feeRateBps,
    feesMillimes: toMillimes(order.feesMillimes),
    vatRateBps: order.vatRateBps,
    vatMillimes: toMillimes(order.vatMillimes),
    stampDutyMillimes: toMillimes(order.stampDutyMillimes),
    totalMillimes: toMillimes(order.totalMillimes),
    createdAt: order.createdAt.toISOString(),
    quoteExpiresAt: order.quoteExpiresAt.toISOString(),
    quoteExpired: quoteExpired(order),
    paymentReference: order.paymentReference,
    ...(order.declaredAmountMillimes === null
      ? {}
      : { declaredAmountMillimes: toMillimes(order.declaredAmountMillimes) }),
  };
}

/** File type from its first bytes (never from the name or the declared type): JPG, PNG or PDF. */
export function sniffProof(
  data: Buffer,
): 'image/jpeg' | 'image/png' | 'application/pdf' | undefined {
  if (data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff) return 'image/jpeg';
  if (data[0] === 0x89 && data[1] === 0x50 && data[2] === 0x4e && data[3] === 0x47)
    return 'image/png';
  if (data[0] === 0x25 && data[1] === 0x50 && data[2] === 0x44 && data[3] === 0x46)
    return 'application/pdf';
  return undefined;
}

@Injectable()
export class OrdersService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(FourEyesService) private readonly fourEyes: FourEyesService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(FILE_STORAGE) private readonly storage: FileStorage,
  ) {}

  detail(order: OrderRow) {
    const who = principal();
    return {
      ...orderSummary(order),
      ...(order.transferReference === null ||
      order.transferDate === null ||
      order.declaredAt === null
        ? {}
        : {
            declaration: {
              transferReference: order.transferReference,
              transferDate: dayOf(order.transferDate),
              amountMillimes: toMillimes(order.declaredAmountMillimes ?? 0n),
              proof: {
                fileName: order.proofFileName ?? 'preuve',
                contentType: order.proofContentType ?? 'application/pdf',
                sizeBytes: order.proofSizeBytes ?? 1,
              },
              declaredAt: order.declaredAt.toISOString(),
            },
          }),
      ...(order.refusalReason === null ? {} : { refusalReason: order.refusalReason }),
      ...(order.proofRejectionReason === null
        ? {}
        : { proofRejectionReason: order.proofRejectionReason }),
      requiresSecondValidation: order.secondValidationRequired,
      ...(order.firstValidatedAt === null || order.status !== 'AWAITING_VALIDATION'
        ? {}
        : {
            firstValidation: {
              actorName: order.firstValidatorName ?? '',
              occurredAt: order.firstValidatedAt.toISOString(),
              byMe: order.firstValidatorId === who.userId,
            },
          }),
      history: order.events.map((event) => ({
        action: event.action,
        occurredAt: event.occurredAt.toISOString(),
        actorName: event.actorName,
        actorRole: event.actorRole,
        ...(event.reason === null ? {} : { reason: event.reason }),
      })),
    };
  }

  private async event(
    tx: Tx,
    orderId: string,
    action: OrderEventAction,
    reason?: string,
  ): Promise<void> {
    const who = principal();
    await tx.creditOrderEvent.create({
      data: {
        id: uuidv7(),
        orderId,
        action,
        actorId: who.userId,
        actorName: who.displayName,
        actorRole: who.role,
        reason: reason ?? null,
      },
    });
  }

  /**
   * Locks the order for the rest of the SQL transaction (ledger-auditor C1): two decisions on the
   * same order are served one after the other, the second one sees the new status (409).
   */
  private async lock(tx: Tx, id: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM credit_orders WHERE id = ${id}::uuid FOR UPDATE`;
  }

  private async load(tx: Tx, id: string): Promise<OrderRow> {
    const order = await tx.creditOrder.findUnique({ where: { id }, include: INCLUDE });
    if (order === null) throw problems.notFound();
    return order;
  }

  /** Order lines: distinct enabled types, positive amounts, at least 100 TND in all. */
  async checkLines(tx: Tx, lines: readonly OrderLineInput[]): Promise<bigint> {
    const invalid = (code: 'REQUIRED' | 'INVALID_FORMAT' | 'INVALID_ENUM' | 'TOO_SMALL') =>
      validationFailed([{ in: 'body', pointer: '/lines', code }]);
    if (lines.length === 0) throw invalid('REQUIRED');
    if (new Set(lines.map((line) => line.creditType)).size !== lines.length)
      throw invalid('INVALID_FORMAT');
    const enabled = await this.settings.enabledTypes(tx);
    if (lines.some((line) => !enabled.has(line.creditType))) throw invalid('INVALID_ENUM');
    const amount = lines.reduce((sum, line) => sum + BigInt(line.amountMillimes), 0n);
    if (amount < MIN_ORDER_MILLIMES) throw invalid('TOO_SMALL');
    return amount;
  }

  /**
   * Fees of an order amount (decisions of 2026-11-03): the rate of the tranche of the company grid,
   * VAT on the rounded commission and stamp duty of the settings. No grid: refused (2026-11-04).
   */
  private async fees(tx: Tx, amount: bigint) {
    const companyId = principal().companyId;
    if (companyId === null) throw problems.forbidden();
    const rate = await this.settings.commissionRate(tx, { companyId }, amount);
    const taxes = await this.settings.taxes(tx);
    return { rate, taxes, fees: feesOf(amount, rate, taxes) };
  }

  async quote(lines: OrderLineInput[]) {
    return this.db.user(async (tx) => {
      const amount = await this.checkLines(tx, lines);
      const { rate, taxes, fees } = await this.fees(tx, amount);
      return {
        lines: sortedLines(
          lines.map((line) => ({
            ...line,
            orderId: '',
            amountMillimes: BigInt(line.amountMillimes),
          })),
        ),
        amountMillimes: toMillimes(amount),
        feeRateBps: rate,
        feesMillimes: toMillimes(fees.commission),
        vatRateBps: taxes.vatRateBps,
        vatMillimes: toMillimes(fees.vat),
        stampDutyMillimes: toMillimes(fees.stamp),
        totalMillimes: toMillimes(amount + fees.commission + fees.vat + fees.stamp),
      };
    });
  }

  // ---------------------------------------------------------------- company

  async create(tx: Tx, lines: OrderLineInput[]) {
    const who = principal();
    if (who.companyId === null) throw problems.forbidden();
    const amount = await this.checkLines(tx, lines);
    const { rate, taxes, fees } = await this.fees(tx, amount);
    const platform = await this.settings.platform(tx);
    const [sequence] = await tx.$queryRaw<
      { value: bigint }[]
    >`SELECT nextval('order_reference_seq') AS value`;
    const id = uuidv7();
    const now = new Date();
    await tx.creditOrder.create({
      data: {
        id,
        reference: `CMD-${businessDay().slice(0, 4)}-${String(sequence?.value ?? 0n)}`,
        companyId: who.companyId,
        status: 'AWAITING_CONFIRMATION',
        amountMillimes: amount,
        feeRateBps: rate,
        feesMillimes: fees.commission,
        vatRateBps: taxes.vatRateBps,
        vatMillimes: fees.vat,
        stampDutyMillimes: fees.stamp,
        totalMillimes: amount + fees.commission + fees.vat + fees.stamp,
        paymentReference: `FXP-${randomDigits(8)}`,
        quoteExpiresAt: new Date(now.getTime() + platform.quoteValidityDays * 86_400_000),
        secondValidationRequired: amount > platform.secondValidationThresholdMillimes,
        lines: {
          create: lines.map((line) => ({
            creditType: line.creditType,
            amountMillimes: BigInt(line.amountMillimes),
          })),
        },
      },
    });
    await this.event(tx, id, 'CREATED');
    const order = await this.load(tx, id);
    await this.audit.record(tx, 'orders.create', order.reference);
    return orderSummary(order);
  }

  private orderWhere(
    filters: { status?: OrderStatus; creditType?: CreditType; companyId?: string },
    request: PageRequest,
  ): Prisma.CreditOrderWhereInput {
    return {
      ...(filters.status === undefined ? {} : { status: filters.status }),
      ...(filters.creditType === undefined
        ? {}
        : { lines: { some: { creditType: filters.creditType } } }),
      ...(filters.companyId === undefined ? {} : { companyId: filters.companyId }),
      ...(request.createdFrom === undefined && request.createdTo === undefined
        ? {}
        : {
            createdAt: {
              ...(request.createdFrom === undefined ? {} : { gte: request.createdFrom }),
              ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
            },
          }),
    };
  }

  /** Company list (RLS keeps it to the company of the session), newest first. */
  async list(
    query: Record<string, unknown>,
    filters: { status?: OrderStatus; creditType?: CreditType },
  ): Promise<Page<ReturnType<typeof orderSummary>>> {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where = this.orderWhere(filters, request);
      const rows = await tx.creditOrder.findMany({
        where,
        include: INCLUDE,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.creditOrder.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(request, rows.map(orderSummary), filters, count);
    });
  }

  /** Admin list: orders waiting for an administrator first, then newest first. */
  async adminList(
    query: Record<string, unknown>,
    filters: { status?: OrderStatus; creditType?: CreditType; companyId?: string },
  ): Promise<Page<ReturnType<typeof orderSummary>>> {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where = this.orderWhere(filters, request);
      const ids = await tx.creditOrder.findMany({
        where,
        select: { id: true, status: true, createdAt: true },
      });
      const ranked = ids
        .sort(
          (a, b) =>
            Number(!NEEDS_ADMIN.includes(a.status)) - Number(!NEEDS_ADMIN.includes(b.status)) ||
            b.createdAt.getTime() - a.createdAt.getTime() ||
            (a.id < b.id ? 1 : -1),
        )
        .slice(request.offset, request.offset + request.limit + 1)
        .map((row) => row.id);
      const rows = await tx.creditOrder.findMany({
        where: { id: { in: ranked } },
        include: INCLUDE,
      });
      const byId = new Map(rows.map((row) => [row.id, row]));
      const ordered = ranked.flatMap((id) => {
        const row = byId.get(id);
        return row === undefined ? [] : [orderSummary(row)];
      });
      return this.paginator.page(
        request,
        ordered,
        filters,
        request.withCount ? ids.length : undefined,
      );
    });
  }

  async get(id: string) {
    return this.db.user(async (tx) => this.detail(await this.load(tx, id)));
  }

  async cancel(id: string) {
    return this.db.user(async (tx) => {
      await this.lock(tx, id);
      const order = await this.load(tx, id);
      if (order.status !== 'AWAITING_CONFIRMATION' && order.status !== 'AWAITING_PAYMENT')
        throw problems.conflict();
      await tx.creditOrder.update({ where: { id }, data: { status: 'CANCELLED' } });
      await this.event(tx, id, 'CANCELLED');
      await this.audit.record(tx, 'orders.cancel', order.reference);
      return this.detail(await this.load(tx, id));
    });
  }

  /** Validates the multipart fields of a transfer declaration (same codes as a JSON body). */
  checkDeclaration(
    fields: Record<string, unknown>,
    file: { size: number; buffer: Buffer; originalname: string } | undefined,
  ) {
    const text = (name: string) => (typeof fields[name] === 'string' ? fields[name].trim() : '');
    const reference = text('transferReference');
    const date = text('transferDate');
    const amount = text('amountMillimes');
    const errors: {
      in: 'body';
      pointer: string;
      code: 'REQUIRED' | 'TOO_LONG' | 'INVALID_FORMAT' | 'IN_FUTURE' | 'UNKNOWN_FIELD';
    }[] = [];
    for (const name of Object.keys(fields)) {
      if (!['transferReference', 'transferDate', 'amountMillimes'].includes(name)) {
        errors.push({ in: 'body', pointer: `/${name}`, code: 'UNKNOWN_FIELD' });
      }
    }
    if (reference === '')
      errors.push({ in: 'body', pointer: '/transferReference', code: 'REQUIRED' });
    else if (reference.length > 64)
      errors.push({ in: 'body', pointer: '/transferReference', code: 'TOO_LONG' });
    if (date === '') errors.push({ in: 'body', pointer: '/transferDate', code: 'REQUIRED' });
    else if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || Number.isNaN(Date.parse(date))) {
      errors.push({ in: 'body', pointer: '/transferDate', code: 'INVALID_FORMAT' });
    } else if (date > businessDay())
      errors.push({ in: 'body', pointer: '/transferDate', code: 'IN_FUTURE' });
    if (amount === '') errors.push({ in: 'body', pointer: '/amountMillimes', code: 'REQUIRED' });
    else if (!/^[1-9][0-9]{0,14}$/.test(amount))
      errors.push({ in: 'body', pointer: '/amountMillimes', code: 'INVALID_FORMAT' });
    if (file === undefined || file.size === 0)
      errors.push({ in: 'body', pointer: '/proof', code: 'REQUIRED' });
    if (errors.length > 0) throw validationFailed(errors);
    if (file === undefined)
      throw validationFailed([{ in: 'body', pointer: '/proof', code: 'REQUIRED' }]);
    if (file.size > MAX_PROOF_BYTES) throw new ApiProblem(413, 'PAYLOAD_TOO_LARGE');
    const contentType = sniffProof(file.buffer);
    if (contentType === undefined) throw new ApiProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
    return { reference, date, amount: BigInt(amount), contentType, file };
  }

  async declareTransfer(tx: Tx, id: string, input: ReturnType<OrdersService['checkDeclaration']>) {
    await this.lock(tx, id);
    const order = await this.load(tx, id);
    if (order.status !== 'AWAITING_PAYMENT') throw problems.conflict();
    if (quoteExpired(order)) throw new ApiProblem(409, 'QUOTE_EXPIRED');
    const key = await this.storage.put(input.file.buffer);
    await tx.creditOrder.update({
      where: { id },
      data: {
        status: 'AWAITING_VALIDATION',
        transferReference: input.reference,
        transferDate: dateOnly(input.date),
        declaredAmountMillimes: input.amount,
        declaredAt: new Date(),
        proofStorageKey: key,
        proofFileName: input.file.originalname.slice(0, 255) || 'capture',
        proofContentType: input.contentType,
        proofSizeBytes: input.file.size,
        proofRejectionReason: null,
      },
    });
    await this.event(tx, id, 'TRANSFER_DECLARED');
    await this.audit.record(tx, 'orders.declareTransfer', order.reference);
    return this.detail(await this.load(tx, id));
  }

  async proof(id: string): Promise<{ data: Buffer; contentType: string; fileName: string }> {
    const order = await this.db.user((tx) => this.load(tx, id));
    if (order.proofStorageKey === null || order.proofContentType === null)
      throw problems.notFound();
    return {
      data: await this.storage.get(order.proofStorageKey),
      contentType: order.proofContentType,
      fileName: order.proofFileName ?? 'preuve',
    };
  }

  // ---------------------------------------------------------------- admin

  async confirm(id: string) {
    return this.db.user(async (tx) => {
      await this.lock(tx, id);
      const order = await this.load(tx, id);
      if (order.status !== 'AWAITING_CONFIRMATION') throw problems.conflict();
      if (quoteExpired(order)) throw new ApiProblem(409, 'QUOTE_EXPIRED');
      await tx.creditOrder.update({ where: { id }, data: { status: 'AWAITING_PAYMENT' } });
      // The invoice is issued at confirmation (to pay), paid at validation.
      const [sequence] = await tx.$queryRaw<
        { value: bigint }[]
      >`SELECT nextval('invoice_number_seq') AS value`;
      await tx.invoice.create({
        data: {
          id: uuidv7(),
          number: `FAC-${businessDay().slice(0, 4)}-${String(sequence?.value ?? 0n)}`,
          companyId: order.companyId,
          orderId: id,
          totalMillimes: order.totalMillimes,
          status: 'UNPAID',
        },
      });
      await this.event(tx, id, 'CONFIRMED');
      await this.audit.record(tx, 'orders.confirm', order.reference);
      return this.detail(await this.load(tx, id));
    });
  }

  async refuse(id: string, reason: string) {
    return this.db.user(async (tx) => {
      await this.lock(tx, id);
      const order = await this.load(tx, id);
      if (order.status !== 'AWAITING_CONFIRMATION') throw problems.conflict();
      await tx.creditOrder.update({
        where: { id },
        data: { status: 'REFUSED', refusalReason: reason },
      });
      await this.event(tx, id, 'REFUSED', reason);
      await this.audit.record(tx, 'orders.refuse', order.reference);
      return this.detail(await this.load(tx, id));
    });
  }

  async rejectProof(id: string, reason: string) {
    return this.db.user(async (tx) => {
      await this.lock(tx, id);
      const order = await this.load(tx, id);
      if (order.status !== 'AWAITING_VALIDATION') throw problems.conflict();
      await tx.creditOrder.update({
        where: { id },
        data: {
          status: 'AWAITING_PAYMENT',
          proofRejectionReason: reason,
          firstValidatorId: null,
          firstValidatorName: null,
          firstValidatedAt: null,
          transferReference: null,
          transferDate: null,
          declaredAmountMillimes: null,
          declaredAt: null,
          proofStorageKey: null,
          proofFileName: null,
          proofContentType: null,
          proofSizeBytes: null,
        },
      });
      await this.event(tx, id, 'PROOF_REJECTED', reason);
      await this.audit.record(tx, 'orders.rejectProof', order.reference);
      return this.detail(await this.load(tx, id));
    });
  }

  /**
   * Validation (financial, idempotent). Above the threshold, two different administrators
   * (rule 12): the first one is recorded, the second one validates. Validation credits each
   * line to the company wallet of its type and the fees to the revenue, in one ledger transaction.
   */
  async validate(tx: Tx, id: string, key: string) {
    const who = principal();
    await this.lock(tx, id);
    const order = await this.load(tx, id);
    if (order.status !== 'AWAITING_VALIDATION') throw problems.conflict();
    if (order.secondValidationRequired) {
      if (order.firstValidatorId === null) {
        await tx.creditOrder.update({
          where: { id },
          data: {
            firstValidatorId: who.userId,
            firstValidatorName: who.displayName,
            firstValidatedAt: new Date(),
          },
        });
        await this.event(tx, id, 'FIRST_VALIDATION');
        await this.audit.record(tx, 'orders.firstValidation', order.reference);
        return this.detail(await this.load(tx, id));
      }
      await this.fourEyes.ensureNotAuthor(order.firstValidatorId, `commande ${order.reference}`);
    }
    await this.ledger.post(tx, {
      type: 'ORDER_VALIDATED',
      reference: order.reference,
      tenantId: order.companyId,
      userId: who.userId,
      idempotencyKey: key,
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount: order.totalMillimes },
        ...order.lines.map((line) => ({
          account: accounts.companyWallet(order.companyId, line.creditType),
          direction: 'C' as const,
          amount: line.amountMillimes,
        })),
        // Commission, VAT and stamp duty each on its own account (decision of 2026-11-03).
        ...[
          { account: accounts.companyFees(), amount: order.feesMillimes },
          { account: accounts.vatCollected(), amount: order.vatMillimes },
          { account: accounts.stampDuty(), amount: order.stampDutyMillimes },
        ]
          .filter((line) => line.amount > 0n)
          .map((line) => ({ ...line, direction: 'C' as const })),
      ],
    });
    await tx.creditOrder.update({ where: { id }, data: { status: 'VALIDATED' } });
    await tx.invoice.updateMany({ where: { orderId: id }, data: { status: 'PAID' } });
    await this.event(tx, id, 'VALIDATED');
    await this.audit.record(tx, 'orders.validate', order.reference);
    return this.detail(await this.load(tx, id));
  }
}
