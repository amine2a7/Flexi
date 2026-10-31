import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { LedgerService, accounts } from '../ledger/ledger.service.js';
import type { Dispute, DisputeNote, Merchant, Payment } from '../generated/prisma/client.js';

/** Target of a decision (decision of 2026-10-31). */
const DECISION_DAYS = 15;
/** A payment stays disputable 30 days (decision of 2026-10-31). */
const DISPUTABLE_DAYS = 30;
/** Refunded credits are valid 30 days at least from the refund (decision of 2026-10-31). */
const REFUND_VALIDITY_DAYS = 30;
const DAY_MS = 86_400_000;

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
 * N2 disputes (decision of 2026-10-31). Opening moves the payment amount from the merchant wallet
 * to its dispute hold account (never in a settlement); rejecting moves it back; accepting asks
 * Finance for the second validation (approval DISPUTE_REFUND), whose approval refunds the employee
 * into its credit lots of origin (same expiry; an expired share follows the expired-credit rule).
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
        notes: (dispute.notes ?? []).map((note) => ({
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
    if (found.payoutId !== null) {
      await tx.$queryRaw`SELECT id FROM payout_requests WHERE id = ${found.payoutId}::uuid FOR UPDATE`;
    }
    await tx.$queryRaw`SELECT id FROM payments WHERE id = ${paymentId}::uuid FOR UPDATE`;
    const payment = await tx.payment.findUniqueOrThrow({ where: { id: paymentId } });
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
    } else if (payout !== null && (payout.status === 'REQUESTED' || payout.status === 'CHECKED')) {
      // In a payout not yet paid: the payout waits for the decision (« En attente — litige »).
      heldPayout = { id: payout.id, status: payout.status };
      await tx.payoutRequest.update({ where: { id: payout.id }, data: { status: 'ON_HOLD' } });
      await tx.payoutEvent.create({
        data: {
          id: uuidv7(),
          payoutId: payout.id,
          status: 'ON_HOLD',
          reason: reference,
          actorId: who.userId,
        },
      });
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
    const dispute = await this.lockOpen(tx, id);
    const payment = dispute.payment;
    let resolution: string | null = null;
    if (dispute.holdTransactionId !== null) {
      const wallet = accounts.merchantWallet(payment.merchantId, payment.creditType);
      const hold = accounts.disputeHold(payment.merchantId, payment.creditType);
      await this.ledger.lockAccounts(tx, [wallet, hold]);
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
    if (dispute.heldPayoutId !== null && dispute.heldPayoutStatus !== null) {
      await tx.payoutRequest.updateMany({
        where: { id: dispute.heldPayoutId, status: 'ON_HOLD' },
        data: { status: dispute.heldPayoutStatus as 'REQUESTED' | 'CHECKED' },
      });
      await tx.payoutEvent.create({
        data: {
          id: uuidv7(),
          payoutId: dispute.heldPayoutId,
          status: dispute.heldPayoutStatus as 'REQUESTED' | 'CHECKED',
          reason: dispute.reference,
          actorId: principal().userId,
        },
      });
    }
    await tx.payment.update({
      where: { id: payment.id },
      data: { status: dispute.paymentPreviousStatus as 'CONFIRMED' | 'SETTLED' },
    });
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
   * the expiry of origin, but valid 30 days at least from the refund (decision of 2026-10-31).
   * Source of the refund: the held amount (free payment); the merchant wallet after the reversal of
   * the held payout (rejected, the merchant requests again: to confirm by Amine); a merchant debt
   * deducted from the next settlement (payment already paid). One balanced transaction.
   */
  async refund(tx: Tx, id: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM disputes WHERE id = ${id}::uuid FOR UPDATE`;
    const dispute = await tx.dispute.findUnique({ where: { id }, include: { payment: true } });
    if (dispute?.status !== 'ACCEPTANCE_PENDING') throw problems.conflict();
    const payment = dispute.payment;
    if (payment.transactionId === null) throw problems.conflict();
    const who = principal();
    const employeeWallet = accounts.employeeWallet(payment.employeeId, payment.creditType);
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
    const source = await this.refundSource(tx, dispute, who.userId);
    await this.ledger.lockAccounts(tx, [source, employeeWallet]);
    const posted = await this.ledger.post(tx, {
      type: 'DISPUTE_REFUND',
      reference: dispute.reference,
      userId: who.userId,
      entries: [
        { account: source, direction: 'D', amount: dispute.amountMillimes },
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
      data: { status: 'ACCEPTED', decidedAt: now, resolutionTransactionId: posted.transactionId },
    });
    await this.audit.record(tx, 'disputes.refund', dispute.reference);
  }

  /** Account the refund is taken from (see refund). */
  private async refundSource(
    tx: Tx,
    dispute: {
      reference: string;
      holdTransactionId: string | null;
      heldPayoutId: string | null;
      payment: {
        merchantId: string;
        creditType: 'RESTAURATION' | 'HABILLEMENT' | 'CARBURANT' | 'CADEAUX';
      };
    },
    actorId: string,
  ) {
    const { merchantId, creditType } = dispute.payment;
    if (dispute.holdTransactionId !== null) return accounts.disputeHold(merchantId, creditType);
    if (dispute.heldPayoutId !== null) {
      await tx.$queryRaw`SELECT id FROM payout_requests WHERE id = ${dispute.heldPayoutId}::uuid FOR UPDATE`;
      const payout = await tx.payoutRequest.findUniqueOrThrow({
        where: { id: dispute.heldPayoutId },
      });
      if (payout.status !== 'ON_HOLD') throw problems.conflict();
      // The held payout is reversed: its gross goes back to the merchant wallet.
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
      return accounts.merchantWallet(merchantId, creditType);
    }
    return accounts.merchantDebt(merchantId);
  }

  /** Second validation refused: the dispute goes back to investigation. */
  async reopen(tx: Tx, id: string): Promise<void> {
    await tx.dispute.updateMany({
      where: { id, status: 'ACCEPTANCE_PENDING' },
      data: { status: 'OPEN', decisionReason: null },
    });
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
