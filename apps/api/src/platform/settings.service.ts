import { Inject, Injectable } from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import type { Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import type {
  CreditType,
  CreditTypeSetting,
  PlatformSettings,
} from '../generated/prisma/client.js';

/** The 4 credit types, in display order (decision of 2026-10-13). */
export const CREDIT_TYPES: readonly CreditType[] = [
  'RESTAURATION',
  'HABILLEMENT',
  'CARBURANT',
  'CADEAUX',
];

/** Four-eyes threshold on credit orders (decision): above 10 000,000 TND, two administrators. */
export const SECOND_VALIDATION_THRESHOLD = 10_000_000n;

export interface CreditTypeSettingsBody {
  creditType: CreditType;
  enabled: boolean;
  commissionRateBps: number;
  validityMonths: number;
  dailyLimitMillimes: number;
}

export function typeSettingsBody(row: CreditTypeSetting): CreditTypeSettingsBody {
  return {
    creditType: row.creditType,
    enabled: row.enabled,
    commissionRateBps: row.commissionRateBps,
    validityMonths: row.validityMonths,
    dailyLimitMillimes: toMillimes(row.dailyLimitMillimes),
  };
}

@Injectable()
export class SettingsService {
  constructor(@Inject(ENV) private readonly env: Env) {}

  async platform(tx: Tx): Promise<PlatformSettings> {
    const row = await tx.platformSettings.findUnique({ where: { id: 1 } });
    if (row === null) throw new Error('platform settings missing: run db:seed');
    return row;
  }

  /** Settings of the 4 types, in display order. */
  async creditTypes(tx: Tx): Promise<CreditTypeSetting[]> {
    const rows = await tx.creditTypeSetting.findMany();
    return CREDIT_TYPES.flatMap((type) => rows.filter((row) => row.creditType === type));
  }

  async creditType(tx: Tx, type: CreditType): Promise<CreditTypeSetting> {
    const row = await tx.creditTypeSetting.findUnique({ where: { creditType: type } });
    if (row === null) throw new Error('credit type settings missing: run db:seed');
    return row;
  }

  /**
   * Commission rate of a shop for a credit type (decision of 2026-10-14): its own commission
   * profile when it has one, otherwise the rate of the credit type. Frozen in the payout request.
   */
  async commissionRate(tx: Tx, merchantId: string, type: CreditType): Promise<number> {
    const merchant = await tx.merchant.findUnique({
      where: { id: merchantId },
      select: { commissionProfile: { select: { rateBps: true } } },
    });
    return (
      merchant?.commissionProfile?.rateBps ?? (await this.creditType(tx, type)).commissionRateBps
    );
  }

  async enabledTypes(tx: Tx): Promise<Set<CreditType>> {
    return new Set(
      (await this.creditTypes(tx)).filter((row) => row.enabled).map((row) => row.creditType),
    );
  }

  /** FlexiPay bank account where companies transfer their orders (server configuration). */
  fundingAccount(): { bankName: string; holder: string; rib: string; iban: string } {
    return {
      bankName: this.env.FUNDING_BANK_NAME,
      holder: this.env.FUNDING_HOLDER,
      rib: this.env.FUNDING_RIB,
      iban: this.env.FUNDING_IBAN,
    };
  }
}
