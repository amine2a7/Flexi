-- Human references (orders, invoices, payments, payouts, batches, contact messages): one sequence
-- each, so that concurrent requests never compute the same number.
CREATE SEQUENCE order_reference_seq START 7300;
CREATE SEQUENCE invoice_number_seq START 5400;
CREATE SEQUENCE payment_reference_seq START 9000;
CREATE SEQUENCE payout_reference_seq START 4100;
CREATE SEQUENCE batch_reference_seq START 300;
CREATE SEQUENCE contact_reference_seq START 1041;
GRANT USAGE, SELECT ON SEQUENCE order_reference_seq, invoice_number_seq, payment_reference_seq,
  payout_reference_seq, batch_reference_seq, contact_reference_seq TO flexipay_app;
