import { Injectable } from '@nestjs/common';
import { uuidv7 } from '../common/crypto.js';
import type { Tx } from '../common/db.service.js';
import type { CreditType, LedgerAccountKind, LedgerOwnerType } from '../generated/prisma/enums.js';

// The ONE write path to the money (spec 02 §6): double entry, append-only, integer millimes
// (BIGINT), accounts locked in a deterministic order, balances updated in the same transaction.

export interface AccountRef {
  readonly code: string;
  readonly kind: LedgerAccountKind;
  readonly ownerType: LedgerOwnerType;
  readonly ownerId: string | null;
  readonly creditType: CreditType | null;
  /** Wallets and payables can never go below zero. */
  readonly nonNegative: boolean;
}

const platform = (code: string, kind: LedgerAccountKind, nonNegative: boolean): AccountRef => ({
  code,
  kind,
  ownerType: 'PLATFORM',
  ownerId: null,
  creditType: null,
  nonNegative,
});

const wallet = (
  ownerType: LedgerOwnerType,
  prefix: string,
  ownerId: string,
  creditType: CreditType,
): AccountRef => ({
  code: `${prefix}:${ownerId}:${creditType}`,
  kind: 'LIABILITY',
  ownerType,
  ownerId,
  creditType,
  nonNegative: true,
});

/** Chart of accounts (spec 02 §2), wallets per owner AND per credit type (no transfer between types). */
export const accounts = {
  /** Client funds held in escrow (asset). */
  bankEscrow: () => platform('BANK_ESCROW', 'ASSET', false),
  /** Outgoing payments account (asset). Treasury moves from escrow are outside the ledger. */
  bankPayment: () => platform('BANK_PAYMENT', 'ASSET', false),
  /** Payouts requested by merchants, not yet executed. */
  payoutPayable: () => platform('PAYOUT_PAYABLE', 'LIABILITY', true),
  companyFees: () => platform('REVENUE_COMPANY_FEES', 'REVENUE', true),
  merchantCommission: () => platform('REVENUE_MERCHANT_COMMISSION', 'REVENUE', true),
  /** VAT collected on the commissions, owed to the State (decision of 2026-11-03). */
  vatCollected: () => platform('VAT_COLLECTED', 'LIABILITY', true),
  /** Stamp duty collected on orders and payouts, owed to the State (decision of 2026-11-03). */
  stampDuty: () => platform('STAMP_DUTY', 'LIABILITY', true),
  /** Withholding tax on the commission, owed to the State (processus v2, decision of 2026-11-10). */
  withholdingTax: () => platform('WITHHOLDING_TAX', 'LIABILITY', true),
  /** Transfer fee of each order and each merchant payout (processus v2). */
  transferFees: () => platform('REVENUE_TRANSFER_FEES', 'REVENUE', true),
  expiredCredits: () => platform('REVENUE_EXPIRED', 'REVENUE', true),
  companyWallet: (companyId: string, type: CreditType) =>
    wallet('COMPANY', 'COMPANY_WALLET', companyId, type),
  employeeWallet: (employeeId: string, type: CreditType) =>
    wallet('EMPLOYEE', 'EMPLOYEE_WALLET', employeeId, type),
  merchantWallet: (merchantId: string, type: CreditType) =>
    wallet('MERCHANT', 'MERCHANT_WALLET', merchantId, type),
  /** Amount of a disputed payment, held out of the merchant wallet (N2): never settled. */
  /** What a merchant owes FlexiPay (accepted dispute on a paid payment), deducted from the next
   *  settlement (decision of 2026-10-31). Asset, never negative. */
  merchantDebt: (merchantId: string): AccountRef => ({
    code: `MERCHANT_DEBT:${merchantId}`,
    kind: 'ASSET',
    ownerType: 'MERCHANT',
    ownerId: merchantId,
    creditType: null,
    nonNegative: true,
  }),
  disputeHold: (merchantId: string, type: CreditType) =>
    wallet('MERCHANT', 'DISPUTE_HOLD', merchantId, type),
} as const;

export interface EntryInput {
  readonly account: AccountRef;
  readonly direction: 'D' | 'C';
  readonly amount: bigint;
  readonly lotId?: string;
}

export interface PostInput {
  readonly type: string;
  readonly reference: string;
  readonly entries: readonly EntryInput[];
  readonly tenantId?: string | null;
  readonly userId?: string | null;
  readonly idempotencyKey?: string | null;
  readonly reversesId?: string | null;
}

export interface Posted {
  readonly transactionId: string;
  /** Balance of each account touched, after the transaction, by account code. */
  readonly balances: ReadonlyMap<string, bigint>;
}

/** A wallet (or payable) would go below zero. Nothing has been written. */
export class InsufficientFundsError extends Error {
  constructor(
    readonly accountCode: string,
    readonly missing: bigint,
  ) {
    super('insufficient funds');
  }
}

export interface Lot {
  readonly id: string;
  readonly creditType: CreditType;
  readonly initial: bigint;
  readonly remaining: bigint;
  readonly expiresAt: Date;
}

/** Signed effect of an entry on the balance of an account of `kind`. */
function effect(kind: LedgerAccountKind, direction: 'D' | 'C', amount: bigint): bigint {
  const increases = kind === 'ASSET' ? direction === 'D' : direction === 'C';
  return increases ? amount : -amount;
}

@Injectable()
export class LedgerService {
  /** Creates the account (and its balance row) if needed; returns its id. */
  private async ensureAccount(tx: Tx, account: AccountRef): Promise<string> {
    const id = uuidv7();
    await tx.$executeRaw`INSERT INTO ledger_accounts (id, code, kind, owner_type, owner_id, credit_type, non_negative)
      VALUES (${id}::uuid, ${account.code}, ${account.kind}::"LedgerAccountKind", ${account.ownerType}::"LedgerOwnerType",
              ${account.ownerId}::uuid, ${account.creditType}::"CreditType", ${account.nonNegative})
      ON CONFLICT (code) DO NOTHING`;
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ledger_accounts WHERE code = ${account.code}`;
    const accountId = rows[0]?.id;
    if (accountId === undefined) throw new Error('ledger account not created');
    await tx.$executeRaw`INSERT INTO account_balances (account_id, balance_millimes, non_negative)
      VALUES (${accountId}::uuid, 0, ${account.nonNegative}) ON CONFLICT (account_id) DO NOTHING`;
    return accountId;
  }

  /**
   * Posts one balanced transaction. Locks the balances of every account touched in a fixed order
   * (by id: no deadlock), checks the non-negative accounts, inserts the entries with the balance
   * after each one, and updates the balances. Debits = credits is checked here and again by the
   * database at COMMIT.
   */
  async post(tx: Tx, input: PostInput): Promise<Posted> {
    if (input.entries.length < 2)
      throw new Error('a ledger transaction needs two entries at least');
    let debits = 0n;
    let credits = 0n;
    for (const entry of input.entries) {
      if (typeof entry.amount !== 'bigint' || entry.amount <= 0n)
        throw new Error('entry amounts are positive millimes');
      if (entry.direction === 'D') debits += entry.amount;
      else credits += entry.amount;
    }
    if (debits !== credits)
      throw new Error('a ledger transaction must be balanced (debits = credits)');

    const ids = new Map<string, string>();
    for (const entry of input.entries) {
      if (!ids.has(entry.account.code))
        ids.set(entry.account.code, await this.ensureAccount(tx, entry.account));
    }
    const ordered = [...ids.values()].sort();
    const locked = await tx.$queryRaw<{ account_id: string; balance_millimes: bigint }[]>`
      SELECT account_id, balance_millimes FROM account_balances
       WHERE account_id = ANY(${ordered}::uuid[]) ORDER BY account_id FOR UPDATE`;
    const balances = new Map(locked.map((row) => [row.account_id, row.balance_millimes]));

    // Final balances first: refuse before writing anything.
    const finals = new Map(balances);
    for (const entry of input.entries) {
      const id = ids.get(entry.account.code) ?? '';
      finals.set(
        id,
        (finals.get(id) ?? 0n) + effect(entry.account.kind, entry.direction, entry.amount),
      );
    }
    for (const entry of input.entries) {
      const id = ids.get(entry.account.code) ?? '';
      const final = finals.get(id) ?? 0n;
      if (entry.account.nonNegative && final < 0n)
        throw new InsufficientFundsError(entry.account.code, -final);
    }

    const transactionId = uuidv7();
    await tx.$executeRaw`INSERT INTO ledger_transactions (id, type, tenant_id, user_id, idempotency_key, reference, reverses_id)
      VALUES (${transactionId}::uuid, ${input.type}, ${input.tenantId ?? null}::uuid, ${input.userId ?? null}::uuid,
              ${input.idempotencyKey ?? null}::uuid, ${input.reference}, ${input.reversesId ?? null}::uuid)`;
    for (const entry of input.entries) {
      const id = ids.get(entry.account.code) ?? '';
      const after =
        (balances.get(id) ?? 0n) + effect(entry.account.kind, entry.direction, entry.amount);
      balances.set(id, after);
      await tx.$executeRaw`INSERT INTO ledger_entries (transaction_id, account_id, direction, amount_millimes, balance_after_millimes, lot_id)
        VALUES (${transactionId}::uuid, ${id}::uuid, ${entry.direction}::"EntryDirection", ${entry.amount}, ${after}, ${entry.lotId ?? null}::uuid)`;
    }
    for (const [id, value] of balances) {
      await tx.$executeRaw`UPDATE account_balances SET balance_millimes = ${value}, updated_at = now() WHERE account_id = ${id}::uuid`;
    }
    const byCode = new Map<string, bigint>();
    for (const [code, id] of ids) byCode.set(code, balances.get(id) ?? 0n);
    return { transactionId, balances: byCode };
  }

  /**
   * Locks the balance of an account for the rest of the SQL transaction (creates it if needed).
   * Checks made under this lock (daily limit, payout available) cannot race with another payment.
   */
  async lockAccount(tx: Tx, account: AccountRef): Promise<void> {
    await this.lockAccounts(tx, [account]);
  }

  /**
   * Locks every account of an operation at once, in the fixed order of post() (by id), before
   * any check: two operations on the same accounts never wait for each other in a cycle
   * (ledger-auditor C5).
   */
  async lockAccounts(tx: Tx, refs: readonly AccountRef[]): Promise<void> {
    const ids: string[] = [];
    for (const ref of refs) ids.push(await this.ensureAccount(tx, ref));
    const ordered = [...new Set(ids)].sort();
    await tx.$queryRaw`SELECT account_id FROM account_balances
       WHERE account_id = ANY(${ordered}::uuid[]) ORDER BY account_id FOR UPDATE`;
  }

  /** Correction: a new transaction with the opposite entries, pointing to the original. */
  async reverse(tx: Tx, transactionId: string, reference: string): Promise<Posted> {
    // Entries that moved credit lots cannot be reversed blindly: the lots would no longer match
    // the wallet (ledger-auditor C9). No flow needs it today (only payout requests are reversed).
    const withLots = await tx.$queryRaw<{ count: bigint }[]>`
      SELECT count(*)::bigint AS count FROM ledger_entries
       WHERE transaction_id = ${transactionId}::uuid AND lot_id IS NOT NULL`;
    if ((withLots[0]?.count ?? 0n) > 0n)
      throw new Error('cannot reverse a transaction that moved credit lots');
    const rows = await tx.$queryRaw<
      {
        code: string;
        kind: LedgerAccountKind;
        owner_type: LedgerOwnerType;
        owner_id: string | null;
        credit_type: CreditType | null;
        non_negative: boolean;
        direction: 'D' | 'C';
        amount_millimes: bigint;
        type: string;
      }[]
    >`SELECT a.code, a.kind, a.owner_type, a.owner_id, a.credit_type, a.non_negative, e.direction,
             e.amount_millimes, t.type
        FROM ledger_entries e
        JOIN ledger_accounts a ON a.id = e.account_id
        JOIN ledger_transactions t ON t.id = e.transaction_id
       WHERE e.transaction_id = ${transactionId}::uuid
       ORDER BY e.id`;
    if (rows.length === 0) throw new Error('unknown ledger transaction');
    return this.post(tx, {
      type: `REVERSAL_${rows[0]?.type ?? ''}`.slice(0, 40),
      reference,
      reversesId: transactionId,
      entries: rows.map((row) => ({
        account: {
          code: row.code,
          kind: row.kind,
          ownerType: row.owner_type,
          ownerId: row.owner_id,
          creditType: row.credit_type,
          nonNegative: row.non_negative,
        },
        direction: row.direction === 'D' ? 'C' : 'D',
        amount: row.amount_millimes,
      })),
    });
  }

  async balance(tx: Tx, account: AccountRef): Promise<bigint> {
    const rows = await tx.$queryRaw<{ balance_millimes: bigint }[]>`SELECT b.balance_millimes
      FROM account_balances b JOIN ledger_accounts a ON a.id = b.account_id WHERE a.code = ${account.code}`;
    return rows[0] === undefined ? 0n : rows[0].balance_millimes;
  }

  /** Balances of several accounts at once (missing accounts are 0). */
  async balances(tx: Tx, refs: readonly AccountRef[]): Promise<Map<string, bigint>> {
    const codes = refs.map((ref) => ref.code);
    const rows = await tx.$queryRaw<
      { code: string; balance_millimes: bigint }[]
    >`SELECT a.code, b.balance_millimes
      FROM account_balances b JOIN ledger_accounts a ON a.id = b.account_id WHERE a.code = ANY(${codes}::text[])`;
    const found = new Map(rows.map((row) => [row.code, row.balance_millimes]));
    return new Map(codes.map((code) => [code, found.get(code) ?? 0n]));
  }

  // ---------------------------------------------------------------- credit lots (FEFO)

  async addLot(
    tx: Tx,
    lot: {
      account: AccountRef;
      creditType: CreditType;
      amount: bigint;
      expiresAt: Date;
      sourceTransactionId: string;
    },
  ): Promise<string> {
    const accountId = await this.ensureAccount(tx, lot.account);
    const id = uuidv7();
    await tx.$executeRaw`INSERT INTO credit_lots (id, account_id, credit_type, initial_millimes, remaining_millimes, expires_at, source_transaction_id)
      VALUES (${id}::uuid, ${accountId}::uuid, ${lot.creditType}::"CreditType", ${lot.amount}, ${lot.amount}, ${lot.expiresAt}, ${lot.sourceTransactionId}::uuid)`;
    return id;
  }

  /** Lots of a wallet, first to expire first. */
  async lots(tx: Tx, account: AccountRef): Promise<Lot[]> {
    const rows = await tx.$queryRaw<
      {
        id: string;
        credit_type: CreditType;
        initial_millimes: bigint;
        remaining_millimes: bigint;
        expires_at: Date;
      }[]
    >`SELECT l.id, l.credit_type, l.initial_millimes, l.remaining_millimes, l.expires_at
        FROM credit_lots l JOIN ledger_accounts a ON a.id = l.account_id
       WHERE a.code = ${account.code} ORDER BY l.expires_at, l.id`;
    return rows.map((row) => ({
      id: row.id,
      creditType: row.credit_type,
      initial: row.initial_millimes,
      remaining: row.remaining_millimes,
      expiresAt: row.expires_at,
    }));
  }

  /**
   * Takes `amount` from the non-expired lots of a wallet, first to expire first (FEFO), under lock.
   * Must be called in the same SQL transaction as the posting that debits the wallet (one debit
   * entry per lot). Throws InsufficientFundsError when the usable lots do not cover the amount.
   */
  async consumeFefo(
    tx: Tx,
    account: AccountRef,
    amount: bigint,
    now: Date,
  ): Promise<{ lotId: string; amount: bigint }[]> {
    // Lock the wallet balance first (same order as post), then its lots.
    const accountId = await this.ensureAccount(tx, account);
    await tx.$queryRaw`SELECT account_id FROM account_balances WHERE account_id = ${accountId}::uuid FOR UPDATE`;
    const lots = await tx.$queryRaw<{ id: string; remaining_millimes: bigint }[]>`
      SELECT id, remaining_millimes FROM credit_lots
       WHERE account_id = ${accountId}::uuid AND remaining_millimes > 0 AND expires_at > ${now}
       ORDER BY expires_at, id FOR UPDATE`;
    const parts: { lotId: string; amount: bigint }[] = [];
    let left = amount;
    for (const lot of lots) {
      if (left === 0n) break;
      const take = lot.remaining_millimes < left ? lot.remaining_millimes : left;
      parts.push({ lotId: lot.id, amount: take });
      left -= take;
    }
    if (left > 0n) throw new InsufficientFundsError(account.code, left);
    for (const part of parts) {
      await tx.$executeRaw`UPDATE credit_lots SET remaining_millimes = remaining_millimes - ${part.amount} WHERE id = ${part.lotId}::uuid`;
    }
    return parts;
  }

  /** Sum of the non-expired remainders of a wallet (what can actually be spent). */
  async usable(tx: Tx, account: AccountRef, now: Date): Promise<bigint> {
    const rows = await tx.$queryRaw<
      { total: bigint | null }[]
    >`SELECT sum(l.remaining_millimes)::bigint AS total
      FROM credit_lots l JOIN ledger_accounts a ON a.id = l.account_id
     WHERE a.code = ${account.code} AND l.expires_at > ${now}`;
    return rows[0]?.total ?? 0n;
  }

  // ---------------------------------------------------------------- reconciliation

  /**
   * Daily reconciliation (spec 02 §5): every materialized balance equals the sum of its entries,
   * and the books are balanced (total debits = total credits). Lists the accounts in error.
   */
  async reconcile(tx: Tx): Promise<{
    ok: boolean;
    mismatches: string[];
    lotMismatches: string[];
    holdMismatches: string[];
    taxMismatches: string[];
    totalDebits: bigint;
    totalCredits: bigint;
  }> {
    const mismatches = await tx.$queryRaw<{ code: string }[]>`
      SELECT a.code FROM ledger_accounts a
        JOIN account_balances b ON b.account_id = a.id
        LEFT JOIN LATERAL (
          SELECT coalesce(sum(CASE
                   WHEN (a.kind = 'ASSET') = (e.direction = 'D') THEN e.amount_millimes
                   ELSE -e.amount_millimes END), 0)::bigint AS computed
            FROM ledger_entries e WHERE e.account_id = a.id
        ) s ON true
       WHERE s.computed <> b.balance_millimes
       ORDER BY a.code`;
    const totals = await tx.$queryRaw<{ d: bigint | null; c: bigint | null }[]>`
      SELECT (sum(amount_millimes) FILTER (WHERE direction = 'D'))::bigint AS d,
             (sum(amount_millimes) FILTER (WHERE direction = 'C'))::bigint AS c FROM ledger_entries`;
    const totalDebits = totals[0]?.d ?? 0n;
    const totalCredits = totals[0]?.c ?? 0n;
    // Employee wallets: the remainders of their lots add up to the balance (FEFO consistency, C8).
    const lotMismatches = await tx.$queryRaw<{ code: string }[]>`
      SELECT a.code FROM ledger_accounts a
        JOIN account_balances b ON b.account_id = a.id
        LEFT JOIN LATERAL (
          SELECT coalesce(sum(l.remaining_millimes), 0)::bigint AS lots
            FROM credit_lots l WHERE l.account_id = a.id
        ) s ON true
       WHERE a.owner_type = 'EMPLOYEE' AND s.lots <> b.balance_millimes
       ORDER BY a.code`;
    // Dispute holds: each one equals the amounts of the disputes in progress that hold it.
    const holdMismatches = await tx.$queryRaw<{ code: string }[]>`
      SELECT a.code FROM ledger_accounts a
        JOIN account_balances b ON b.account_id = a.id
        LEFT JOIN LATERAL (
          SELECT coalesce(sum(d.amount_millimes), 0)::bigint AS held
            FROM disputes d JOIN payments p ON p.id = d.payment_id
           WHERE d.hold_transaction_id IS NOT NULL
             AND d.status IN ('OPEN', 'ACCEPTANCE_PENDING')
             AND d.merchant_id = a.owner_id AND p.credit_type = a.credit_type
        ) s ON true
       WHERE a.code LIKE 'DISPUTE_HOLD:%' AND s.held <> b.balance_millimes
       ORDER BY a.code`;
    // VAT and stamp duty owed to the State equal what the documents carry (decision of
    // 2026-11-03): validated orders, payouts not rejected, minus the VAT of cancelled commissions.
    const [documents] = await tx.$queryRaw<{ vat: bigint; stamp: bigint }[]>`
      SELECT
        ((SELECT coalesce(sum(vat_millimes), 0) FROM credit_orders WHERE status = 'VALIDATED')
          + (SELECT coalesce(sum(vat_millimes), 0) FROM payout_requests WHERE status <> 'REJECTED')
          - (SELECT coalesce(sum(vat_reversed_millimes), 0) FROM disputes WHERE status = 'ACCEPTED')
        )::bigint AS vat,
        ((SELECT coalesce(sum(stamp_duty_millimes), 0) FROM credit_orders WHERE status = 'VALIDATED')
          + (SELECT coalesce(sum(stamp_duty_millimes), 0) FROM payout_requests WHERE status <> 'REJECTED')
        )::bigint AS stamp`;
    const taxMismatches: string[] = [];
    if ((await this.balance(tx, accounts.vatCollected())) !== (documents?.vat ?? 0n))
      taxMismatches.push(accounts.vatCollected().code);
    if ((await this.balance(tx, accounts.stampDuty())) !== (documents?.stamp ?? 0n))
      taxMismatches.push(accounts.stampDuty().code);
    return {
      ok:
        mismatches.length === 0 &&
        lotMismatches.length === 0 &&
        holdMismatches.length === 0 &&
        taxMismatches.length === 0 &&
        totalDebits === totalCredits,
      mismatches: mismatches.map((row) => row.code),
      lotMismatches: lotMismatches.map((row) => row.code),
      holdMismatches: holdMismatches.map((row) => row.code),
      taxMismatches,
      totalDebits,
      totalCredits,
    };
  }
}
