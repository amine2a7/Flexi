import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  Post,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Response } from 'express';
import { Can, Roles } from '../common/decorators.js';
import { pathId, sendFile } from '../common/responses.js';
import { KycService } from './kyc.service.js';

/** « Compte › Mon dossier »: the company or the merchant files its own KYC documents. */
@Roles('COMPANY', 'MERCHANT')
@Controller('v1/account/kyc')
export class KycController {
  constructor(@Inject(KycService) private readonly kyc: KycService) {}

  @Can('kyc.submit')
  @Get()
  mine() {
    return this.kyc.mine();
  }

  /** Multipart: `type` (one of the four documents) and `document` (PDF, JPG or PNG, 5 MB). */
  @Can('kyc.submit')
  @Post('documents')
  @HttpCode(201)
  @UseInterceptors(
    FileInterceptor('document', { limits: { fileSize: 5 * 1024 * 1024, files: 1, fields: 2 } }),
  )
  upload(
    @Body() body: Record<string, unknown> | undefined,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    const type = typeof body?.type === 'string' ? body.type : '';
    return this.kyc.upload(type, file);
  }

  @Can('kyc.submit')
  @Get('documents/:documentId')
  async document(@Param('documentId') documentId: string, @Res() res: Response): Promise<void> {
    const file = await this.kyc.document(pathId('documentId', documentId));
    sendFile(res, file.data, file.contentType, file.fileName);
  }
}
