import type { Schemas } from '@flexipay/api-client';
import { CREDIT_TYPES, type CreditType } from './credit-types';
import { COMPANY_TENANT, DEMO_PIN, MERCHANT_TENANT } from './fixtures/accounts';
import { DAY, MINUTE, calendarDate, createRandom, iso } from './fixtures/random';

type S = Schemas;

/** Demo beneficiary (Yasmine J., employee of the demo company), shared by web and mobile tests. */
export interface MockEmployee {
  profile: S['EmployeeProfile'];
  /** Operations, newest first; each one moves the balance of ITS type only. */
  operations: S['EmployeeOperationDetail'][];
  requests: (S['EmployeePaymentRequest'] & { merchantPaymentId?: string })[];
  activeCode?: { code: string; expiresAt: number };
  pin: string;
  pinFailures: number;
  pinLockedUntil?: number;
  nextExpiryDate: string;
}

/** Shops of every credit type around the demo beneficiary (the first one is the demo shop). */
export const EMPLOYEE_SHOPS: readonly {
  name: string;
  city: string;
  types: readonly CreditType[];
}[] = [
  { name: MERCHANT_TENANT.label, city: 'Tunis', types: ['RESTAURATION', 'CADEAUX'] },
  { name: 'Restaurant Le Jasmin', city: 'Tunis', types: ['RESTAURATION'] },
  { name: 'Boulangerie Ennour', city: 'La Marsa', types: ['RESTAURATION'] },
  { name: 'Mode & Vous', city: 'La Marsa', types: ['HABILLEMENT'] },
  { name: 'Station Agil Lac', city: 'Tunis', types: ['CARBURANT'] },
  { name: 'Librairie Al Kitab', city: 'Ariana', types: ['CADEAUX'] },
];

const MONTHLY_CREDIT: Record<CreditType, number> = {
  RESTAURATION: 220_000,
  HABILLEMENT: 75_000,
  CARBURANT: 100_000,
  CADEAUX: 40_000,
};
const PAYMENT_RANGE: Record<CreditType, [number, number]> = {
  RESTAURATION: [9, 48],
  HABILLEMENT: [50, 190],
  CARBURANT: [40, 120],
  CADEAUX: [30, 110],
};

export function buildEmployee(now: number): MockEmployee {
  const random = createRandom(53);
  type Draft = Omit<S['EmployeeOperationDetail'], 'balanceAfterMillimes'>;
  const events: Draft[] = [];
  for (let month = 5; month >= 0; month -= 1) {
    for (const creditType of CREDIT_TYPES) {
      events.push({
        id: random.uuid(),
        reference: `ATT-${String(4100 - month)}-${creditType.slice(0, 3)}`,
        type: 'ALLOCATION',
        direction: 'CREDIT',
        amountMillimes: MONTHLY_CREDIT[creditType],
        creditType,
        counterpartyName: COMPANY_TENANT.label,
        counterpartyCity: null,
        status: 'COMPLETED',
        occurredAt: iso(now - month * 30 * DAY - 20 * DAY),
      });
    }
  }
  for (let index = 0; index < 40; index += 1) {
    const shop = random.pick(EMPLOYEE_SHOPS);
    const creditType = random.pick(shop.types);
    const [min, max] = PAYMENT_RANGE[creditType];
    events.push({
      id: random.uuid(),
      reference: `PAY-${String(7600 - index)}`,
      type: 'PAYMENT',
      direction: 'DEBIT',
      amountMillimes: random.int(min, max) * 500,
      creditType,
      counterpartyName: shop.name,
      counterpartyCity: shop.city,
      status: index === 4 || index === 17 ? 'REFUSED' : 'COMPLETED',
      occurredAt: iso(now - (index * 4 + 1) * DAY - random.int(30, 600) * MINUTE),
    });
  }
  events.push({
    id: random.uuid(),
    reference: 'EXP-0920',
    type: 'EXPIRY',
    direction: 'DEBIT',
    amountMillimes: 18_500,
    creditType: 'RESTAURATION',
    counterpartyName: COMPANY_TENANT.label,
    counterpartyCity: null,
    status: 'COMPLETED',
    occurredAt: iso(now - 150 * DAY),
  });
  // Balance of each type after each operation, oldest first; a payment that the type balance
  // cannot cover is refused (no payment with another type).
  events.sort((a, b) => a.occurredAt.localeCompare(b.occurredAt));
  const balances: Record<CreditType, number> = {
    RESTAURATION: 0,
    HABILLEMENT: 0,
    CARBURANT: 0,
    CADEAUX: 0,
  };
  const operations = events.map((event): S['EmployeeOperationDetail'] => {
    let status = event.status;
    if (status === 'COMPLETED') {
      const next =
        balances[event.creditType] +
        (event.direction === 'CREDIT' ? event.amountMillimes : -event.amountMillimes);
      if (next < 0) status = 'REFUSED';
      else balances[event.creditType] = next;
    }
    return { ...event, status, balanceAfterMillimes: balances[event.creditType] };
  });
  operations.reverse();
  return {
    profile: {
      firstName: 'Yasmine',
      lastName: 'Jebali',
      employeeNumber: 'EMP-1007',
      email: 'yasmine.jebali@carthage-services.test',
      phone: '+21698123456',
      companyName: COMPANY_TENANT.label,
      pinSet: true,
    },
    operations,
    requests: [],
    pin: DEMO_PIN,
    pinFailures: 0,
    nextExpiryDate: calendarDate(now + 45 * DAY),
  };
}

/** Current balance of one credit type: after its most recent completed operation. */
export function employeeBalance(employee: MockEmployee, creditType: CreditType): number {
  return (
    employee.operations.find(
      (operation) => operation.status === 'COMPLETED' && operation.creditType === creditType,
    )?.balanceAfterMillimes ?? 0
  );
}
