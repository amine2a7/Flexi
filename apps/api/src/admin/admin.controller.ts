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
import { ContactService } from '../contact/contact.service.js';
import { Can, Public, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { pathId, sendFile, sendOutcome } from '../common/responses.js';
import {
  creditType,
  email,
  millimes,
  parse,
  phoneNumber,
  positiveMillimes,
  rateBps,
  reason,
} from '../common/validation.js';
import { commissionGridSchema } from '@flexipay/shared';
import { SettingsService } from '../platform/settings.service.js';
import { AdminService } from './admin.service.js';

const accountStatus = z.enum(['PENDING_KYC', 'APPROVED', 'REJECTED', 'SUSPENDED']);
const category = z.enum([
  'RESTAURANT',
  'CAFE',
  'GROCERY',
  'BAKERY',
  'FAST_FOOD',
  'CLOTHING',
  'FUEL_STATION',
  'GIFT_SHOP',
]);
const types = z.array(creditType).min(1).max(4);
/** Legal form, required when a client is created (processus v2): drives the withholding rate. */
const legalForm = z.enum(['PP_CIN', 'PP_MF', 'PM_MF']);
const listQuery = z.object({ status: accountStatus.optional(), q: z.string().max(100).optional() });
const name = z.string().trim().min(1).max(200);
const city = z.string().trim().min(1).max(80);
const settingsBody = z.strictObject({
  settings: z.strictObject({
    payoutMinimumMillimes: millimes,
    creditValidityMonths: z.number().int().min(1).max(60),
    maxFamilyMembers: z.number().int().min(0).max(10),
    orderFeeRateBps: rateBps,
    vatRateBps: rateBps,
    stampDutyMillimes: millimes,
    // Processus v2: withholding tax per legal form above a threshold, transfer fee.
    withholding: z
      .strictObject({
        thresholdMillimes: millimes,
        ppCinBps: rateBps,
        ppMfBps: rateBps,
        pmMfBps: rateBps,
      })
      .optional(),
    transferFeeMillimes: millimes.optional(),
    expiredCreditsDestination: z.enum(['PLATFORM_REVENUE', 'COMPANY_RETURN']),
    // A Tunisian IBAN is TN59 followed by the RIB: both must name the same account (S-PA-01).
    fundingAccount: z
      .strictObject({
        bankName: z.string().trim().min(1).max(120),
        holder: z.string().trim().min(1).max(120),
        rib: z.string().regex(/^[0-9]{20}$/),
        iban: z.string().regex(/^TN[0-9]{22}$/),
      })
      .refine((account) => account.iban === `TN59${account.rib}`, {
        path: ['iban'],
        params: { fieldCode: 'INVALID_FORMAT' },
      }),
    secondValidationThresholdMillimes: positiveMillimes,
    quoteValidityDays: z.number().int().min(1).max(90),
    invitationValidityDays: z.number().int().min(1).max(30),
    otpValidityMinutes: z.number().int().min(1).max(30),
    pinLockMinutes: z.array(z.number().int().min(1).max(1440)).min(1).max(5),
    paymentCancelHours: z.number().int().min(0).max(72),
    settlementDelayDays: z.number().int().min(1).max(10),
    creditTypes: z
      .array(
        z.strictObject({
          creditType,
          enabled: z.boolean(),
          commissionRateBps: rateBps,
          validityMonths: z.number().int().min(1).max(60),
          dailyLimitMillimes: positiveMillimes,
        }),
      )
      .length(4),
  }),
  reason,
});

@Roles('ADMIN')
@Controller('v1/admin')
export class AdminController {
  constructor(
    @Inject(AdminService) private readonly admin: AdminService,
    @Inject(ContactService) private readonly contact: ContactService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('dashboard.read')
  @Get('dashboard')
  dashboard() {
    return this.admin.dashboard();
  }

  @Can('accounts.read')
  @Get('merchants')
  merchants(@Query() query: Record<string, unknown>) {
    return this.admin.merchants(
      query,
      parse(listQuery, { status: query.status, q: query.q }, 'query'),
    );
  }

  @Can('merchants.manage')
  @Post('merchants')
  @HttpCode(201)
  createMerchant(@Body() body: unknown) {
    return this.admin.createMerchant(
      parse(
        z.strictObject({
          name,
          legalForm,
          category,
          city,
          phone: phoneNumber,
          email,
          commissionGrid: commissionGridSchema,
          acceptedCreditTypes: types,
        }),
        body,
      ),
    );
  }

  @Can('accounts.read')
  @Get('merchants/:merchantId')
  merchant(@Param('merchantId') merchantId: string) {
    return this.admin.merchant(pathId('merchantId', merchantId));
  }

  @Can('merchants.manage')
  @Put('merchants/:merchantId/credit-types')
  setTypes(@Param('merchantId') merchantId: string, @Body() body: unknown) {
    return this.admin.setMerchantTypes(
      pathId('merchantId', merchantId),
      parse(z.strictObject({ acceptedCreditTypes: types }), body).acceptedCreditTypes,
    );
  }

  @Can('accounts.read')
  @Get('merchants/:merchantId/record')
  merchantRecord(@Param('merchantId') merchantId: string) {
    return this.admin.accountRecord({ merchantId: pathId('merchantId', merchantId) });
  }

  @Can('merchants.manage')
  @Patch('merchants/:merchantId')
  updateMerchant(@Param('merchantId') merchantId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({
        name: name.optional(),
        category: category.optional(),
        city: city.optional(),
        address: z.string().trim().max(200).optional(),
        phone: phoneNumber.optional(),
        email: email.optional(),
        reason: reason.optional(),
      }),
      body,
    );
    const { reason: why, ...fields } = input;
    return this.admin.updateAccount({ merchantId: pathId('merchantId', merchantId) }, fields, why);
  }

  @Can('merchants.manage')
  @Post('merchants/:merchantId/iban-change-requests')
  @HttpCode(201)
  ibanChangeRequest(@Param('merchantId') merchantId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({ iban: z.string().regex(/^TN[0-9]{22}$/), reason }),
      body,
    );
    return this.admin.requestIbanChange(pathId('merchantId', merchantId), input.iban, input.reason);
  }

  @Can('accounts.read')
  @Get('companies/:companyId/record')
  companyRecord(@Param('companyId') companyId: string) {
    return this.admin.accountRecord({ companyId: pathId('companyId', companyId) });
  }

  @Can('companies.manage')
  @Patch('companies/:companyId')
  updateCompany(@Param('companyId') companyId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({
        name: name.optional(),
        city: city.optional(),
        phone: phoneNumber.optional(),
        email: email.optional(),
        reason: reason.optional(),
      }),
      body,
    );
    const { reason: why, ...fields } = input;
    return this.admin.updateAccount({ companyId: pathId('companyId', companyId) }, fields, why);
  }

  @Can('accounts.read')
  @Get('companies')
  companies(@Query() query: Record<string, unknown>) {
    return this.admin.companies(
      query,
      parse(listQuery, { status: query.status, q: query.q }, 'query'),
    );
  }

  @Can('companies.manage')
  @Post('companies')
  @HttpCode(201)
  createCompany(@Body() body: unknown) {
    return this.admin.createCompany(
      parse(
        z.strictObject({
          name,
          legalForm,
          city,
          phone: phoneNumber,
          email,
          commissionGrid: commissionGridSchema,
        }),
        body,
      ),
    );
  }

  @Can('commissions.request')
  @Post('commission-grids/change-requests')
  @HttpCode(201)
  gridChangeRequest(@Body() body: unknown) {
    const input = parse(
      z.union([
        z.strictObject({ companyId: z.uuid(), tiers: commissionGridSchema, reason }),
        z.strictObject({ merchantId: z.uuid(), tiers: commissionGridSchema, reason }),
      ]),
      body,
    );
    return this.admin.requestGridChange(
      'companyId' in input ? { companyId: input.companyId } : { merchantId: input.merchantId },
      input.tiers,
      input.reason,
    );
  }

  @Can('payouts.decide')
  @Post('settlements/:batchId/release-requests')
  @HttpCode(201)
  batchReleaseRequest(@Param('batchId') batchId: string, @Body() body: unknown) {
    const input = parse(z.strictObject({ reason }), body);
    return this.admin.requestBatchRelease(pathId('batchId', batchId), input.reason);
  }

  @Can('approvals.read')
  @Get('approvals')
  approvals(@Query() query: Record<string, unknown>) {
    return this.admin.approvals(
      query,
      parse(
        z.object({ status: z.enum(['PENDING', 'APPROVED', 'REJECTED']).optional() }),
        { status: query.status },
        'query',
      ),
    );
  }

  @Can('approvals.decide')
  @Post('approvals/:approvalId/approve')
  @HttpCode(200)
  async approve(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('approvalId') approvalId: string,
  ) {
    const id = pathId('approvalId', approvalId);
    if ((await this.admin.approvalType(id)) !== 'DISPUTE_REFUND') return this.admin.approve(id);
    // A dispute refund moves money: the Idempotency-Key is required (rule 4, ledger-auditor N2-2).
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 200,
      body: await this.admin.approveIn(tx, id),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('approvals.decide')
  @Post('approvals/:approvalId/reject')
  @HttpCode(200)
  reject(@Param('approvalId') approvalId: string, @Body() body: unknown) {
    return this.admin.reject(
      pathId('approvalId', approvalId),
      parse(z.strictObject({ reason }), body).reason,
    );
  }

  @Can('transactions.read')
  @Get('transactions')
  transactions(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: z.enum(['INITIATED', 'CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED']).optional(),
        creditType: creditType.optional(),
        q: z.string().max(100).optional(),
      }),
      { status: query.status, creditType: query.creditType, q: query.q },
      'query',
    );
    return this.admin.transactions(query, filters);
  }

  @Can('audit.read')
  @Get('audit-logs')
  audit(@Query() query: Record<string, unknown>) {
    return this.admin.auditLogs(
      query,
      parse(z.object({ q: z.string().max(100).optional() }), { q: query.q }, 'query'),
    );
  }

  @Can('settings.read')
  @Get('settings')
  settings() {
    return this.admin.platformSettings();
  }

  @Can('settings.request')
  @Put('settings')
  @HttpCode(202)
  changeSettings(@Body() body: unknown) {
    const input = parse(settingsBody, body);
    return this.admin.requestSettingsChange(input.settings, input.reason);
  }

  @Can('kyc.read')
  @Get('kyc-files')
  kycFiles(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: z.enum(['PENDING', 'APPROVED', 'REJECTED']).optional(),
        accountType: z.enum(['MERCHANT', 'COMPANY']).optional(),
      }),
      { status: query.status, accountType: query.accountType },
      'query',
    );
    return this.admin.kycFiles(query, filters);
  }

  @Can('kyc.read')
  @Get('kyc-files/:fileId')
  kycFile(@Param('fileId') fileId: string) {
    return this.admin.kycFile(pathId('fileId', fileId));
  }

  @Can('kycDocuments.read')
  @Get('kyc-files/:fileId/documents/:documentId')
  async kycDocument(
    @Param('fileId') fileId: string,
    @Param('documentId') documentId: string,
    @Res() res: Response,
  ): Promise<void> {
    const file = await this.admin.kycDocument(
      pathId('fileId', fileId),
      pathId('documentId', documentId),
    );
    sendFile(res, file.data, file.contentType, file.fileName);
  }

  @Can('kyc.decide')
  @Post('kyc-files/:fileId/approve')
  @HttpCode(200)
  approveKyc(@Param('fileId') fileId: string) {
    return this.admin.decideKyc(pathId('fileId', fileId), 'APPROVED');
  }

  @Can('kyc.decide')
  @Post('kyc-files/:fileId/corrections')
  @HttpCode(200)
  requestKycCorrections(@Param('fileId') fileId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({
        corrections: z
          .array(z.strictObject({ documentId: z.uuid(), reason }))
          .min(1)
          .max(4),
      }),
      body,
    );
    return this.admin.requestKycCorrections(pathId('fileId', fileId), input.corrections);
  }

  @Can('kyc.decide')
  @Post('kyc-files/:fileId/reject')
  @HttpCode(200)
  rejectKyc(@Param('fileId') fileId: string, @Body() body: unknown) {
    return this.admin.decideKyc(
      pathId('fileId', fileId),
      'REJECTED',
      parse(z.strictObject({ reason }), body).reason,
    );
  }

  @Can('messages.read')
  @Get('contact-messages')
  messages(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: z.enum(['NEW', 'HANDLED']).optional(),
        requesterType: z.enum(['COMPANY', 'MERCHANT', 'OTHER']).optional(),
        q: z.string().max(100).optional(),
      }),
      { status: query.status, requesterType: query.requesterType, q: query.q },
      'query',
    );
    return this.contact.list(query, filters);
  }

  @Can('messages.read')
  @Get('contact-messages/:messageId')
  message(@Param('messageId') messageId: string) {
    return this.contact.get(pathId('messageId', messageId));
  }

  @Can('messages.handle')
  @Post('contact-messages/:messageId/handle')
  @HttpCode(200)
  handle(@Param('messageId') messageId: string, @Body() body: unknown) {
    return this.contact.handle(
      pathId('messageId', messageId),
      parse(z.strictObject({ note: z.string().max(500).optional() }), body ?? {}).note,
    );
  }
}

/** Public "Contact us" form of the home page (contract: public, rate limited). */
@Controller('v1/public')
export class PublicController {
  constructor(
    @Inject(ContactService) private readonly contact: ContactService,
    @Inject(SettingsService) private readonly settings: SettingsService,
  ) {}

  /**
   * Terms of the platform shown in the texts of the pages (settlement cycle, validities...):
   * values of the settings, never written in the web (request of 2026-11-05). Nothing sensitive.
   */
  @Public()
  @Get('terms')
  terms() {
    return this.settings.terms();
  }

  @Public()
  @Post('contact-messages')
  @HttpCode(202)
  create(@Body() body: unknown) {
    return this.contact.create(
      parse(
        z.strictObject({
          name: z.string().trim().min(2).max(120),
          email,
          phone: phoneNumber.optional(),
          companyName: z.string().max(200).optional(),
          requesterType: z.enum(['COMPANY', 'MERCHANT', 'OTHER']),
          message: z.string().trim().min(10).max(2000),
        }),
        body,
      ),
    );
  }
}
