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
  Req,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { pathId, sendFile, sendOutcome } from '../common/responses.js';
import { creditType, email, parse, phoneNumber, positiveMillimes } from '../common/validation.js';
import { OrdersService } from '../orders/orders.service.js';
import { SettingsService } from '../platform/settings.service.js';
import { CompanyService } from './company.service.js';
import { DepartmentsService } from './departments.service.js';
import { UsersService } from '../users/users.service.js';
import { accessReason } from '../users/users.controller.js';

const orderStatus = z.enum([
  'AWAITING_CONFIRMATION',
  'AWAITING_PAYMENT',
  'AWAITING_VALIDATION',
  'VALIDATED',
  'REFUSED',
  'CANCELLED',
]);
const lines = z
  .array(z.strictObject({ creditType, amountMillimes: positiveMillimes }))
  .min(1)
  .max(4);
const ordersQuery = z.object({ status: orderStatus.optional(), creditType: creditType.optional() });
const employeesQuery = z.object({
  status: z.enum(['INVITED', 'ACTIVE', 'SUSPENDED', 'DEACTIVATED']).optional(),
  q: z.string().max(100).optional(),
});
const employeeBody = z.strictObject({
  employeeNumber: z.string().max(20),
  firstName: z.string().max(60),
  lastName: z.string().max(60),
  email: z.union([email, z.string().max(254)]),
  phone: z.union([phoneNumber, z.string().max(16)]),
});
const allocationBody = z.strictObject({
  allocations: z
    .array(z.strictObject({ employeeId: z.uuid(), creditType, amountMillimes: positiveMillimes }))
    .min(1)
    .max(5_000),
});

@Roles('COMPANY')
@Controller('v1/company')
export class CompanyController {
  constructor(
    @Inject(CompanyService) private readonly company: CompanyService,
    @Inject(OrdersService) private readonly orders: OrdersService,
    @Inject(SettingsService) private readonly settings: SettingsService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
    @Inject(UsersService) private readonly users: UsersService,
    @Inject(DepartmentsService) private readonly departments: DepartmentsService,
  ) {}

  @Can('balances.read')
  @Get('dashboard')
  dashboard() {
    return this.company.dashboard();
  }

  @Can('employees.read')
  @Get('employees')
  employees(@Query() query: Record<string, unknown>) {
    return this.company.employees(
      query,
      parse(employeesQuery, { status: query.status, q: query.q }, 'query'),
    );
  }

  @Can('employees.read')
  @Get('departments')
  departmentList() {
    return this.departments.list();
  }

  @Can('employees.manage')
  @Post('departments')
  @HttpCode(201)
  createDepartment(@Body() body: unknown) {
    return this.departments.create(
      parse(z.strictObject({ name: z.string().trim().min(1).max(80) }), body).name,
    );
  }

  @Can('employees.manage')
  @Put('employees/:employeeId/department')
  assignDepartment(@Param('employeeId') employeeId: string, @Body() body: unknown) {
    return this.departments.assign(
      pathId('employeeId', employeeId),
      parse(z.strictObject({ departmentId: z.uuid().nullable() }), body).departmentId,
    );
  }

  @Can('employees.manage')
  @Post('employees')
  @HttpCode(201)
  createEmployee(@Body() body: unknown) {
    return this.company.createEmployee(parse(employeeBody, body));
  }

  @Can('employees.manage')
  @Post('employees/:employeeId/suspend')
  @HttpCode(200)
  async suspendEmployee(@Param('employeeId') employeeId: string, @Body() body: unknown) {
    return this.employeeStatus(employeeId, 'SUSPEND', body);
  }

  @Can('employees.manage')
  @Post('employees/:employeeId/reactivate')
  @HttpCode(200)
  async reactivateEmployee(@Param('employeeId') employeeId: string, @Body() body: unknown) {
    return this.employeeStatus(employeeId, 'REACTIVATE', body);
  }

  @Can('employees.manage')
  @Post('employees/:employeeId/deactivate')
  @HttpCode(200)
  async deactivateEmployee(@Param('employeeId') employeeId: string, @Body() body: unknown) {
    return this.employeeStatus(employeeId, 'DEACTIVATE', body);
  }

  /** Bulk suspend or reactivate of one page (never a bulk deactivation, spec §12.1). */
  @Can('employees.manage')
  @Post('employees/status-changes')
  @HttpCode(200)
  employeesStatus(@Body() body: unknown) {
    const input = parse(
      z.strictObject({
        action: z.enum(['SUSPEND', 'REACTIVATE']),
        employeeIds: z.array(z.uuid()).min(1).max(100),
        reason: accessReason,
      }),
      body,
    );
    return this.users.changeEmployeesStatus(
      [...new Set(input.employeeIds)],
      input.action,
      input.reason,
    );
  }

  private async employeeStatus(
    employeeId: string,
    action: 'SUSPEND' | 'REACTIVATE' | 'DEACTIVATE',
    body: unknown,
  ) {
    const id = pathId('employeeId', employeeId);
    const { reason } = parse(z.strictObject({ reason: accessReason }), body);
    await this.users.changeEmployeeStatus(id, action, reason);
    return this.company.employee(id);
  }

  @Can('employees.manage')
  @Post('employees/import-previews')
  @HttpCode(200)
  previewImport(@Body() body: unknown) {
    return this.company.previewEmployees(
      parse(z.strictObject({ csv: z.string().max(1_048_576) }), body).csv,
    );
  }

  @Can('employees.manage')
  @Post('employees/imports')
  @HttpCode(201)
  confirmImport(@Body() body: unknown) {
    return this.company.confirmImport(
      parse(z.strictObject({ previewId: z.uuid() }), body).previewId,
    );
  }

  @Can('orders.create')
  @Post('order-quotes')
  @HttpCode(200)
  quote(@Body() body: unknown) {
    return this.orders.quote(parse(z.strictObject({ lines }), body).lines);
  }

  @Can('orders.read')
  @Get('orders')
  listOrders(@Query() query: Record<string, unknown>) {
    return this.orders.list(
      query,
      parse(ordersQuery, { status: query.status, creditType: query.creditType }, 'query'),
    );
  }

  @Can('orders.create')
  @Post('orders')
  async createOrder(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const input = parse(z.union([z.strictObject({ quoteId: z.uuid() }), z.strictObject({ lines })]), body);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 201,
      body: await this.orders.create(tx, input),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('orders.read')
  @Get('orders/:orderId')
  order(@Param('orderId') orderId: string) {
    return this.orders.get(pathId('orderId', orderId));
  }

  @Can('orders.create')
  @Post('orders/:orderId/cancel')
  @HttpCode(200)
  cancel(@Param('orderId') orderId: string) {
    return this.orders.cancel(pathId('orderId', orderId));
  }

  @Can('orders.declareTransfer')
  @Post('orders/:orderId/transfer-declarations')
  @UseInterceptors(
    FileInterceptor('proof', { limits: { fileSize: 5 * 1024 * 1024, files: 1, fields: 5 } }),
  )
  async declare(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('orderId') orderId: string,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    const id = pathId('orderId', orderId);
    const input = this.orders.checkDeclaration((req.body ?? {}) as Record<string, unknown>, file);
    const outcome = await this.idempotency.run(req, async (tx) => ({
      status: 201,
      body: await this.orders.declareTransfer(tx, id, input),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('orders.read')
  @Get('orders/:orderId/proof')
  async proof(@Param('orderId') orderId: string, @Res() res: Response): Promise<void> {
    const file = await this.orders.proof(pathId('orderId', orderId));
    sendFile(res, file.data, file.contentType, file.fileName);
  }

  @Can('fundingAccount.read')
  @Get('funding-account')
  fundingAccount() {
    return this.settings.fundingAccount();
  }

  @Can('credits.allocate')
  @Post('allocation-imports/previews')
  @HttpCode(200)
  previewAllocations(@Body() body: unknown) {
    return this.company.previewAllocations(
      parse(z.strictObject({ csv: z.string().max(200_000) }), body).csv,
    );
  }

  @Can('credits.allocate')
  @Post('allocations')
  async allocate(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const input = parse(allocationBody, body);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 201,
      body: await this.company.allocate(tx, input.allocations, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('invoices.read')
  @Get('invoices/:invoiceId/pdf')
  async invoicePdf(@Param('invoiceId') invoiceId: string, @Res() res: Response): Promise<void> {
    const file = await this.company.invoicePdf(pathId('invoiceId', invoiceId));
    sendFile(res, file.data, 'application/pdf', file.fileName);
  }

  @Can('invoices.read')
  @Get('invoices')
  invoices(@Query() query: Record<string, unknown>) {
    return this.company.invoices(query);
  }
}
