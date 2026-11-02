import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { commissionOf, toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { LedgerService, accounts, type EntryInput } from '../ledger/ledger.service.js';
import { nextBatch } from '../payouts/settlement-batch.js';
import type {
  CreditType,
  Dispute,
  DisputeNote,
  Merchant,
  Payment,
  PayoutRequest,
} from '../generated/prisma/client.js';

/** Target of a decision (decision of 2026-10-31). */
const DECISION_DAYS = 15;
/** A payment stays disputable 30 days (decision of 2026-10-31). */
const DISPUTABLE_DAYS = 30;
/** Refunded credits are valid 30 days at least from the refund (decision of 2026-10-31). */
const REFUND_VALIDITY_DAYS = 30;
const DAY_MS = 86_400_000;
/** A dispute still in progress keeps its payout on hold. */
const ACTIVE = ['OPEN', 'ACCEPTANCE_PENDING'] as const;

type DisputeRow = Dispute & { payment: Payment; merchant: Merchant; notes?: DisputeNote[] };

function disputeBody(dispute: DisputeRow) {
  return {
    id: dispute.id,
    reference: dispute.reference,
    paymentReference: dispute.payment.reference,
    merchantName: dispute.merchant.name,
    creditType: dispute.payment.creditType,
    amountMillimes: toMillimes(dispute.amountMillimes),
    reason: dispute.reason,
    status: dispute.status,
    openedAt: dispute.openedAt.toISOString(),
    openedByName: dispute.openedByName,
    dueAt: dispute.dueAt.toISOString(),
    decisionReason: dispute.decisionReason,
    decidedAt: dispute.decidedAt?.toISOString() ?? null,
  };
}

/**
 * N2 disputes (decisions of 2026-10-31 and 2026-11-02). Opening moves the payment amount from the
 * merchant wallet to its dispute hold account, or puts its payout on hold; rejecting gives it back;
 * accepting asks Finance for the second validation (approval DISPUTE_REFUND), whose approval
 * refunds the employee. Lock order everywhere: every account at once, then dispute, payout, payment.
 */
@Injectable()
export class DisputesService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
  ) {}

  async list(query: Record<string, unknown>): Promise<Page<unknown>> {
    const request = this.paginator.request(query, {});
    return this.db.user(async (tx) => {
      const rows = await tx.dispute.findMany({
        include: { payment: true, merchant: true },
        orderBy: [{ openedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.dispute.count({ take: 10_001 }) : undefined;
      return this.paginator.page(request, rows.map(disputeBody), {}, count);
    });
  }

  async detail(id: string) {
    return this.db.user(async (tx) => {
      const dispute = await tx.dispute.findUnique({
        where: { id },
        include: { payment: true, merchant: true, notes: { orderBy: { createdAt: 'asc' } } },
      });
      if (dispute === null) throw problems.notFound();
      return {
        ...disputeBody(dispute),
        notes: dispute.notes.map((note) => ({
          id: note.id,
          authorName: note.authorName,
          text: note.text,
          createdAt: note.createdAt.toISOString(),
        })),
      };
    });
  }

  /**
   * Opens a dispute on a payment of the last 30 days (decision of 2026-10-31), three cases:
   * free (amount held out of the merchant wallet), in a payout not yet paid (the payout is put on
   * hold until the decision), already paid (nothing moves until the decision).
   */
  async open(tx: Tx, paymentId: string, reason: string) {
    const who = principal();
    const found = await tx.payment.findUnique({ where: { id: paymentId } });
    if (found === null) throw problems.notFound();
    const wallet = accounts.merchantWallet(found.merchantId, found.creditType);
    const hold = accounts.disputeHold(found.merchantId, found.creditType);
    // Same order as a payout request: the accounts, then the payout and payment rows (N2-4).
    await this.ledger.lockAccounts(tx, [wallet, hold]);
    if (found.payoutId !== null) await this.lockPayout(tx, found.payoutId);
    await tx.$queryRaw`SELECT id FROM payments WHERE id = ${paymentId}::uuid FOR UPDATE`;
    const payment = await tx.payment.findUniqueOrThrow({ where: { id: paymentId } });
    // The payout read above is the one locked: a request may have just taken the payment.
    if (payment.payoutId !== found.payoutId) throw problems.conflict();
    if (payment.status !== 'CONFIRMED' && payment.status !== 'SETTLED') throw problems.conflict();
    const confirmedAt = payment.confirmedAt ?? payment.createdAt;
    if (Date.now() - confirmedAt.getTime() > DISPUTABLE_DAYS * DAY_MS) throw problems.conflict();
    if ((await tx.dispute.count({ where: { paymentId } })) > 0) throw problems.conflict();
    const payout =
      payment.payoutId === null
        ? null
        : await tx.payoutRequest.findUnique({ where: { id: payment.payoutId } });
    const [sequence] = await tx.$queryRaw<
      { value: bigint }[]
    >`SELECT nextval('dispute_number_seq') AS value`;
    const reference = `LIT-${new Date().getUTCFullYear().toString()}-${String(sequence?.value ?? 0n).padStart(4, '0')}`;
    let holdTransactionId: string | null = null;
    let heldPayout: { id: string; status: string } | null = null;
    if (payment.status === 'CONFIRMED' && payment.payoutId === null) {
      // Free payment: held out of the merchant wallet, so it never enters a settlement.
      if ((await this.ledger.balance(tx, wallet)) < payment.amountMillimes)
        throw problems.conflict();
      const posted = await this.ledger.post(tx, {
        type: 'DISPUTE_HOLD',
        reference,
        userId: who.userId,
        entries: [
          { account: wallet, direction: 'D', amount: payment.amountMillimes },
          { account: hold, direction: 'C', amount: payment.amountMillimes },
        ],
      });
      holdTransactionId = posted.transactionId;
    } else if (
      payout !== null &&
      (payout.status === 'REQUESTED' || payout.status === 'CHECKED' || payout.status === 'ON_HOLD')
    ) {
      // In a payout not yet paid: the payout waits for the decision (« En attente — litige »).
      heldPayout = await this.holdPayout(tx, payout, reference, who.userId);
    }
    // Otherwise already paid: nothing moves until the decision (debt deducted if accepted).
    await tx.payment.update({ where: { id: paymentId }, data: { status: 'DISPUTED' } });
    const now = new Date();
    const dispute = await tx.dispute.create({
      data: {
        id: uuidv7(),
        reference,
        paymentId,
        merchantId: payment.merchantId,
        amountMillimes: payment.amountMillimes,
        reason,
        openedBy: who.userId,
        openedByName: who.displayName,
        openedAt: now,
        dueAt: new Date(now.getTime() + DECISION_DAYS * DAY_MS),
        holdTransactionId,
        heldPayoutId: heldPayout?.id ?? null,
        heldPayoutStatus: heldPayout?.status ?? null,
        paymentPreviousStatus: payment.status,
      },
      include: { payment: true, merchant: true },
    });
    await this.audit.record(tx, 'disputes.open', `${reference} ${payment.reference}`);
    return disputeBody(dispute);
  }

  async note(id: string, text: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const dispute = await tx.dispute.findUnique({ where: { id } });
      if (dispute === null) throw problems.notFound();
      if (dispute.status === 'ACCEPTED' || dispute.status === 'REJECTED') throw problems.conflict();
      const note = await tx.disputeNote.create({
        data: {
          id: uuidv7(),
          disputeId: id,
          authorId: who.userId,
          authorName: who.displayName,
          text,
        },
      });
      await this.audit.record(tx, 'disputes.note', dispute.reference);
      return {
        id: note.id,
        authorName: note.authorName,
        text: note.text,
        createdAt: note.createdAt.toISOString(),
      };
    });
  }

  /** Rejected: everything goes back as before (held amount, held payout, payment status). */
  async reject(tx: Tx, id: string, reason: string) {
    const { merchantId, creditType } = await this.paymentOf(tx, id);
    const wallet = accounts.merchantWallet(merchantId, creditType);
    const hold = accounts.disputeHold(merchantId, creditType);
    await this.ledger.lockAccounts(tx, [wallet, hold]);
    const dispute = await this.lockOpen(tx, id);
    let resolution: string | null = null;
    if (dispute.holdTransactionId !== null) {
      const posted = await this.ledger.post(tx, {
        type: 'DISPUTE_RELEASE',
        reference: dispute.reference,
        userId: principal().userId,
        entries: [
          { account: hold, direction: 'D', amount: dispute.amountMillimes },
          { account: wallet, direction: 'C', amount: dispute.amountMillimes },
        ],
      });
      resolution = posted.transactionId;
    }
    if (dispute.heldPayoutId !== null) await this.releasePayout(tx, dispute);
    await this.restorePayment(tx, dispute);
    const updated = await tx.dispute.update({
      where: { id },
      data: {
        status: 'REJECTED',
        decisionReason: reason,
        decidedAt: new Date(),
        resolutionTransactionId: resolution,
      },
      include: { payment: true, merchant: true },
    });
    await this.audit.record(tx, 'disputes.reject', dispute.reference);
    return disputeBody(updated);
  }

  /** Accepted: pending the second validation of Finance (four eyes on money). */
  async accept(tx: Tx, id: string, reason: string) {
    const who = principal();
    const dispute = await this.lockOpen(tx, id);
    await tx.approval.create({
      data: {
        type: 'DISPUTE_REFUND',
        subject: `Litige ${dispute.reference} (${dispute.payment.reference})`,
        payload: { disputeId: id },
        reason,
        initiatorId: who.userId,
        initiatorName: who.displayName,
      },
    });
    const updated = await tx.dispute.update({
      where: { id },
      data: { status: 'ACCEPTANCE_PENDING', decisionReason: reason },
      include: { payment: true, merchant: true },
    });
    await this.audit.record(tx, 'disputes.accept', dispute.reference);
    return disputeBody(updated);
  }

  /**
   * Second validation given (AdminService.approve): the employee is refunded into credit lots of
   * the expiry of origin, but valid 30 days at least from the refund (decision of 2026-10-31). One
   * balanced transaction, its debits depend on where the money is at the decision (refundDebits).
   */
  async refund(tx: Tx, id: string): Promise<void> {
    const { employeeId, merchantId, creditType } = await this.paymentOf(tx, id);
    const employeeWallet = accounts.employeeWallet(employeeId, creditType);
    await this.ledger.lockAccounts(tx, [
      employeeWallet,
      accounts.merchantWallet(merchantId, creditType),
      accounts.disputeHold(merchantId, creditType),
      accounts.merchantDebt(merchantId),
      accounts.merchantCommission(),
      accounts.payoutPayable(),
    ]);
    await tx.$queryRaw`SELECT id FROM disputes WHERE id = ${id}::uuid FOR UPDATE`;
    const dispute = await tx.dispute.findUnique({ where: { id }, include: { payment: true } });
    if (dispute?.status !== 'ACCEPTANCE_PENDING') throw problems.conflict();
    const payment = dispute.payment;
    if (payment.transactionId === null) throw problems.conflict();
    const who = principal();
    const parts = await tx.$queryRaw<{ amount: bigint; expires_at: Date }[]>`
      SELECT e.amount_millimes AS amount, l.expires_at
        FROM ledger_entries e
        JOIN ledger_accounts a ON a.id = e.account_id
        JOIN credit_lots l ON l.id = e.lot_id
       WHERE e.transaction_id = ${payment.transactionId}::uuid
         AND a.code = ${employeeWallet.code} AND e.direction = 'D'
       ORDER BY l.expires_at, e.id`;
    // Every debit of the employee wallet must carry its lot: never a silent share (N2-3).
    const [debited] = await tx.$queryRaw<{ total: bigint }[]>`
      SELECT coalesce(sum(e.amount_millimes), 0)::bigint AS total
        FROM ledger_entries e JOIN ledger_accounts a ON a.id = e.account_id
       WHERE e.transaction_id = ${payment.transactionId}::uuid
         AND a.code = ${employeeWallet.code} AND e.direction = 'D'`;
    const lotted = parts.reduce((sum, part) => sum + part.amount, 0n);
    if (debited?.total !== dispute.amountMillimes || lotted !== dispute.amountMillimes) {
      throw new Error('dispute refund: payment debits do not match the disputed amount');
    }
    const now = new Date();
    const { debits, commission } = await this.refundDebits(tx, dispute, who.userId);
    const posted = await this.ledger.post(tx, {
      type: 'DISPUTE_REFUND',
      reference: dispute.reference,
      userId: who.userId,
      entries: [
        ...debits,
        { account: employeeWallet, direction: 'C', amount: dispute.amountMillimes },
      ],
    });
    const floor = now.getTime() + REFUND_VALIDITY_DAYS * DAY_MS;
    for (const part of parts) {
      await this.ledger.addLot(tx, {
        account: employeeWallet,
        creditType: payment.creditType,
        amount: part.amount,
        expiresAt: new Date(Math.max(part.expires_at.getTime(), floor)),
        sourceTransactionId: posted.transactionId,
      });
    }
    await tx.payment.update({ where: { id: payment.id }, data: { status: 'REFUNDED' } });
    await tx.dispute.update({
      where: { id },
      data: {
        status: 'ACCEPTED',
        decidedAt: now,
        resolutionTransactionId: posted.transactionId,
        commissionReversedMillimes: commission,
      },
    });
    await this.audit.record(tx, 'disputes.refund', dispute.reference);
  }

  /**
   * Debits of the refund, from where the money is: the held amount (free payment); the merchant
   * wallet after the reversal of the held payout (rejected, the merchant requests again: to confirm
   * by Amine); paid to the merchant, its commission cancelled (decision of 2026-11-02) and the rest
   * a debt deducted from the next settlement.
   */
  private async refundDebits(
    tx: Tx,
    dispute: Dispute & { payment: Payment },
    actorId: string,
  ): Promise<{ debits: EntryInput[]; commission: bigint }> {
    const { merchantId, creditType } = dispute.payment;
    const amount = dispute.amountMillimes;
    if (dispute.holdTransactionId !== null) {
      const account = accounts.disputeHold(merchantId, creditType);
      return { debits: [{ account, direction: 'D', amount }], commission: 0n };
    }
    if (dispute.heldPayoutId !== null) {
      await this.reverseHeldPayout(tx, dispute, actorId);
      const account = accounts.merchantWallet(merchantId, creditType);
      return { debits: [{ account, direction: 'D', amount }], commission: 0n };
    }
    const commission = await this.commissionToCancel(tx, dispute);
    const debt = amount - commission;
    return {
      debits: [
        ...(debt > 0n
          ? [{ account: accounts.merchantDebt(merchantId), direction: 'D' as const, amount: debt }]
          : []),
        ...(commission > 0n
          ? [
              {
                account: accounts.merchantCommission(),
                direction: 'D' as const,
                amount: commission,
              },
            ]
          : []),
      ],
      commission,
    };
  }

  /**
   * The held payout is reversed: its gross goes back to the merchant wallet. The amount of every
   * other dispute on it is held at once, so that it never comes back free to the merchant.
   */
  private async reverseHeldPayout(
    tx: Tx,
    dispute: Dispute & { payment: Payment },
    actorId: string,
  ): Promise<void> {
    if (dispute.heldPayoutId === null) return;
    await this.lockPayout(tx, dispute.heldPayoutId);
    const payout = await tx.payoutRequest.findUniqueOrThrow({
      where: { id: dispute.heldPayoutId },
    });
    if (payout.status !== 'ON_HOLD') throw problems.conflict();
    if (payout.transactionId !== null) {
      await this.ledger.reverse(
        tx,
        payout.transactionId,
        `${payout.reference}-${dispute.reference}`,
      );
    }
    await tx.payment.updateMany({ where: { payoutId: payout.id }, data: { payoutId: null } });
    await tx.payoutRequest.update({ where: { id: payout.id }, data: { status: 'REJECTED' } });
    await tx.payoutEvent.create({
      data: {
        id: uuidv7(),
        payoutId: payout.id,
        status: 'REJECTED',
        reason: dispute.reference,
        actorId,
      },
    });
    const others = await tx.dispute.findMany({
      where: { heldPayoutId: payout.id, status: { in: [...ACTIVE] }, id: { not: dispute.id } },
    });
    const { merchantId, creditType } = dispute.payment;
    for (const other of others) {
      const posted = await this.ledger.post(tx, {
        type: 'DISPUTE_HOLD',
        reference: other.reference,
        userId: actorId,
        entries: [
          {
            account: accounts.merchantWallet(merchantId, creditType),
            direction: 'D',
            amount: other.amountMillimes,
          },
          {
            account: accounts.disputeHold(merchantId, creditType),
            direction: 'C',
            amount: other.amountMillimes,
          },
        ],
      });
      await tx.dispute.update({
        where: { id: other.id },
        data: {
          holdTransactionId: posted.transactionId,
          heldPayoutId: null,
          heldPayoutStatus: null,
        },
      });
    }
  }

  /**
   * Commission of a paid payment at the frozen rate of its payout, without ever cancelling more
   * than the payout took (the rounding of several shares could add up to more).
   */
  private async commissionToCancel(
    tx: Tx,
    dispute: Dispute & { payment: Payment },
  ): Promise<bigint> {
    if (dispute.payment.payoutId === null) return 0n;
    const payout = await tx.payoutRequest.findUnique({ where: { id: dispute.payment.payoutId } });
    if (payout === null) return 0n;
    const done = await tx.dispute.aggregate({
      _sum: { commissionReversedMillimes: true },
      where: { status: 'ACCEPTED', payment: { payoutId: payout.id } },
    });
    const left = payout.commissionMillimes - (done._sum.commissionReversedMillimes ?? 0n);
    const share = commissionOf(dispute.amountMillimes, payout.commissionRateBps);
    return share < left ? share : left;
  }

  /** First dispute: the payout leaves its batch and waits. Next ones keep its status of origin. */
  private async holdPayout(
    tx: Tx,
    payout: PayoutRequest,
    reference: string,
    actorId: string,
  ): Promise<{ id: string; status: string }> {
    if (payout.status === 'ON_HOLD') {
      const held = await tx.dispute.findFirst({
        where: { heldPayoutId: payout.id, status: { in: [...ACTIVE] } },
      });
      const status = held?.heldPayoutStatus ?? null;
      if (status === null) throw problems.conflict();
      return { id: payout.id, status };
    }
    await tx.payoutRequest.update({
      where: { id: payout.id },
      data: { status: 'ON_HOLD', batchId: null },
    });
    await tx.payoutEvent.create({
      data: { id: uuidv7(), payoutId: payout.id, status: 'ON_HOLD', reason: reference, actorId },
    });
    return { id: payout.id, status: payout.status };
  }

  /** The last open dispute closed: the payout resumes, checked ones in the next batch. */
  private async releasePayout(tx: Tx, dispute: Dispute): Promise<void> {
    if (dispute.heldPayoutId === null) return;
    await this.lockPayout(tx, dispute.heldPayoutId);
    const payout = await tx.payoutRequest.findUniqueOrThrow({
      where: { id: dispute.heldPayoutId },
    });
    if (payout.status !== 'ON_HOLD') return;
    const others = await tx.dispute.count({
      where: { heldPayoutId: payout.id, status: { in: [...ACTIVE] }, id: { not: dispute.id } },
    });
    if (others > 0) return;
    const status = dispute.heldPayoutStatus === 'CHECKED' ? 'CHECKED' : 'REQUESTED';
    const batchId = status === 'CHECKED' ? (await nextBatch(tx)).id : null;
    await tx.payoutRequest.update({ where: { id: payout.id }, data: { status, batchId } });
    await tx.payoutEvent.create({
      data: {
        id: uuidv7(),
        payoutId: payout.id,
        status,
        reason: dispute.reference,
        actorId: principal().userId,
      },
    });
  }

  /** Back to its status, settled if its payout was executed during the dispute. */
  private async restorePayment(tx: Tx, dispute: Dispute & { payment: Payment }): Promise<void> {
    const { payment } = dispute;
    const payout =
      payment.payoutId === null
        ? null
        : await tx.payoutRequest.findUnique({ where: { id: payment.payoutId } });
    const status =
      payout?.status === 'EXECUTED'
        ? 'SETTLED'
        : (dispute.paymentPreviousStatus as 'CONFIRMED' | 'SETTLED');
    await tx.payment.update({ where: { id: payment.id }, data: { status } });
  }

  /** Second validation refused: the dispute goes back to investigation. */
  async reopen(tx: Tx, id: string): Promise<void> {
    await tx.dispute.updateMany({
      where: { id, status: 'ACCEPTANCE_PENDING' },
      data: { status: 'OPEN', decisionReason: null },
    });
  }

  private async lockPayout(tx: Tx, id: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM payout_requests WHERE id = ${id}::uuid FOR UPDATE`;
  }

  /** Who the dispute concerns, read before any lock: its accounts are locked first. */
  private async paymentOf(
    tx: Tx,
    id: string,
  ): Promise<{ employeeId: string; merchantId: string; creditType: CreditType }> {
    const dispute = await tx.dispute.findUnique({
      where: { id },
      select: { payment: { select: { employeeId: true, merchantId: true, creditType: true } } },
    });
    if (dispute === null) throw problems.notFound();
    return dispute.payment;
  }

  private async lockOpen(tx: Tx, id: string): Promise<DisputeRow> {
    await tx.$queryRaw`SELECT id FROM disputes WHERE id = ${id}::uuid FOR UPDATE`;
    const dispute = await tx.dispute.findUnique({
      where: { id },
      include: { payment: true, merchant: true },
    });
    if (dispute === null) throw problems.notFound();
    if (dispute.status !== 'OPEN') throw problems.conflict();
    return dispute;
  }
}
