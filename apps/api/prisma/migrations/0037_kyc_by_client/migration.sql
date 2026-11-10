-- The client files its own KYC documents (processus v2, bug 2): page « Compte › Mon dossier ».
-- Each document has its status (submitted, validated, to correct with a reason); a new upload of a
-- type replaces the previous one (kept, marked replaced). The administrator asks a correction per
-- document, or validates the file once the four documents are there.
CREATE TYPE "KycDocumentStatus" AS ENUM ('SUBMITTED', 'VALIDATED', 'TO_CORRECT');
ALTER TABLE "kyc_documents"
  ADD COLUMN "status" "KycDocumentStatus" NOT NULL DEFAULT 'SUBMITTED',
  ADD COLUMN "correction_reason" VARCHAR(500),
  ADD COLUMN "replaced_at" TIMESTAMPTZ(3);
CREATE INDEX "kyc_documents_current_idx" ON "kyc_documents" ("file_id", "type") WHERE "replaced_at" IS NULL;
ALTER TYPE "KycAction" ADD VALUE 'DOCUMENT_UPLOADED';
ALTER TYPE "KycAction" ADD VALUE 'CORRECTION_REQUESTED';
