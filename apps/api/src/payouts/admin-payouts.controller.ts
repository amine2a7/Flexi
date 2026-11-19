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
import { pathId, sendFile, sendOutcome } from '../common/responses.js';
import { creditType, parse, reason } from '../common/validation.js';
import { PayoutsService } from './payouts.service.js';

/** Payment recorded by Finance: bank reference, date, amount; a reason when it is not the net. */
const payment = z.strictObject({
  bankReference: z.string().trim().min(1).max(40),
  paidOn: z.iso.date(),
  amountMillimes: z.number().int().positive().max(Number.MAX_SAFE_INTEGER),
  reason: z.string().trim().max(500).optional(),
});

@Roles('ADMIN')
@Controller('v1/admin')
export class AdminPayoutsController {
  constructor(
    @Inject(PayoutsService) private readonly payouts: PayoutsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('adminPayouts.read')
  @Get('payout-requests')
  list(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: z
          .enum(['REQUESTED', 'CHECKED', 'ON_HOLD', 'SENT', 'EXECUTED', 'REJECTED'])
          .optional(),
        creditType: creditType.optional(),
        q: z.string().max(100).optional(),
      }),
      { status: query.status, creditType: query.creditType, q: query.q },
      'query',
    );
    return this.payouts.adminList(query, filters);
  }

  /** Commission invoice of a payout, for the « Factures » tab of a merchant record (W-FIN). */
  @Can('adminInvoices.read')
  @Get('payout-requests/:payoutId/invoice')
  async invoice(@Param('payoutId') payoutId: string, @Res() res: Response): Promise<void> {
    const file = await this.payouts.commissionInvoice(pathId('payoutId', payoutId), true);
    sendFile(res, file.data, 'application/pdf', file.fileName);
  }

  @Can('adminPayouts.read')
  @Get('payout-requests/:payoutId')
  get(@Param('payoutId') payoutId: string) {
    return this.payouts.adminGet(pathId('payoutId', payoutId));
  }

  @Can('payouts.decide')
  @Post('payout-requests/:payoutId/approve')
  async approve(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('payoutId') payoutId: string,
  ) {
    const id = pathId('payoutId', payoutId);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.payouts.approve(tx, id),
    }));
    return sendOutcome(res, outcome);
  }

  /** Financial (reversal of the request entry): Idempotency-Key required (rule 4). */
  @Can('payouts.decide')
  @Post('payout-requests/:payoutId/reject')
  @HttpCode(200)
  async reject(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('payoutId') payoutId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('payoutId', payoutId);
    const input = parse(z.strictObject({ reason }), body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.payouts.reject(tx, id, input.reason),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('adminPayouts.read')
  @Get('settlements')
  batches(@Query() query: Record<string, unknown>) {
    return this.payouts.batches(query);
  }

  @Can('adminPayouts.read')
  @Get('settlements/:batchId')
  batch(@Param('batchId') batchId: string) {
    return this.payouts.batch(pathId('batchId', batchId));
  }

  /** Financial (ledger of the execution): Idempotency-Key required (rule 4). */
  @Can('payouts.decide')
  @Post('payout-requests/:payoutId/payment')
  @HttpCode(200)
  async recordPayment(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('payoutId') payoutId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('payoutId', payoutId);
    const input = parse(payment, body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.payouts.recordPayment(
        tx,
        { payoutId: id },
        {
          ...input,
          amountMillimes: BigInt(input.amountMillimes),
        },
      ),
    }));
    return sendOutcome(res, outcome);
  }

  /** The payment of a batch pays every payout of the batch (bug 6). */
  @Can('payouts.decide')
  @Post('settlements/:batchId/payment')
  @HttpCode(200)
  async recordBatchPayment(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('batchId') batchId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('batchId', batchId);
    const input = parse(payment, body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.payouts.recordPayment(
        tx,
        { batchId: id },
        {
          ...input,
          amountMillimes: BigInt(input.amountMillimes),
        },
      ),
    }));
    return sendOutcome(res, outcome);
  }
}
