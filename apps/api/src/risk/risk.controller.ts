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
import { pathId, sendOutcome } from '../common/responses.js';
import { parse } from '../common/validation.js';
import { DisputesService } from './disputes.service.js';

const reasonBody = z.strictObject({ reason: z.string().trim().min(10).max(500) });
const openBody = z.strictObject({
  paymentId: z.uuid(),
  reason: z.string().trim().min(10).max(500),
});
const noteBody = z.strictObject({ text: z.string().trim().min(1).max(2000) });

/**
 * Sécurité & conformité (decisions of 2026-10-31): disputes (N2). Reading `risk.read`, handling
 * `disputes.manage` (super-admin, Opérations); the refund is approved by Finance (approvals).
 */
@Roles('ADMIN')
@Controller('v1/admin/disputes')
export class DisputesController {
  constructor(
    @Inject(DisputesService) private readonly disputes: DisputesService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('risk.read')
  @Get()
  list(@Query() query: Record<string, unknown>) {
    return this.disputes.list(query);
  }

  @Can('risk.read')
  @Get(':disputeId')
  detail(@Param('disputeId') disputeId: string) {
    return this.disputes.detail(pathId('disputeId', disputeId));
  }

  @Can('disputes.manage')
  @Post()
  async open(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const input = parse(openBody, body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 201,
      body: await this.disputes.open(tx, input.paymentId, input.reason),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('disputes.manage')
  @Post(':disputeId/notes')
  @HttpCode(201)
  note(@Param('disputeId') disputeId: string, @Body() body: unknown) {
    return this.disputes.note(pathId('disputeId', disputeId), parse(noteBody, body).text);
  }

  @Can('disputes.manage')
  @Post(':disputeId/reject')
  async reject(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('disputeId') disputeId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('disputeId', disputeId);
    const { reason } = parse(reasonBody, body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.disputes.reject(tx, id, reason),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('disputes.manage')
  @Post(':disputeId/accept')
  async accept(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('disputeId') disputeId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('disputeId', disputeId);
    const { reason } = parse(reasonBody, body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.disputes.accept(tx, id, reason),
    }));
    return sendOutcome(res, outcome);
  }
}
