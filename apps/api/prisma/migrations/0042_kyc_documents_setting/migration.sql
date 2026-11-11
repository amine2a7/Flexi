-- Processus v2 (« Pièces KYC demandées : la liste est-elle complète ? »): the super-admin chooses
-- the documents a client files, among a catalogue; the four of the PDF stay the default.
ALTER TYPE "KycDocumentType" ADD VALUE 'COMPANY_STATUTES';
ALTER TYPE "KycDocumentType" ADD VALUE 'PROOF_OF_ADDRESS';
ALTER TABLE "platform_settings" ADD COLUMN "kyc_required_documents" "KycDocumentType"[] NOT NULL
  DEFAULT ARRAY['REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID', 'BANK_DETAILS']::"KycDocumentType"[];
