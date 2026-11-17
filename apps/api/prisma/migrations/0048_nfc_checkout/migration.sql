-- M4 (request of 2026-11-17): payment by NFC sticker at the till (montage A), mobile sessions,
-- beneficiary notifications. Never edit once applied: add a new migration (CLAUDE.md rule 17).

-- ------------------------------------------------------------------ registers (caisses)
CREATE TYPE "RegisterStatus" AS ENUM ('ACTIVE', 'DISABLED');

CREATE TABLE "registers" (
    "id" UUID NOT NULL,
    "merchant_id" UUID NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    -- Random, unguessable id written on the NFC sticker (base64url, 22 characters).
    "public_id" VARCHAR(32) NOT NULL,
    "status" "RegisterStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "registers_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "registers_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id")
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "registers_name_not_blank" CHECK (length(btrim("name")) > 0)
);
CREATE UNIQUE INDEX "registers_public_id_key" ON "registers"("public_id");
CREATE INDEX "registers_merchant_idx" ON "registers"("merchant_id");

-- A cashier is attached to one till of its own shop.
ALTER TABLE "users" ADD COLUMN "register_id" UUID;
ALTER TABLE "users" ADD CONSTRAINT "users_register_id_fkey" FOREIGN KEY ("register_id")
  REFERENCES "registers"("id") ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX "users_register_idx" ON "users"("register_id");

-- ------------------------------------------------------------------ checkouts (demandes de caisse)
CREATE TYPE "CheckoutStatus" AS ENUM ('PENDING', 'PAID', 'EXPIRED', 'CANCELLED');
ALTER TYPE "PaymentChannel" ADD VALUE IF NOT EXISTS 'REGISTER_CHECKOUT';

CREATE TABLE "checkouts" (
    "id" UUID NOT NULL,
    "merchant_id" UUID NOT NULL,
    "register_id" UUID NOT NULL,
    "amount_millimes" BIGINT NOT NULL,
    "credit_type" "CreditType" NOT NULL,
    "short_code" CHAR(4) NOT NULL,
    "status" "CheckoutStatus" NOT NULL DEFAULT 'PENDING',
    "idempotency_key" UUID NOT NULL,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "closed_at" TIMESTAMPTZ(3),
    "employee_id" UUID,
    "payment_id" UUID,
    "customer_first_name" VARCHAR(60),
    -- Last refusal of a confirmation (the request stays open): shown to the till, no amount.
    "last_refusal_code" VARCHAR(40),
    "last_refusal_reason" VARCHAR(40),
    "last_refusal_first_name" VARCHAR(60),
    "last_refusal_at" TIMESTAMPTZ(3),
    CONSTRAINT "checkouts_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "checkouts_merchant_id_fkey" FOREIGN KEY ("merchant_id") REFERENCES "merchants"("id")
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "checkouts_register_id_fkey" FOREIGN KEY ("register_id") REFERENCES "registers"("id")
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "checkouts_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id")
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "checkouts_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id")
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "checkouts_amount_positive" CHECK ("amount_millimes" > 0),
    CONSTRAINT "checkouts_short_code_digits" CHECK ("short_code" ~ '^[0-9]{4}$'),
    -- A paid checkout always names its payer and its payment; an open one names neither.
    CONSTRAINT "checkouts_paid_consistent" CHECK (
      ("status" = 'PAID') = ("payment_id" IS NOT NULL AND "employee_id" IS NOT NULL)
    ),
    CONSTRAINT "checkouts_closed_consistent" CHECK (("status" = 'PENDING') = ("closed_at" IS NULL))
);
-- Idempotency-Key unique per merchant (a replay never creates a second request).
CREATE UNIQUE INDEX "checkouts_merchant_idempotency_key" ON "checkouts"("merchant_id", "idempotency_key");
-- One active request per till.
CREATE UNIQUE INDEX "checkouts_one_pending_per_register" ON "checkouts"("register_id")
  WHERE "status" = 'PENDING';
-- A short code designates one open request at a time.
CREATE UNIQUE INDEX "checkouts_pending_short_code" ON "checkouts"("short_code")
  WHERE "status" = 'PENDING';
-- A payment pays one request.
CREATE UNIQUE INDEX "checkouts_payment_key" ON "checkouts"("payment_id");
-- Expiry job and the day of a till.
CREATE INDEX "checkouts_pending_expiry_idx" ON "checkouts"("expires_at") WHERE "status" = 'PENDING';
CREATE INDEX "checkouts_register_created_idx" ON "checkouts"("register_id", "created_at" DESC);

REVOKE DELETE, TRUNCATE ON "checkouts" FROM flexipay_app;
GRANT SELECT, INSERT, UPDATE ON "registers", "checkouts" TO flexipay_app;

ALTER TABLE "registers" ENABLE ROW LEVEL SECURITY;
CREATE POLICY registers_access ON "registers" USING (
  app_is_platform() OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);

-- The customer reaches a checkout only through audited server steps (sticker or code lookup,
-- confirmation): never by a direct read of another tenant's rows.
ALTER TABLE "checkouts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY checkouts_access ON "checkouts" USING (
  app_is_platform()
  OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
  OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

-- ------------------------------------------------------------------ rush hour (midi)
-- Daily limit and family cap read the confirmed payments of the day of one beneficiary.
CREATE INDEX IF NOT EXISTS "payments_employee_type_confirmed_idx"
  ON "payments"("employee_id", "credit_type", "confirmed_at")
  WHERE "status" IN ('CONFIRMED', 'SETTLED');
-- The day of a shop (Pro app « Aujourd'hui »).
CREATE INDEX IF NOT EXISTS "payments_merchant_created_idx" ON "payments"("merchant_id", "created_at" DESC);

-- ------------------------------------------------------------------ outbox (events)
-- Events written in the same transaction as the business change, published after commit.
CREATE TABLE "outbox_events" (
    "id" UUID NOT NULL,
    "topic" VARCHAR(60) NOT NULL,
    "aggregate_id" UUID NOT NULL,
    "payload" JSONB NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "published_at" TIMESTAMPTZ(3),
    CONSTRAINT "outbox_events_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "outbox_events_unpublished_idx" ON "outbox_events"("created_at") WHERE "published_at" IS NULL;
GRANT SELECT, INSERT, UPDATE ON "outbox_events" TO flexipay_app;
REVOKE DELETE, TRUNCATE ON "outbox_events" FROM flexipay_app;
ALTER TABLE "outbox_events" ENABLE ROW LEVEL SECURITY;
CREATE POLICY outbox_events_access ON "outbox_events" USING (app_is_platform());

-- ------------------------------------------------------------------ notifications read marker
CREATE TABLE "notification_reads" (
    "employee_id" UUID NOT NULL,
    "read_until" TIMESTAMPTZ(3) NOT NULL,
    CONSTRAINT "notification_reads_pkey" PRIMARY KEY ("employee_id"),
    CONSTRAINT "notification_reads_employee_id_fkey" FOREIGN KEY ("employee_id")
      REFERENCES "employees"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
GRANT SELECT, INSERT, UPDATE ON "notification_reads" TO flexipay_app;
ALTER TABLE "notification_reads" ENABLE ROW LEVEL SECURITY;
CREATE POLICY notification_reads_access ON "notification_reads" USING (
  app_is_platform() OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

-- ------------------------------------------------------------------ mobile sessions
CREATE TYPE "SessionChannel" AS ENUM ('WEB', 'MOBILE');
ALTER TABLE "sessions" ADD COLUMN "channel" "SessionChannel" NOT NULL DEFAULT 'WEB';
ALTER TABLE "sessions" ADD COLUMN "device_id" VARCHAR(128);
-- Mobile: the access token lives 15 min; the refresh token rotates until the absolute deadline.
ALTER TABLE "sessions" ADD COLUMN "access_expires_at" TIMESTAMPTZ(3);
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_mobile_device" CHECK (
  ("channel" = 'MOBILE') = ("device_id" IS NOT NULL AND "access_expires_at" IS NOT NULL)
);
