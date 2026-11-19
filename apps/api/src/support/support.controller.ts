import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  Post,
  Query,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { pathId, sendFile } from '../common/responses.js';
import { parse, queryBoolean } from '../common/validation.js';
import { MAX_PIECE_BYTES, SupportService } from './support.service.js';

export const ticketCategory = z.enum([
  'PAYMENT_DECLINED',
  'DISPUTED_TRANSACTION',
  'ACCOUNT_ACCESS',
  'ORDER_TRANSFER',
  'PAYOUT',
  'KYC',
  'OTHER',
]);
export const ticketStatus = z.enum([
  'OPEN',
  'IN_PROGRESS',
  'WAITING_CUSTOMER',
  'RESOLVED',
  'CLOSED',
]);
export const ticketTeam = z.enum(['SUPPORT', 'FINANCE', 'OPERATIONS']);
const searchText = z.string().trim().max(100).optional();

/** Multipart or JSON: the fields are strings (multipart), an empty optional field is absent. */
const blankToUndefined = (value: unknown) =>
  typeof value === 'string' && value.trim() === '' ? undefined : value;

const createBody = z.strictObject({
  category: ticketCategory,
  subject: z.string().trim().min(3).max(160),
  description: z.string().trim().min(10).max(4000),
  linkType: z.preprocess(blankToUndefined, z.enum(['PAYMENT', 'ORDER', 'PAYOUT']).optional()),
  linkId: z.preprocess(blankToUndefined, z.uuid().optional()),
});

const replyBody = z.strictObject({ body: z.string().trim().min(1).max(4000) });

export const linkQuery = z.strictObject({
  expires: z.coerce.number().int().positive(),
  signature: z.string().regex(/^[A-Za-z0-9_-]{43}$/),
});

export const pieceInterceptor = () =>
  FileInterceptor('attachment', { limits: { fileSize: MAX_PIECE_BYTES, files: 1, fields: 8 } });

/**
 * Support tickets of the signed-in client (W-SUP): every role and sub-role of a company or a
 * merchant, and the beneficiaries (apps). Each user sees its tickets; the owner sees those of its
 * company or shop.
 */
@Roles('COMPANY', 'MERCHANT', 'EMPLOYEE', 'FAMILY_MEMBER')
@Controller('v1/support/tickets')
export class SupportController {
  constructor(@Inject(SupportService) private readonly support: SupportService) {}

  @Can('support.use')
  @Get()
  list(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({ status: ticketStatus.optional(), q: searchText }),
      { status: query.status, q: query.q },
      'query',
    );
    return this.support.list(query, filters);
  }

  /** Multipart (`attachment`: PDF, JPG or PNG, 5 MB) or JSON without a piece. */
  @Can('support.use')
  @Post()
  @HttpCode(201)
  @UseInterceptors(pieceInterceptor())
  create(@Body() body: unknown, @UploadedFile() file: Express.Multer.File | undefined) {
    return this.support.create(parse(createBody, body ?? {}), file);
  }

  @Can('support.use')
  @Get(':ticketId')
  detail(@Param('ticketId') ticketId: string) {
    return this.support.detail(pathId('ticketId', ticketId));
  }

  @Can('support.use')
  @Post(':ticketId/messages')
  @HttpCode(201)
  @UseInterceptors(pieceInterceptor())
  reply(
    @Param('ticketId') ticketId: string,
    @Body() body: unknown,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    const input = parse(replyBody, body ?? {});
    return this.support.reply(pathId('ticketId', ticketId), input.body, file);
  }

  @Can('support.use')
  @Post(':ticketId/reopen')
  @HttpCode(200)
  reopen(@Param('ticketId') ticketId: string) {
    return this.support.reopen(pathId('ticketId', ticketId));
  }

  /** Signed link to a piece (5 minutes, for this user only). */
  @Can('support.use')
  @Get(':ticketId/attachments/:attachmentId/link')
  link(@Param('ticketId') ticketId: string, @Param('attachmentId') attachmentId: string) {
    return this.support.attachmentLink(
      pathId('ticketId', ticketId),
      pathId('attachmentId', attachmentId),
      false,
    );
  }

  @Can('support.use')
  @Get(':ticketId/attachments/:attachmentId')
  async attachment(
    @Param('ticketId') ticketId: string,
    @Param('attachmentId') attachmentId: string,
    @Query() query: Record<string, unknown>,
    @Res() res: Response,
  ): Promise<void> {
    const file = await this.support.attachment(
      pathId('ticketId', ticketId),
      pathId('attachmentId', attachmentId),
      parse(linkQuery, query, 'query'),
      false,
    );
    sendFile(res, file.data, file.contentType, file.fileName);
  }
}

const agentReplyBody = z.strictObject({
  body: z.string().trim().min(1).max(4000),
  internal: z.preprocess(
    (value) => (value === 'true' ? true : value === 'false' ? false : value),
    z.boolean().default(false),
  ),
  waitingCustomer: z.preprocess(
    (value) => (value === 'true' ? true : value === 'false' ? false : value),
    z.boolean().default(false),
  ),
});

/**
 * Queue of the support tickets (W-SUP), every administrator: Support answers, assigns and
 * transfers to Finance or Opérations. Nothing here moves money: the linked operation is read only.
 */
@Roles('ADMIN')
@Controller('v1/admin/support-tickets')
export class AdminSupportController {
  constructor(@Inject(SupportService) private readonly support: SupportService) {}

  @Can('tickets.read')
  @Get()
  queue(@Query() query: Record<string, unknown>) {
    const filters = parse(
      z.object({
        status: ticketStatus.optional(),
        category: ticketCategory.optional(),
        priority: z.enum(['NORMAL', 'HIGH']).optional(),
        team: ticketTeam.optional(),
        assignee: z.union([z.enum(['me', 'none']), z.uuid()]).optional(),
        overdue: queryBoolean.optional(),
        q: searchText,
      }),
      {
        status: query.status,
        category: query.category,
        priority: query.priority,
        team: query.team,
        assignee: query.assignee,
        overdue: query.overdue,
        q: query.q,
      },
      'query',
    );
    return this.support.queue(query, filters);
  }

  @Can('tickets.read')
  @Get('stats')
  stats() {
    return this.support.stats();
  }

  @Can('tickets.read')
  @Get('agents')
  agents(@Query() query: Record<string, unknown>) {
    const { team } = parse(z.object({ team: ticketTeam }), { team: query.team }, 'query');
    return this.support.agents(team);
  }

  @Can('tickets.read')
  @Get(':ticketId')
  detail(@Param('ticketId') ticketId: string) {
    return this.support.agentDetail(pathId('ticketId', ticketId));
  }

  /** Answer to the client, or internal note (`internal`); multipart with a piece, or JSON. */
  @Can('tickets.manage')
  @Post(':ticketId/messages')
  @HttpCode(201)
  @UseInterceptors(pieceInterceptor())
  reply(
    @Param('ticketId') ticketId: string,
    @Body() body: unknown,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    return this.support.agentReply(
      pathId('ticketId', ticketId),
      parse(agentReplyBody, body ?? {}),
      file,
    );
  }

  @Can('tickets.manage')
  @Post(':ticketId/assignment')
  @HttpCode(200)
  assign(@Param('ticketId') ticketId: string, @Body() body: unknown) {
    const input = parse(z.strictObject({ assigneeId: z.uuid().nullable() }), body);
    return this.support.assign(pathId('ticketId', ticketId), input.assigneeId);
  }

  @Can('tickets.manage')
  @Post(':ticketId/transfer')
  @HttpCode(200)
  transfer(@Param('ticketId') ticketId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({ team: ticketTeam, note: z.string().trim().max(4000).optional() }),
      body,
    );
    return this.support.transfer(pathId('ticketId', ticketId), input.team, input.note);
  }

  @Can('tickets.manage')
  @Post(':ticketId/status')
  @HttpCode(200)
  status(@Param('ticketId') ticketId: string, @Body() body: unknown) {
    const input = parse(
      z.strictObject({ status: z.enum(['IN_PROGRESS', 'WAITING_CUSTOMER', 'RESOLVED', 'CLOSED']) }),
      body,
    );
    return this.support.setStatus(pathId('ticketId', ticketId), input.status);
  }

  @Can('tickets.read')
  @Get(':ticketId/attachments/:attachmentId/link')
  link(@Param('ticketId') ticketId: string, @Param('attachmentId') attachmentId: string) {
    return this.support.attachmentLink(
      pathId('ticketId', ticketId),
      pathId('attachmentId', attachmentId),
      true,
    );
  }

  @Can('tickets.read')
  @Get(':ticketId/attachments/:attachmentId')
  async attachment(
    @Param('ticketId') ticketId: string,
    @Param('attachmentId') attachmentId: string,
    @Query() query: Record<string, unknown>,
    @Res() res: Response,
  ): Promise<void> {
    const file = await this.support.attachment(
      pathId('ticketId', ticketId),
      pathId('attachmentId', attachmentId),
      parse(linkQuery, query, 'query'),
      true,
    );
    sendFile(res, file.data, file.contentType, file.fileName);
  }
}
