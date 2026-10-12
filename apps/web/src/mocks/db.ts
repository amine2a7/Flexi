import type { Schemas } from '@flexipay/api-client';
import {
  COMPANY_TENANT,
  MERCHANT_TENANT,
  createDemoAccounts,
  type DemoAccount,
} from './fixtures/accounts';
import {
  CITIES,
  DAY,
  FIRST_NAMES,
  LAST_NAMES,
  MINUTE,
  calendarDate,
  createRandom,
  iso,
  tunisianPhone,
} from './fixtures/random';

type S = Schemas;

// In-memory state of the mocked API. Actions (collect, order, create…) change it for the whole
// browser session; a page reload starts again from the same seed.

export type MockPayment = S['MerchantPayment'] & { confirmAt?: number; willRefuse?: boolean };
export type MockApproval = Omit<S['Approval'], 'initiatedByMe'> & {
  initiatorId: string;
  profileId?: string;
  settings?: S['PlatformSettings'];
};

export interface MockSession {
  accountId: string;
  step: 'NONE' | 'PASSWORD_CHANGE' | 'MFA_ENROLL';
  restrictedUntil?: number;
}

export interface MockDb {
  accounts: DemoAccount[];
  session: MockSession | null;
  challenges: Map<string, { accountId: string; expiresAt: number }>;
  merchant: {
    rateBps: number;
    payments: MockPayment[];
    initiations: number[];
    quotes: Map<string, S['PayoutQuote']>;
    payouts: S['PayoutRequest'][];
    settlements: S['Settlement'][];
    documents: S['MerchantDocument'][];
    profile: S['MerchantProfile'];
  };
  company: {
    walletMillimes: number;
    employees: S['Employee'][];
    orders: S['CreditOrder'][];
    invoices: S['Invoice'][];
    previews: Map<string, S['EmployeeImportPreview']>;
  };
  admin: {
    merchants: S['MerchantAccount'][];
    companies: S['CompanyAccount'][];
    profiles: S['CommissionProfile'][];
    approvals: MockApproval[];
    batches: S['SettlementBatch'][];
    audit: S['AuditLogEntry'][];
    settings: S['PlatformSettings'];
  };
}

const SHOP_PREFIXES = [
  'Café',
  'Restaurant',
  'Superette',
  'Boulangerie',
  'Snack',
  'Pâtisserie',
] as const;
const SHOP_NAMES = [
  'El Medina',
  'Ennour',
  'Essalem',
  'Zitouna',
  'El Yasmine',
  'Ennakhla',
  'El Amen',
  'Carthage',
  'Essaada',
  'El Waha',
  'Dar Salma',
  'Le Jasmin',
  'El Bahja',
  'Ennasr',
  'La Kasbah',
  'Les Oliviers',
  'El Andalous',
  'Sidi Saber',
  'Bab Bhar',
  'El Manar',
] as const;
const CATEGORY_BY_PREFIX: Record<(typeof SHOP_PREFIXES)[number], S['MerchantCategory']> = {
  Café: 'CAFE',
  Restaurant: 'RESTAURANT',
  Superette: 'GROCERY',
  Boulangerie: 'BAKERY',
  Snack: 'FAST_FOOD',
  Pâtisserie: 'BAKERY',
};
const COMPANY_NAMES = [
  'Groupe Carthage Services',
  'Sfax Industries Mécaniques',
  'Tunis Logistique',
  'Atlas Informatique',
  'Méditerranée Textiles',
  'Cap Bon Agroalimentaire',
  'Sahel Distribution',
  'Djerba Tourisme Services',
  'Bizerte Chantiers Navals',
  'Kairouan Céramiques',
  'Nabeul Emballages',
  'Gabès Chimie Services',
  'Monastir Électronique',
  'Sousse Conseil',
  'Ariana Télécom Services',
  'Manouba Plastiques',
  'La Marsa Assurances Conseil',
  'Hammamet Hôtellerie Services',
  'Mahdia Pêche et Froid',
  'Ben Arous Métallurgie',
  'Tunis Santé Services',
  'Sfax Huileries Réunies',
  'Sousse Automobiles',
  'Carthage Énergie Services',
  'Medjerda Agricole',
  'Zaghouan Eaux Minérales',
  'Kélibia Conserves',
  'Tozeur Dattes Export',
  'Béja Laiterie Centrale',
  'Siliana Matériaux',
  'Jendouba Bois et Liège',
  'Tataouine Transport',
] as const;

function amount(
  random: ReturnType<typeof createRandom>,
  min: number,
  max: number,
  step = 500,
): number {
  return random.int(Math.ceil(min / step), Math.floor(max / step)) * step;
}

/** Commission in millimes, rounded half up on the integer value (mock of the server rule). */
export function commissionOf(grossMillimes: number, rateBps: number): number {
  return Math.floor((grossMillimes * rateBps + 5_000) / 10_000);
}

function personName(random: ReturnType<typeof createRandom>) {
  return { firstName: random.pick(FIRST_NAMES), lastName: random.pick(LAST_NAMES) };
}

function buildMerchant(now: number) {
  const random = createRandom(7);
  const rateBps = 200;
  const payments: MockPayment[] = [];
  let sequence = 4810;
  const addPayment = (createdAt: number, status: S['PaymentStatus']) => {
    const { firstName, lastName } = personName(random);
    sequence += 1;
    payments.push({
      id: random.uuid(),
      reference: `PAY-${String(sequence)}`,
      status,
      amountMillimes: amount(random, 4_500, 62_000),
      customer: {
        firstName,
        lastInitial: lastName.charAt(0),
        maskedEmployeeNumber: `•••${random.digits(4)}`,
      },
      createdAt: iso(createdAt),
      expiresAt: null,
    });
  };
  for (let index = 0; index < 46; index += 1) {
    const roll = random.next();
    addPayment(
      now - random.int(3, 30) * DAY - random.int(0, 600) * MINUTE,
      roll < 0.88 ? 'SETTLED' : roll < 0.95 ? 'REFUSED' : 'DISPUTED',
    );
  }
  for (let index = 0; index < 38; index += 1) {
    addPayment(
      now - random.int(5, 2 * 24 * 60) * MINUTE,
      random.next() < 0.88 ? 'CONFIRMED' : 'REFUSED',
    );
  }
  payments.sort((a, b) => b.createdAt.localeCompare(a.createdAt));

  const payouts: S['PayoutRequest'][] = Array.from({ length: 32 }, (_, index) => {
    const gross = amount(random, 150_000, 2_400_000, 1_000);
    const commission = commissionOf(gross, rateBps);
    const statuses: S['PayoutRequestStatus'][] = [
      'EXECUTED',
      'EXECUTED',
      'EXECUTED',
      'SENT',
      'CHECKED',
      'REJECTED',
    ];
    return {
      id: random.uuid(),
      reference: `VIR-2026-${String(9300 - index)}`,
      status: index < 2 ? 'REQUESTED' : random.pick(statuses),
      grossMillimes: gross,
      commissionRateBps: rateBps,
      commissionMillimes: commission,
      netMillimes: gross - commission,
      requestedAt: iso(now - (index * 3 + 1) * DAY - random.int(0, 500) * MINUTE),
      maskedIban: '•••• 4821',
    };
  });

  const settlements: S['Settlement'][] = Array.from({ length: 42 }, (_, index) => {
    const gross = amount(random, 300_000, 1_900_000, 500);
    const commission = commissionOf(gross, rateBps);
    return {
      id: random.uuid(),
      reference: `REG-${calendarDate(now + (2 - index) * DAY).replaceAll('-', '')}`,
      settlementDate: calendarDate(now + (2 - index) * DAY),
      paymentsCount: random.int(12, 64),
      grossMillimes: gross,
      commissionMillimes: commission,
      netMillimes: gross - commission,
      status: index < 2 ? 'SCHEDULED' : 'PAID',
    };
  });

  const documents: S['MerchantDocument'][] = [];
  for (let month = 0; month < 12; month += 1) {
    const date = new Date(now);
    date.setUTCDate(1);
    date.setUTCMonth(date.getUTCMonth() - month - 1);
    const period = date.toISOString().slice(0, 7);
    for (const type of ['COMMISSION_INVOICE', 'STATEMENT', 'CERTIFICATE'] as const) {
      documents.push({
        id: random.uuid(),
        type,
        period,
        issuedAt: iso(now - (month * 30 + 28) * DAY),
      });
    }
  }

  const profile: S['MerchantProfile'] = {
    name: MERCHANT_TENANT.label,
    category: 'CAFE',
    city: 'Tunis',
    address: '14, rue de Marseille, 1000 Tunis',
    phone: '+21698421337',
    maskedIban: '•••• •••• •••• 4821',
    commissionProfile: { id: '01930a1d-0001-7b00-8000-000000000001', name: 'Standard', rateBps },
    pointsOfSale: [
      { id: random.uuid(), name: 'Café El Medina — Centre-ville', city: 'Tunis' },
      { id: random.uuid(), name: 'Café El Medina — Lac 2', city: 'Tunis' },
      { id: random.uuid(), name: 'Café El Medina — La Marsa', city: 'La Marsa' },
    ],
    staff: [
      { id: random.uuid(), displayName: 'Sami B.', subRole: 'OWNER' },
      { id: random.uuid(), displayName: 'Salma B.', subRole: 'CASHIER' },
      { id: random.uuid(), displayName: 'Walid T.', subRole: 'CASHIER' },
      { id: random.uuid(), displayName: 'Imen J.', subRole: 'ACCOUNTANT' },
    ],
  };

  return {
    rateBps,
    payments,
    initiations: [],
    quotes: new Map(),
    payouts,
    settlements,
    documents,
    profile,
  };
}

function buildCompany(now: number) {
  const random = createRandom(11);
  const employees: S['Employee'][] = Array.from({ length: 84 }, (_, index) => {
    const { firstName, lastName } = personName(random);
    const roll = random.next();
    const status: S['EmployeeStatus'] =
      roll < 0.84 ? 'ACTIVE' : roll < 0.94 ? 'INVITED' : 'SUSPENDED';
    const slug = `${firstName}.${lastName}`
      .normalize('NFD')
      .replace(/[̀-ͯ]/g, '')
      .replaceAll(' ', '')
      .toLowerCase();
    return {
      id: random.uuid(),
      employeeNumber: `EMP-${String(1001 + index)}`,
      firstName,
      lastName,
      email: `${slug}${String(index)}@carthage-services.test`,
      phone: tunisianPhone(random),
      status,
      monthAllocatedMillimes: status === 'ACTIVE' ? amount(random, 60_000, 220_000, 5_000) : 0,
    };
  });

  const orderStatuses: S['OrderStatus'][] = [
    'CREDITED',
    'CREDITED',
    'CREDITED',
    'CREDITED',
    'RECONCILED',
    'PAID',
  ];
  const orders: S['CreditOrder'][] = Array.from({ length: 36 }, (_, index) => {
    const value = amount(random, 4_000_000, 32_000_000, 100_000);
    const fees = commissionOf(value, 150);
    return {
      id: random.uuid(),
      reference: `CMD-2026-${String(7200 - index)}`,
      status:
        index < 2
          ? 'CREATED'
          : index === 7 || index === 19
            ? 'CANCELLED'
            : random.pick(orderStatuses),
      amountMillimes: value,
      feesMillimes: fees,
      totalMillimes: value + fees,
      createdAt: iso(now - (index * 8 + 1) * DAY - random.int(0, 600) * MINUTE),
      paymentReference: `FXP-${random.digits(8)}`,
    };
  });

  const invoices: S['Invoice'][] = orders
    .filter((order) => order.status !== 'CREATED' && order.status !== 'CANCELLED')
    .map((order, index) => ({
      id: random.uuid(),
      number: `FAC-2026-${String(5400 - index)}`,
      orderReference: order.reference,
      totalMillimes: order.totalMillimes,
      issuedAt: order.createdAt,
      status: order.status === 'PAID' ? 'UNPAID' : 'PAID',
    }));

  return { walletMillimes: 48_250_000, employees, orders, invoices, previews: new Map() };
}

function buildAdmin(now: number, merchantRate: number) {
  const random = createRandom(23);
  const profiles: S['CommissionProfile'][] = [
    {
      id: '01930a1d-0001-7b00-8000-000000000001',
      name: 'Standard',
      rateBps: merchantRate,
      merchantsCount: 0,
      updatedAt: iso(now - 90 * DAY),
    },
    {
      id: '01930a1d-0002-7b00-8000-000000000002',
      name: 'Réduit',
      rateBps: 150,
      merchantsCount: 0,
      updatedAt: iso(now - 60 * DAY),
    },
    {
      id: '01930a1d-0003-7b00-8000-000000000003',
      name: 'Partenaire',
      rateBps: 100,
      merchantsCount: 0,
      updatedAt: iso(now - 45 * DAY),
    },
    {
      id: '01930a1d-0004-7b00-8000-000000000004',
      name: 'Premium',
      rateBps: 250,
      merchantsCount: 0,
      updatedAt: iso(now - 20 * DAY),
    },
  ];
  const summary = (profile: S['CommissionProfile']) => ({
    id: profile.id,
    name: profile.name,
    rateBps: profile.rateBps,
  });

  const merchants: S['MerchantAccount'][] = [];
  const used = new Set<string>([MERCHANT_TENANT.label]);
  merchants.push({
    id: MERCHANT_TENANT.id,
    name: MERCHANT_TENANT.label,
    category: 'CAFE',
    city: 'Tunis',
    status: 'APPROVED',
    commissionProfile: summary(profiles[0]!),
    createdAt: iso(now - 200 * DAY),
  });
  while (merchants.length < 46) {
    const prefix = random.pick(SHOP_PREFIXES);
    const name = `${prefix} ${random.pick(SHOP_NAMES)}`;
    if (used.has(name)) continue;
    used.add(name);
    const roll = random.next();
    merchants.push({
      id: random.uuid(),
      name,
      category: CATEGORY_BY_PREFIX[prefix],
      city: random.pick(CITIES),
      status:
        roll < 0.78
          ? 'APPROVED'
          : roll < 0.9
            ? 'PENDING_KYC'
            : roll < 0.96
              ? 'SUSPENDED'
              : 'REJECTED',
      commissionProfile: summary(random.pick(profiles)),
      createdAt: iso(now - random.int(1, 400) * DAY),
    });
  }
  for (const profile of profiles) {
    profile.merchantsCount = merchants.filter(
      (merchant) => merchant.commissionProfile.id === profile.id,
    ).length;
  }

  const companies: S['CompanyAccount'][] = COMPANY_NAMES.map((name, index) => ({
    id: index === 0 ? COMPANY_TENANT.id : random.uuid(),
    name,
    city: index === 0 ? 'Tunis' : random.pick(CITIES),
    status: index === 0 ? 'APPROVED' : random.next() < 0.85 ? 'APPROVED' : 'PENDING_KYC',
    employeesCount: index === 0 ? 84 : random.int(12, 640),
    createdAt: iso(now - random.int(5, 500) * DAY),
  }));

  const otherAdmin = { id: '01930a1c-0009-7a00-8000-000000000009', name: 'Hela R.' };
  const approvals: MockApproval[] = [
    {
      id: random.uuid(),
      type: 'COMMISSION_RATE_CHANGE',
      status: 'PENDING',
      subject: 'Partenaire',
      oldRateBps: 100,
      newRateBps: 120,
      reason: 'Révision annuelle des partenariats',
      initiatorName: otherAdmin.name,
      initiatorId: otherAdmin.id,
      profileId: profiles[2]?.id,
      createdAt: iso(now - 3 * 60 * MINUTE),
    },
    {
      id: random.uuid(),
      type: 'COMMISSION_RATE_CHANGE',
      status: 'PENDING',
      subject: 'Premium',
      oldRateBps: 250,
      newRateBps: 230,
      reason: 'Alignement sur la concurrence',
      initiatorName: otherAdmin.name,
      initiatorId: otherAdmin.id,
      profileId: profiles[3]?.id,
      createdAt: iso(now - 26 * 60 * MINUTE),
    },
    {
      id: random.uuid(),
      type: 'COMMISSION_RATE_CHANGE',
      status: 'APPROVED',
      subject: 'Réduit',
      oldRateBps: 175,
      newRateBps: 150,
      reason: 'Campagne de recrutement des commerçants',
      initiatorName: otherAdmin.name,
      initiatorId: otherAdmin.id,
      createdAt: iso(now - 60 * DAY),
    },
    {
      id: random.uuid(),
      type: 'SETTINGS_CHANGE',
      status: 'REJECTED',
      subject: 'Seuil minimal de virement',
      reason: 'Seuil jugé trop bas',
      initiatorName: otherAdmin.name,
      initiatorId: otherAdmin.id,
      createdAt: iso(now - 75 * DAY),
    },
  ];

  const batches: S['SettlementBatch'][] = Array.from({ length: 42 }, (_, index) => {
    const gross = amount(random, 18_000_000, 96_000_000, 1_000);
    const commission = commissionOf(gross, 190);
    return {
      id: random.uuid(),
      reference: `LOT-${calendarDate(now + (2 - index) * DAY).replaceAll('-', '')}`,
      settlementDate: calendarDate(now + (2 - index) * DAY),
      merchantsCount: random.int(28, 46),
      grossMillimes: gross,
      commissionMillimes: commission,
      netMillimes: gross - commission,
      status: index < 2 ? 'SCHEDULED' : 'PAID',
    };
  });

  const actions = [
    ['auth.login', 'Connexion'],
    ['merchants.create', 'Commerçant'],
    ['companies.create', 'Entreprise'],
    ['commissions.request', 'Profil de commission'],
    ['approvals.approve', 'Demande de validation'],
    ['kyc.validate', 'Dossier KYC'],
    ['payouts.execute', 'Lot de virements'],
    ['settings.request', 'Paramétrage'],
  ] as const;
  const actors = ['Amine K.', 'Hela R.', 'Mehdi S.', 'Olfa D.'];
  const audit: S['AuditLogEntry'][] = Array.from({ length: 124 }, (_, index) => {
    const [action, label] = random.pick(actions);
    return {
      id: random.uuid(),
      occurredAt: iso(now - index * 97 * MINUTE - random.int(0, 60) * MINUTE),
      actorName: random.pick(actors),
      action,
      target: `${label} ${random.pick(merchants).name}`,
    };
  });

  return {
    merchants,
    companies,
    profiles,
    approvals,
    batches,
    audit,
    settings: {
      payoutMinimumMillimes: 20_000,
      creditValidityMonths: 12,
      maxFamilyMembers: 4,
      orderFeeRateBps: 150,
    },
  };
}

function build(): MockDb {
  const now = Date.now();
  const merchant = buildMerchant(now);
  return {
    accounts: createDemoAccounts(),
    session: null,
    challenges: new Map(),
    merchant,
    company: buildCompany(now),
    admin: buildAdmin(now, merchant.rateBps),
  };
}

export let db: MockDb = build();

/** Fresh data (tests). */
export function resetDb(): void {
  db = build();
}

export function currentAccount(): DemoAccount | undefined {
  const session = db.session;
  return session === null
    ? undefined
    : db.accounts.find((account) => account.id === session.accountId);
}
