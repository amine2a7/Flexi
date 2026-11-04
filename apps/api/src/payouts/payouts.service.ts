import { PiiService } from '../common/pii.js';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { FourEyesService } from '../common/four-eyes.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { feesOf, fromMillimes, toMillimes } from '../common/money.js';
import { currentGridInclude, defaultRate, gridBody } from '../platform/commission-grids.js';
import { Paginator, type Page } from '../common/pagination.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import {
  businessDay,
  dateOnly,
  dayOf,
  lastMonths,
  startOfBusinessDay,
  startOfBusinessMonth,
} from '../common/tunis.js';
import type {
  CreditType,
  PayoutEvent,
  PayoutRequest,
  PayoutStatus,
  Prisma,
} from '../generated/prisma/client.js';
import { InsufficientFundsError, LedgerService, accounts } from '../ledger/ledger.service.js';
import { merchantPayment } from '../payments/payments.service.js';
import { nextBatch } from './settlement-batch.js';
import { OutboxService } from '../common/outbox.service.js';
import {
  BANK_ADAPTER,
  type BankAdapter,
  type BankOrderLine,
  type BankReturnLine,
} from './bank.adapter.js';
import { CREDIT_TYPES, SettingsService } from '../platform/settings.service.js';

const QUOTE_TTL_MS = 10 * 60_000;
type PayoutRow = PayoutRequest & {
  events: PayoutEvent[];
  merchant: { name: string };
  batch: { id: string; reference: string } | null;
};

function payoutBody(payout: PayoutRequest) {
  return {
    id: payout.id,
    reference: payout.reference,
    status: payout.status,
    creditType: payout.creditType,
    grossMillimes: toMillimes(payout.grossMillimes),
    commissionRateBps: payout.commissionRateBps,
    commissionMillimes: toMillimes(payout.commissionMillimes),
    vatRateBps: payout.vatRateBps,
    vatMillimes: toMillimes(payout.vatMillimes),
    stampDutyMillimes: toMillimes(payout.stampDutyMillimes),
    netMillimes: toMillimes(payout.netMillimes),
    deductedMillimes: toMillimes(payout.deductedMillimes),
    requestedAt: payout.requestedAt.toISOString(),
  };
}

function history(events: readonly PayoutEvent[]) {
  return events.map((event) => ({
    status: event.status,
    occurredAt: event.occurredAt.toISOString(),
    ...(event.reason === null ? {} : { reason: event.reason }),
  }));
}

function adminPayout(payout: PayoutRow, pii: PiiService) {
  return {
    ...payoutBody(payout),
    merchantId: payout.merchantId,
    merchantName: payout.merchant.name,
    iban: pii.open(payout.iban),
    ...(payout.batch === null
      ? {}
      : { batchId: payout.batch.id, batchReference: payout.batch.reference }),
  };
}

const ADMIN_INCLUDE = {
  events: { orderBy: { occurredAt: 'asc' } },
  merchant: { select: { name: true } },
  batch: { select: { id: true, reference: true } },
} as const satisfies Prisma.PayoutRequestInclude;

@Injectable()
export class PayoutsService {
  private readonly logger = new Logger('Settlements');

  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(FourEyesService) private readonly fourEyes: FourEyesService,
    @Inject(PiiService) private readonly pii: PiiService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(BANK_ADAPTER) private readonly bank: BankAdapter,
    @Inject(OutboxService) private readonly outbox: OutboxService,
  ) {}

  private merchantId(): string {
    const id = principal().merchantId;
    if (id === null) throw problems.forbidden();
    return id;
  }

  // ---------------------------------------------------------------- merchant space

  /** Confirmed payments not yet in a payout request: what the merchant is owed (D+2). */
  private receivablesWhere(merchantId: string, creditType?: CreditType): Prisma.PaymentWhereInput {
    return {
      merchantId,
      status: 'CONFIRMED',
      payoutId: null,
      ...(creditType === undefined ? {} : { creditType }),
    };
  }

  async dashboard() {
    const merchantId = this.merchantId();
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUniqueOrThrow({
        where: { id: merchantId },
        include: { commissionGrids: currentGridInclude },
      });
      const today = startOfBusinessDay(businessDay());
      const collected = { status: { in: ['CONFIRMED' as const, 'SETTLED' as const] } };
      const todays = await tx.payment.aggregate({
        where: { ...collected, confirmedAt: { gte: today } },
        _sum: { amountMillimes: true },
        _count: true,
      });
      const receivables = await tx.payment.aggregate({
        where: this.receivablesWhere(merchantId),
        _sum: { amountMillimes: true },
        _min: { settlementDate: true },
      });
      const recent = await tx.payment.findMany({
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        take: 5,
      });
      const months = lastMonths(6);
      const since = startOfBusinessMonth(months[0]);
      const payments = await tx.payment.findMany({
        where: { ...collected, confirmedAt: { gte: since } },
        select: { amountMillimes: true, confirmedAt: true, creditType: true },
      });
      const executed = await tx.payoutEvent.findMany({
        where: { status: 'EXECUTED', occurredAt: { gte: since } },
        include: { payout: { select: { netMillimes: true } } },
      });
      const monthIndex = (date: Date) => months.indexOf(businessDay(date).slice(0, 7));
      const flows = months.map((month) => ({ month, collected: 0n, settled: 0n }));
      const byType = new Map<CreditType, bigint>();
      for (const payment of payments) {
        if (payment.confirmedAt === null) continue;
        const flow = flows[monthIndex(payment.confirmedAt)];
        if (flow !== undefined) flow.collected += payment.amountMillimes;
        if (monthIndex(payment.confirmedAt) === months.length - 1) {
          byType.set(
            payment.creditType,
            (byType.get(payment.creditType) ?? 0n) + payment.amountMillimes,
          );
        }
      }
      for (const event of executed) {
        const flow = flows[monthIndex(event.occurredAt)];
        if (flow !== undefined) flow.settled += event.payout.netMillimes;
      }
      return {
        todayCollectedMillimes: toMillimes(todays._sum.amountMillimes ?? 0n),
        todayPaymentsCount: todays._count,
        receivablesMillimes: toMillimes(receivables._sum.amountMillimes ?? 0n),
        nextSettlementDate:
          receivables._min.settlementDate === null ? null : dayOf(receivables._min.settlementDate),
        commissionRateBps: defaultRate(gridBody(merchant.commissionGrids)),
        recentPayments: recent.map(merchantPayment),
        monthlyFlows: flows.map((flow) => ({
          month: flow.month,
          collectedMillimes: toMillimes(flow.collected),
          settledMillimes: toMillimes(flow.settled),
        })),
        monthByCreditType: CREDIT_TYPES.map((creditType) => ({
          creditType,
          amountMillimes: toMillimes(byType.get(creditType) ?? 0n),
        })),
      };
    });
  }

  async receivables(query: Record<string, unknown>, filters: { creditType?: CreditType }) {
    const merchantId = this.merchantId();
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.PaymentWhereInput = {
        ...this.receivablesWhere(merchantId, filters.creditType),
        ...(request.createdFrom === undefined && request.createdTo === undefined
          ? {}
          : {
              confirmedAt: {
                ...(request.createdFrom === undefined ? {} : { gte: request.createdFrom }),
                ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
              },
            }),
      };
      const rows = await tx.payment.findMany({
        where,
        orderBy: [{ confirmedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const total = await tx.payment.aggregate({ where, _sum: { amountMillimes: true } });
      const count = request.withCount ? await tx.payment.count({ where, take: 10_001 }) : undefined;
      return {
        ...this.paginator.page(
          request,
          rows.map((row) => ({
            paymentId: row.id,
            reference: row.reference,
            creditType: row.creditType,
            amountMillimes: toMillimes(row.amountMillimes),
            confirmedAt: (row.confirmedAt ?? row.createdAt).toISOString(),
            settlementDate: row.settlementDate === null ? businessDay() : dayOf(row.settlementDate),
          })),
          filters,
          count,
        ),
        totalMillimes: toMillimes(total._sum.amountMillimes ?? 0n),
      };
    });
  }

  /** Simulation (rate of the type now): gross, rate, commission, net, available of the type. */
  async quote(input: { creditType: CreditType; grossMillimes: number }) {
    const merchantId = this.merchantId();
    return this.db.user(async (tx) => {
      const minimum = (await this.settings.platform(tx)).payoutMinimumMillimes;
      const gross = fromMillimes(input.grossMillimes);
      if (gross < minimum)
        throw validationFailed([
          {
            in: 'body',
            pointer: '/grossMillimes',
            code: 'TOO_SMALL',
            params: { min: toMillimes(minimum) },
          },
        ]);
      const available = await this.ledger.balance(
        tx,
        accounts.merchantWallet(merchantId, input.creditType),
      );
      if (gross > available)
        throw new ApiProblem(422, 'INSUFFICIENT_FUNDS', {
          missingMillimes: toMillimes(gross - available),
        });
      const rate = await this.settings.commissionRate(tx, { merchantId }, gross);
      const taxes = await this.settings.taxes(tx);
      const fees = feesOf(gross, rate, taxes);
      const net = gross - fees.commission - fees.vat - fees.stamp;
      // The stamp duty and the VAT must leave a positive amount to transfer.
      if (net <= 0n)
        throw validationFailed([
          {
            in: 'body',
            pointer: '/grossMillimes',
            code: 'TOO_SMALL',
            params: { min: toMillimes(minimum) },
          },
        ]);
      const quote = await tx.payoutQuote.create({
        data: {
          id: uuidv7(),
          merchantId,
          creditType: input.creditType,
          grossMillimes: gross,
          commissionRateBps: rate,
          commissionMillimes: fees.commission,
          vatRateBps: taxes.vatRateBps,
          vatMillimes: fees.vat,
          stampDutyMillimes: fees.stamp,
          netMillimes: net,
          expiresAt: new Date(Date.now() + QUOTE_TTL_MS),
        },
      });
      return {
        quoteId: quote.id,
        creditType: quote.creditType,
        grossMillimes: toMillimes(gross),
        commissionRateBps: rate,
        commissionMillimes: toMillimes(fees.commission),
        vatRateBps: taxes.vatRateBps,
        vatMillimes: toMillimes(fees.vat),
        stampDutyMillimes: toMillimes(fees.stamp),
        netMillimes: toMillimes(net),
        availableMillimes: toMillimes(available),
        expiresAt: quote.expiresAt.toISOString(),
      };
    });
  }

  /**
   * Payout request from a quote (financial, idempotent). The rate of the quote is frozen in the
   * request (rule 5); refused if the rate changed meanwhile or the quote expired. Ledger: debit of
   * the merchant wallet of the type (gross), credit of the payable (net) and of the commission.
   */
  async request(tx: Tx, quoteId: string, key: string) {
    const who = principal();
    const merchantId = this.merchantId();
    const quote = await tx.payoutQuote.findUnique({ where: { id: quoteId } });
    if (quote?.merchantId !== merchantId) throw problems.notFound();
    // A quote is used once, even by two requests at the same time (ledger-auditor C6).
    const taken = await tx.payoutQuote.updateMany({
      where: { id: quoteId, usedAt: null },
      data: { usedAt: new Date() },
    });
    if (taken.count !== 1) throw problems.conflict();
    const rate = await this.settings.commissionRate(tx, { merchantId }, quote.grossMillimes);
    // The rates of the simulation are frozen in the request; a change meanwhile refuses it.
    const taxes = await this.settings.taxes(tx);
    if (
      quote.expiresAt.getTime() < Date.now() ||
      quote.commissionRateBps !== rate ||
      quote.vatRateBps !== taxes.vatRateBps ||
      quote.stampDutyMillimes !== taxes.stampDutyMillimes
    )
      throw problems.conflict();
    const found = await tx.merchant.findUniqueOrThrow({ where: { id: merchantId } });
    // No IBAN checked yet (KYC): no payout.
    if (found.iban === null) throw problems.conflict();
    const merchant = { ...found, iban: found.iban };
    const [sequence] = await tx.$queryRaw<
      { value: bigint }[]
    >`SELECT nextval('payout_reference_seq') AS value`;
    const reference = `VIR-${businessDay().slice(0, 4)}-${String(sequence?.value ?? 0n)}`;
    let transactionId: string;
    try {
      const entries = [
        {
          account: accounts.merchantWallet(merchantId, quote.creditType),
          direction: 'D' as const,
          amount: quote.grossMillimes,
        },
        { account: accounts.payoutPayable(), direction: 'C' as const, amount: quote.netMillimes },
        // Commission, VAT and stamp duty each on its own account (decision of 2026-11-03).
        ...[
          { account: accounts.merchantCommission(), amount: quote.commissionMillimes },
          { account: accounts.vatCollected(), amount: quote.vatMillimes },
          { account: accounts.stampDuty(), amount: quote.stampDutyMillimes },
        ]
          .filter((line) => line.amount > 0n)
          .map((line) => ({ ...line, direction: 'C' as const })),
      ];
      transactionId = (
        await this.ledger.post(tx, {
          type: 'PAYOUT_REQUESTED',
          reference,
          tenantId: merchantId,
          userId: who.userId,
          idempotencyKey: key,
          entries,
        })
      ).transactionId;
    } catch (error) {
      if (error instanceof InsufficientFundsError)
        throw new ApiProblem(422, 'INSUFFICIENT_FUNDS', {
          missingMillimes: toMillimes(error.missing),
        });
      throw error;
    }
    const id = uuidv7();
    const payout = await tx.payoutRequest.create({
      data: {
        id,
        reference,
        merchantId,
        creditType: quote.creditType,
        grossMillimes: quote.grossMillimes,
        commissionRateBps: quote.commissionRateBps,
        commissionMillimes: quote.commissionMillimes,
        vatRateBps: quote.vatRateBps,
        vatMillimes: quote.vatMillimes,
        stampDutyMillimes: quote.stampDutyMillimes,
        netMillimes: quote.netMillimes,
        iban: merchant.iban,
        transactionId,
        events: { create: [{ id: uuidv7(), status: 'REQUESTED' }] },
      },
    });
    // The oldest receivables of the type that the gross covers whole leave the "to settle" list.
    const open = await tx.payment.findMany({
      where: this.receivablesWhere(merchantId, quote.creditType),
      orderBy: [{ confirmedAt: 'asc' }, { id: 'asc' }],
      select: { id: true, amountMillimes: true },
    });
    let left = quote.grossMillimes;
    const covered: string[] = [];
    for (const payment of open) {
      if (payment.amountMillimes > left) break;
      left -= payment.amountMillimes;
      covered.push(payment.id);
    }
    if (covered.length > 0)
      await tx.payment.updateMany({ where: { id: { in: covered } }, data: { payoutId: id } });
    await this.audit.record(tx, 'payouts.request', reference);
    return { ...payoutBody(payout), maskedIban: this.pii.maskedIban(merchant.iban) };
  }

  async merchantPayouts(
    query: Record<string, unknown>,
    filters: { status?: PayoutStatus; creditType?: CreditType },
  ) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const where: Prisma.PayoutRequestWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.creditType === undefined ? {} : { creditType: filters.creditType }),
        ...(request.createdFrom === undefined && request.createdTo === undefined
          ? {}
          : {
              requestedAt: {
                ...(request.createdFrom === undefined ? {} : { gte: request.createdFrom }),
                ...(request.createdTo === undefined ? {} : { lt: request.createdTo }),
              },
            }),
      };
      const rows = await tx.payoutRequest.findMany({
        where,
        orderBy: [{ requestedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.payoutRequest.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({ ...payoutBody(row), maskedIban: this.pii.maskedIban(row.iban) })),
        filters,
        count,
      );
    });
  }

  async merchantPayout(id: string) {
    return this.db.user(async (tx) => {
      const payout = await tx.payoutRequest.findUnique({
        where: { id },
        include: { events: { orderBy: { occurredAt: 'asc' } } },
      });
      if (payout === null) throw problems.notFound();
      return {
        ...payoutBody(payout),
        maskedIban: this.pii.maskedIban(payout.iban),
        history: history(payout.events),
      };
    });
  }

  /** Settlements of the merchant: its payouts grouped by settlement batch. */
  async merchantSettlements(query: Record<string, unknown>): Promise<Page<unknown>> {
    const request = this.paginator.request(query, {});
    return this.db.user(async (tx) => {
      const payouts = await tx.payoutRequest.findMany({
        where: { batchId: { not: null } },
        include: { batch: true, _count: { select: { events: true } } },
      });
      const covered = await tx.payment.groupBy({
        by: ['payoutId'],
        where: { payoutId: { in: payouts.map((payout) => payout.id) } },
        _count: true,
      });
      const counts = new Map(covered.map((row) => [row.payoutId, row._count]));
      const batches = new Map<
        string,
        {
          id: string;
          reference: string;
          date: Date;
          status: 'SCHEDULED' | 'PAID';
          count: number;
          gross: bigint;
          commission: bigint;
          net: bigint;
        }
      >();
      for (const payout of payouts) {
        if (payout.batch === null) continue;
        const current = batches.get(payout.batch.id) ?? {
          id: payout.batch.id,
          reference: payout.batch.reference,
          date: payout.batch.settlementDate,
          // The merchant sees a batch to settle until the bank paid it (released, sent: still to come).
          status: payout.batch.status === 'PAID' ? 'PAID' : 'SCHEDULED',
          count: 0,
          gross: 0n,
          commission: 0n,
          net: 0n,
        };
        current.count += counts.get(payout.id) ?? 0;
        current.gross += payout.grossMillimes;
        current.commission += payout.commissionMillimes;
        current.net += payout.netMillimes;
        batches.set(payout.batch.id, current);
      }
      const sorted = [...batches.values()].sort((a, b) => b.date.getTime() - a.date.getTime());
      return this.paginator.page(
        request,
        sorted.slice(request.offset, request.offset + request.limit + 1).map((batch) => ({
          id: batch.id,
          reference: batch.reference,
          settlementDate: dayOf(batch.date),
          paymentsCount: batch.count,
          grossMillimes: toMillimes(batch.gross),
          commissionMillimes: toMillimes(batch.commission),
          netMillimes: toMillimes(batch.net),
          status: batch.status,
        })),
        {},
        request.withCount ? sorted.length : undefined,
      );
    });
  }

  // ---------------------------------------------------------------- admin

  async adminList(
    query: Record<string, unknown>,
    filters: { status?: PayoutStatus; creditType?: CreditType; q?: string },
  ) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const needle = filters.q?.trim();
      const where: Prisma.PayoutRequestWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.creditType === undefined ? {} : { creditType: filters.creditType }),
        ...(needle === undefined || needle === ''
          ? {}
          : {
              OR: [
                { reference: { contains: needle, mode: 'insensitive' } },
                { merchant: { name: { contains: needle, mode: 'insensitive' } } },
              ],
            }),
      };
      const all = await tx.payoutRequest.findMany({
        where,
        select: { id: true, status: true, requestedAt: true },
      });
      const ranked = all
        .sort(
          (a, b) =>
            Number(b.status === 'REQUESTED') - Number(a.status === 'REQUESTED') ||
            b.requestedAt.getTime() - a.requestedAt.getTime(),
        )
        .slice(request.offset, request.offset + request.limit + 1)
        .map((row) => row.id);
      const rows = await tx.payoutRequest.findMany({
        where: { id: { in: ranked } },
        include: ADMIN_INCLUDE,
      });
      const byId = new Map(rows.map((row) => [row.id, row]));
      return this.paginator.page(
        request,
        ranked.flatMap((id) => {
          const row = byId.get(id);
          return row === undefined ? [] : [adminPayout(row, this.pii)];
        }),
        filters,
        request.withCount ? all.length : undefined,
      );
    });
  }

  private async loadAdmin(tx: Tx, id: string): Promise<PayoutRow> {
    const payout = await tx.payoutRequest.findUnique({ where: { id }, include: ADMIN_INCLUDE });
    if (payout === null) throw problems.notFound();
    return payout;
  }

  async adminGet(id: string) {
    return this.db.user(async (tx) => {
      const payout = await this.loadAdmin(tx, id);
      return { ...adminPayout(payout, this.pii), history: history(payout.events) };
    });
  }

  /** Controlled (CHECKED): the request joins the next scheduled settlement batch (J+2). */
  /** Locks the payout request (ledger-auditor C2): approve and reject never both apply. */
  private async lockPayout(tx: Tx, id: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM payout_requests WHERE id = ${id}::uuid FOR UPDATE`;
  }

  async approve(tx: Tx, id: string) {
    await this.lockPayout(tx, id);
    const payout = await this.loadAdmin(tx, id);
    if (payout.status !== 'REQUESTED') throw problems.conflict();
    // Four eyes: the user who requested the payout (author of its ledger entry) never approves it.
    const [requested] =
      payout.transactionId === null
        ? []
        : await tx.$queryRaw<{ user_id: string | null }[]>`
            SELECT user_id FROM ledger_transactions WHERE id = ${payout.transactionId}::uuid`;
    await this.fourEyes.ensureNotAuthor(requested?.user_id, `virement ${payout.reference}`);
    // QY-03 b: nor does the administrator who created the merchant.
    const merchant = await tx.merchant.findUniqueOrThrow({
      where: { id: payout.merchantId },
      select: { createdBy: true },
    });
    await this.fourEyes.ensureNotAuthor(merchant.createdBy, `virement ${payout.reference}`);
    const batch = await nextBatch(tx);
    await tx.payoutRequest.update({
      where: { id },
      data: { status: 'CHECKED', batchId: batch.id },
    });
    await tx.payoutEvent.create({
      data: { id: uuidv7(), payoutId: id, status: 'CHECKED', actorId: principal().userId },
    });
    await this.audit.record(tx, 'payouts.approve', payout.reference);
    const updated = await this.loadAdmin(tx, id);
    return { ...adminPayout(updated, this.pii), history: history(updated.events) };
  }

  /** Rejected with a reason: the request entry is reversed (the merchant gets its balance back). */
  async reject(tx: Tx, id: string, reason: string) {
    {
      // Same order as a dispute: the accounts of the reversal, then the payout.
      const found = await tx.payoutRequest.findUnique({ where: { id } });
      if (found === null) throw problems.notFound();
      await this.ledger.lockAccounts(tx, [
        accounts.merchantWallet(found.merchantId, found.creditType),
        accounts.payoutPayable(),
        accounts.merchantCommission(),
        accounts.vatCollected(),
        accounts.stampDuty(),
      ]);
      await this.lockPayout(tx, id);
      const payout = await this.loadAdmin(tx, id);
      if (payout.status !== 'REQUESTED') throw problems.conflict();
      if (payout.transactionId !== null)
        await this.ledger.reverse(tx, payout.transactionId, `${payout.reference}-REJ`);
      await tx.payment.updateMany({ where: { payoutId: id }, data: { payoutId: null } });
      await tx.payoutRequest.update({ where: { id }, data: { status: 'REJECTED' } });
      await tx.payoutEvent.create({
        data: {
          id: uuidv7(),
          payoutId: id,
          status: 'REJECTED',
          reason,
          actorId: principal().userId,
        },
      });
      await this.audit.record(tx, 'payouts.reject', payout.reference);
      const updated = await this.loadAdmin(tx, id);
      return { ...adminPayout(updated, this.pii), history: history(updated.events) };
    }
  }

  private batchTotals(payouts: readonly PayoutRequest[]) {
    return {
      merchantsCount: new Set(payouts.map((payout) => payout.merchantId)).size,
      grossMillimes: toMillimes(payouts.reduce((sum, payout) => sum + payout.grossMillimes, 0n)),
      commissionMillimes: toMillimes(
        payouts.reduce((sum, payout) => sum + payout.commissionMillimes, 0n),
      ),
      vatMillimes: toMillimes(payouts.reduce((sum, payout) => sum + payout.vatMillimes, 0n)),
      stampDutyMillimes: toMillimes(
        payouts.reduce((sum, payout) => sum + payout.stampDutyMillimes, 0n),
      ),
      netMillimes: toMillimes(payouts.reduce((sum, payout) => sum + payout.netMillimes, 0n)),
    };
  }

  async batches(query: Record<string, unknown>) {
    const request = this.paginator.request(query, {});
    return this.db.user(async (tx) => {
      const rows = await tx.settlementBatch.findMany({
        include: { payouts: true },
        orderBy: [{ settlementDate: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.settlementBatch.count({ take: 10_001 })
        : undefined;
      return this.paginator.page(
        request,
        rows.map((batch) => ({
          id: batch.id,
          reference: batch.reference,
          settlementDate: dayOf(batch.settlementDate),
          status: batch.status,
          ...this.batchTotals(batch.payouts),
        })),
        {},
        count,
      );
    });
  }

  async batch(id: string) {
    return this.db.user(async (tx) => {
      const batch = await tx.settlementBatch.findUnique({ where: { id } });
      if (batch === null) throw problems.notFound();
      const payouts = await tx.payoutRequest.findMany({
        where: { batchId: id },
        include: ADMIN_INCLUDE,
        orderBy: { requestedAt: 'asc' },
      });
      return {
        id: batch.id,
        reference: batch.reference,
        settlementDate: dayOf(batch.settlementDate),
        status: batch.status,
        releasedAt: batch.releasedAt?.toISOString() ?? null,
        sentAt: batch.sentAt?.toISOString() ?? null,
        bankReference: batch.bankReference,
        ...this.batchTotals(payouts),
        payouts: payouts.map((row) => adminPayout(row, this.pii)),
      };
    });
  }

  /**
   * Settlement job (D+2, task 9): every batch RELEASED by Finance (four eyes) whose date has come
   * goes to the bank. Order: each payout SENT, the merchant debt deducted, payable debited and
   * payment account credited (decision « SENT » of 2026-11-02). Return of the bank: paid -> EXECUTED
   * and its payments SETTLED; rejected -> both entries reversed, the payout REJECTED and the
   * merchant told (he requests again). Then the batch is PAID (reconciled with the bank return).
   */
  async executeDueBatches(): Promise<number> {
    const due = await this.db.system((tx) =>
      tx.settlementBatch.findMany({
        where: { status: 'RELEASED', settlementDate: { lte: dateOnly(businessDay()) } },
        select: { id: true },
      }),
    );
    let done = 0;
    for (const { id } of due) {
      const order = await this.sendBatch(id);
      if (order === undefined) continue;
      const { bankReference } = await this.bank.send(order.reference, order.lines);
      const results = await this.bank.returnOf(bankReference, order.lines);
      await this.applyBankReturn(id, bankReference, results);
      done += 1;
    }
    if (done > 0) this.logger.log(`settlement batches executed: ${String(done)}`);
    return done;
  }

  /** The order of a batch: claimed once (ledger-auditor C3), each payout SENT and posted. */
  private async sendBatch(id: string) {
    return this.db.system(async (tx) => {
      const claimed = await tx.$queryRaw<{ id: string }[]>`
        SELECT id FROM settlement_batches WHERE id = ${id}::uuid AND status = 'RELEASED'
           FOR UPDATE SKIP LOCKED`;
      if (claimed.length === 0) return undefined;
      const batch = await tx.settlementBatch.findUniqueOrThrow({ where: { id } });
      const payouts = await tx.payoutRequest.findMany({ where: { batchId: id, status: 'CHECKED' } });
      // Accounts first and all at once, as everywhere (ledger-auditor C4).
      await this.ledger.lockAccounts(tx, [
        accounts.payoutPayable(),
        accounts.bankPayment(),
        ...payouts.map((payout) => accounts.merchantDebt(payout.merchantId)),
      ]);
      const lines: BankOrderLine[] = [];
      for (const payout of payouts) {
        // A payout held meanwhile left the batch and is not sent.
        const moved = await tx.payoutRequest.updateMany({
          where: { id: payout.id, batchId: id, status: 'CHECKED' },
          data: { status: 'SENT' },
        });
        if (moved.count !== 1) continue;
        // A merchant debt (accepted dispute on a paid payment) is deducted from what the bank
        // sends (decision of 2026-10-31); the payout records it.
        const debtAccount = accounts.merchantDebt(payout.merchantId);
        const debt = await this.ledger.balance(tx, debtAccount);
        const deducted = debt < payout.netMillimes ? debt : payout.netMillimes;
        await this.ledger.post(tx, {
          type: 'PAYOUT_EXECUTED',
          reference: payout.reference,
          entries: [
            { account: accounts.payoutPayable(), direction: 'D', amount: payout.netMillimes },
            ...(payout.netMillimes - deducted > 0n
              ? [
                  {
                    account: accounts.bankPayment(),
                    direction: 'C' as const,
                    amount: payout.netMillimes - deducted,
                  },
                ]
              : []),
            ...(deducted > 0n
              ? [{ account: debtAccount, direction: 'C' as const, amount: deducted }]
              : []),
          ],
        });
        if (deducted > 0n)
          await tx.payoutRequest.update({
            where: { id: payout.id },
            data: { deductedMillimes: deducted },
          });
        await tx.payoutEvent.create({
          data: { id: uuidv7(), payoutId: payout.id, status: 'SENT', occurredAt: new Date() },
        });
        if (payout.netMillimes - deducted > 0n)
          lines.push({
            payoutId: payout.id,
            reference: payout.reference,
            iban: this.pii.open(payout.iban),
            amountMillimes: payout.netMillimes - deducted,
          });
      }
      await tx.settlementBatch.update({
        where: { id },
        data: { status: 'SENT', sentAt: new Date() },
      });
      await this.audit.record(tx, 'settlements.send', batch.reference, 'Système');
      return { reference: batch.reference, lines, sent: payouts.map((payout) => payout.id) };
    });
  }

  /** Return of the bank: paid or rejected per transfer, then the batch is reconciled (PAID). */
  private async applyBankReturn(
    id: string,
    bankReference: string,
    results: readonly BankReturnLine[],
  ): Promise<void> {
    const rejected: { merchantId: string; reference: string; reason: string }[] = [];
    await this.db.system(async (tx) => {
      const sent = await tx.payoutRequest.findMany({ where: { batchId: id, status: 'SENT' } });
      const byId = new Map(results.map((line) => [line.payoutId, line]));
      // Every account a rejection may reverse, locked first and at once.
      await this.ledger.lockAccounts(tx, [
        accounts.payoutPayable(),
        accounts.bankPayment(),
        accounts.merchantCommission(),
        accounts.vatCollected(),
        accounts.stampDuty(),
        ...sent.flatMap((payout) => [
          accounts.merchantDebt(payout.merchantId),
          accounts.merchantWallet(payout.merchantId, payout.creditType),
        ]),
      ]);
      const now = new Date();
      for (const payout of sent) {
        // A payout fully covered by a debt has no bank line: it is paid by the deduction.
        const result = byId.get(payout.id) ?? { payoutId: payout.id, paid: true };
        if (result.paid) {
          await tx.payoutRequest.update({ where: { id: payout.id }, data: { status: 'EXECUTED' } });
          await tx.payoutEvent.create({
            data: { id: uuidv7(), payoutId: payout.id, status: 'EXECUTED', occurredAt: now },
          });
          const settled = await tx.payment.findMany({
            where: { payoutId: payout.id, status: 'CONFIRMED' },
            select: { id: true },
          });
          await tx.payment.updateMany({
            where: { id: { in: settled.map((row) => row.id) } },
            data: { status: 'SETTLED' },
          });
          await tx.paymentEvent.createMany({
            data: settled.map((row) => ({
              id: uuidv7(),
              paymentId: row.id,
              status: 'SETTLED' as const,
              occurredAt: now,
            })),
          });
          continue;
        }
        // Rejected by the bank: the order and the request are reversed (the merchant gets its
        // balance and its debt back), the payout is rejected and the merchant requests again.
        const executed = await tx.ledgerTransaction.findFirst({
          where: { reference: payout.reference, type: 'PAYOUT_EXECUTED', reversesId: null },
          select: { id: true },
        });
        if (executed !== null)
          await this.ledger.reverse(tx, executed.id, `${payout.reference}-BANK`);
        if (payout.transactionId !== null)
          await this.ledger.reverse(tx, payout.transactionId, `${payout.reference}-RET`);
        await tx.payment.updateMany({ where: { payoutId: payout.id }, data: { payoutId: null } });
        await tx.payoutRequest.update({
          where: { id: payout.id },
          data: { status: 'REJECTED', deductedMillimes: 0n },
        });
        const reason = result.reason ?? 'Rejet bancaire';
        await tx.payoutEvent.create({
          data: { id: uuidv7(), payoutId: payout.id, status: 'REJECTED', reason, occurredAt: now },
        });
        rejected.push({ merchantId: payout.merchantId, reference: payout.reference, reason });
      }
      await tx.settlementBatch.update({ where: { id }, data: { status: 'PAID', bankReference } });
      await this.audit.record(tx, 'settlements.execute', id, 'Système');
    });
    for (const line of rejected) await this.notifyCancelled(line.merchantId, line.reference, line.reason);
  }

  /**
   * The merchant is told that a payout was cancelled (rejected by the bank, or reversed by an
   * accepted dispute, decision of 2026-11-04) and that he can request it again (simulated e-mail).
   */
  async notifyCancelled(merchantId: string, reference: string, reason: string): Promise<void> {
    const owners = await this.db.system((tx) =>
      tx.user.findMany({
        where: { merchantId, subRole: 'OWNER', status: 'ACTIVE' },
        select: { email: true },
      }),
    );
    for (const owner of owners) {
      await this.outbox.send({
        to: owner.email,
        subject: `Virement ${reference} annulé`,
        text: `Votre virement ${reference} a été annulé (${reason}). Le montant est de nouveau disponible : vous pouvez le redemander depuis l'écran Virements.\n${this.outbox.webOrigin()}/fr/commercant/virements`,
      });
    }
  }
}
