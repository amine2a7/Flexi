import { Inject, Injectable } from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { asService, DbService, type Tx } from '../common/db.service.js';
import { ApiProblem } from '../common/problem.js';
import { toMillimes } from '../common/money.js';
import { gridRate, type GridOwner } from './commission-grids.js';
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
  constructor(
    @Inject(ENV) private readonly env: Env,
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

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
   * Commission rate of an amount on the grid of a company (order) or a shop (payout, payment),
   * decisions of 2026-11-03 and 2026-11-04: the tranche that contains the amount, else the default
   * line. Read under the internal service role: a beneficiary paying a shop never reads its grid.
   * No fallback rate: without a grid the operation is refused and Opérations and Finance are told.
   */
  async commissionRate(tx: Tx, owner: GridOwner, amountMillimes: bigint): Promise<number> {
    const rate = await asService(tx, () => gridRate(tx, owner, amountMillimes));
    if (rate === undefined) {
      await this.reportMissingGrid(owner);
      throw new ApiProblem(422, 'COMMISSION_GRID_MISSING');
    }
    return rate;
  }

  /**
   * Alert (Opérations) and audit entry (Finance) in their own transaction: the refused operation
   * is rolled back, the report stays.
   */
  private async reportMissingGrid(owner: GridOwner): Promise<void> {
    await this.db.system(async (tx) => {
      const id = 'companyId' in owner ? owner.companyId : owner.merchantId;
      const found =
        'companyId' in owner
          ? await tx.company.findUnique({ where: { id }, select: { name: true } })
          : await tx.merchant.findUnique({ where: { id }, select: { name: true } });
      const subject = (found?.name ?? id).slice(0, 120);
      const inserted = await tx.$executeRaw`
        INSERT INTO fraud_alerts (id, kind, severity, subject, subject_key)
        VALUES (${uuidv7()}::uuid, 'COMMISSION_GRID_MISSING'::"FraudAlertKind",
                'HIGH'::"FraudAlertSeverity", ${subject}, ${id})
        ON CONFLICT (kind, subject_key) DO NOTHING`;
      if (inserted > 0) await this.audit.record(tx, 'commissions.gridMissing', subject);
    });
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
