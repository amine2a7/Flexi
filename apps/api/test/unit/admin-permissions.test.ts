// TEST-FIRST (decision C of 2026-10-23, Opérations as the second administrator on 2026-11-14):
// matrix of the administrator sub-roles.
import { describe, expect, it } from 'vitest';
import { permissionsOf } from '../../src/common/permissions.js';

const admin = (subRole: 'SUPER_ADMIN' | 'COMPLIANCE' | 'FINANCE' | 'SUPPORT') =>
  permissionsOf('ADMIN', subRole);

describe('administrator sub-roles (decision C)', () => {
  it('only the super-admin manages administrator roles and asks for settings changes', () => {
    expect(admin('SUPER_ADMIN')).toEqual(
      expect.arrayContaining(['users.manage', 'users.adminRoles', 'settings.request']),
    );
    for (const subRole of ['COMPLIANCE', 'FINANCE', 'SUPPORT'] as const) {
      expect(admin(subRole)).not.toContain('users.adminRoles');
      expect(admin(subRole)).not.toContain('settings.request');
    }
    for (const subRole of ['FINANCE', 'SUPPORT'] as const)
      expect(admin(subRole)).not.toContain('users.manage');
  });

  it('Opérations is the second administrator: everything else of the super-admin', () => {
    const kept = ['users.adminRoles', 'settings.request', 'users.manage', 'users.support'];
    expect([...admin('COMPLIANCE')].sort()).toEqual(
      admin('SUPER_ADMIN')
        .filter((permission) => !kept.includes(permission))
        .sort(),
    );
    expect(admin('COMPLIANCE')).toEqual(
      expect.arrayContaining([
        'companies.manage',
        'merchants.manage',
        'approvals.decide',
        'kyc.decide',
        'orders.confirm',
        'orders.validate',
        'payouts.decide',
        'commissions.request',
      ]),
    );
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

  // Request of 2026-11-17: Opérations, Finance and Support only read the users.
  it('only the super-admin changes a user (invitations and PINs included)', () => {
    expect(admin('SUPER_ADMIN')).toEqual(expect.arrayContaining(['users.manage', 'users.support']));
    for (const subRole of ['COMPLIANCE', 'FINANCE', 'SUPPORT'] as const) {
      expect(admin(subRole)).toContain('users.read');
      expect(admin(subRole)).not.toContain('users.manage');
      expect(admin(subRole)).not.toContain('users.support');
      expect(admin(subRole)).not.toContain('users.adminRoles');
    }
  });

  it('money decisions belong to finance, operations and the super-admin; KYC never to finance', () => {
    const money = ['commissions.request', 'orders.confirm', 'orders.validate', 'payouts.decide'];
    expect(admin('FINANCE')).toEqual(expect.arrayContaining([...money, 'approvals.decide']));
    expect(admin('FINANCE')).not.toContain('kyc.decide');
    expect(admin('FINANCE')).not.toContain('kycDocuments.read');
    for (const permission of money) expect(admin('SUPPORT')).not.toContain(permission);
  });

  it('no administrator permission opens a company or merchant route', () => {
    const tenant = [
      ...(['OWNER', 'MANAGER', 'FINANCE', 'ACCOUNTANT', 'READ_ONLY'] as const).flatMap((sub) =>
        permissionsOf('COMPANY', sub),
      ),
      ...(['OWNER', 'CASHIER', 'ACCOUNTANT'] as const).flatMap((sub) =>
        permissionsOf('MERCHANT', sub),
      ),
      ...permissionsOf('EMPLOYEE', null),
      ...permissionsOf('FAMILY_MEMBER', null),
    ];
    for (const permission of admin('SUPER_ADMIN')) expect(tenant).not.toContain(permission);
  });

  it('fraud alerts and disputes are read by operations and the super-admin only', () => {
    expect(admin('SUPER_ADMIN')).toContain('risk.read');
    expect(admin('COMPLIANCE')).toContain('risk.read');
    expect(admin('FINANCE')).not.toContain('risk.read');
    expect(admin('SUPPORT')).not.toContain('risk.read');
  });
});
