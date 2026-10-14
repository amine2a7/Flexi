import { Module } from '@nestjs/common';
import { ContactService } from '../contact/contact.service.js';
import { AdminController, PublicController } from './admin.controller.js';
import { AdminService } from './admin.service.js';

/** Administration (accounts, KYC, commissions, approvals, settings, supervision) and contact. */
@Module({
  controllers: [AdminController, PublicController],
  providers: [AdminService, ContactService],
})
export class AdminModule {}
