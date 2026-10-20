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
import { Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { pathId, sendOutcome } from '../common/responses.js';
import { creditType, parse, reason } from '../common/validation.js';
import { PayoutsService } from './payouts.service.js';

@Roles('ADMIN')
@Controller('v1/admin')
export class AdminPayoutsController {
  constructor(
    @Inject(PayoutsService) private readonly payouts: PayoutsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Get('payout-requests')
  list(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: z.enum(['REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED']).optional(),
        creditType: creditType.optional(),
        q: z.string().max(100).optional(),
      }),
      { status: query.status, creditType: query.creditType, q: query.q },
      'query',
    );
    return this.payouts.adminList(query, filters);
  }

  @Get('payout-requests/:payoutId')
  get(@Param('payoutId') payoutId: string) {
    return this.payouts.adminGet(pathId('payoutId', payoutId));
  }

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

  @Get('settlements')
  batches(@Query() query: Record<string, unknown>) {
    return this.payouts.batches(query);
  }

  @Get('settlements/:batchId')
  batch(@Param('batchId') batchId: string) {
    return this.payouts.batch(pathId('batchId', batchId));
  }
}
