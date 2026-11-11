import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService, type Tx } from '../common/db.service.js';
import { ApiProblem, problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { FILE_STORAGE, type FileStorage } from '../common/storage.js';
import type { KycDocument, KycDocumentType } from '../generated/prisma/client.js';
import { sniffProof } from '../orders/orders.service.js';

/** Catalogue of the documents (processus v2), in display order; the super-admin picks some. */
export const KYC_DOCUMENT_TYPES: readonly KycDocumentType[] = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID',
  'BANK_DETAILS',
  'COMPANY_STATUTES',
  'PROOF_OF_ADDRESS',
];

/** Documents a client files today (settings of the super-admin), in catalogue order. */
export async function requiredDocuments(tx: Tx): Promise<KycDocumentType[]> {
  const row = await tx.platformSettings.findUnique({
    where: { id: 1 },
    select: { kycRequiredDocuments: true },
  });
  const required = row?.kycRequiredDocuments ?? KYC_DOCUMENT_TYPES.slice(0, 4);
  return KYC_DOCUMENT_TYPES.filter((type) => required.includes(type));
}
const MAX_DOCUMENT_BYTES = 5 * 1024 * 1024;

/** Each type with its current document: « à déposer » (MISSING) when there is none. */
export function documentsByType(
  documents: readonly KycDocument[],
  required: readonly KycDocumentType[],
) {
  return required.map((type) => {
    const current = documents.find(
      (document) => document.type === type && document.replacedAt === null,
    );
    return current === undefined
      ? { type, status: 'MISSING' as const }
      : {
          type,
          status: current.status,
          documentId: current.id,
          fileName: current.fileName,
          contentType: current.contentType,
          sizeBytes: current.sizeBytes,
          uploadedAt: current.uploadedAt.toISOString(),
          ...(current.correctionReason === null
            ? {}
            : { correctionReason: current.correctionReason }),
        };
  });
}

/**
 * KYC file of the signed-in company or merchant (processus v2, page « Compte › Mon dossier »): the
 * client files the four documents (PDF or image, 5 MB at most), sees the status of each and files a
 * document again when the administrator asks a correction. Row security keeps it to its own file.
 */
@Injectable()
export class KycService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(FILE_STORAGE) private readonly storage: FileStorage,
  ) {}

  private async current(tx: Tx) {
    const who = principal();
    const file = await tx.kycFile.findFirst({
      where:
        who.companyId !== null
          ? { companyId: who.companyId }
          : who.merchantId !== null
            ? { merchantId: who.merchantId }
            : { id: '00000000-0000-0000-0000-000000000000' },
      orderBy: { submittedAt: 'desc' },
      include: { documents: { orderBy: { uploadedAt: 'asc' } } },
    });
    if (file === null) throw problems.notFound();
    return file;
  }

  private body(
    file: Awaited<ReturnType<KycService['current']>>,
    required: readonly KycDocumentType[],
  ) {
    return {
      id: file.id,
      status: file.status,
      ...(file.rejectionReason === null ? {} : { rejectionReason: file.rejectionReason }),
      documents: documentsByType(file.documents, required),
    };
  }

  async mine() {
    return this.db.user(async (tx) =>
      this.body(await this.current(tx), await requiredDocuments(tx)),
    );
  }

  /** Files (or files again) one document; refused once the file is validated. */
  async upload(
    type: string,
    file: { size: number; buffer: Buffer; originalname: string } | undefined,
  ) {
    if (!(KYC_DOCUMENT_TYPES as readonly string[]).includes(type))
      throw new ApiProblem(400, 'VALIDATION_FAILED', {
        fields: [
          {
            in: 'body',
            pointer: '/type',
            code: 'INVALID_ENUM',
            messageKey: 'errors.field.invalidEnum',
          },
        ],
      });
    if (file === undefined || file.size === 0)
      throw new ApiProblem(400, 'VALIDATION_FAILED', {
        fields: [
          {
            in: 'body',
            pointer: '/document',
            code: 'REQUIRED',
            messageKey: 'errors.field.required',
          },
        ],
      });
    if (file.size > MAX_DOCUMENT_BYTES) throw new ApiProblem(413, 'PAYLOAD_TOO_LARGE');
    const contentType = sniffProof(file.buffer);
    if (contentType === undefined) throw new ApiProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
    const key = await this.storage.put(file.buffer);
    return this.db.user(async (tx) => {
      const found = await this.current(tx);
      await tx.$queryRaw`SELECT id FROM kyc_files WHERE id = ${found.id}::uuid FOR UPDATE`;
      if (found.status === 'APPROVED') throw problems.conflict();
      const documentType = type as KycDocumentType;
      const required = await requiredDocuments(tx);
      // Only a document the super-admin asks for (settings).
      if (!required.includes(documentType))
        throw new ApiProblem(400, 'VALIDATION_FAILED', {
          fields: [
            {
              in: 'body',
              pointer: '/type',
              code: 'INVALID_ENUM',
              messageKey: 'errors.field.invalidEnum',
            },
          ],
        });
      await tx.kycDocument.updateMany({
        where: { fileId: found.id, type: documentType, replacedAt: null },
        data: { replacedAt: new Date() },
      });
      await tx.kycDocument.create({
        data: {
          id: uuidv7(),
          fileId: found.id,
          type: documentType,
          fileName: file.originalname.slice(0, 255) || 'piece',
          contentType,
          sizeBytes: file.size,
          storageKey: key,
        },
      });
      // A refused file goes back to review when the client files again.
      if (found.status === 'REJECTED')
        await tx.kycFile.update({
          where: { id: found.id },
          data: { status: 'PENDING', rejectionReason: null },
        });
      await tx.kycEvent.create({
        data: {
          id: uuidv7(),
          fileId: found.id,
          action: 'DOCUMENT_UPLOADED',
          actorName: principal().displayName,
          reason: documentType,
        },
      });
      await this.audit.record(tx, 'kyc.upload', documentType);
      return this.body(await this.current(tx), required);
    });
  }

  async document(documentId: string) {
    const document = await this.db.user(async (tx) => {
      const found = await this.current(tx);
      return tx.kycDocument.findFirst({ where: { id: documentId, fileId: found.id } });
    });
    if (document === null) throw problems.notFound();
    return {
      data: await this.storage.get(document.storageKey),
      contentType: document.contentType,
      fileName: document.fileName,
    };
  }
}
