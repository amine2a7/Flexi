-- Credit note (avoir, request of 2026-11-05): an order cancelled after its invoice was issued
-- (awaiting payment) cancels the invoice with a credit note number. Nothing was paid: no ledger.
ALTER TYPE "InvoiceStatus" ADD VALUE 'CANCELLED';
ALTER TABLE "invoices"
  ADD COLUMN "credit_note_number" VARCHAR(32) UNIQUE,
  ADD COLUMN "cancelled_at" TIMESTAMPTZ(3);
CREATE SEQUENCE credit_note_number_seq START 100;
GRANT USAGE, SELECT ON SEQUENCE credit_note_number_seq TO flexipay_app;
