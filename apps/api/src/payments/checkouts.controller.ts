import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  Patch,
  Post,
  Put,
  Query,
  Req,
  Res,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { pathId, sendFile, sendOutcome } from '../common/responses.js';
import { creditType, parse, positiveMillimes } from '../common/validation.js';
import { CheckoutEvents } from './checkout-events.service.js';
import { CheckoutsService } from './checkouts.service.js';
import { NotificationsService } from './notifications.service.js';
import { PaymentsService } from './payments.service.js';

const registerName = z.string().trim().min(1).max(60);
const createRegisterBody = z.strictObject({ name: registerName });
const updateRegisterBody = z
  .strictObject({
    name: registerName.optional(),
    status: z.enum(['ACTIVE', 'DISABLED']).optional(),
  })
  .refine((value) => value.name !== undefined || value.status !== undefined);
const assignBody = z.strictObject({ registerId: z.uuid().nullable() });
// Integer millimes only: 0, a negative amount or a decimal (4 decimals of dinar) is refused (400).
const checkoutBody = z.strictObject({ amountMillimes: positiveMillimes, creditType });
const pin = z.strictObject({ pin: z.string().regex(/^[0-9]{4}$/) });
const PUBLIC_ID = /^[A-Za-z0-9_-]{16,32}$/;
const SIGNATURE = /^[A-Za-z0-9_-]{16,64}$/;
const KEEPALIVE_MS = 20_000;

/** Tills, stickers and till requests of a shop (M4). The cashier only reaches its own till. */
@Roles('MERCHANT')
@Controller('v1/merchant')
export class MerchantCheckoutsController {
  constructor(
    @Inject(CheckoutsService) private readonly checkouts: CheckoutsService,
    @Inject(CheckoutEvents) private readonly events: CheckoutEvents,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('payments.collect')
  @Get('registers')
  registers() {
    return this.checkouts.listRegisters();
  }

  @Can('registers.manage')
  @Post('registers')
  @HttpCode(201)
  createRegister(@Body() body: unknown) {
    return this.checkouts.createRegister(parse(createRegisterBody, body).name);
  }

  @Can('registers.manage')
  @Patch('registers/:registerId')
  updateRegister(@Param('registerId') registerId: string, @Body() body: unknown) {
    return this.checkouts.updateRegister(
      pathId('registerId', registerId),
      parse(updateRegisterBody, body),
    );
  }

  @Can('registers.manage')
  @Get('registers/:registerId/sticker')
  sticker(@Param('registerId') registerId: string) {
    return this.checkouts.sticker(pathId('registerId', registerId));
  }

  @Can('registers.manage')
  @Get('registers/:registerId/sticker/pdf')
  async stickerPdf(@Param('registerId') registerId: string, @Res() res: Response): Promise<void> {
    const file = await this.checkouts.stickerDocument(pathId('registerId', registerId));
    sendFile(res, file.data, 'application/pdf', file.fileName);
  }

  @Can('registers.manage')
  @Put('cashiers/:userId/register')
  @HttpCode(204)
  async assign(@Param('userId') userId: string, @Body() body: unknown): Promise<void> {
    await this.checkouts.assignCashier(
      pathId('userId', userId),
      parse(assignBody, body).registerId,
    );
  }

  @Can('payments.collect')
  @Post('registers/:registerId/checkouts')
  async create(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('registerId') registerId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('registerId', registerId);
    const input = parse(checkoutBody, body);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 201,
      body: await this.checkouts.create(tx, id, input, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('payments.collect')
  @Get('checkouts/by-idempotency-key/:key')
  byKey(@Param('key') key: string) {
    return this.checkouts.byKey(pathId('key', key).toLowerCase());
  }

  @Can('payments.collect')
  @Post('checkouts/:checkoutId/cancel')
  @HttpCode(200)
  cancel(@Param('checkoutId') checkoutId: string) {
    return this.checkouts.cancel(pathId('checkoutId', checkoutId));
  }

  /**
   * Server-Sent Events of one till: the current request at the opening, then each change (paid
   * with the first name of the customer, cancelled, expired). Keep-alive comment every 20 s.
   */
  @Can('payments.collect')
  @Get('registers/:registerId/checkouts/events')
  async stream(
    @Param('registerId') registerId: string,
    @Req() req: Request,
    @Res() res: Response,
  ): Promise<void> {
    const id = pathId('registerId', registerId);
    const scope = await this.checkouts.streamScope(id);
    res.status(200);
    res.setHeader('Content-Type', 'text/event-stream; charset=utf-8');
    res.setHeader('Cache-Control', 'no-store');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('X-Accel-Buffering', 'no');
    res.flushHeaders();
    const send = (data: unknown) => {
      if (!res.writableEnded) res.write(`event: checkout\ndata: ${JSON.stringify(data)}\n\n`);
    };
    const current = await this.checkouts.latest(id);
    if (current !== null) send(current);
    const unsubscribe = await this.events.subscribe(id, (checkoutId) => {
      this.checkouts
        .viewInScope(scope, checkoutId)
        .then((view) => {
          if (view !== null) send(view);
        })
        .catch(() => undefined);
    });
    const keepalive = setInterval(() => {
      if (!res.writableEnded) res.write(':keepalive\n\n');
    }, KEEPALIVE_MS);
    keepalive.unref();
    req.on('close', () => {
      clearInterval(keepalive);
      unsubscribe();
      res.end();
    });
  }
}

/** The customer side of a till request (M4), and the notifications of the beneficiary. */
@Roles('EMPLOYEE', 'FAMILY_MEMBER')
@Controller('v1/employee')
export class EmployeeCheckoutsController {
  constructor(
    @Inject(CheckoutsService) private readonly checkouts: CheckoutsService,
    @Inject(PaymentsService) private readonly payments: PaymentsService,
    @Inject(NotificationsService) private readonly notifications: NotificationsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('payments.pay')
  @Get('checkouts/sticker/:publicId')
  bySticker(@Param('publicId') publicId: string, @Query('s') signature: unknown) {
    if (!PUBLIC_ID.test(publicId)) {
      throw validationFailed([{ in: 'path', pointer: 'publicId', code: 'INVALID_FORMAT' }]);
    }
    if (typeof signature !== 'string' || !SIGNATURE.test(signature)) {
      throw validationFailed([{ in: 'query', pointer: 's', code: 'INVALID_FORMAT' }]);
    }
    return this.checkouts.bySticker(publicId, signature);
  }

  @Can('payments.pay')
  @Get('checkouts/code/:shortCode')
  byCode(@Param('shortCode') shortCode: string) {
    if (!/^[0-9]{4}$/.test(shortCode)) {
      throw validationFailed([{ in: 'path', pointer: 'shortCode', code: 'INVALID_FORMAT' }]);
    }
    return this.checkouts.byCode(shortCode);
  }

  @Can('payments.pay')
  @Post('checkouts/:checkoutId/confirm')
  async confirm(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('checkoutId') checkoutId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('checkoutId', checkoutId);
    const input = parse(pin, body);
    // The PIN is checked first (its failures count even when the payment is refused).
    this.idempotency.keyOf(req);
    await this.payments.verifyPin(input.pin);
    try {
      const outcome = await this.idempotency.run(req, async (tx, key) => ({
        status: 200,
        body: await this.checkouts.confirm(tx, id, key),
      }));
      return sendOutcome(res, outcome);
    } catch (error) {
      // The till sees « refusé » with the first name of the customer (nothing was debited).
      if (error instanceof ApiProblem && error.status === 422) {
        await this.checkouts.recordRefusal(id, error).catch(() => undefined);
      }
      throw error;
    }
  }

  /**
   * Result of a confirmation by its Idempotency-Key (M5): after a network cut the app asks it
   * before trying again, so a payment is never made twice. 404: nothing was done with this key
   * (send the same key again); 409 IDEMPOTENCY_REQUEST_IN_PROGRESS: still running; otherwise the
   * recorded answer (the receipt, or the refusal).
   */
  @Can('payments.pay')
  @Get('checkouts/by-idempotency-key/:key')
  async confirmationByKey(@Param('key') key: string, @Res({ passthrough: true }) res: Response) {
    const found = await this.idempotency.lookup(pathId('key', key).toLowerCase());
    if (found === null) throw problems.notFound();
    if (found.state === 'IN_PROGRESS') {
      throw new ApiProblem(
        409,
        'IDEMPOTENCY_REQUEST_IN_PROGRESS',
        { retryAfterSeconds: 1 },
        {
          'Retry-After': '1',
        },
      );
    }
    const body = found.body as Record<string, unknown> | null;
    // Only the answers of a till confirmation: a receipt of a payment, or a business refusal.
    const receipt = found.status === 200 && body?.type === 'PAYMENT';
    const refusal = found.status === 422 && typeof body?.code === 'string';
    if (!receipt && !refusal) throw problems.notFound();
    res.status(found.status);
    if (refusal) res.setHeader('Content-Type', 'application/problem+json; charset=utf-8');
    return body;
  }

  @Can('wallet.read')
  @Get('notifications')
  notificationsList(@Query() query: Record<string, unknown>) {
    return this.notifications.list(query);
  }

  @Can('wallet.read')
  @Post('notifications/read')
  @HttpCode(204)
  async read(): Promise<void> {
    await this.notifications.markAllRead();
  }
}
