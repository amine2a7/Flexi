import { Module } from '@nestjs/common';
import { CheckoutEvents } from './checkout-events.service.js';
import { EmployeeCheckoutsController, MerchantCheckoutsController } from './checkouts.controller.js';
import { CheckoutsService } from './checkouts.service.js';
import { DemoController } from './demo.controller.js';
import { EmployeeController } from './employee.controller.js';
import { NotificationsService } from './notifications.service.js';
import { PaymentsService } from './payments.service.js';
import { PinService } from './pin.service.js';

const DEVELOPMENT = process.env.NODE_ENV !== 'production';

@Module({
  controllers: [
    EmployeeController,
    EmployeeCheckoutsController,
    MerchantCheckoutsController,
    ...(DEVELOPMENT ? [DemoController] : []),
  ],
  providers: [PaymentsService, PinService, CheckoutsService, CheckoutEvents, NotificationsService],
  exports: [PaymentsService, CheckoutsService],
})
export class PaymentsModule {}
