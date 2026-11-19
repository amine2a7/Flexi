import { PiiService } from '../common/pii.js';
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
import { DbService } from '../common/db.service.js';
import { Can, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { Paginator } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { pathId, sendFile, sendOutcome } from '../common/responses.js';
import { creditType, parse, positiveMillimes } from '../common/validation.js';
import { PaymentsService } from '../payments/payments.service.js';
import { currentGridInclude, gridBody } from '../platform/commission-grids.js';
import { CREDIT_TYPES } from '../platform/settings.service.js';
import { PayoutsService } from './payouts.service.js';

const paymentStatus = z.enum(['INITIATED', 'CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED']);
const payoutStatus = z.enum(['REQUESTED', 'CHECKED', 'ON_HOLD', 'SENT', 'EXECUTED', 'REJECTED']);

@Roles('MERCHANT')
@Controller('v1/merchant')
export class MerchantController {
  constructor(
    @Inject(PayoutsService) private readonly payouts: PayoutsService,
    @Inject(PaymentsService) private readonly payments: PaymentsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(PiiService) private readonly pii: PiiService,
  ) {}

  @Can('stats.read')
  @Get('dashboard')
  async dashboard() {
    await this.payments.expireStale();
    return this.payouts.dashboard();
  }

  @Can('sales.read', 'sales.readToday')
  @Get('payments')
  list(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: paymentStatus.optional(),
        creditType: creditType.optional(),
        q: z.string().max(100).optional(),
      }),
      { status: query.status, creditType: query.creditType, q: query.q },
      'query',
    );
    return this.payments.merchantPayments(query, filters);
  }

  @Can('payments.collect')
  @Post('payments')
  async initiate(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const input = parse(
      z.strictObject({
        customerCode: z.string().regex(/^[0-9]{8}$/),
        creditType,
        amountMillimes: positiveMillimes,
      }),
      body,
    );
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 201,
      body: await this.payments.initiate(tx, input),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('sales.read', 'sales.readToday')
  @Get('payments/:paymentId')
  detail(@Param('paymentId') paymentId: string) {
    return this.payments.merchantPaymentDetail(pathId('paymentId', paymentId));
  }

  @Can('payments.collect')
  @Post('payments/:paymentId/cancel')
  @HttpCode(200)
  cancel(@Param('paymentId') paymentId: string) {
    return this.payments.cancel(pathId('paymentId', paymentId));
  }

  /** Cancellation of a confirmed payment within the window of the settings (money: key). */
  @Can('payments.refund')
  @Post('payments/:paymentId/refund')
  async refund(
    @Param('paymentId') paymentId: string,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const id = pathId('paymentId', paymentId);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 200,
      body: await this.payments.refundByMerchant(tx, id, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('receivables.read')
  @Get('receivables')
  receivables(@Query() query: Record<string, unknown>) {
    return this.payouts.receivables(
      query,
      parse(
        z.object({
          creditType: creditType.optional(),
          q: z.string().trim().max(100).optional(),
        }),
        { creditType: query.creditType, q: query.q },
        'query',
      ),
    );
  }

  @Can('payouts.request')
  @Post('payout-quotes')
  @HttpCode(200)
  quote(@Body() body: unknown) {
    return this.payouts.quote(
      parse(z.strictObject({ creditType, grossMillimes: positiveMillimes }), body),
    );
  }

  @Can('payouts.read')
  @Get('payouts')
  payoutList(@Query() query: Record<string, unknown>) {
    return this.payouts.merchantPayouts(
      query,
      parse(
        z.object({ status: payoutStatus.optional(), creditType: creditType.optional() }),
        { status: query.status, creditType: query.creditType },
        'query',
      ),
    );
  }

  @Can('payouts.request')
  @Post('payouts')
  async requestPayout(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const { quoteId } = parse(z.strictObject({ quoteId: z.uuid() }), body);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 201,
      body: await this.payouts.request(tx, quoteId, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('payouts.read')
  @Get('payouts/:payoutId/invoice')
  async payoutInvoice(@Param('payoutId') payoutId: string, @Res() res: Response): Promise<void> {
    const file = await this.payouts.commissionInvoice(pathId('payoutId', payoutId));
    sendFile(res, file.data, 'application/pdf', file.fileName);
  }

  @Can('payouts.read')
  @Get('payouts/:payoutId')
  payout(@Param('payoutId') payoutId: string) {
    return this.payouts.merchantPayout(pathId('payoutId', payoutId));
  }

  @Can('settlements.read')
  @Get('settlements')
  settlements(@Query() query: Record<string, unknown>) {
    return this.payouts.merchantSettlements(query, parse(
      z.object({ q: z.string().trim().max(100).optional() }),
      { q: query.q },
      'query',
    ).q);
  }

  @Can('documents.read')
  @Get('documents')
  async documents(@Query() query: Record<string, unknown>) {
    const request = this.paginator.request(query, {});
    return this.db.user(async (tx) => {
      const rows = await tx.merchantDocument.findMany({
        orderBy: [{ issuedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.merchantDocument.count({ take: 10_001 })
        : undefined;
      return this.paginator.page(
        request,
        rows.map((row) => ({
          id: row.id,
          type: row.type,
          period: row.period,
          issuedAt: row.issuedAt.toISOString(),
        })),
        {},
        count,
      );
    });
  }

  @Can('shop.read')
  @Get('profile')
  async profile() {
    const merchantId = principal().merchantId;
    if (merchantId === null) throw problems.forbidden();
    return this.db.user(async (tx) => {
      const merchant = await tx.merchant.findUniqueOrThrow({
        where: { id: merchantId },
        include: {
          commissionGrids: currentGridInclude,
          pointsOfSale: { orderBy: { name: 'asc' } },
          users: { orderBy: { displayName: 'asc' } },
        },
      });
      return {
        name: merchant.name,
        category: merchant.category,
        city: merchant.city,
        address: merchant.address,
        phone: this.pii.open(merchant.phone),
        maskedIban: merchant.iban === null ? '' : this.pii.maskedIban(merchant.iban),
        paymentCode: merchant.paymentCode,
        acceptedCreditTypes: CREDIT_TYPES.filter((type) =>
          merchant.acceptedCreditTypes.includes(type),
        ),
        commissionGrid: gridBody(merchant.commissionGrids),
        pointsOfSale: merchant.pointsOfSale.map((point) => ({
          id: point.id,
          name: point.name,
          city: point.city,
        })),
        staff: merchant.users.map((user) => ({
          id: user.id,
          displayName: user.displayName,
          subRole: user.subRole ?? 'OWNER',
        })),
      };
    });
  }
}
