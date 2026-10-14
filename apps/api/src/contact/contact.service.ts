import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { uuidv7 } from '../common/crypto.js';
import { DbService } from '../common/db.service.js';
import { Paginator } from '../common/pagination.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import type {
  ContactMessage,
  ContactMessageStatus,
  ContactRequesterType,
  Prisma,
} from '../generated/prisma/client.js';

function body(message: ContactMessage) {
  return {
    id: message.id,
    reference: message.reference,
    name: message.name,
    email: message.email,
    phone: message.phone,
    companyName: message.companyName,
    requesterType: message.requesterType,
    message: message.message,
    status: message.status,
    receivedAt: message.receivedAt.toISOString(),
    handledAt: message.handledAt?.toISOString() ?? null,
    handledBy: message.handledBy,
    note: message.note,
  };
}

@Injectable()
export class ContactService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(Paginator) private readonly paginator: Paginator,
  ) {}

  /** Public form: stored as NEW, a reference is returned. Its content is never logged. */
  async create(input: {
    name: string;
    email: string;
    phone?: string;
    companyName?: string;
    requesterType: ContactRequesterType;
    message: string;
  }) {
    return this.db.run({ role: 'SYSTEM' }, async (tx) => {
      const [sequence] = await tx.$queryRaw<
        { value: bigint }[]
      >`SELECT nextval('contact_reference_seq') AS value`;
      const reference = `MSG-${String(sequence?.value ?? 0n)}`;
      await tx.contactMessage.create({
        data: {
          id: uuidv7(),
          reference,
          name: input.name.trim(),
          email: input.email.trim().toLowerCase(),
          phone: input.phone ?? null,
          companyName:
            input.companyName?.trim() === '' ? null : (input.companyName?.trim() ?? null),
          requesterType: input.requesterType,
          message: input.message.trim(),
        },
      });
      return { reference };
    });
  }

  async list(
    query: Record<string, unknown>,
    filters: { status?: ContactMessageStatus; requesterType?: ContactRequesterType; q?: string },
  ) {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const needle = filters.q?.trim();
      const where: Prisma.ContactMessageWhereInput = {
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...(filters.requesterType === undefined ? {} : { requesterType: filters.requesterType }),
        ...(needle === undefined || needle === ''
          ? {}
          : {
              OR: ['name', 'companyName', 'email', 'reference'].map((field) => ({
                [field]: { contains: needle, mode: 'insensitive' as const },
              })),
            }),
      };
      const rows = await tx.contactMessage.findMany({
        where,
        orderBy: [{ receivedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.contactMessage.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(request, rows.map(body), filters, count);
    });
  }

  async get(id: string) {
    return this.db.user(async (tx) => {
      const message = await tx.contactMessage.findUnique({ where: { id } });
      if (message === null) throw problems.notFound();
      return body(message);
    });
  }

  async handle(id: string, note?: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const message = await tx.contactMessage.findUnique({ where: { id } });
      if (message === null) throw problems.notFound();
      if (message.status !== 'NEW') throw problems.conflict();
      const updated = await tx.contactMessage.update({
        where: { id },
        data: {
          status: 'HANDLED',
          handledAt: new Date(),
          handledBy: who.displayName,
          note: note === undefined || note.trim() === '' ? null : note.trim(),
        },
      });
      await this.audit.record(tx, 'contact.handle', message.reference);
      return body(updated);
    });
  }
}
