import { Module } from '@nestjs/common';
import { UsersModule } from '../users/users.module.js';
import { AdminClientController } from '../company/admin-client.controller.js';
import { AdminInvoicesController } from '../company/admin-invoices.controller.js';
import { CompanyController } from '../company/company.controller.js';
import { CompanyService } from '../company/company.service.js';
import { DepartmentsService } from '../company/departments.service.js';
import { AllocationTemplatesService } from '../company/allocation-templates.service.js';
import { AdminOrdersController } from './admin-orders.controller.js';
import { OrdersService } from './orders.service.js';

/** Credit orders (company and admin), company employees, allocation, invoices. */
@Module({
  imports: [UsersModule],
  controllers: [
    CompanyController,
    AdminOrdersController,
    AdminClientController,
    AdminInvoicesController,
  ],
  providers: [OrdersService, CompanyService, DepartmentsService, AllocationTemplatesService],
  exports: [OrdersService, CompanyService, AllocationTemplatesService],
})
export class OrdersModule {}
