-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'COMPANY', 'MERCHANT', 'EMPLOYEE', 'FAMILY_MEMBER');

-- CreateEnum
CREATE TYPE "SubRole" AS ENUM ('SUPER_ADMIN', 'FINANCE', 'SUPPORT', 'COMPLIANCE', 'OWNER', 'MANAGER', 'ACCOUNTANT', 'READ_ONLY', 'CASHIER');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "SessionStep" AS ENUM ('NONE', 'PASSWORD_CHANGE', 'MFA_ENROLL');

-- CreateEnum
CREATE TYPE "CreditType" AS ENUM ('RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX');

-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('PENDING_KYC', 'APPROVED', 'REJECTED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "MerchantCategory" AS ENUM ('RESTAURANT', 'CAFE', 'GROCERY', 'BAKERY', 'FAST_FOOD', 'CLOTHING', 'FUEL_STATION', 'GIFT_SHOP');

-- CreateEnum
CREATE TYPE "EmployeeStatus" AS ENUM ('INVITED', 'ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('AWAITING_CONFIRMATION', 'AWAITING_PAYMENT', 'AWAITING_VALIDATION', 'VALIDATED', 'REFUSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "OrderEventAction" AS ENUM ('CREATED', 'CONFIRMED', 'REFUSED', 'CANCELLED', 'TRANSFER_DECLARED', 'PROOF_REJECTED', 'FIRST_VALIDATION', 'VALIDATED');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('PAID', 'UNPAID');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('INITIATED', 'CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED');

-- CreateEnum
CREATE TYPE "PaymentChannel" AS ENUM ('CUSTOMER_CODE', 'MERCHANT_CODE');

-- CreateEnum
CREATE TYPE "PayoutStatus" AS ENUM ('REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED');

-- CreateEnum
CREATE TYPE "SettlementStatus" AS ENUM ('SCHEDULED', 'PAID');

-- CreateEnum
CREATE TYPE "KycStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "KycAccountType" AS ENUM ('MERCHANT', 'COMPANY');

-- CreateEnum
CREATE TYPE "KycDocumentType" AS ENUM ('REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID', 'BANK_DETAILS');

-- CreateEnum
CREATE TYPE "KycAction" AS ENUM ('SUBMITTED', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "ApprovalType" AS ENUM ('COMMISSION_RATE_CHANGE', 'SETTINGS_CHANGE');

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "MerchantDocumentType" AS ENUM ('COMMISSION_INVOICE', 'STATEMENT', 'CERTIFICATE');

-- CreateEnum
CREATE TYPE "ContactRequesterType" AS ENUM ('COMPANY', 'MERCHANT', 'OTHER');

-- CreateEnum
CREATE TYPE "ContactMessageStatus" AS ENUM ('NEW', 'HANDLED');

-- CreateEnum
CREATE TYPE "IdempotencyState" AS ENUM ('IN_PROGRESS', 'DONE');

-- CreateEnum
CREATE TYPE "LedgerAccountKind" AS ENUM ('ASSET', 'LIABILITY', 'REVENUE');

-- CreateEnum
CREATE TYPE "LedgerOwnerType" AS ENUM ('PLATFORM', 'COMPANY', 'EMPLOYEE', 'MERCHANT');

-- CreateEnum
CREATE TYPE "EntryDirection" AS ENUM ('D', 'C');

-- CreateTable
CREATE TABLE "companies" (
    "id" UUID NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "city" VARCHAR(80) NOT NULL,
    "phone" VARCHAR(16) NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'PENDING_KYC',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commission_profiles" (
    "id" UUID NOT NULL,
    "name" VARCHAR(80) NOT NULL,
    "rate_bps" INTEGER NOT NULL,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "commission_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "merchants" (
    "id" UUID NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "category" "MerchantCategory" NOT NULL,
    "city" VARCHAR(80) NOT NULL,
    "address" VARCHAR(200) NOT NULL DEFAULT '',
    "phone" VARCHAR(16) NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'PENDING_KYC',
    "accepted_credit_types" "CreditType"[],
    "payment_code" CHAR(6) NOT NULL,
    "iban" CHAR(24) NOT NULL,
    "commission_profile_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "merchants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "points_of_sale" (
    "id" UUID NOT NULL,
    "merchant_id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "city" VARCHAR(80) NOT NULL,

    CONSTRAINT "points_of_sale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees" (
    "id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "employee_number" VARCHAR(20) NOT NULL,
    "first_name" VARCHAR(60) NOT NULL,
    "last_name" VARCHAR(60) NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "phone" VARCHAR(16) NOT NULL,
    "status" "EmployeeStatus" NOT NULL DEFAULT 'INVITED',
    "pin_hash" TEXT,
    "pin_failures" INTEGER NOT NULL DEFAULT 0,
    "pin_locked_until" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "role" "Role" NOT NULL,
    "sub_role" "SubRole",
    "display_name" VARCHAR(120) NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "phone" VARCHAR(16),
    "password_hash" TEXT NOT NULL,
    "must_change_password" BOOLEAN NOT NULL DEFAULT false,
    "temp_password_expires_at" TIMESTAMPTZ(3),
    "mfa_secret_enc" TEXT,
    "mfa_pending_secret_enc" TEXT,
    "mfa_pending_expires_at" TIMESTAMPTZ(3),
    "mfa_last_step" BIGINT,
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "failed_logins" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMPTZ(3),
    "onboarding_tour_done" BOOLEAN NOT NULL DEFAULT false,
    "company_id" UUID,
    "merchant_id" UUID,
    "employee_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recovery_codes" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "code_hash" TEXT NOT NULL,
    "used_at" TIMESTAMPTZ(3),

    CONSTRAINT "recovery_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL,
    "family_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "step" "SessionStep" NOT NULL,
    "access_token_hash" TEXT NOT NULL,
    "refresh_token_hash" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "absolute_expires_at" TIMESTAMPTZ(3) NOT NULL,
    "restricted_until" TIMESTAMPTZ(3),
    "rotated_at" TIMESTAMPTZ(3),
    "revoked_at" TIMESTAMPTZ(3),

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mfa_challenges" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "consumed_at" TIMESTAMPTZ(3),

    CONSTRAINT "mfa_challenges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "used_at" TIMESTAMPTZ(3),

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "login_failures" (
    "user_id" UUID NOT NULL,
    "ip" VARCHAR(64) NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 0,
    "blocked_until" TIMESTAMPTZ(3),
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "login_failures_pkey" PRIMARY KEY ("user_id","ip")
);

-- CreateTable
CREATE TABLE "platform_settings" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "payout_minimum_millimes" BIGINT NOT NULL,
    "credit_validity_months" INTEGER NOT NULL,
    "max_family_members" INTEGER NOT NULL,
    "order_fee_rate_bps" INTEGER NOT NULL,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "platform_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credit_type_settings" (
    "credit_type" "CreditType" NOT NULL,
    "enabled" BOOLEAN NOT NULL,
    "commission_rate_bps" INTEGER NOT NULL,
    "validity_months" INTEGER NOT NULL,
    "daily_limit_millimes" BIGINT NOT NULL,

    CONSTRAINT "credit_type_settings_pkey" PRIMARY KEY ("credit_type")
);

-- CreateTable
CREATE TABLE "approvals" (
    "id" UUID NOT NULL,
    "type" "ApprovalType" NOT NULL,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
    "subject" VARCHAR(200) NOT NULL,
    "payload" JSONB NOT NULL,
    "old_rate_bps" INTEGER,
    "new_rate_bps" INTEGER,
    "reason" VARCHAR(500) NOT NULL,
    "initiator_id" UUID NOT NULL,
    "initiator_name" VARCHAR(120) NOT NULL,
    "decider_id" UUID,
    "decided_at" TIMESTAMPTZ(3),
    "reject_reason" VARCHAR(500),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "approvals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" UUID NOT NULL,
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actor_user_id" UUID,
    "actor_name" VARCHAR(120) NOT NULL,
    "action" VARCHAR(64) NOT NULL,
    "target" VARCHAR(200) NOT NULL,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credit_orders" (
    "id" UUID NOT NULL,
    "reference" VARCHAR(32) NOT NULL,
    "company_id" UUID NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'AWAITING_CONFIRMATION',
    "amount_millimes" BIGINT NOT NULL,
    "fee_rate_bps" INTEGER NOT NULL,
    "fees_millimes" BIGINT NOT NULL,
    "total_millimes" BIGINT NOT NULL,
    "payment_reference" VARCHAR(32) NOT NULL,
    "declared_amount_millimes" BIGINT,
    "transfer_reference" VARCHAR(64),
    "transfer_date" DATE,
    "declared_at" TIMESTAMPTZ(3),
    "proof_storage_key" TEXT,
    "proof_file_name" VARCHAR(255),
    "proof_content_type" VARCHAR(40),
    "proof_size_bytes" INTEGER,
    "refusal_reason" VARCHAR(500),
    "proof_rejection_reason" VARCHAR(500),
    "first_validator_id" UUID,
    "first_validator_name" VARCHAR(120),
    "first_validated_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credit_order_lines" (
    "order_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "amount_millimes" BIGINT NOT NULL,

    CONSTRAINT "credit_order_lines_pkey" PRIMARY KEY ("order_id","credit_type")
);

-- CreateTable
CREATE TABLE "credit_order_events" (
    "id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "action" "OrderEventAction" NOT NULL,
    "actor_id" UUID,
    "actor_name" VARCHAR(120) NOT NULL,
    "actor_role" "Role" NOT NULL,
    "reason" VARCHAR(500),
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_order_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL,
    "number" VARCHAR(32) NOT NULL,
    "company_id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "total_millimes" BIGINT NOT NULL,
    "status" "InvoiceStatus" NOT NULL,
    "issued_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "allocations" (
    "id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "amount_millimes" BIGINT NOT NULL,
    "transaction_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_codes" (
    "id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "code" CHAR(8) NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "consumed_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "reference" VARCHAR(32) NOT NULL,
    "merchant_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "amount_millimes" BIGINT NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "channel" "PaymentChannel" NOT NULL,
    "expires_at" TIMESTAMPTZ(3),
    "commission_rate_bps" INTEGER,
    "confirmed_at" TIMESTAMPTZ(3),
    "settlement_date" DATE,
    "transaction_id" UUID,
    "payout_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_events" (
    "id" UUID NOT NULL,
    "payment_id" UUID NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credit_expiries" (
    "id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "amount_millimes" BIGINT NOT NULL,
    "transaction_id" UUID NOT NULL,
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_expiries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payout_quotes" (
    "id" UUID NOT NULL,
    "merchant_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "gross_millimes" BIGINT NOT NULL,
    "commission_rate_bps" INTEGER NOT NULL,
    "commission_millimes" BIGINT NOT NULL,
    "net_millimes" BIGINT NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "used_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payout_quotes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payout_requests" (
    "id" UUID NOT NULL,
    "reference" VARCHAR(32) NOT NULL,
    "merchant_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "status" "PayoutStatus" NOT NULL DEFAULT 'REQUESTED',
    "gross_millimes" BIGINT NOT NULL,
    "commission_rate_bps" INTEGER NOT NULL,
    "commission_millimes" BIGINT NOT NULL,
    "net_millimes" BIGINT NOT NULL,
    "iban" CHAR(24) NOT NULL,
    "batch_id" UUID,
    "transaction_id" UUID,
    "requested_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payout_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payout_events" (
    "id" UUID NOT NULL,
    "payout_id" UUID NOT NULL,
    "status" "PayoutStatus" NOT NULL,
    "reason" VARCHAR(500),
    "actor_id" UUID,
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payout_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settlement_batches" (
    "id" UUID NOT NULL,
    "reference" VARCHAR(32) NOT NULL,
    "settlement_date" DATE NOT NULL,
    "status" "SettlementStatus" NOT NULL DEFAULT 'SCHEDULED',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "settlement_batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "merchant_documents" (
    "id" UUID NOT NULL,
    "merchant_id" UUID NOT NULL,
    "type" "MerchantDocumentType" NOT NULL,
    "period" CHAR(7) NOT NULL,
    "issued_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "merchant_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_files" (
    "id" UUID NOT NULL,
    "account_type" "KycAccountType" NOT NULL,
    "company_id" UUID,
    "merchant_id" UUID,
    "status" "KycStatus" NOT NULL DEFAULT 'PENDING',
    "rejection_reason" VARCHAR(500),
    "submitted_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_files_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_documents" (
    "id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "type" "KycDocumentType" NOT NULL,
    "file_name" VARCHAR(255) NOT NULL,
    "content_type" VARCHAR(40) NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "storage_key" TEXT NOT NULL,
    "uploaded_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_events" (
    "id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "action" "KycAction" NOT NULL,
    "actor_name" VARCHAR(120) NOT NULL,
    "reason" VARCHAR(500),
    "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact_messages" (
    "id" UUID NOT NULL,
    "reference" VARCHAR(32) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "phone" VARCHAR(16),
    "company_name" VARCHAR(200),
    "requester_type" "ContactRequesterType" NOT NULL,
    "message" VARCHAR(2000) NOT NULL,
    "status" "ContactMessageStatus" NOT NULL DEFAULT 'NEW',
    "received_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "handled_at" TIMESTAMPTZ(3),
    "handled_by" VARCHAR(120),
    "note" VARCHAR(500),

    CONSTRAINT "contact_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "idempotency_keys" (
    "scope" VARCHAR(80) NOT NULL,
    "user_id" UUID NOT NULL,
    "key" UUID NOT NULL,
    "fingerprint" CHAR(64) NOT NULL,
    "state" "IdempotencyState" NOT NULL,
    "fence_token" UUID NOT NULL,
    "lease_until" TIMESTAMPTZ(3) NOT NULL,
    "response_status" INTEGER,
    "response_body" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "idempotency_keys_pkey" PRIMARY KEY ("scope","user_id","key")
);

-- CreateTable
CREATE TABLE "ledger_accounts" (
    "id" UUID NOT NULL,
    "code" VARCHAR(120) NOT NULL,
    "kind" "LedgerAccountKind" NOT NULL,
    "owner_type" "LedgerOwnerType" NOT NULL,
    "owner_id" UUID,
    "credit_type" "CreditType",
    "non_negative" BOOLEAN NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'TND',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ledger_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ledger_transactions" (
    "id" UUID NOT NULL,
    "type" VARCHAR(40) NOT NULL,
    "tenant_id" UUID,
    "user_id" UUID,
    "idempotency_key" UUID,
    "reference" VARCHAR(64) NOT NULL,
    "reverses_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ledger_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ledger_entries" (
    "id" BIGSERIAL NOT NULL,
    "transaction_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "direction" "EntryDirection" NOT NULL,
    "amount_millimes" BIGINT NOT NULL,
    "balance_after_millimes" BIGINT NOT NULL,
    "lot_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ledger_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account_balances" (
    "account_id" UUID NOT NULL,
    "balance_millimes" BIGINT NOT NULL,
    "non_negative" BOOLEAN NOT NULL,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_balances_pkey" PRIMARY KEY ("account_id")
);

-- CreateTable
CREATE TABLE "credit_lots" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "initial_millimes" BIGINT NOT NULL,
    "remaining_millimes" BIGINT NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "source_transaction_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_lots_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "commission_profiles_name_key" ON "commission_profiles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "merchants_payment_code_key" ON "merchants"("payment_code");

-- CreateIndex
CREATE INDEX "points_of_sale_merchant_id_idx" ON "points_of_sale"("merchant_id");

-- CreateIndex
CREATE INDEX "employees_company_id_idx" ON "employees"("company_id");

-- CreateIndex
CREATE UNIQUE INDEX "employees_company_id_employee_number_key" ON "employees"("company_id", "employee_number");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_employee_id_key" ON "users"("employee_id");

-- CreateIndex
CREATE INDEX "users_company_id_idx" ON "users"("company_id");

-- CreateIndex
CREATE INDEX "users_merchant_id_idx" ON "users"("merchant_id");

-- CreateIndex
CREATE INDEX "recovery_codes_user_id_idx" ON "recovery_codes"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_access_token_hash_key" ON "sessions"("access_token_hash");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_refresh_token_hash_key" ON "sessions"("refresh_token_hash");

-- CreateIndex
CREATE INDEX "sessions_family_id_idx" ON "sessions"("family_id");

-- CreateIndex
CREATE INDEX "sessions_user_id_idx" ON "sessions"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_tokens_token_hash_key" ON "password_reset_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "audit_log_occurred_at_idx" ON "audit_log"("occurred_at");

-- CreateIndex
CREATE UNIQUE INDEX "credit_orders_reference_key" ON "credit_orders"("reference");

-- CreateIndex
CREATE INDEX "credit_orders_company_id_created_at_idx" ON "credit_orders"("company_id", "created_at");

-- CreateIndex
CREATE INDEX "credit_orders_status_idx" ON "credit_orders"("status");

-- CreateIndex
CREATE INDEX "credit_order_events_order_id_idx" ON "credit_order_events"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_number_key" ON "invoices"("number");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_order_id_key" ON "invoices"("order_id");

-- CreateIndex
CREATE INDEX "invoices_company_id_idx" ON "invoices"("company_id");

-- CreateIndex
CREATE INDEX "allocations_company_id_created_at_idx" ON "allocations"("company_id", "created_at");

-- CreateIndex
CREATE INDEX "allocations_employee_id_idx" ON "allocations"("employee_id");

-- CreateIndex
CREATE INDEX "payment_codes_code_idx" ON "payment_codes"("code");

-- CreateIndex
CREATE UNIQUE INDEX "payments_reference_key" ON "payments"("reference");

-- CreateIndex
CREATE INDEX "payments_merchant_id_created_at_idx" ON "payments"("merchant_id", "created_at");

-- CreateIndex
CREATE INDEX "payments_employee_id_created_at_idx" ON "payments"("employee_id", "created_at");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "payments"("status");

-- CreateIndex
CREATE INDEX "payment_events_payment_id_idx" ON "payment_events"("payment_id");

-- CreateIndex
CREATE INDEX "credit_expiries_employee_id_idx" ON "credit_expiries"("employee_id");

-- CreateIndex
CREATE UNIQUE INDEX "payout_requests_reference_key" ON "payout_requests"("reference");

-- CreateIndex
CREATE INDEX "payout_requests_merchant_id_requested_at_idx" ON "payout_requests"("merchant_id", "requested_at");

-- CreateIndex
CREATE INDEX "payout_requests_status_idx" ON "payout_requests"("status");

-- CreateIndex
CREATE INDEX "payout_events_payout_id_idx" ON "payout_events"("payout_id");

-- CreateIndex
CREATE UNIQUE INDEX "settlement_batches_reference_key" ON "settlement_batches"("reference");

-- CreateIndex
CREATE INDEX "merchant_documents_merchant_id_idx" ON "merchant_documents"("merchant_id");

-- CreateIndex
CREATE INDEX "kyc_files_status_idx" ON "kyc_files"("status");

-- CreateIndex
CREATE INDEX "kyc_documents_file_id_idx" ON "kyc_documents"("file_id");

-- CreateIndex
CREATE INDEX "kyc_events_file_id_idx" ON "kyc_events"("file_id");

-- CreateIndex
CREATE UNIQUE INDEX "contact_messages_reference_key" ON "contact_messages"("reference");

-- CreateIndex
CREATE INDEX "contact_messages_received_at_idx" ON "contact_messages"("received_at");

-- CreateIndex
CREATE UNIQUE INDEX "ledger_accounts_code_key" ON "ledger_accounts"("code");

-- CreateIndex
CREATE INDEX "ledger_accounts_owner_type_owner_id_idx" ON "ledger_accounts"("owner_type", "owner_id");

-- CreateIndex
CREATE INDEX "ledger_transactions_type_created_at_idx" ON "ledger_transactions"("type", "created_at");

-- CreateIndex
CREATE INDEX "ledger_entries_transaction_id_idx" ON "ledger_entries"("transaction_id");

-- CreateIndex
CREATE INDEX "ledger_entries_account_id_id_idx" ON "ledger_entries"("account_id", "id");

-- CreateIndex
CREATE INDEX "credit_lots_account_id_expires_at_idx" ON "credit_lots"("account_id", "expires_at");

-- AddForeignKey
ALTER TABLE "merchants" ADD CONSTRAINT "merchants_commission_profile_id_fkey" FOREIGN KEY ("commission_profile_id") REFERENCES "commission_profiles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "points_of_sale" ADD CONSTRAINT "points_of_sale_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recovery_codes" ADD CONSTRAINT "recovery_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mfa_challenges" ADD CONSTRAINT "mfa_challenges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_tokens" ADD CONSTRAINT "password_reset_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "login_failures" ADD CONSTRAINT "login_failures_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credit_orders" ADD CONSTRAINT "credit_orders_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credit_order_lines" ADD CONSTRAINT "credit_order_lines_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "credit_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credit_order_events" ADD CONSTRAINT "credit_order_events_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "credit_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "credit_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocations" ADD CONSTRAINT "allocations_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_codes" ADD CONSTRAINT "payment_codes_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_events" ADD CONSTRAINT "payment_events_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payout_quotes" ADD CONSTRAINT "payout_quotes_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payout_requests" ADD CONSTRAINT "payout_requests_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payout_requests" ADD CONSTRAINT "payout_requests_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "settlement_batches"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payout_events" ADD CONSTRAINT "payout_events_payout_id_fkey" FOREIGN KEY ("payout_id") REFERENCES "payout_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "merchant_documents" ADD CONSTRAINT "merchant_documents_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_files" ADD CONSTRAINT "kyc_files_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_files" ADD CONSTRAINT "kyc_files_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_documents" ADD CONSTRAINT "kyc_documents_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "kyc_files"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_events" ADD CONSTRAINT "kyc_events_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "kyc_files"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "ledger_transactions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "ledger_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account_balances" ADD CONSTRAINT "account_balances_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "ledger_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credit_lots" ADD CONSTRAINT "credit_lots_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "ledger_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

