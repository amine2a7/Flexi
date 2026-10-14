import { Controller, HttpCode, Inject, Post } from '@nestjs/common';
import { Roles } from '../common/decorators.js';
import { PaymentsService } from './payments.service.js';

/**
 * Development only (not in the contract, never registered in production): a merchant request
 * reaches the signed-in beneficiary, as if a shop had typed its code. The web beneficiary space
 * can then be tried alone in one tab ("Simuler une demande").
 */
@Roles('EMPLOYEE')
@Controller('__demo')
export class DemoController {
  constructor(@Inject(PaymentsService) private readonly payments: PaymentsService) {}

  @Post('employee/payment-request')
  @HttpCode(204)
  async paymentRequest(): Promise<void> {
    await this.payments.demoRequest();
  }
}
