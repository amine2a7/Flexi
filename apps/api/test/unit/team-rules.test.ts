// TEST-FIRST (request of 2026-11-14): sub-roles of a company (Propriétaire, RH, Finance) and of a
// merchant (Propriétaire, Caissier), who manages whom on the « Utilisateurs » pages.
import { describe, expect, it } from 'vitest';
import { permissionsOf } from '../../src/common/permissions.js';
import { assignableSubRoles, canManageTarget, TEAM_SUB_ROLES } from '../../src/users/team-rules.js';

describe('team sub-roles', () => {
  it('a company has Propriétaire, RH and Finance; a merchant Propriétaire and Caissier', () => {
    expect(TEAM_SUB_ROLES.COMPANY).toEqual(['OWNER', 'MANAGER', 'FINANCE']);
    expect(TEAM_SUB_ROLES.MERCHANT).toEqual(['OWNER', 'CASHIER']);
  });

  it('the owner gives RH and Finance (or Caissier), never Propriétaire; the admin gives all', () => {
    expect(assignableSubRoles('COMPANY', 'OWNER')).toEqual(['MANAGER', 'FINANCE']);
    expect(assignableSubRoles('MERCHANT', 'OWNER')).toEqual(['CASHIER']);
    expect(assignableSubRoles('COMPANY', 'ADMIN')).toEqual(['OWNER', 'MANAGER', 'FINANCE']);
    expect(assignableSubRoles('MERCHANT', 'ADMIN')).toEqual(['OWNER', 'CASHIER']);
  });

  it('the owner manages its RH and Finance only, never an owner nor itself', () => {
    const owner = (target: { id: string; subRole: 'OWNER' | 'MANAGER' | 'FINANCE' | null }) =>
      canManageTarget({ tenant: 'COMPANY', actor: 'OWNER', actorUserId: 'me', target });
    expect(owner({ id: 'u1', subRole: 'MANAGER' })).toBe(true);
    expect(owner({ id: 'u2', subRole: 'FINANCE' })).toBe(true);
    expect(owner({ id: 'u3', subRole: 'OWNER' })).toBe(false);
    expect(owner({ id: 'me', subRole: 'MANAGER' })).toBe(false);
    expect(owner({ id: 'u4', subRole: null })).toBe(false);
    expect(
      canManageTarget({
        tenant: 'MERCHANT',
        actor: 'OWNER',
        actorUserId: 'me',
        target: { id: 'c1', subRole: 'CASHIER' },
      }),
    ).toBe(true);
  });

  it('the administrator manages every account of the tenant', () => {
    expect(
      canManageTarget({
        tenant: 'COMPANY',
        actor: 'ADMIN',
        actorUserId: 'admin',
        target: { id: 'o1', subRole: 'OWNER' },
      }),
    ).toBe(true);
  });
});

describe('team permissions', () => {
  it('only the owners manage their users', () => {
    expect(permissionsOf('COMPANY', 'OWNER')).toContain('team.manage');
    expect(permissionsOf('MERCHANT', 'OWNER')).toContain('team.manage');
    for (const subRole of ['MANAGER', 'FINANCE'] as const)
      expect(permissionsOf('COMPANY', subRole)).not.toContain('team.manage');
    expect(permissionsOf('MERCHANT', 'CASHIER')).not.toContain('team.manage');
  });

  it('RH: employees, departments, allocation; never orders nor invoices', () => {
    const hr = permissionsOf('COMPANY', 'MANAGER');
    expect(hr).toEqual(
      expect.arrayContaining(['employees.read', 'employees.manage', 'credits.allocate']),
    );
    for (const permission of ['orders.read', 'orders.create', 'invoices.read'])
      expect(hr).not.toContain(permission);
  });

  it('Finance: orders, transfers, invoices; never employees nor allocation', () => {
    const finance = permissionsOf('COMPANY', 'FINANCE');
    expect(finance).toEqual(
      expect.arrayContaining([
        'orders.read',
        'orders.create',
        'orders.declareTransfer',
        'invoices.read',
      ]),
    );
    for (const permission of ['employees.read', 'employees.manage', 'credits.allocate'])
      expect(finance).not.toContain(permission);
  });

  it('Caissier: collect and the day only, no payout, statistics nor history of other days', () => {
    const cashier = permissionsOf('MERCHANT', 'CASHIER');
    expect(cashier).toEqual(expect.arrayContaining(['payments.collect', 'sales.readToday']));
    for (const permission of [
      'sales.read',
      'stats.read',
      'payouts.read',
      'payouts.request',
      'payments.refund',
      'kyc.submit',
    ])
      expect(cashier).not.toContain(permission);
  });
});
