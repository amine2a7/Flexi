// TEST-FIRST (decisions A, B of 2026-10-23, e3 of 2026-10-22): account lifecycle rules.
import { describe, expect, it } from 'vitest';
import {
  canReceiveCredits,
  canSignIn,
  canSpend,
  changeRefusal,
  graceEnd,
  nextStatus,
} from '../../src/common/account-lifecycle.js';

const NOW = new Date('2026-10-29T10:00:00.000Z');
const LATER = new Date('2026-11-28T10:00:00.000Z');
const EARLIER = new Date('2026-10-01T10:00:00.000Z');

describe('transitions', () => {
  it('suspends an active or invited account, reactivates a suspended one only', () => {
    expect(nextStatus('ACTIVE', 'SUSPEND')).toBe('SUSPENDED');
    expect(nextStatus('INVITED', 'SUSPEND')).toBe('SUSPENDED');
    expect(nextStatus('SUSPENDED', 'REACTIVATE')).toBe('ACTIVE');
    expect(nextStatus('ACTIVE', 'REACTIVATE')).toBeNull();
    expect(nextStatus('SUSPENDED', 'SUSPEND')).toBeNull();
  });

  it('deactivates for good: no way back from DEACTIVATED', () => {
    for (const from of ['INVITED', 'ACTIVE', 'SUSPENDED'] as const) {
      expect(nextStatus(from, 'DEACTIVATE')).toBe('DEACTIVATED');
    }
    for (const action of ['SUSPEND', 'REACTIVATE', 'DEACTIVATE'] as const) {
      expect(nextStatus('DEACTIVATED', action)).toBeNull();
    }
  });

  it('freezes the end of the grace period from the number of days', () => {
    expect(graceEnd(NOW, 30).toISOString()).toBe('2026-11-28T10:00:00.000Z');
  });
});

describe('what each status allows', () => {
  it('a suspended employee keeps its balance but neither pays nor receives', () => {
    const suspended = { status: 'SUSPENDED' as const, graceUntil: null };
    expect(canSpend(suspended, NOW)).toBe(false);
    expect(canReceiveCredits(suspended)).toBe(false);
  });

  it('a deactivated employee only spends until the end of its grace period', () => {
    const inGrace = { status: 'DEACTIVATED' as const, graceUntil: LATER };
    const closed = { status: 'DEACTIVATED' as const, graceUntil: EARLIER };
    expect(canSpend(inGrace, NOW)).toBe(true);
    expect(canReceiveCredits(inGrace)).toBe(false);
    expect(canSpend(closed, NOW)).toBe(false);
  });

  it('signs in when active, or as an employee in its grace period', () => {
    const employee = { status: 'DEACTIVATED' as const, graceUntil: LATER };
    expect(canSignIn({ status: 'ACTIVE', role: 'ADMIN' }, null, NOW)).toBe(true);
    expect(canSignIn({ status: 'SUSPENDED', role: 'EMPLOYEE' }, employee, NOW)).toBe(false);
    expect(canSignIn({ status: 'DEACTIVATED', role: 'EMPLOYEE' }, employee, NOW)).toBe(true);
    expect(
      canSignIn(
        { status: 'DEACTIVATED', role: 'EMPLOYEE' },
        { status: 'DEACTIVATED', graceUntil: EARLIER },
        NOW,
      ),
    ).toBe(false);
    // Any other deactivated account is closed at once.
    expect(canSignIn({ status: 'DEACTIVATED', role: 'COMPANY' }, null, NOW)).toBe(false);
  });
});

describe('guards (decision B)', () => {
  const superAdmin = { id: 'b', role: 'ADMIN' as const, subRole: 'SUPER_ADMIN' as const };

  it('nobody changes its own status or role', () => {
    expect(
      changeRefusal({ actorId: 'b', target: superAdmin, activeSuperAdmins: 3, action: 'SUSPEND' }),
    ).toBe('SELF');
    expect(
      changeRefusal({ actorId: 'b', target: superAdmin, activeSuperAdmins: 3, action: 'ROLE' }),
    ).toBe('SELF');
  });

  it('the last active super-admin is never suspended, deactivated nor demoted', () => {
    for (const action of ['SUSPEND', 'DEACTIVATE'] as const) {
      expect(
        changeRefusal({ actorId: 'a', target: superAdmin, activeSuperAdmins: 1, action }),
      ).toBe('LAST_SUPER_ADMIN');
    }
    expect(
      changeRefusal({
        actorId: 'a',
        target: superAdmin,
        activeSuperAdmins: 1,
        action: 'ROLE',
        newSubRole: 'FINANCE',
      }),
    ).toBe('LAST_SUPER_ADMIN');
    expect(
      changeRefusal({ actorId: 'a', target: superAdmin, activeSuperAdmins: 2, action: 'SUSPEND' }),
    ).toBeNull();
    expect(
      changeRefusal({
        actorId: 'a',
        target: { id: 'c', role: 'ADMIN', subRole: 'FINANCE' },
        activeSuperAdmins: 1,
        action: 'DEACTIVATE',
      }),
    ).toBeNull();
  });
});
