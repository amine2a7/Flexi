import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  Post,
  Query,
  Req,
  Res,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { validationFailed } from '../common/problem.js';
import { pathId, sendOutcome } from '../common/responses.js';
import { creditType, parse, positiveMillimes } from '../common/validation.js';
import { PaymentsService } from './payments.service.js';

const pin = z.string().regex(/^[0-9]{4}$/);
const operationsQuery = z.object({
  type: z.enum(['PAYMENT', 'ALLOCATION', 'EXPIRY']).optional(),
  creditType: creditType.optional(),
});
const payBody = z.strictObject({
  merchantCode: z.string().regex(/^[0-9]{6}$/),
  creditType,
  amountMillimes: positiveMillimes,
  pin,
});

/** Beneficiary routes: the web space /beneficiaire and the future mobile app (same contract). */
@Roles('EMPLOYEE', 'FAMILY_MEMBER')
@Controller('v1/employee')
export class EmployeeController {
  constructor(
    @Inject(PaymentsService) private readonly payments: PaymentsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('wallet.read')
  @Get('wallet')
  wallet() {
    return this.payments.wallet();
  }

  @Can('payments.pay')
  @Post('payment-codes')
  @HttpCode(201)
  code() {
    return this.payments.newCode();
  }

  @Can('payments.pay')
  @Get('payment-requests')
  requests() {
    return this.payments.requests();
  }

  @Can('payments.pay')
  @Post('payment-requests/:requestId/confirm')
  async confirm(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('requestId') requestId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('requestId', requestId);
    const input = parse(z.strictObject({ pin }), body);
    // The PIN is checked before (its failures are counted even when the payment is refused).
    this.idempotency.keyOf(req);
    await this.payments.verifyPin(input.pin);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 200,
      body: await this.payments.confirmRequest(tx, id, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('payments.pay')
  @Post('payment-requests/:requestId/refuse')
  @HttpCode(204)
  async refuse(@Param('requestId') requestId: string): Promise<void> {
    await this.payments.refuseRequest(pathId('requestId', requestId));
  }

  @Can('payments.pay')
  @Get('merchants/:merchantCode')
  merchant(@Param('merchantCode') merchantCode: string) {
    if (!/^[0-9]{6}$/.test(merchantCode)) {
      throw validationFailed([{ in: 'path', pointer: 'merchantCode', code: 'INVALID_FORMAT' }]);
    }
    return this.payments.lookupMerchant(merchantCode);
  }

  @Can('payments.pay')
  @Post('payments')
  async pay(@Req() req: Request, @Res({ passthrough: true }) res: Response, @Body() body: unknown) {
    const input = parse(payBody, body);
    this.idempotency.keyOf(req);
    await this.payments.verifyPin(input.pin);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 201,
      body: await this.payments.payMerchant(tx, input, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('wallet.read')
  @Get('operations')
  operations(@Query() query: Record<string, unknown>) {
    return this.payments.listOperations(
      query,
      parse(operationsQuery, { type: query.type, creditType: query.creditType }, 'query'),
    );
  }

  @Can('wallet.read')
  @Get('operations/:operationId')
  operation(@Param('operationId') operationId: string) {
    return this.payments.operation(pathId('operationId', operationId));
  }

  @Can('wallet.read')
  @Get('profile')
  profile() {
    return this.payments.profile();
  }

  @Can('payments.pay')
  @Post('pin')
  @HttpCode(204)
  async changePin(@Body() body: unknown): Promise<void> {
    const input = parse(z.strictObject({ currentPin: pin, newPin: pin }), body);
    await this.payments.changePin(input.currentPin, input.newPin);
  }
}
