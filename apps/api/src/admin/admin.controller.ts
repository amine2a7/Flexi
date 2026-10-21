import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  Post,
  Put,
  Query,
  Res,
} from '@nestjs/common';
import type { Response } from 'express';
import { z } from 'zod';
import { ContactService } from '../contact/contact.service.js';
import { Can, Public, Roles } from '../common/decorators.js';
import { pathId, sendFile } from '../common/responses.js';
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
const listQuery = z.object({ status: accountStatus.optional(), q: z.string().max(100).optional() });
const name = z.string().trim().min(1).max(200);
const city = z.string().trim().min(1).max(80);
const settingsBody = z.strictObject({
  settings: z.strictObject({
    payoutMinimumMillimes: millimes,
    creditValidityMonths: z.number().int().min(1).max(60),
    maxFamilyMembers: z.number().int().min(0).max(10),
    orderFeeRateBps: rateBps,
    expiredCreditsDestination: z.enum(['PLATFORM_REVENUE', 'COMPANY_RETURN']),
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
  ) {}

  @Can('platform.read')
  @Get('dashboard')
  dashboard() {
    return this.admin.dashboard();
  }

  @Can('platform.read')
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
          category,
          city,
          phone: phoneNumber,
          email,
          commissionProfileId: z.uuid().optional(),
          acceptedCreditTypes: types,
        }),
        body,
      ),
    );
  }

  @Can('platform.read')
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

  @Can('platform.read')
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
      parse(z.strictObject({ name, city, phone: phoneNumber, email }), body),
    );
  }

  @Can('platform.read')
  @Get('commission-profiles')
  profiles() {
    return this.admin.profiles();
  }

  @Can('commissions.request')
  @Post('commission-profiles/:profileId/change-requests')
  @HttpCode(201)
  changeRequest(@Param('profileId') profileId: string, @Body() body: unknown) {
    const input = parse(z.strictObject({ newRateBps: rateBps, reason }), body);
    return this.admin.requestCommissionChange(
      pathId('profileId', profileId),
      input.newRateBps,
      input.reason,
    );
  }

  @Can('platform.read')
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
  approve(@Param('approvalId') approvalId: string) {
    return this.admin.approve(pathId('approvalId', approvalId));
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

  @Can('platform.read')
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

  @Can('platform.read')
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

  @Can('platform.read')
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

  @Can('platform.read')
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
  @Post('kyc-files/:fileId/reject')
  @HttpCode(200)
  rejectKyc(@Param('fileId') fileId: string, @Body() body: unknown) {
    return this.admin.decideKyc(
      pathId('fileId', fileId),
      'REJECTED',
      parse(z.strictObject({ reason }), body).reason,
    );
  }

  @Can('platform.read')
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

  @Can('platform.read')
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
  constructor(@Inject(ContactService) private readonly contact: ContactService) {}

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
