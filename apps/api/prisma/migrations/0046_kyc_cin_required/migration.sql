-- Corrections after the demo (2026-11-13): « CIN recto » and « CIN verso » replace « CIN du gérant »
-- in the documents asked by default and in the settings (the other choices of the super-admin stay).
ALTER TABLE "platform_settings" ALTER COLUMN "kyc_required_documents" SET DEFAULT
  ARRAY['REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID_FRONT', 'MANAGER_ID_BACK', 'BANK_DETAILS']::"KycDocumentType"[];
UPDATE "platform_settings"
   SET "kyc_required_documents" = array_cat(
         array_remove("kyc_required_documents", 'MANAGER_ID'::"KycDocumentType"),
         ARRAY['MANAGER_ID_FRONT', 'MANAGER_ID_BACK']::"KycDocumentType"[])
 WHERE 'MANAGER_ID'::"KycDocumentType" = ANY ("kyc_required_documents");
