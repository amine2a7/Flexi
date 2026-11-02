-- N2 v3 (decision of 2026-11-02): commission of a paid payment cancelled with its refund.
ALTER TABLE disputes
  ADD COLUMN commission_reversed_millimes BIGINT NOT NULL DEFAULT 0
    CONSTRAINT disputes_commission_reversed_check CHECK (commission_reversed_millimes >= 0);

-- ledger-auditor B2: the held payout exists, the deduction never exceeds the net.
ALTER TABLE disputes
  ADD CONSTRAINT disputes_held_payout_id_fkey
    FOREIGN KEY (held_payout_id) REFERENCES payout_requests(id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE payout_requests
  ADD CONSTRAINT payout_requests_deducted_check
    CHECK (deducted_millimes >= 0 AND deducted_millimes <= net_millimes);

-- securite S-N2-05: the fraud job reads the recent payments by status.
CREATE INDEX payments_status_created_idx ON payments (status, created_at);
