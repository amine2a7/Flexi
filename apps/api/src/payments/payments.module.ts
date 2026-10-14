import { Module } from '@nestjs/common';
import { DemoController } from './demo.controller.js';
import { EmployeeController } from './employee.controller.js';
import { PaymentsService } from './payments.service.js';
import { PinService } from './pin.service.js';

const DEVELOPMENT = process.env.NODE_ENV !== 'production';

@Module({
  controllers: [EmployeeController, ...(DEVELOPMENT ? [DemoController] : [])],
  providers: [PaymentsService, PinService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
