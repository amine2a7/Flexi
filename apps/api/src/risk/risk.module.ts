import { Module } from '@nestjs/common';
import { DisputesController, FraudAlertsController } from './risk.controller.js';
import { DisputesService } from './disputes.service.js';
import { FraudService } from './fraud.service.js';

/** Sécurité & conformité: disputes (N2) and fraud alerts (decisions of 2026-10-31). */
@Module({
  controllers: [DisputesController, FraudAlertsController],
  providers: [DisputesService, FraudService],
  exports: [DisputesService, FraudService],
})
export class RiskModule {}
