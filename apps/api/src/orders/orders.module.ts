import { Module } from '@nestjs/common';
import { CompanyController } from '../company/company.controller.js';
import { CompanyService } from '../company/company.service.js';
import { AdminOrdersController } from './admin-orders.controller.js';
import { OrdersService } from './orders.service.js';

/** Credit orders (company and admin), company employees, allocation, invoices. */
@Module({
  controllers: [CompanyController, AdminOrdersController],
  providers: [OrdersService, CompanyService],
  exports: [OrdersService, CompanyService],
})
export class OrdersModule {}
