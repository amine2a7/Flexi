import { Controller, Get, Inject, Query, Res } from '@nestjs/common';
import type { Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { sendFile } from '../common/responses.js';
import { parse } from '../common/validation.js';
import { LedgerAdminService, type LedgerFilters } from './ledger-admin.service.js';

const filters = z
  .object({
    clientType: z.enum(['COMPANY', 'MERCHANT']).optional(),
    clientId: z.uuid().optional(),
    transactionType: z
      .string()
      .regex(/^[A-Z][A-Z_]{1,39}$/)
      .optional(),
    createdFrom: z.iso.datetime({ offset: true }).optional(),
    createdTo: z.iso.datetime({ offset: true }).optional(),
    // W-SUP-bis: reference of the transaction (or its account code).
    q: z.string().trim().min(1).max(100).optional(),
  })
  // A client is a type and an id together.
  .refine((value) => (value.clientId === undefined) === (value.clientType === undefined), {
    path: ['clientId'],
  });

function read(query: Record<string, unknown>) {
  const input = parse(
    filters,
    {
      clientType: query.clientType,
      clientId: query.clientId,
      transactionType: query.transactionType,
      createdFrom: query.createdFrom,
      createdTo: query.createdTo,
      q: query.q,
    },
    'query',
  );
  const selected: LedgerFilters = {
    ...(input.clientType === undefined ? {} : { clientType: input.clientType }),
    ...(input.clientId === undefined ? {} : { clientId: input.clientId }),
    ...(input.transactionType === undefined ? {} : { transactionType: input.transactionType }),
    ...(input.q === undefined ? {} : { q: input.q }),
  };
  const period = {
    ...(input.createdFrom === undefined ? {} : { createdFrom: new Date(input.createdFrom) }),
    ...(input.createdTo === undefined ? {} : { createdTo: new Date(input.createdTo) }),
  };
  return { selected, period };
}

/** General ledger of the platform (W-FIN), read only: Finance and the super-admin. */
@Roles('ADMIN')
@Controller('v1/admin/ledger-entries')
export class LedgerAdminController {
  constructor(@Inject(LedgerAdminService) private readonly ledger: LedgerAdminService) {}

  @Can('ledger.read')
  @Get()
  async list(@Query() query: Record<string, unknown>) {
    const { selected } = read(query);
    await this.ledger.checkClient(selected);
    return this.ledger.list(query, selected);
  }

  @Can('ledger.read')
  @Get('types')
  types() {
    return this.ledger.types();
  }

  @Can('ledger.read')
  @Get('export')
  async export(@Query() query: Record<string, unknown>, @Res() res: Response): Promise<void> {
    const { selected, period } = read(query);
    await this.ledger.checkClient(selected);
    const file = await this.ledger.exportCsv(selected, period);
    sendFile(res, file.data, 'text/csv; charset=utf-8', file.fileName);
  }
}
