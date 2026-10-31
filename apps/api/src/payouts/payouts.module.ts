import { Module } from '@nestjs/common';
import { JobsService } from '../jobs/jobs.service.js';
import { RiskModule } from '../risk/risk.module.js';
import { PaymentsModule } from '../payments/payments.module.js';
import { AdminPayoutsController } from './admin-payouts.controller.js';
import { MerchantController } from './merchant.controller.js';
import { PayoutsService } from './payouts.service.js';

/** Merchant space (payments, receivables, payouts, settlements), admin payout control, jobs. */
@Module({
  imports: [RiskModule, PaymentsModule],
  controllers: [MerchantController, AdminPayoutsController],
  providers: [PayoutsService, JobsService],
  exports: [PayoutsService, JobsService],
})
export class PayoutsModule {}
