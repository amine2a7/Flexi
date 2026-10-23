// TEST-FIRST (decision C of 2026-10-23): matrix of the administrator sub-roles, including the user
// management permissions that no route uses yet (stage 2).
import { describe, expect, it } from 'vitest';
import { permissionsOf } from '../../src/common/permissions.js';

const admin = (subRole: 'SUPER_ADMIN' | 'COMPLIANCE' | 'FINANCE' | 'SUPPORT') =>
  permissionsOf('ADMIN', subRole);

describe('administrator sub-roles (decision C)', () => {
  it('only the super-admin manages users, administrator roles and settings', () => {
    expect(admin('SUPER_ADMIN')).toEqual(
      expect.arrayContaining(['users.manage', 'users.adminRoles', 'settings.request']),
    );
    for (const subRole of ['COMPLIANCE', 'FINANCE', 'SUPPORT'] as const) {
      expect(admin(subRole)).not.toContain('users.manage');
      expect(admin(subRole)).not.toContain('users.adminRoles');
      expect(admin(subRole)).not.toContain('settings.request');
    }
  });

  it('every administrator reads users; balances are hidden from support only', () => {
    for (const subRole of ['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE', 'SUPPORT'] as const) {
      expect(admin(subRole)).toContain('users.read');
    }
    expect(admin('SUPER_ADMIN')).toContain('userBalances.read');
    expect(admin('COMPLIANCE')).toContain('userBalances.read');
    expect(admin('FINANCE')).toContain('userBalances.read');
    expect(admin('SUPPORT')).not.toContain('userBalances.read');
    expect(admin('SUPPORT')).not.toContain('dashboard.read');
  });

  it('support resends invitations and unlocks PINs; the others do not', () => {
    expect(admin('SUPPORT')).toContain('users.support');
    expect(admin('SUPER_ADMIN')).toContain('users.support');
    expect(admin('COMPLIANCE')).not.toContain('users.support');
    expect(admin('FINANCE')).not.toContain('users.support');
  });

  it('money decisions belong to finance (and the super-admin), KYC to operations', () => {
    const money = ['commissions.request', 'orders.confirm', 'orders.validate', 'payouts.decide'];
    expect(admin('FINANCE')).toEqual(expect.arrayContaining([...money, 'approvals.decide']));
    expect(admin('COMPLIANCE')).toEqual(
      expect.arrayContaining(['kyc.decide', 'kycDocuments.read']),
    );
    for (const permission of money) expect(admin('COMPLIANCE')).not.toContain(permission);
    expect(admin('FINANCE')).not.toContain('kyc.decide');
    expect(admin('FINANCE')).not.toContain('kycDocuments.read');
  });

  it('no administrator permission opens a company or merchant route', () => {
    const tenant = [
      ...permissionsOf('COMPANY', 'OWNER'),
      ...permissionsOf('MERCHANT', 'OWNER'),
      ...permissionsOf('MERCHANT', 'CASHIER'),
      ...permissionsOf('EMPLOYEE', null),
    ];
    for (const permission of admin('SUPER_ADMIN')) expect(tenant).not.toContain(permission);
  });
});
