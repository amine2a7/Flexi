import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { asService, DbService, type Tx } from '../common/db.service.js';
import { ApiProblem } from '../common/problem.js';
import { toMillimes, type Taxes } from '../common/money.js';
import { addDays, businessDay, dateOnly } from '../common/tunis.js';
import { gridRate, type GridOwner } from './commission-grids.js';
import type {
  CreditType,
  CreditTypeSetting,
  LegalForm,
  PlatformSettings,
} from '../generated/prisma/client.js';

/** The 4 credit types, in display order (decision of 2026-10-13). */
export const CREDIT_TYPES: readonly CreditType[] = [
  'RESTAURATION',
  'HABILLEMENT',
  'CARBURANT',
  'CADEAUX',
];

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
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async platform(tx: Tx): Promise<PlatformSettings> {
    const row = await tx.platformSettings.findUnique({ where: { id: 1 } });
    if (row === null) throw new Error('platform settings missing: run db:seed');
    return row;
  }

  /** VAT rate and stamp duty of the settings (super-admin), frozen in each order and payout. */
  /** Taxes and fees of the settings, with the withholding rate of the client's legal form. */
  async taxes(tx: Tx, legalForm: LegalForm): Promise<Taxes> {
    const row = await this.platform(tx);
    return {
      vatRateBps: row.vatRateBps,
      stampDutyMillimes: row.stampDutyMillimes,
      withholdingRateBps:
        legalForm === 'PP_CIN'
          ? row.withholdingPpCinBps
          : legalForm === 'PP_MF'
            ? row.withholdingPpMfBps
            : row.withholdingPmMfBps,
      withholdingThresholdMillimes: row.withholdingThresholdMillimes,
      transferFeeMillimes: row.transferFeeMillimes,
    };
  }

  /** Public terms of the platform (texts of the pages): values of the settings only. */
  async terms() {
    const row = await this.db.system((tx) => this.platform(tx));
    return {
      settlementDelayDays: row.settlementDelayDays,
      invitationValidityDays: row.invitationValidityDays,
      quoteValidityDays: row.quoteValidityDays,
      paymentCancelHours: row.paymentCancelHours,
      payoutMinimumMillimes: toMillimes(row.payoutMinimumMillimes),
      secondValidationThresholdMillimes: toMillimes(row.secondValidationThresholdMillimes),
    };
  }

  /** Settlement date of a payment confirmed `now`: its business day + the settlement cycle (days). */
  async settlementDate(tx: Tx, now: Date): Promise<Date> {
    const { settlementDelayDays } = await this.platform(tx);
    return dateOnly(addDays(businessDay(now), settlementDelayDays));
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

  /** FlexiPay bank account where companies transfer their orders (settings of the super-admin). */
  async fundingAccount(): Promise<{ bankName: string; holder: string; rib: string; iban: string }> {
    const row = await this.db.user((tx) => this.platform(tx));
    return {
      bankName: row.fundingBankName,
      holder: row.fundingHolder,
      rib: row.fundingRib,
      iban: row.fundingIban,
    };
  }
}
