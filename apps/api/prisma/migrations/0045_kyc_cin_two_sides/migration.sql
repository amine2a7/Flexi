-- Corrections after the demo (2026-11-13): the CIN of the manager is filed in two pieces, front
-- and back (company and merchant). MANAGER_ID stays for the documents already filed.
ALTER TYPE "KycDocumentType" ADD VALUE 'MANAGER_ID_FRONT';
ALTER TYPE "KycDocumentType" ADD VALUE 'MANAGER_ID_BACK';
