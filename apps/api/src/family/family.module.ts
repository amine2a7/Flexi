import { Module } from '@nestjs/common';
import { CompanyFamilyController, FamilyController } from './family.controller.js';
import { FamilyService } from './family.service.js';

/** Family accounts of the beneficiaries (processus v2). */
@Module({
  controllers: [FamilyController, CompanyFamilyController],
  providers: [FamilyService],
})
export class FamilyModule {}
