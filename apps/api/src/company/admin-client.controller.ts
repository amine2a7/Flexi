import { Body, Controller, Delete, HttpCode, Inject, Param, Post } from '@nestjs/common';
import { Can, Roles } from '../common/decorators.js';
import { pathId } from '../common/responses.js';
import { parse } from '../common/validation.js';
import { AllocationTemplatesService } from './allocation-templates.service.js';
import { employeeBody } from './company.controller.js';
import { CompanyService } from './company.service.js';

/**
 * « Fiche client » of a company (processus v2): the administrator adds an employee and archives an
 * allocation template, always within the company of the path.
 */
@Roles('ADMIN')
@Controller('v1/admin/companies/:companyId')
export class AdminClientController {
  constructor(
    @Inject(CompanyService) private readonly company: CompanyService,
    @Inject(AllocationTemplatesService) private readonly templates: AllocationTemplatesService,
  ) {}

  @Can('companies.manage')
  @Post('employees')
  @HttpCode(201)
  createEmployee(@Param('companyId') companyId: string, @Body() body: unknown) {
    return this.company.createEmployeeAsAdmin(
      pathId('companyId', companyId),
      parse(employeeBody, body),
    );
  }

  @Can('companies.manage')
  @Delete('allocation-templates/:templateId')
  @HttpCode(204)
  async archiveTemplate(
    @Param('companyId') companyId: string,
    @Param('templateId') templateId: string,
  ): Promise<void> {
    await this.templates.archiveAsAdmin(
      pathId('companyId', companyId),
      pathId('templateId', templateId),
    );
  }
}
