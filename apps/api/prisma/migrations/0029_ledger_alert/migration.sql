-- R2 (ledger-auditor, decision of 2026-11-03): the daily reconciliation raises an alert in the
-- Security screen when a balance differs from the sum of its entries; never a correction.
ALTER TYPE "FraudAlertKind" ADD VALUE 'LEDGER_MISMATCH';
