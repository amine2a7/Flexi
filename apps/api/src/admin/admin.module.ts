import { Module } from '@nestjs/common';
import { RiskModule } from '../risk/risk.module.js';
import { ContactService } from '../contact/contact.service.js';
import { AdminController, PublicController } from './admin.controller.js';
import { AdminService } from './admin.service.js';
import { ClientOverviewService } from './client-overview.service.js';
import { LedgerAdminController } from './ledger-admin.controller.js';
import { LedgerAdminService } from './ledger-admin.service.js';

/** Administration (accounts, KYC, commissions, approvals, settings, supervision) and contact. */
@Module({
  imports: [RiskModule],
  controllers: [AdminController, PublicController, LedgerAdminController],
  providers: [AdminService, ContactService, ClientOverviewService, LedgerAdminService],
})
export class AdminModule {}
