-- What the merchant may see of its customer (first name, initial, masked number), copied on the
-- payment: the merchant never reads the employees table (minimisation, RLS).
ALTER TABLE payments ADD COLUMN customer_first_name VARCHAR(60) NOT NULL DEFAULT '';
ALTER TABLE payments ADD COLUMN customer_last_initial VARCHAR(1) NOT NULL DEFAULT '';
ALTER TABLE payments ADD COLUMN customer_masked_number VARCHAR(20) NOT NULL DEFAULT '';
CREATE INDEX payments_employee_status_idx ON payments (employee_id, status, expires_at);
