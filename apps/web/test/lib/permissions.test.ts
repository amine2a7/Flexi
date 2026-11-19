// TEST-FIRST (decision C of 2026-10-23): the web shows a page, a menu entry or an action only when
// the session (`/v1/me` permissions) allows it. A display comfort: the API refuses anyway.
import { describe, expect, it } from 'vitest';
import { can, canOpen, firstOpenPage } from '@/lib/session/permissions';
import { sessionOf } from '../fixtures/sessions';

const account = sessionOf;

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

  it('only the owners open « Utilisateurs »; a cashier never opens the shop page nor support', () => {
    expect(canOpen(account('entreprise@flexipay.test'), '/entreprise/utilisateurs')).toBe(true);
    expect(canOpen(account('commercant@flexipay.test'), '/commercant/utilisateurs')).toBe(true);
    expect(canOpen(account('commercant@flexipay.test'), '/commercant/mon-commerce')).toBe(true);
    expect(canOpen(account('rh@flexipay.test'), '/entreprise/utilisateurs')).toBe(false);
    expect(canOpen(account('comptable@flexipay.test'), '/entreprise/utilisateurs')).toBe(false);
    const cashier = account('caissier@flexipay.test');
    expect(canOpen(cashier, '/commercant/utilisateurs')).toBe(false);
    expect(canOpen(cashier, '/commercant/mon-commerce')).toBe(false);
    expect(canOpen(cashier, '/commercant/support')).toBe(false);
  });

  it('company Finance: orders, transfers and invoices, never employees, departments nor allocation', () => {
    const finance = account('comptable@flexipay.test');
    expect(canOpen(finance, '/entreprise/commandes/nouvelle')).toBe(true);
    expect(canOpen(finance, '/entreprise/factures')).toBe(true);
    expect(canOpen(finance, '/entreprise/employes')).toBe(false);
    expect(canOpen(finance, '/entreprise/departements')).toBe(false);
    expect(canOpen(finance, '/entreprise/attribution')).toBe(false);
    expect(canOpen(account('rh@flexipay.test'), '/entreprise/departements')).toBe(true);
  });

  it('a page outside the table is open (employee space, unknown paths: the API decides)', () => {
    expect(canOpen(account('beneficiaire@flexipay.test'), '/beneficiaire/payer')).toBe(true);
  });
});

// W-FIN: one test per page, the account allowed to open it and another role refused.
describe('W-FIN pages: allowed role, refused role', () => {
  const pages: readonly [string, string, string][] = [
    ['/admin/grand-livre', 'admin2@flexipay.test', 'operations@flexipay.test'],
    ['/admin/grand-livre', 'admin@flexipay.test', 'support@flexipay.test'],
    ['/admin/factures', 'admin2@flexipay.test', 'support@flexipay.test'],
    [
      '/admin/factures/0193a000-0000-7000-8000-000000000001',
      'operations@flexipay.test',
      'support@flexipay.test',
    ],
    [
      '/entreprise/factures/0193a000-0000-7000-8000-000000000001',
      'comptable@flexipay.test',
      'rh@flexipay.test',
    ],
    ['/entreprise/utilisateurs', 'entreprise@flexipay.test', 'rh@flexipay.test'],
    ['/commercant/utilisateurs', 'commercant@flexipay.test', 'caissier@flexipay.test'],
    ['/commercant/caissiers', 'commercant@flexipay.test', 'caissier@flexipay.test'],
    ['/commercant/caisses', 'commercant@flexipay.test', 'caissier@flexipay.test'],
    [
      '/admin/entreprises/0193a000-0000-7000-8000-000000000001',
      'support@flexipay.test',
      'entreprise@flexipay.test',
    ],
    [
      '/admin/commercants/0193a000-0000-7000-8000-000000000001',
      'admin2@flexipay.test',
      'commercant@flexipay.test',
    ],
  ];
  for (const [path, allowed, refused] of pages) {
    it(`${path}: ${allowed} opens it, ${refused} is refused`, () => {
      expect(canOpen(account(allowed), path)).toBe(true);
      expect(canOpen(account(refused), path)).toBe(false);
    });
  }
});
