import {
  Body,
  Controller,
  Delete,
  Get,
  Inject,
  Param,
  Post,
  Put,
  Req,
  Res,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { IdempotencyService } from '../common/idempotency.service.js';
import { pathId, sendOutcome } from '../common/responses.js';
import { creditType, parse, phoneNumber, positiveMillimes } from '../common/validation.js';
import { FamilyService } from './family.service.js';

const memberBody = z.strictObject({
  firstName: z.string().trim().min(1).max(60),
  lastName: z.string().trim().min(1).max(60),
  relationship: z.enum(['SPOUSE', 'CHILD', 'PARENT']),
  phone: phoneNumber,
});
const transferBody = z.strictObject({
  memberId: z.uuid(),
  creditType,
  amountMillimes: positiveMillimes,
  dailyLimitMillimes: positiveMillimes.nullable(),
  endsOn: z.iso.date().nullable(),
});
const reclaimBody = z.strictObject({ creditType: creditType.nullable() });

/** « Ma famille » of a beneficiary (processus v2): members, transfers, take back, delete. */
@Roles('EMPLOYEE')
@Controller('v1/employee/family')
export class FamilyController {
  constructor(
    @Inject(FamilyService) private readonly family: FamilyService,
    @Inject(IdempotencyService) private readonly idempotency: IdempotencyService,
  ) {}

  @Can('family.manage')
  @Get()
  list() {
    return this.family.list();
  }

  @Can('family.manage')
  @Post('members')
  create(@Body() body: unknown) {
    return this.family.create(parse(memberBody, body));
  }

  @Can('family.manage')
  @Post('transfers')
  async transfer(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    const input = parse(transferBody, body);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 201,
      body: await this.family.transfer(tx, input, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('family.manage')
  @Post('members/:memberId/reclaim')
  async reclaim(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('memberId') memberId: string,
    @Body() body: unknown,
  ) {
    const id = pathId('memberId', memberId);
    const input = parse(reclaimBody, body);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 200,
      body: await this.family.reclaim(tx, id, input.creditType, key),
    }));
    return sendOutcome(res, outcome);
  }

  @Can('family.manage')
  @Delete('members/:memberId')
  async remove(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Param('memberId') memberId: string,
  ) {
    const id = pathId('memberId', memberId);
    const outcome = await this.idempotency.run(req, async (tx, key) => ({
      status: 200,
      body: await this.family.remove(tx, id, key),
    }));
    if (outcome.status === 200) await this.family.closeAccount(id);
    return sendOutcome(res, outcome);
  }
}

/** The company switches family accounts on or off for its employees (processus v2). */
@Roles('COMPANY')
@Controller('v1/company/family-accounts')
export class CompanyFamilyController {
  constructor(@Inject(FamilyService) private readonly family: FamilyService) {}

  @Can('employees.read')
  @Get()
  get() {
    return this.family.enabled();
  }

  @Can('employees.manage')
  @Put()
  set(@Body() body: unknown) {
    return this.family.setEnabled(parse(z.strictObject({ enabled: z.boolean() }), body).enabled);
  }
}
