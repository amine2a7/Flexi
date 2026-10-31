-- N2 (ledger-auditor): a payment refunded after an accepted dispute is final, never settled.
ALTER TYPE "PaymentStatus" ADD VALUE IF NOT EXISTS 'REFUNDED';
