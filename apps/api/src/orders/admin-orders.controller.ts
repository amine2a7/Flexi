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
import { OrdersService } from './orders.service.js';

const query = z.object({
  status: z
    .enum([
      'AWAITING_CONFIRMATION',
      'AWAITING_PAYMENT',
      'AWAITING_VALIDATION',
      'VALIDATED',
      'REFUSED',
      'CANCELLED',
    ])
    .optional(),
  creditType: creditType.optional(),
  companyId: z.uuid().optional(),
});
const reasonBody = z.strictObject({ reason });

@Roles('ADMIN')
@Controller('v1/admin/credit-orders')
export class AdminOrdersController {
  constructor(
    @Inject(OrdersService) private readonly orders: OrdersService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('platform.read')
  @Get()
  list(@Query() raw: Record<string, unknown>) {
    return this.orders.adminList(
      raw,
      parse(
        query,
        { status: raw.status, creditType: raw.creditType, companyId: raw.companyId },
        'query',
      ),
    );
  }

  @Can('platform.read')
  @Get(':orderId')
  get(@Param('orderId') orderId: string) {
    return this.orders.get(pathId('orderId', orderId));
  }

  @Can('orders.confirm')
  @Post(':orderId/confirm')
  @HttpCode(200)
  confirm(@Param('orderId') orderId: string) {
    return this.orders.confirm(pathId('orderId', orderId));
  }

  @Can('orders.confirm')
  @Post(':orderId/refuse')
  @HttpCode(200)
  refuse(@Param('orderId') orderId: string, @Body() body: unknown) {
    return this.orders.refuse(pathId('orderId', orderId), parse(reasonBody, body).reason);
  }

  @Can('orders.validate')
  @Post(':orderId/validate')
  async validate(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('orderId') orderId: string,
  ) {
    const id = pathId('orderId', orderId);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 200,
      body: await this.orders.validate(tx, id, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('orders.validate')
  @Post(':orderId/reject-proof')
  @HttpCode(200)
  rejectProof(@Param('orderId') orderId: string, @Body() body: unknown) {
    return this.orders.rejectProof(pathId('orderId', orderId), parse(reasonBody, body).reason);
  }

  @Can('platform.read')
  @Get(':orderId/proof')
  async proof(@Param('orderId') orderId: string, @Res() res: Response): Promise<void> {
    const file = await this.orders.proof(pathId('orderId', orderId));
    sendFile(res, file.data, file.contentType, file.fileName);
  }
}
