import { Injectable } from '@nestjs/common';
import { uuidv7 } from '../common/crypto.js';

/** One transfer of a settlement batch, as the bank receives it (IBAN in clear, memory only). */
export interface BankOrderLine {
  readonly payoutId: string;
  readonly reference: string;
  readonly iban: string;
  readonly amountMillimes: bigint;
}

/** What the bank says of one transfer after the order (paid, or rejected with its reason). */
export interface BankReturnLine {
  readonly payoutId: string;
  readonly paid: boolean;
  readonly reason?: string;
}

/**
 * Bank of the settlements (task 9 of 2026-11-03): an order per batch, then the return of the bank
 * for each transfer. Only a SIMULATED bank for now; a real one replaces it behind this interface.
 */
export interface BankAdapter {
  send(batchReference: string, lines: readonly BankOrderLine[]): Promise<{ bankReference: string }>;
  returnOf(bankReference: string, lines: readonly BankOrderLine[]): Promise<BankReturnLine[]>;
}

export const BANK_ADAPTER = Symbol('BANK_ADAPTER');

/**
 * Simulated bank: accepts every order and pays every transfer, except the test accounts whose
 * IBAN ends with 0000 (rejected « Compte clôturé ») so that the rejection path can be shown.
 * Never logs an IBAN.
 */
@Injectable()
export class SimulatedBankAdapter implements BankAdapter {
  send(batchReference: string): Promise<{ bankReference: string }> {
    return Promise.resolve({
      bankReference: `SIM-${batchReference.slice(4)}-${uuidv7().slice(-6).toUpperCase()}`,
    });
  }

  returnOf(_bankReference: string, lines: readonly BankOrderLine[]): Promise<BankReturnLine[]> {
    return Promise.resolve(
      lines.map((line) =>
        line.iban.endsWith('0000')
          ? { payoutId: line.payoutId, paid: false, reason: 'Compte clôturé' }
          : { payoutId: line.payoutId, paid: true },
      ),
    );
  }
}
