-- Four eyes (securite QY-01): every new KYC file names its author, an existing administrator.
-- NOT VALID: files opened before 0012 keep a null author; the API refuses to decide them
-- (fail closed) until a second administrator re-opens them.
ALTER TABLE kyc_files ADD CONSTRAINT kyc_files_created_by_required
  CHECK (created_by IS NOT NULL) NOT VALID;
ALTER TABLE kyc_files ADD CONSTRAINT kyc_files_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users (id) NOT VALID;
