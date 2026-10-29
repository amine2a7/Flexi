import { Module } from '@nestjs/common';
import { UsersModule } from '../users/users.module.js';
import { CompanyController } from '../company/company.controller.js';
import { CompanyService } from '../company/company.service.js';
import { AdminOrdersController } from './admin-orders.controller.js';
import { OrdersService } from './orders.service.js';

/** Credit orders (company and admin), company employees, allocation, invoices. */
@Module({
  imports: [UsersModule],
  controllers: [CompanyController, AdminOrdersController],
  providers: [OrdersService, CompanyService],
  exports: [OrdersService, CompanyService],
})
export class OrdersModule {}
