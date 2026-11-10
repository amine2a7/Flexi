import { Module } from '@nestjs/common';
import { KycController } from './kyc.controller.js';
import { KycService } from './kyc.service.js';

/** KYC file filed by the client itself (processus v2). */
@Module({
  controllers: [KycController],
  providers: [KycService],
})
export class KycModule {}
