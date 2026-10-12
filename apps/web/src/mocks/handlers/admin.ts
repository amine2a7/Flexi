import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { db, type MockApproval } from '../db';
import {
  apiUrl,
  audit,
  guardRead,
  guardWrite,
  isResponse,
  listParams,
  matches,
  paginate,
  problem,
  validationProblem,
} from './util';

type S = Schemas;

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE = /^\+216[0-9]{8}$/;

function publicApproval(approval: MockApproval, accountId: string): S['Approval'] {
  const { initiatorId, profileId: _profileId, settings: _settings, ...rest } = approval;
  return { ...rest, initiatedByMe: initiatorId === accountId };
}

function requiredFields(body: Record<string, unknown>, fields: readonly string[]) {
  return fields
    .filter((field) => typeof body[field] !== 'string' || (body[field]).trim() === '')
    .map((field) => ({ pointer: `/${field}`, code: 'REQUIRED' as const }));
}

export const adminHandlers = [
  http.get(apiUrl('/v1/admin/dashboard'), async () => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { merchants, companies, approvals, batches } = db.admin;
    const today = new Date().toISOString().slice(0, 10);
    return HttpResponse.json<S['AdminDashboard']>({
      merchantsCount: merchants.length,
      companiesCount: companies.length,
      todayVolumeMillimes:
        db.merchant.payments
          .filter((payment) => payment.createdAt.startsWith(today) && payment.status !== 'REFUSED')
          .reduce((sum, payment) => sum + payment.amountMillimes, 0) * 37,
      pendingApprovalsCount: approvals.filter((approval) => approval.status === 'PENDING').length,
      pendingKycCount:
        merchants.filter((merchant) => merchant.status === 'PENDING_KYC').length +
        companies.filter((company) => company.status === 'PENDING_KYC').length,
      nextSettlementNetMillimes:
        batches.find((batch) => batch.status === 'SCHEDULED')?.netMillimes ?? 0,
    });
  }),

  http.get(apiUrl('/v1/admin/merchants'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const items = db.admin.merchants
      .filter((merchant) => status === null || merchant.status === status)
      .filter((merchant) => matches(query.get('q'), merchant.name, merchant.city));
    return HttpResponse.json<S['MerchantAccountPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/admin/merchants'), async ({ request }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['MerchantCreate'];
    const errors = requiredFields(body, [
      'name',
      'category',
      'city',
      'phone',
      'email',
      'commissionProfileId',
    ]);
    if (body.email !== '' && !EMAIL.test(body.email))
      errors.push({ pointer: '/email', code: 'INVALID_FORMAT' as never });
    if (body.phone !== '' && !PHONE.test(body.phone))
      errors.push({ pointer: '/phone', code: 'INVALID_FORMAT' as never });
    if (errors.length > 0) return validationProblem(errors);
    const profile = db.admin.profiles.find((item) => item.id === body.commissionProfileId);
    if (profile === undefined)
      return validationProblem([{ pointer: '/commissionProfileId', code: 'INVALID_ENUM' }]);
    if (
      db.admin.merchants.some(
        (merchant) => merchant.name.toLowerCase() === body.name.trim().toLowerCase(),
      )
    ) {
      return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    const merchant: S['MerchantAccount'] = {
      id: crypto.randomUUID(),
      name: body.name.trim(),
      category: body.category,
      city: body.city.trim(),
      status: 'PENDING_KYC',
      commissionProfile: { id: profile.id, name: profile.name, rateBps: profile.rateBps },
      createdAt: new Date().toISOString(),
    };
    db.admin.merchants.unshift(merchant);
    profile.merchantsCount += 1;
    audit('merchants.create', merchant.name);
    return HttpResponse.json<S['MerchantAccount']>(merchant, { status: 201 });
  }),

  http.get(apiUrl('/v1/admin/companies'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const { query } = listParams(request);
    const status = query.get('status');
    const items = db.admin.companies
      .filter((company) => status === null || company.status === status)
      .filter((company) => matches(query.get('q'), company.name, company.city));
    return HttpResponse.json<S['CompanyAccountPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/admin/companies'), async ({ request }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['CompanyCreate'];
    const errors = requiredFields(body, ['name', 'city', 'phone', 'email']);
    if (body.email !== '' && !EMAIL.test(body.email))
      errors.push({ pointer: '/email', code: 'INVALID_FORMAT' as never });
    if (body.phone !== '' && !PHONE.test(body.phone))
      errors.push({ pointer: '/phone', code: 'INVALID_FORMAT' as never });
    if (errors.length > 0) return validationProblem(errors);
    if (
      db.admin.companies.some(
        (company) => company.name.toLowerCase() === body.name.trim().toLowerCase(),
      )
    ) {
      return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    const company: S['CompanyAccount'] = {
      id: crypto.randomUUID(),
      name: body.name.trim(),
      city: body.city.trim(),
      status: 'PENDING_KYC',
      employeesCount: 0,
      createdAt: new Date().toISOString(),
    };
    db.admin.companies.unshift(company);
    audit('companies.create', company.name);
    return HttpResponse.json<S['CompanyAccount']>(company, { status: 201 });
  }),

  http.get(apiUrl('/v1/admin/commission-profiles'), async () => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['CommissionProfileList']>({ data: db.admin.profiles });
  }),

  http.post(
    apiUrl('/v1/admin/commission-profiles/:profileId/change-requests'),
    async ({ request, params }) => {
      const account = await guardWrite(request, 'ADMIN');
      if (isResponse(account)) return account;
      const profile = db.admin.profiles.find((item) => item.id === params.profileId);
      if (profile === undefined) return problem(404, 'NOT_FOUND');
      const body = (await request.json()) as S['CommissionChangeRequest'];
      if (!Number.isInteger(body.newRateBps) || body.newRateBps < 0 || body.newRateBps > 10_000) {
        return validationProblem([{ pointer: '/newRateBps', code: 'TOO_BIG' }]);
      }
      if (body.reason.trim() === '')
        return validationProblem([{ pointer: '/reason', code: 'REQUIRED' }]);
      if (
        db.admin.approvals.some(
          (approval) => approval.status === 'PENDING' && approval.profileId === profile.id,
        )
      ) {
        return problem(409, 'RESOURCE_STATE_CONFLICT');
      }
      const approval: MockApproval = {
        id: crypto.randomUUID(),
        type: 'COMMISSION_RATE_CHANGE',
        status: 'PENDING',
        subject: profile.name,
        oldRateBps: profile.rateBps,
        newRateBps: body.newRateBps,
        reason: body.reason.trim(),
        initiatorName: account.displayName,
        initiatorId: account.id,
        profileId: profile.id,
        createdAt: new Date().toISOString(),
      };
      db.admin.approvals.unshift(approval);
      audit('commissions.request', profile.name);
      return HttpResponse.json<S['Approval']>(publicApproval(approval, account.id), {
        status: 201,
      });
    },
  ),

  http.get(apiUrl('/v1/admin/approvals'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const status = listParams(request).query.get('status');
    const items = db.admin.approvals
      .filter((approval) => status === null || approval.status === status)
      .map((approval) => publicApproval(approval, account.id));
    return HttpResponse.json<S['ApprovalPage']>(paginate(items, request));
  }),

  http.post(apiUrl('/v1/admin/approvals/:approvalId/approve'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const approval = db.admin.approvals.find((item) => item.id === params.approvalId);
    if (approval === undefined) return problem(404, 'NOT_FOUND');
    if (approval.initiatorId === account.id) return problem(403, 'FORBIDDEN'); // rule 12
    if (approval.status !== 'PENDING') return problem(409, 'RESOURCE_STATE_CONFLICT');
    approval.status = 'APPROVED';
    if (approval.type === 'COMMISSION_RATE_CHANGE' && approval.newRateBps !== undefined) {
      const profile = db.admin.profiles.find((item) => item.id === approval.profileId);
      if (profile !== undefined) {
        profile.rateBps = approval.newRateBps;
        profile.updatedAt = new Date().toISOString();
        for (const merchant of db.admin.merchants) {
          if (merchant.commissionProfile.id === profile.id)
            merchant.commissionProfile.rateBps = profile.rateBps;
        }
        if (db.merchant.profile.commissionProfile.id === profile.id)
          db.merchant.rateBps = profile.rateBps;
      }
    }
    if (approval.type === 'SETTINGS_CHANGE' && approval.settings !== undefined)
      db.admin.settings = approval.settings;
    audit('approvals.approve', approval.subject);
    return HttpResponse.json<S['Approval']>(publicApproval(approval, account.id));
  }),

  http.post(apiUrl('/v1/admin/approvals/:approvalId/reject'), async ({ request, params }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const approval = db.admin.approvals.find((item) => item.id === params.approvalId);
    if (approval === undefined) return problem(404, 'NOT_FOUND');
    const body = (await request.json()) as S['ApprovalRejectRequest'];
    if (body.reason.trim() === '')
      return validationProblem([{ pointer: '/reason', code: 'REQUIRED' }]);
    if (approval.status !== 'PENDING') return problem(409, 'RESOURCE_STATE_CONFLICT');
    approval.status = 'REJECTED';
    audit('approvals.reject', approval.subject);
    return HttpResponse.json<S['Approval']>(publicApproval(approval, account.id));
  }),

  http.get(apiUrl('/v1/admin/settlements'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['SettlementBatchPage']>(paginate(db.admin.batches, request));
  }),

  http.get(apiUrl('/v1/admin/audit-logs'), async ({ request }) => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    const q = listParams(request).query.get('q');
    const items = db.admin.audit.filter((entry) =>
      matches(q, entry.actorName, entry.action, entry.target),
    );
    return HttpResponse.json<S['AuditLogPage']>(paginate(items, request));
  }),

  http.get(apiUrl('/v1/admin/settings'), async () => {
    const account = await guardRead('ADMIN');
    if (isResponse(account)) return account;
    return HttpResponse.json<S['PlatformSettings']>(db.admin.settings);
  }),

  http.put(apiUrl('/v1/admin/settings'), async ({ request }) => {
    const account = await guardWrite(request, 'ADMIN');
    if (isResponse(account)) return account;
    const body = (await request.json()) as S['PlatformSettingsChange'];
    if (body.reason.trim() === '')
      return validationProblem([{ pointer: '/reason', code: 'REQUIRED' }]);
    if (
      db.admin.approvals.some(
        (approval) => approval.status === 'PENDING' && approval.type === 'SETTINGS_CHANGE',
      )
    ) {
      return problem(409, 'RESOURCE_STATE_CONFLICT');
    }
    const approval: MockApproval = {
      id: crypto.randomUUID(),
      type: 'SETTINGS_CHANGE',
      status: 'PENDING',
      subject: 'Paramétrage de la plateforme',
      reason: body.reason.trim(),
      initiatorName: account.displayName,
      initiatorId: account.id,
      settings: body.settings,
      createdAt: new Date().toISOString(),
    };
    db.admin.approvals.unshift(approval);
    audit('settings.request', approval.subject);
    return HttpResponse.json<S['Approval']>(publicApproval(approval, account.id), { status: 202 });
  }),
];
