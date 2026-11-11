-- Processus v2 (« Fiche client complète »): changing the legal form of a company or a merchant is
-- a four-eyes request; once approved it applies to the next operations only (quotes, orders and
-- payouts already frozen keep their rates).
ALTER TYPE "ApprovalType" ADD VALUE 'LEGAL_FORM_CHANGE';
