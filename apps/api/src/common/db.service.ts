import { Inject, Injectable, type OnModuleDestroy } from '@nestjs/common';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient, type Prisma } from '../generated/prisma/client.js';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { currentContext, type Principal } from './request-context.js';

export type Tx = Prisma.TransactionClient;

/** Row-Level Security context of a SQL transaction (migration 0002). */
export interface DbScope {
  readonly role: 'ADMIN' | 'COMPANY' | 'MERCHANT' | 'EMPLOYEE' | 'SYSTEM';
  readonly userId?: string | null;
  readonly companyId?: string | null;
  readonly merchantId?: string | null;
  readonly employeeId?: string | null;
}

/** Bounds of a financial SQL transaction; the idempotency lease is derived from them (§5). */
export const STATEMENT_TIMEOUT_MS = 10_000;
export const LOCK_TIMEOUT_MS = 5_000;
export const TRANSACTION_TIMEOUT_MS = 20_000;

export function scopeOf(value: Principal): DbScope {
  return {
    role: value.role === 'FAMILY_MEMBER' ? 'EMPLOYEE' : value.role,
    userId: value.userId,
    companyId: value.companyId,
    merchantId: value.merchantId,
    employeeId: value.employeeId,
  };
}

@Injectable()
export class DbService implements OnModuleDestroy {
  readonly prisma: PrismaClient;

  constructor(@Inject(ENV) env: Env) {
    this.prisma = new PrismaClient({
      adapter: new PrismaPg({ connectionString: env.databaseUrl }),
    });
  }

  async onModuleDestroy(): Promise<void> {
    await this.prisma.$disconnect();
  }

  /** Runs `fn` in one SQL transaction whose RLS context is `scope`. */
  async run<T>(
    scope: DbScope,
    fn: (tx: Tx) => Promise<T>,
    isolationLevel: Prisma.TransactionIsolationLevel = 'ReadCommitted',
  ): Promise<T> {
    return this.prisma.$transaction(
      async (tx) => {
        await tx.$queryRaw`SELECT
          set_config('app.role', ${scope.role}, true),
          set_config('app.user_id', ${scope.userId ?? ''}, true),
          set_config('app.company_id', ${scope.companyId ?? ''}, true),
          set_config('app.merchant_id', ${scope.merchantId ?? ''}, true),
          set_config('app.employee_id', ${scope.employeeId ?? ''}, true),
          set_config('statement_timeout', ${String(STATEMENT_TIMEOUT_MS)}, true),
          set_config('lock_timeout', ${String(LOCK_TIMEOUT_MS)}, true)`;
        return fn(tx);
      },
      { isolationLevel, maxWait: 5_000, timeout: TRANSACTION_TIMEOUT_MS },
    );
  }

  /** Transaction in the context of the signed-in user of the current request. */
  async user<T>(fn: (tx: Tx) => Promise<T>): Promise<T> {
    const principal = currentContext()?.principal;
    if (principal === undefined) throw new Error('db.user() outside an authenticated request');
    return this.run(scopeOf(principal), fn);
  }

  /** Audited server step that crosses tenants (sign-in, payment between two tenants, jobs). */
  async system<T>(fn: (tx: Tx) => Promise<T>): Promise<T> {
    const principal = currentContext()?.principal;
    return this.run({ role: 'SYSTEM', userId: principal?.userId ?? null }, fn);
  }
}
