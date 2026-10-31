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

  /** Opens a dispute on a confirmed payment that is in no payout request yet. */
  async open(tx: Tx, paymentId: string, reason: string) {
    const who = principal();
    await tx.$queryRaw`SELECT id FROM payments WHERE id = ${paymentId}::uuid FOR UPDATE`;
    const payment = await tx.payment.findUnique({ where: { id: paymentId } });
    if (payment === null) throw problems.notFound();
    // Settled, refused or already in a payout request: never disputed here (to confirm by Amine).
    if (payment.status !== 'CONFIRMED' || payment.payoutId !== null) throw problems.conflict();
    if ((await tx.dispute.count({ where: { paymentId } })) > 0) throw problems.conflict();
    const wallet = accounts.merchantWallet(payment.merchantId, payment.creditType);
    const hold = accounts.disputeHold(payment.merchantId, payment.creditType);
    await this.ledger.lockAccounts(tx, [wallet, hold]);
    if ((await this.ledger.balance(tx, wallet)) < payment.amountMillimes) throw problems.conflict();
    const [sequence] = await tx.$queryRaw<
      { value: bigint }[]
    >`SELECT nextval('dispute_number_seq') AS value`;
    const reference = `LIT-${new Date().getUTCFullYear().toString()}-${String(sequence?.value ?? 0n).padStart(4, '0')}`;
    const posted = await this.ledger.post(tx, {
      type: 'DISPUTE_HOLD',
      reference,
      userId: who.userId,
      entries: [
        { account: wallet, direction: 'D', amount: payment.amountMillimes },
        { account: hold, direction: 'C', amount: payment.amountMillimes },
      ],
    });
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
        holdTransactionId: posted.transactionId,
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

  /** Rejected: the held amount goes back to the merchant (normal settlement). */
  async reject(tx: Tx, id: string, reason: string) {
    const dispute = await this.lockOpen(tx, id);
    const payment = dispute.payment;
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
    const updated = await tx.dispute.update({
      where: { id },
      data: {
        status: 'REJECTED',
        decisionReason: reason,
        decidedAt: new Date(),
        resolutionTransactionId: posted.transactionId,
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
   * Second validation given (AdminService.approve): refund of the employee into the credit lots
   * the payment consumed, same expiry; the share of a lot expired since follows the expired-credit
   * destination (decision of 2026-10-14). One balanced transaction.
   */
  async refund(tx: Tx, id: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM disputes WHERE id = ${id}::uuid FOR UPDATE`;
    const dispute = await tx.dispute.findUnique({ where: { id }, include: { payment: true } });
    if (dispute?.status !== 'ACCEPTANCE_PENDING') throw problems.conflict();
    const payment = dispute.payment;
    if (payment.transactionId === null) throw problems.conflict();
    const employeeWallet = accounts.employeeWallet(payment.employeeId, payment.creditType);
    const parts = await tx.$queryRaw<{ amount: bigint; expires_at: Date }[]>`
      SELECT e.amount_millimes AS amount, l.expires_at
        FROM ledger_entries e
        JOIN ledger_accounts a ON a.id = e.account_id
        JOIN credit_lots l ON l.id = e.lot_id
       WHERE e.transaction_id = ${payment.transactionId}::uuid
         AND a.code = ${employeeWallet.code} AND e.direction = 'D'
       ORDER BY l.expires_at, e.id`;
    const now = new Date();
    const valid = parts.filter((part) => part.expires_at.getTime() > now.getTime());
    const refunded = valid.reduce((sum, part) => sum + part.amount, 0n);
    const expired = dispute.amountMillimes - refunded;
    const destination = (await tx.platformSettings.findUnique({ where: { id: 1 } }))
      ?.expiredCreditsDestination;
    const expiredTarget =
      destination === 'COMPANY_RETURN'
        ? accounts.companyWallet(payment.companyId, payment.creditType)
        : accounts.expiredCredits();
    const hold = accounts.disputeHold(payment.merchantId, payment.creditType);
    await this.ledger.lockAccounts(tx, [hold, employeeWallet, expiredTarget]);
    const posted = await this.ledger.post(tx, {
      type: 'DISPUTE_REFUND',
      reference: dispute.reference,
      userId: principal().userId,
      entries: [
        { account: hold, direction: 'D', amount: dispute.amountMillimes },
        ...(refunded > 0n
          ? [{ account: employeeWallet, direction: 'C' as const, amount: refunded }]
          : []),
        ...(expired > 0n
          ? [{ account: expiredTarget, direction: 'C' as const, amount: expired }]
          : []),
      ],
    });
    for (const part of valid) {
      await this.ledger.addLot(tx, {
        account: employeeWallet,
        creditType: payment.creditType,
        amount: part.amount,
        expiresAt: part.expires_at,
        sourceTransactionId: posted.transactionId,
      });
    }
    await tx.dispute.update({
      where: { id },
      data: { status: 'ACCEPTED', decidedAt: now, resolutionTransactionId: posted.transactionId },
    });
    await this.audit.record(tx, 'disputes.refund', dispute.reference, undefined);
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
