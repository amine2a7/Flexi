import { Controller, Get, Inject, Param, Query, Res } from '@nestjs/common';
import type { Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { pathId, sendFile } from '../common/responses.js';
import { parse } from '../common/validation.js';
import { CompanyService } from './company.service.js';

const filters = z.object({
  companyId: z.uuid().optional(),
  status: z.enum(['PAID', 'UNPAID', 'CANCELLED']).optional(),
  q: z.string().max(100).optional(),
});

/** Invoices issued by FlexiPay to the companies (W-FIN): list, detail, PDF. */
@Roles('ADMIN')
@Controller('v1/admin/invoices')
export class AdminInvoicesController {
  constructor(@Inject(CompanyService) private readonly company: CompanyService) {}

  @Can('adminInvoices.read')
  @Get()
  list(@Query() query: Record<string, unknown>) {
    const input = parse(
      filters,
      { companyId: query.companyId, status: query.status, q: query.q },
      'query',
    );
    return this.company.adminInvoices(query, {
      ...(input.companyId === undefined ? {} : { companyId: input.companyId }),
      ...(input.status === undefined ? {} : { status: input.status }),
      ...(input.q === undefined ? {} : { q: input.q }),
    });
  }

  @Can('adminInvoices.read')
  @Get(':invoiceId/pdf')
  async pdf(@Param('invoiceId') invoiceId: string, @Res() res: Response): Promise<void> {
    const file = await this.company.invoicePdf(pathId('invoiceId', invoiceId));
    sendFile(res, file.data, 'application/pdf', file.fileName);
  }

  @Can('adminInvoices.read')
  @Get(':invoiceId')
  detail(@Param('invoiceId') invoiceId: string) {
    return this.company.invoiceDetail(pathId('invoiceId', invoiceId));
  }
}
