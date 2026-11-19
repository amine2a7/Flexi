import { Inject, Injectable } from '@nestjs/common';
import { KEYS, type Keys } from '../config/env.provider.js';
import { AuditService } from '../common/audit.service.js';
import { hmac, safeEqual, uuidv7 } from '../common/crypto.js';
import { asService, DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { Paginator, type Page } from '../common/pagination.js';
import { PiiService } from '../common/pii.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { principal, type Principal } from '../common/request-context.js';
import { FILE_STORAGE, type FileStorage } from '../common/storage.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  SubRole,
  TicketCategory,
  TicketLinkType,
  TicketStatus,
  TicketTeam,
} from '../generated/prisma/enums.js';
import { sniffProof } from '../orders/orders.service.js';
import { redactSecrets } from './redact.js';

/** An uploaded piece (multer): PDF, JPG or PNG of 5 MB at most. */
export interface UploadedPiece {
  readonly size: number;
  readonly buffer: Buffer;
  readonly originalname: string;
}

export interface TicketInput {
  category: TicketCategory;
  subject: string;
  description: string;
  linkType?: TicketLinkType | undefined;
  linkId?: string | undefined;
}

export interface CustomerFilters {
  status?: TicketStatus | undefined;
  q?: string | undefined;
}

export interface AgentFilters extends CustomerFilters {
  category?: TicketCategory | undefined;
  priority?: 'NORMAL' | 'HIGH' | undefined;
  team?: TicketTeam | undefined;
  assignee?: string | undefined;
  overdue?: boolean | undefined;
}

export const MAX_PIECE_BYTES = 5 * 1024 * 1024;
/** Tickets a user may open per hour (limit of the creation, besides the per-address limit). */
export const TICKETS_PER_HOUR = 10;
/** First answer due: 4 hours for a contested transaction (high), 24 hours otherwise. */
const FIRST_RESPONSE_HOURS = { HIGH: 4, NORMAL: 24 } as const;
/** A resolved ticket is closed 7 days later, unless the client reopens it. */
export const AUTO_CLOSE_DAYS = 7;
const LINK_SECONDS = 5 * 60;
const HOUR_MS = 3_600_000;
const DAY_MS = 86_400_000;
/** Still waiting for FlexiPay or the client. */
const ACTIVE: TicketStatus[] = ['OPEN', 'IN_PROGRESS', 'WAITING_CUSTOMER'];
/** Agents of each team (assignment): Opérations is the COMPLIANCE sub-role. */
const TEAM_SUB_ROLES: Record<TicketTeam, SubRole[]> = {
  SUPPORT: ['SUPPORT', 'SUPER_ADMIN'],
  FINANCE: ['FINANCE', 'SUPER_ADMIN'],
  OPERATIONS: ['COMPLIANCE', 'SUPER_ADMIN'],
};

const ticketInclude = {
  messages: { orderBy: { createdAt: 'asc' }, include: { attachments: true } },
  attachments: { where: { messageId: null }, orderBy: { createdAt: 'asc' } },
} satisfies Prisma.SupportTicketInclude;

type TicketRow = Prisma.SupportTicketGetPayload<object>;
type TicketDetailRow = Prisma.SupportTicketGetPayload<{ include: typeof ticketInclude }>;
type AttachmentRow = Prisma.SupportTicketAttachmentGetPayload<object>;

function fieldError(pointer: string, code: 'REQUIRED' | 'INVALID_ENUM' | 'INVALID_FORMAT') {
  return validationFailed([{ in: 'body', pointer, code }]);
}

function attachmentView(row: AttachmentRow) {
  return {
    id: row.id,
    fileName: row.fileName,
    contentType: row.contentType,
    sizeBytes: row.sizeBytes,
    createdAt: row.createdAt.toISOString(),
  };
}

function isOverdue(row: TicketRow, now = Date.now()): boolean {
  return (
    ACTIVE.includes(row.status) &&
    row.firstResponseAt === null &&
    row.firstResponseDueAt.getTime() < now
  );
}

/** What the client sees of its ticket (never the team, the agent nor the internal notes). */
function customerSummary(row: TicketRow) {
  return {
    id: row.id,
    reference: row.reference,
    category: row.category,
    priority: row.priority,
    status: row.status,
    subject: row.subject,
    requesterName: row.requesterName,
    link:
      row.linkType === null || row.linkId === null
        ? null
        : { type: row.linkType, id: row.linkId, reference: row.linkReference },
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
    resolvedAt: row.resolvedAt?.toISOString() ?? null,
    closedAt: row.closedAt?.toISOString() ?? null,
  };
}

function agentSummary(row: TicketRow, clientName: string | null) {
  return {
    ...customerSummary(row),
    team: row.team,
    requesterRole: row.requesterRole,
    clientName,
    assignee: row.assigneeId === null ? null : { id: row.assigneeId, name: row.assigneeName ?? '' },
    firstResponseDueAt: row.firstResponseDueAt.toISOString(),
    firstResponseAt: row.firstResponseAt?.toISOString() ?? null,
    overdue: isOverdue(row),
  };
}

function messageView(message: TicketDetailRow['messages'][number], agent: boolean) {
  return {
    id: message.id,
    authorName: message.authorName,
    fromAgent: message.fromAgent,
    body: message.body,
    redacted: message.redacted,
    createdAt: message.createdAt.toISOString(),
    attachments: message.attachments.map(attachmentView),
    ...(agent ? { internal: message.internal } : {}),
  };
}

/** Tenant columns of the ticket of the signed-in client (from the session, never the request). */
function tenantOf(who: Principal) {
  if (who.role === 'COMPANY' && who.companyId !== null) return { companyId: who.companyId };
  if (who.role === 'MERCHANT' && who.merchantId !== null) return { merchantId: who.merchantId };
  if ((who.role === 'EMPLOYEE' || who.role === 'FAMILY_MEMBER') && who.employeeId !== null)
    return { employeeId: who.employeeId };
  throw problems.forbidden();
}

/**
 * The tickets a client sees: its tenant (RLS), narrowed to its own tickets unless it is the owner
 * of the company or the shop (W-SUP). A beneficiary only has its own tickets.
 */
function customerWhere(who: Principal): Prisma.SupportTicketWhereInput {
  return who.subRole === 'OWNER' ? {} : { requesterId: who.userId };
}

/**
 * Support tickets (W-SUP): opened by a company, a merchant or a beneficiary, answered by
 * FlexiPay (Support, transferred to Finance or Opérations). Secrets typed in a message are masked
 * before saving; pieces are encrypted and reached by a signed link of 5 minutes; every action is
 * audited; each answer writes an outbox event (notification).
 */
@Injectable()
export class SupportService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PiiService) private readonly pii: PiiService,
    @Inject(FILE_STORAGE) private readonly storage: FileStorage,
    @Inject(KEYS) private readonly keys: Keys,
  ) {}

  // ---------------------------------------------------------------- client

  async list(query: Record<string, unknown>, filters: CustomerFilters): Promise<Page<unknown>> {
    const who = principal();
    const request = this.paginator.request(query, { ...filters });
    return this.db.user(async (tx) => {
      const where: Prisma.SupportTicketWhereInput = {
        ...customerWhere(who),
        ...(filters.status === undefined ? {} : { status: filters.status }),
        ...textFilter(filters.q),
      };
      const rows = await tx.supportTicket.findMany({
        where,
        orderBy: [{ updatedAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.supportTicket.count({ where, take: 10_001 })
        : undefined;
      return this.paginator.page(request, rows.map(customerSummary), { ...filters }, count);
    });
  }

  async detail(id: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const row = await tx.supportTicket.findFirst({
        where: { id, ...customerWhere(who) },
        include: ticketInclude,
      });
      if (row === null) throw problems.notFound();
      return this.customerDetail(row);
    });
  }

  private customerDetail(row: TicketDetailRow) {
    return {
      ...customerSummary(row),
      description: row.description,
      redacted: row.redacted,
      canReopen: row.status === 'RESOLVED',
      canReply: row.status !== 'CLOSED',
      attachments: row.attachments.map(attachmentView),
      messages: row.messages.map((message) => messageView(message, false)),
    };
  }

  async create(input: TicketInput, piece: UploadedPiece | undefined) {
    const who = principal();
    const tenant = tenantOf(who);
    const subject = redactSecrets(input.subject.trim());
    const description = redactSecrets(input.description.trim());
    const stored = piece === undefined ? null : await this.store(piece);
    return this.db.user(async (tx) => {
      const recent = await tx.supportTicket.count({
        where: { requesterId: who.userId, createdAt: { gt: new Date(Date.now() - HOUR_MS) } },
      });
      if (recent >= TICKETS_PER_HOUR)
        throw new ApiProblem(
          429,
          'RATE_LIMITED',
          { retryAfterSeconds: 3600 },
          { 'Retry-After': '3600' },
        );
      const link = await this.checkLink(tx, input);
      const [sequence] = await tx.$queryRaw<
        { value: bigint }[]
      >`SELECT nextval('ticket_reference_seq') AS value`;
      const now = new Date();
      const reference = `TK-${String(now.getUTCFullYear())}-${String(sequence?.value ?? 0n).padStart(6, '0')}`;
      // A contested transaction is urgent (W-SUP): high priority, answer within 4 hours.
      const priority = input.category === 'DISPUTED_TRANSACTION' ? 'HIGH' : 'NORMAL';
      const id = uuidv7();
      await tx.supportTicket.create({
        data: {
          id,
          reference,
          category: input.category,
          priority,
          subject: subject.text.slice(0, 160),
          description: description.text.slice(0, 4000),
          redacted: subject.redacted || description.redacted,
          requesterId: who.userId,
          requesterName: who.displayName,
          requesterRole: who.role,
          ...tenant,
          ...(link === null
            ? {}
            : { linkType: link.type, linkId: link.id, linkReference: link.reference }),
          createdAt: now,
          updatedAt: now,
          firstResponseDueAt: new Date(now.getTime() + FIRST_RESPONSE_HOURS[priority] * HOUR_MS),
        },
      });
      if (stored !== null) await this.attach(tx, id, null, stored, who.userId);
      await this.notify(tx, 'support.ticket.opened', id, { reference, audience: 'AGENTS' });
      await this.audit.record(tx, 'support.create', `${reference} ${input.category}`);
      const row = await tx.supportTicket.findUniqueOrThrow({
        where: { id },
        include: ticketInclude,
      });
      return this.customerDetail(row);
    });
  }

  /** Answer of the client: a ticket waiting for it, or resolved, goes back to « En cours ». */
  async reply(id: string, body: string, piece: UploadedPiece | undefined) {
    const who = principal();
    const clean = redactSecrets(body.trim());
    const stored = piece === undefined ? null : await this.store(piece);
    return this.db.user(async (tx) => {
      const ticket = await this.lockCustomer(tx, id, who);
      if (ticket.status === 'CLOSED') throw problems.conflict();
      const messageId = uuidv7();
      await tx.supportTicketMessage.create({
        data: {
          id: messageId,
          ticketId: id,
          authorId: who.userId,
          authorName: who.displayName,
          fromAgent: false,
          body: clean.text.slice(0, 4000),
          redacted: clean.redacted,
        },
      });
      if (stored !== null) await this.attach(tx, id, messageId, stored, who.userId);
      const reopened = ticket.status === 'WAITING_CUSTOMER' || ticket.status === 'RESOLVED';
      await tx.supportTicket.update({
        where: { id },
        data: {
          updatedAt: new Date(),
          ...(reopened ? { status: 'IN_PROGRESS', resolvedAt: null } : {}),
        },
      });
      await this.notify(tx, 'support.ticket.replied', id, {
        reference: ticket.reference,
        audience: 'AGENTS',
        recipientUserId: ticket.assigneeId,
      });
      await this.audit.record(tx, 'support.reply', ticket.reference);
      return this.customerDetail(
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  /** The client reopens a resolved ticket (before its automatic closing). */
  async reopen(id: string) {
    const who = principal();
    return this.db.user(async (tx) => {
      const ticket = await this.lockCustomer(tx, id, who);
      if (ticket.status !== 'RESOLVED') throw problems.conflict();
      await tx.supportTicket.update({
        where: { id },
        data: {
          status: ticket.assigneeId === null ? 'OPEN' : 'IN_PROGRESS',
          resolvedAt: null,
          updatedAt: new Date(),
        },
      });
      await this.notify(tx, 'support.ticket.reopened', id, {
        reference: ticket.reference,
        audience: 'AGENTS',
        recipientUserId: ticket.assigneeId,
      });
      await this.audit.record(tx, 'support.reopen', ticket.reference);
      return this.customerDetail(
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  private async lockCustomer(tx: Tx, id: string, who: Principal) {
    // The RLS of the row applies to the lock too: another tenant's ticket is never locked.
    await tx.$queryRaw`SELECT id FROM support_tickets WHERE id = ${id}::uuid FOR UPDATE`;
    const ticket = await tx.supportTicket.findFirst({ where: { id, ...customerWhere(who) } });
    if (ticket === null) throw problems.notFound();
    return ticket;
  }

  // ---------------------------------------------------------------- FlexiPay agents

  async queue(query: Record<string, unknown>, filters: AgentFilters): Promise<Page<unknown>> {
    const who = principal();
    const request = this.paginator.request(query, { ...filters });
    const where: Prisma.SupportTicketWhereInput = {
      ...(filters.status === undefined ? {} : { status: filters.status }),
      ...(filters.category === undefined ? {} : { category: filters.category }),
      ...(filters.priority === undefined ? {} : { priority: filters.priority }),
      ...(filters.team === undefined ? {} : { team: filters.team }),
      ...(filters.assignee === undefined
        ? {}
        : filters.assignee === 'none'
          ? { assigneeId: null }
          : { assigneeId: filters.assignee === 'me' ? who.userId : filters.assignee }),
      ...(filters.overdue === true
        ? {
            status: { in: ACTIVE },
            firstResponseAt: null,
            firstResponseDueAt: { lt: new Date() },
          }
        : {}),
      ...textFilter(filters.q),
    };
    return this.db.user(async (tx) => {
      const rows = await tx.supportTicket.findMany({
        where,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount
        ? await tx.supportTicket.count({ where, take: 10_001 })
        : undefined;
      const names = await this.clientNames(tx, rows);
      return this.paginator.page(
        request,
        rows.map((row) => agentSummary(row, names.get(row.id) ?? null)),
        { ...filters },
        count,
      );
    });
  }

  /** Counters of the queue: open, late (no first answer in time), mean first answer (30 days). */
  async stats() {
    return this.db.user(async (tx) => {
      const [row] = await tx.$queryRaw<
        { open: bigint; overdue: bigint; high: bigint; average: number | null }[]
      >`SELECT
          count(*) FILTER (WHERE status IN ('OPEN', 'IN_PROGRESS', 'WAITING_CUSTOMER')) AS open,
          count(*) FILTER (WHERE status IN ('OPEN', 'IN_PROGRESS', 'WAITING_CUSTOMER')
                             AND first_response_at IS NULL
                             AND first_response_due_at < now()) AS overdue,
          count(*) FILTER (WHERE status IN ('OPEN', 'IN_PROGRESS', 'WAITING_CUSTOMER')
                             AND priority = 'HIGH') AS high,
          (avg(EXTRACT(EPOCH FROM (first_response_at - created_at)))
             FILTER (WHERE first_response_at IS NOT NULL
                       AND created_at > now() - interval '30 days'))::float8 AS average
        FROM support_tickets`;
      return {
        open: Number(row?.open ?? 0n),
        overdue: Number(row?.overdue ?? 0n),
        highPriority: Number(row?.high ?? 0n),
        averageFirstResponseMinutes:
          row?.average === null || row?.average === undefined ? null : Math.round(row.average / 60),
      };
    });
  }

  async agentDetail(id: string) {
    return this.db.user(async (tx) => {
      const row = await tx.supportTicket.findUnique({ where: { id }, include: ticketInclude });
      if (row === null) throw problems.notFound();
      await this.audit.record(tx, 'support.view', row.reference);
      return this.agentBody(tx, row);
    });
  }

  private async agentBody(tx: Tx, row: TicketDetailRow) {
    const names = await this.clientNames(tx, [row]);
    return {
      ...agentSummary(row, names.get(row.id) ?? null),
      description: row.description,
      redacted: row.redacted,
      attachments: row.attachments.map(attachmentView),
      messages: row.messages.map((message) => messageView(message, true)),
      // The linked transaction, order or payout, read only (Support never changes money).
      linked: await this.linkSummary(tx, row),
    };
  }

  /** Answer of an agent (public) or internal note (FlexiPay only, no notification). */
  async agentReply(
    id: string,
    input: { body: string; internal: boolean; waitingCustomer: boolean },
    piece: UploadedPiece | undefined,
  ) {
    const who = principal();
    const clean = redactSecrets(input.body.trim());
    const stored = piece === undefined ? null : await this.store(piece);
    return this.db.user(async (tx) => {
      const ticket = await this.lockAgent(tx, id);
      if (ticket.status === 'CLOSED') throw problems.conflict();
      const now = new Date();
      const messageId = uuidv7();
      await tx.supportTicketMessage.create({
        data: {
          id: messageId,
          ticketId: id,
          authorId: who.userId,
          authorName: who.displayName,
          fromAgent: true,
          internal: input.internal,
          body: clean.text.slice(0, 4000),
          redacted: clean.redacted,
          createdAt: now,
        },
      });
      if (stored !== null) await this.attach(tx, id, messageId, stored, who.userId);
      if (input.internal) {
        await tx.supportTicket.update({ where: { id }, data: { updatedAt: now } });
        await this.audit.record(tx, 'support.note', ticket.reference);
      } else {
        const status: TicketStatus = input.waitingCustomer
          ? 'WAITING_CUSTOMER'
          : ticket.status === 'OPEN' || ticket.status === 'WAITING_CUSTOMER'
            ? 'IN_PROGRESS'
            : ticket.status;
        await tx.supportTicket.update({
          where: { id },
          data: {
            status,
            updatedAt: now,
            ...(ticket.firstResponseAt === null ? { firstResponseAt: now } : {}),
            // The agent who answers an unassigned ticket takes it.
            ...(ticket.assigneeId === null
              ? { assigneeId: who.userId, assigneeName: who.displayName }
              : {}),
          },
        });
        await this.notify(tx, 'support.ticket.replied', id, {
          reference: ticket.reference,
          audience: 'CUSTOMER',
          recipientUserId: ticket.requesterId,
        });
        await this.audit.record(tx, 'support.answer', ticket.reference);
      }
      return this.agentBody(
        tx,
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  /** Agents who may take the tickets of a team (assignment list). */
  async agents(team: TicketTeam) {
    const rows = await this.db.user((tx) =>
      tx.user.findMany({
        where: { role: 'ADMIN', status: 'ACTIVE', subRole: { in: TEAM_SUB_ROLES[team] } },
        select: { id: true, displayName: true, subRole: true },
        orderBy: { displayName: 'asc' },
        take: 200,
      }),
    );
    return {
      data: rows.map((row) => ({ id: row.id, displayName: row.displayName, subRole: row.subRole })),
    };
  }

  /** Assigns the ticket to an agent of its team (or nobody). */
  async assign(id: string, assigneeId: string | null) {
    return this.db.user(async (tx) => {
      const ticket = await this.lockAgent(tx, id);
      if (ticket.status === 'CLOSED') throw problems.conflict();
      let assignee: { id: string; displayName: string } | null = null;
      if (assigneeId !== null) {
        assignee = await tx.user.findFirst({
          where: {
            id: assigneeId,
            role: 'ADMIN',
            status: 'ACTIVE',
            subRole: { in: TEAM_SUB_ROLES[ticket.team] },
          },
          select: { id: true, displayName: true },
        });
        if (assignee === null) throw fieldError('/assigneeId', 'INVALID_FORMAT');
      }
      await tx.supportTicket.update({
        where: { id },
        data: {
          assigneeId: assignee?.id ?? null,
          assigneeName: assignee?.displayName ?? null,
          updatedAt: new Date(),
          ...(assignee !== null && ticket.status === 'OPEN' ? { status: 'IN_PROGRESS' } : {}),
        },
      });
      await this.audit.record(
        tx,
        'support.assign',
        `${ticket.reference} → ${assignee?.displayName ?? '—'}`,
      );
      return this.agentBody(
        tx,
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  /** Hands the ticket over to Finance, Opérations (or back to Support): unassigned, noted. */
  async transfer(id: string, team: TicketTeam, note: string | undefined) {
    const who = principal();
    return this.db.user(async (tx) => {
      const ticket = await this.lockAgent(tx, id);
      if (ticket.status === 'CLOSED' || ticket.team === team) throw problems.conflict();
      const now = new Date();
      await tx.supportTicket.update({
        where: { id },
        data: { team, assigneeId: null, assigneeName: null, updatedAt: now },
      });
      if (note !== undefined && note.trim() !== '') {
        const clean = redactSecrets(note.trim());
        await tx.supportTicketMessage.create({
          data: {
            id: uuidv7(),
            ticketId: id,
            authorId: who.userId,
            authorName: who.displayName,
            fromAgent: true,
            internal: true,
            body: clean.text.slice(0, 4000),
            redacted: clean.redacted,
            createdAt: now,
          },
        });
      }
      await this.notify(tx, 'support.ticket.transferred', id, {
        reference: ticket.reference,
        audience: 'AGENTS',
        team,
      });
      await this.audit.record(tx, 'support.transfer', `${ticket.reference} → ${team}`);
      return this.agentBody(
        tx,
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  /** Status set by an agent; a closed ticket is final. */
  async setStatus(id: string, status: Exclude<TicketStatus, 'OPEN'>) {
    return this.db.user(async (tx) => {
      const ticket = await this.lockAgent(tx, id);
      if (ticket.status === 'CLOSED' || ticket.status === status) throw problems.conflict();
      const now = new Date();
      await tx.supportTicket.update({
        where: { id },
        data: {
          status,
          updatedAt: now,
          resolvedAt: status === 'RESOLVED' ? now : status === 'CLOSED' ? ticket.resolvedAt : null,
          ...(status === 'CLOSED' ? { closedAt: now } : {}),
        },
      });
      if (status === 'RESOLVED' || status === 'WAITING_CUSTOMER' || status === 'CLOSED')
        await this.notify(tx, 'support.ticket.status', id, {
          reference: ticket.reference,
          audience: 'CUSTOMER',
          recipientUserId: ticket.requesterId,
          status,
        });
      await this.audit.record(tx, 'support.status', `${ticket.reference} ${status}`);
      return this.agentBody(
        tx,
        await tx.supportTicket.findUniqueOrThrow({ where: { id }, include: ticketInclude }),
      );
    });
  }

  private async lockAgent(tx: Tx, id: string) {
    await tx.$queryRaw`SELECT id FROM support_tickets WHERE id = ${id}::uuid FOR UPDATE`;
    const ticket = await tx.supportTicket.findUnique({ where: { id } });
    if (ticket === null) throw problems.notFound();
    return ticket;
  }

  /** Resolved for 7 days: closed (job of the API process). */
  async closeResolved(now = new Date()): Promise<number> {
    return this.db.system(async (tx) => {
      const limit = new Date(now.getTime() - AUTO_CLOSE_DAYS * DAY_MS);
      const closed = await tx.supportTicket.updateMany({
        where: { status: 'RESOLVED', resolvedAt: { lte: limit } },
        data: { status: 'CLOSED', closedAt: now, updatedAt: now },
      });
      if (closed.count > 0)
        await this.audit.record(tx, 'support.autoClose', `${String(closed.count)} ticket(s)`);
      return closed.count;
    });
  }

  // ---------------------------------------------------------------- pieces

  /** Signed link to a piece, valid 5 minutes, for the user who asks (audited). */
  async attachmentLink(ticketId: string, attachmentId: string, agent: boolean) {
    const who = principal();
    const reference = await this.db.user(async (tx) => {
      const piece = await this.findAttachment(tx, ticketId, attachmentId, agent, who);
      await this.audit.record(tx, 'support.attachmentLink', piece.ticket.reference);
      return piece.ticket.reference;
    });
    const expires = Math.floor(Date.now() / 1000) + LINK_SECONDS;
    const signature = this.linkSignature(ticketId, attachmentId, who.userId, expires);
    const base = agent ? '/v1/admin/support-tickets' : '/v1/support/tickets';
    return {
      reference,
      url: `${base}/${ticketId}/attachments/${attachmentId}?expires=${String(expires)}&signature=${signature}`,
      expires,
      signature,
      expiresAt: new Date(expires * 1000).toISOString(),
    };
  }

  async attachment(
    ticketId: string,
    attachmentId: string,
    link: { expires: number; signature: string },
    agent: boolean,
  ): Promise<{ data: Buffer; contentType: string; fileName: string }> {
    const who = principal();
    // Expired, signed for another user or another piece: refused before any read.
    const expected = this.linkSignature(ticketId, attachmentId, who.userId, link.expires);
    if (link.expires * 1000 < Date.now() || !safeEqual(expected, link.signature))
      throw problems.forbidden();
    const piece = await this.db.user((tx) =>
      this.findAttachment(tx, ticketId, attachmentId, agent, who),
    );
    return {
      data: this.pii.openFile(await this.storage.get(piece.storageKey)),
      contentType: piece.contentType,
      fileName: piece.fileName,
    };
  }

  private async findAttachment(
    tx: Tx,
    ticketId: string,
    attachmentId: string,
    agent: boolean,
    who: Principal,
  ) {
    const piece = await tx.supportTicketAttachment.findFirst({
      where: {
        id: attachmentId,
        ticketId,
        ticket: agent ? {} : customerWhere(who),
      },
      include: { ticket: { select: { reference: true } } },
    });
    if (piece === null) throw problems.notFound();
    return piece;
  }

  private linkSignature(ticketId: string, attachmentId: string, userId: string, expires: number) {
    return hmac(
      this.keys.fileLink,
      `ticket-attachment|${ticketId}|${attachmentId}|${userId}|${String(expires)}`,
    );
  }

  /** Checks the piece (size, real type from its bytes) and stores it encrypted. */
  private async store(piece: UploadedPiece) {
    if (piece.size === 0) throw fieldError('/attachment', 'REQUIRED');
    if (piece.size > MAX_PIECE_BYTES) throw new ApiProblem(413, 'PAYLOAD_TOO_LARGE');
    const contentType = sniffProof(piece.buffer);
    if (contentType === undefined) throw new ApiProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
    const key = await this.storage.put(this.pii.sealFile(piece.buffer));
    return {
      key,
      contentType,
      size: piece.size,
      fileName: piece.originalname.slice(0, 255) || 'piece',
    };
  }

  private async attach(
    tx: Tx,
    ticketId: string,
    messageId: string | null,
    stored: { key: string; contentType: string; size: number; fileName: string },
    userId: string,
  ) {
    await tx.supportTicketAttachment.create({
      data: {
        id: uuidv7(),
        ticketId,
        messageId,
        fileName: stored.fileName,
        contentType: stored.contentType,
        sizeBytes: stored.size,
        storageKey: stored.key,
        uploadedBy: userId,
      },
    });
  }

  // ---------------------------------------------------------------- helpers

  /** Notification of the answer (outbox, published after commit), never the message itself. */
  private async notify(
    tx: Tx,
    topic: string,
    ticketId: string,
    payload: Record<string, string | null>,
  ) {
    await asService(tx, () =>
      tx.outboxEvent.create({ data: { id: uuidv7(), topic, aggregateId: ticketId, payload } }),
    );
  }

  /**
   * The linked transaction, order or payout must be one the client sees (RLS of its session):
   * a ticket never names another tenant's operation.
   */
  private async checkLink(
    tx: Tx,
    input: TicketInput,
  ): Promise<{ type: TicketLinkType; id: string; reference: string } | null> {
    if (input.linkType === undefined && input.linkId === undefined) return null;
    if (input.linkType === undefined) throw fieldError('/linkType', 'REQUIRED');
    if (input.linkId === undefined) throw fieldError('/linkId', 'REQUIRED');
    const id = input.linkId;
    const found =
      input.linkType === 'PAYMENT'
        ? await tx.payment.findUnique({ where: { id }, select: { reference: true } })
        : input.linkType === 'ORDER'
          ? await tx.creditOrder.findUnique({ where: { id }, select: { reference: true } })
          : await tx.payoutRequest.findUnique({ where: { id }, select: { reference: true } });
    if (found === null) throw problems.notFound();
    return { type: input.linkType, id, reference: found.reference };
  }

  private async linkSummary(tx: Tx, row: TicketRow) {
    if (row.linkType === null || row.linkId === null) return null;
    const id = row.linkId;
    if (row.linkType === 'PAYMENT') {
      const payment = await tx.payment.findUnique({
        where: { id },
        include: { merchant: { select: { name: true } } },
      });
      if (payment === null) return null;
      return {
        type: row.linkType,
        id,
        reference: payment.reference,
        status: payment.status,
        amountMillimes: toMillimes(payment.amountMillimes),
        creditType: payment.creditType,
        counterparty: payment.merchant.name,
        occurredAt: (payment.confirmedAt ?? payment.createdAt).toISOString(),
      };
    }
    if (row.linkType === 'ORDER') {
      const order = await tx.creditOrder.findUnique({
        where: { id },
        include: { company: { select: { name: true } } },
      });
      if (order === null) return null;
      return {
        type: row.linkType,
        id,
        reference: order.reference,
        status: order.status,
        amountMillimes: toMillimes(order.totalMillimes),
        creditType: null,
        counterparty: order.company.name,
        occurredAt: order.createdAt.toISOString(),
      };
    }
    const payout = await tx.payoutRequest.findUnique({
      where: { id },
      include: { merchant: { select: { name: true } } },
    });
    if (payout === null) return null;
    return {
      type: row.linkType,
      id,
      reference: payout.reference,
      status: payout.status,
      amountMillimes: toMillimes(payout.grossMillimes),
      creditType: payout.creditType,
      counterparty: payout.merchant.name,
      occurredAt: payout.requestedAt.toISOString(),
    };
  }

  /** Company, shop or « Prénom N. (Entreprise) » of each ticket (agents only). */
  private async clientNames(tx: Tx, rows: readonly TicketRow[]): Promise<Map<string, string>> {
    const ids = (pick: (row: TicketRow) => string | null) =>
      [...new Set(rows.map(pick))].filter((id): id is string => id !== null);
    const companies = new Map(
      (
        await tx.company.findMany({
          where: { id: { in: ids((r) => r.companyId) } },
          select: { id: true, name: true },
        })
      ).map((c) => [c.id, c.name]),
    );
    const merchants = new Map(
      (
        await tx.merchant.findMany({
          where: { id: { in: ids((r) => r.merchantId) } },
          select: { id: true, name: true },
        })
      ).map((m) => [m.id, m.name]),
    );
    const employees = new Map(
      (
        await tx.employee.findMany({
          where: { id: { in: ids((r) => r.employeeId) } },
          select: {
            id: true,
            firstName: true,
            lastName: true,
            company: { select: { name: true } },
          },
        })
      ).map((e) => [e.id, `${e.firstName} ${e.lastName.charAt(0)}. (${e.company.name})`]),
    );
    const names = new Map<string, string>();
    for (const row of rows) {
      const name =
        (row.companyId !== null ? companies.get(row.companyId) : undefined) ??
        (row.merchantId !== null ? merchants.get(row.merchantId) : undefined) ??
        (row.employeeId !== null ? employees.get(row.employeeId) : undefined);
      if (name !== undefined) names.set(row.id, name);
    }
    return names;
  }
}

/** Reference or subject containing the text (list pages; the global search uses the indexes). */
function textFilter(q: string | undefined): Prisma.SupportTicketWhereInput {
  if (q === undefined || q.trim() === '') return {};
  const text = q.trim();
  return {
    OR: [
      { reference: { contains: text, mode: 'insensitive' } },
      { subject: { contains: text, mode: 'insensitive' } },
      { requesterName: { contains: text, mode: 'insensitive' } },
    ],
  };
}
