// TEST-FIRST (decision C of 2026-10-23): the web shows a page, a menu entry or an action only when
// the session (`/v1/me` permissions) allows it. A display comfort: the API refuses anyway.
import { describe, expect, it } from 'vitest';
import { createDemoAccounts } from '@/mocks/fixtures/accounts';
import { can, canOpen, firstOpenPage } from '@/lib/session/permissions';

const account = (identifier: string) => {
  const found = createDemoAccounts().find((item) => item.identifier === identifier);
  if (found === undefined) throw new Error(identifier);
  return found;
};

describe('page permissions', () => {
  it('support never opens the dashboard, settings, audit, orders or payouts', () => {
    const support = account('support@flexipay.test');
    for (const path of [
      '/admin',
      '/admin/parametres',
      '/admin/audit',
      '/admin/commandes',
      '/admin/virements/abc',
      '/admin/reglements',
      '/admin/commissions',
      '/admin/kyc',
    ]) {
      expect({ path, open: canOpen(support, path) }).toEqual({ path, open: false });
    }
    for (const path of ['/admin/commercants', '/admin/transactions', '/admin/messages']) {
      expect({ path, open: canOpen(support, path) }).toEqual({ path, open: true });
    }
    expect(firstOpenPage(support, ['/admin', '/admin/commercants'])).toBe('/admin/commercants');
  });

  it('finance opens settings but never decides KYC; operations never settings', () => {
    const finance = account('admin2@flexipay.test');
    const operations = account('operations@flexipay.test');
    expect(canOpen(finance, '/admin/parametres')).toBe(true);
    expect(can(finance, 'kyc.decide')).toBe(false);
    expect(can(finance, 'commissions.request')).toBe(true);
    expect(canOpen(operations, '/admin/parametres')).toBe(false);
    expect(can(operations, 'kyc.decide')).toBe(true);
    expect(can(operations, 'orders.confirm')).toBe(false);
  });

  it('the super-admin opens every admin page', () => {
    const admin = account('admin@flexipay.test');
    for (const path of ['/admin', '/admin/parametres', '/admin/audit', '/admin/messages']) {
      expect(canOpen(admin, path)).toBe(true);
    }
  });

  it('a cashier collects and reads the history, never payouts nor the dashboard', () => {
    const cashier = account('caissier@flexipay.test');
    expect(canOpen(cashier, '/commercant/encaissement')).toBe(true);
    expect(canOpen(cashier, '/commercant/historique')).toBe(true);
    expect(canOpen(cashier, '/commercant/virements')).toBe(false);
    expect(canOpen(cashier, '/commercant')).toBe(false);
  });

  it('company HR manages employees and allocations, never orders', () => {
    const hr = account('rh@flexipay.test');
    expect(canOpen(hr, '/entreprise/employes/import')).toBe(true);
    expect(canOpen(hr, '/entreprise/attribution')).toBe(true);
    expect(canOpen(hr, '/entreprise/commandes')).toBe(false);
    const readOnly = account('lecture@flexipay.test');
    expect(canOpen(readOnly, '/entreprise/commandes')).toBe(true);
    expect(canOpen(readOnly, '/entreprise/commandes/nouvelle')).toBe(false);
    expect(canOpen(readOnly, '/entreprise/employes/import')).toBe(false);
  });

  it('a page outside the table is open (employee space, unknown paths: the API decides)', () => {
    expect(canOpen(account('beneficiaire@flexipay.test'), '/beneficiaire/payer')).toBe(true);
  });
});
