import { Module } from '@nestjs/common';
import { DisputesController } from './risk.controller.js';
import { DisputesService } from './disputes.service.js';

/** Sécurité & conformité: disputes (N2) and fraud alerts (decisions of 2026-10-31). */
@Module({
  controllers: [DisputesController],
  providers: [DisputesService],
  exports: [DisputesService],
})
export class RiskModule {}
