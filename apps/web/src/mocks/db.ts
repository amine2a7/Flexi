import type { Schemas } from '@flexipay/api-client';
import {
  DEFAULT_TYPE_SETTINGS,
  splitOverTypes,
  typesForCategory,
  type TypeBalances,
} from './credit-types';
import {
  buildContactMessages,
  buildKycFiles,
  buildOtherPayouts,
  buildTransactions,
} from './admin-seed';
import { buildEmployee, type MockEmployee } from './employee-seed';
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

/** Credit order with the uploaded transfer proof (kept in memory only). */
export type MockOrder = Omit<S['CreditOrderDetail'], 'firstValidation'> & {
  proof?: Blob;
  /** First of the two admin validations (four-eyes above the threshold), kept server side. */
  firstValidator?: { actorId: string; actorName: string; occurredAt: string };
};

/** Four-eyes threshold on credit orders (decision): credits above 10 000,000 TND. */
export const SECOND_VALIDATION_THRESHOLD_MILLIMES = 10_000_000;
export const ADMIN_IDS = {
  'Amine K.': '01930a1c-0001-7a00-8000-000000000001',
  'Hela R.': '01930a1c-0009-7a00-8000-000000000009',
} as const;

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
    /** One balance per credit type (never a single global balance). */
    balances: TypeBalances;
    employees: S['Employee'][];
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
    kycFiles: S['KycFile'][];
    /** Payout requests of the other merchants (the demo shop's are in merchant.payouts). */
    payoutRequests: S['AdminPayoutRequest'][];
    /** Steps recorded by an admin decision on a payout request (approve / reject). */
    payoutEvents: Map<string, S['PayoutEvent'][]>;
    /** Payout lines of each settlement batch (generated on first read, then appended to). */
    batchLines: Map<string, S['AdminPayoutRequest'][]>;
    transactions: S['AdminTransaction'][];
    /** Messages of the public "Contact us" form. */
    contactMessages: S['ContactMessage'][];
    /** Generated demo documents (KYC pieces), by document id. */
    documents: Map<string, Blob>;
  };
  /** Credit orders of every company (company space: own orders only; admin space: all). */
  orders: MockOrder[];
  /** Demo beneficiary (employee) of the demo company. */
  employee: MockEmployee;
}

const SHOP_PREFIXES = [
  'Café',
  'Restaurant',
  'Superette',
  'Boulangerie',
  'Snack',
  'Pâtisserie',
  'Boutique',
  'Station',
  'Librairie',
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
  Boutique: 'CLOTHING',
  Station: 'FUEL_STATION',
  Librairie: 'GIFT_SHOP',
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
      creditType: random.next() < 0.8 ? 'RESTAURATION' : 'CADEAUX',
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
      creditType: index % 5 === 3 ? 'CADEAUX' : 'RESTAURATION',
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
    acceptedCreditTypes: ['RESTAURATION', 'CADEAUX'],
    city: 'Tunis',
    address: '14, rue de Marseille, 1000 Tunis',
    phone: '+21698421337',
    maskedIban: '•••• •••• •••• 4821',
    paymentCode: '482915',
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

function buildCompany() {
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

  const invoices: S['Invoice'][] = [];
  const balances: TypeBalances = {
    RESTAURATION: 28_400_000,
    HABILLEMENT: 9_850_000,
    CARBURANT: 6_200_000,
    CADEAUX: 3_800_000,
  };
  return { balances, employees, invoices, previews: new Map() };
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
    acceptedCreditTypes: ['RESTAURATION', 'CADEAUX'],
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
      acceptedCreditTypes: typesForCategory(CATEGORY_BY_PREFIX[prefix]),
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
      creditTypes: DEFAULT_TYPE_SETTINGS.map((item) => ({ ...item })),
    },
  };
}

const HOUR = 60 * MINUTE;
const ADMIN_NAMES = ['Amine K.', 'Hela R.'] as const satisfies readonly (keyof typeof ADMIN_IDS)[];
const REFUSAL_REASONS = [
  "Dossier KYC de l'entreprise incomplet : merci de transmettre l'extrait du registre de commerce.",
  'Montant inhabituel : merci de contacter votre chargé de compte avant de commander.',
];
const PROOF_REJECTION_REASON = 'Virement introuvable sur le compte FlexiPay à la date indiquée.';

type OrderScenario =
  | 'AWAITING_CONFIRMATION'
  | 'AWAITING_PAYMENT'
  | 'PROOF_REJECTED'
  | 'AWAITING_VALIDATION'
  | 'AMOUNT_MISMATCH'
  | 'VALIDATED'
  | 'REFUSED'
  | 'CANCELLED'
  /** Awaiting validation, first validation by Hela R. (Amine K. can finish). */
  | 'FIRST_BY_OTHER'
  /** Awaiting validation, first validation by Amine K. (needs admin2). */
  | 'FIRST_BY_ME';

/** One credit order and its history, consistent with its status (who did what, and when). */
function buildOrder(
  random: ReturnType<typeof createRandom>,
  company: { id: string; name: string },
  requester: string,
  reference: string,
  createdAtMs: number,
  scenario: OrderScenario,
): MockOrder {
  const drawn = amount(random, 4_000_000, 32_000_000, 100_000);
  const value =
    scenario === 'FIRST_BY_OTHER' || scenario === 'FIRST_BY_ME'
      ? Math.max(drawn, 12_500_000)
      : drawn;
  const fees = commissionOf(value, 150);
  const total = value + fees;
  const admin = random.pick(ADMIN_NAMES);
  const at = (offset: number) => iso(createdAtMs + offset);
  const event = (
    action: S['CreditOrderEventAction'],
    offset: number,
    actorRole: S['Role'],
    reason?: string,
    adminOverride?: string,
  ): S['CreditOrderEvent'] => ({
    action,
    occurredAt: at(offset),
    actorName: actorRole === 'ADMIN' ? (adminOverride ?? admin) : requester,
    actorRole,
    ...(reason === undefined ? {} : { reason }),
  });
  const order: MockOrder = {
    id: random.uuid(),
    reference,
    status: 'AWAITING_CONFIRMATION',
    lines: splitOverTypes(random, value),
    requiresSecondValidation: value > SECOND_VALIDATION_THRESHOLD_MILLIMES,
    companyId: company.id,
    companyName: company.name,
    amountMillimes: value,
    feesMillimes: fees,
    totalMillimes: total,
    createdAt: at(0),
    paymentReference: `FXP-${random.digits(8)}`,
    history: [event('CREATED', 0, 'COMPANY')],
  };
  const declare = (offset: number, declared: number) => {
    order.declaration = {
      transferReference: `VIR${random.digits(10)}`,
      transferDate: calendarDate(createdAtMs + offset - 2 * HOUR),
      amountMillimes: declared,
      proof: {
        fileName: `avis-virement-${reference.toLowerCase()}.png`,
        contentType: 'image/png',
        sizeBytes: random.int(140_000, 880_000),
      },
      declaredAt: at(offset),
    };
    order.declaredAmountMillimes = declared;
    order.history.push(event('TRANSFER_DECLARED', offset, 'COMPANY'));
  };
  if (scenario === 'AWAITING_CONFIRMATION') return order;
  if (scenario === 'REFUSED') {
    const reason = random.pick(REFUSAL_REASONS);
    order.status = 'REFUSED';
    order.refusalReason = reason;
    order.history.push(event('REFUSED', 3 * HOUR, 'ADMIN', reason));
    return order;
  }
  if (scenario === 'CANCELLED') {
    order.status = 'CANCELLED';
    order.history.push(event('CANCELLED', HOUR, 'COMPANY'));
    return order;
  }
  order.history.push(event('CONFIRMED', 2 * HOUR, 'ADMIN'));
  order.status = 'AWAITING_PAYMENT';
  if (scenario === 'AWAITING_PAYMENT') return order;
  if (scenario === 'PROOF_REJECTED') {
    declare(18 * HOUR, total);
    order.history.push(event('PROOF_REJECTED', 22 * HOUR, 'ADMIN', PROOF_REJECTION_REASON));
    order.proofRejectionReason = PROOF_REJECTION_REASON;
    delete order.declaration;
    delete order.declaredAmountMillimes;
    return order;
  }
  declare(18 * HOUR, scenario === 'AMOUNT_MISMATCH' ? total - 600_000 : total);
  order.status = 'AWAITING_VALIDATION';
  if (scenario === 'AWAITING_VALIDATION' || scenario === 'AMOUNT_MISMATCH') return order;
  const other = admin === 'Amine K.' ? 'Hela R.' : 'Amine K.';
  if (scenario === 'FIRST_BY_OTHER' || scenario === 'FIRST_BY_ME') {
    const first = scenario === 'FIRST_BY_ME' ? 'Amine K.' : 'Hela R.';
    order.history.push(event('FIRST_VALIDATION', 26 * HOUR, 'ADMIN', undefined, first));
    order.firstValidator = {
      actorId: ADMIN_IDS[first],
      actorName: first,
      occurredAt: at(26 * HOUR),
    };
    return order;
  }
  if (order.requiresSecondValidation) {
    order.history.push(event('FIRST_VALIDATION', 28 * HOUR, 'ADMIN', undefined, other));
  }
  order.history.push(event('VALIDATED', 30 * HOUR, 'ADMIN'));
  order.status = 'VALIDATED';
  return order;
}

function buildOrders(now: number, companies: readonly S['CompanyAccount'][]): MockOrder[] {
  const random = createRandom(31);
  const tenant = companies.find((company) => company.id === COMPANY_TENANT.id);
  const own = { id: COMPANY_TENANT.id, name: tenant?.name ?? COMPANY_TENANT.label };
  const ownScenarios: Partial<Record<number, OrderScenario>> = {
    0: 'AWAITING_CONFIRMATION',
    1: 'AWAITING_PAYMENT',
    2: 'PROOF_REJECTED',
    3: 'FIRST_BY_OTHER',
    5: 'REFUSED',
    7: 'CANCELLED',
    19: 'CANCELLED',
  };
  const orders = Array.from({ length: 36 }, (_, index) =>
    buildOrder(
      random,
      own,
      'Leïla M.',
      `CMD-2026-${String(7200 - index)}`,
      now - (index * 8 + 2) * DAY - random.int(0, 600) * MINUTE,
      ownScenarios[index] ?? 'VALIDATED',
    ),
  );
  const others = companies.filter(
    (company) => company.id !== COMPANY_TENANT.id && company.status === 'APPROVED',
  );
  const recentScenarios: OrderScenario[] = [
    'AWAITING_CONFIRMATION',
    'AWAITING_VALIDATION',
    'AMOUNT_MISMATCH',
    'AWAITING_CONFIRMATION',
    'AWAITING_PAYMENT',
    'FIRST_BY_ME',
    'AWAITING_CONFIRMATION',
  ];
  for (let index = 0; index < 28; index += 1) {
    const company = random.pick(others);
    const { firstName, lastName } = personName(random);
    const recent = recentScenarios[index];
    const scenario =
      recent ??
      random.pick<OrderScenario>(['VALIDATED', 'VALIDATED', 'VALIDATED', 'CANCELLED', 'REFUSED']);
    const daysAgo = recent === undefined ? random.int(10, 150) : 1 + index;
    orders.push(
      buildOrder(
        random,
        { id: company.id, name: company.name },
        `${firstName} ${lastName.charAt(0)}.`,
        `CMD-2026-${String(6900 - index)}`,
        now - daysAgo * DAY - random.int(0, 600) * MINUTE,
        scenario,
      ),
    );
  }
  return orders.sort((a, b) => b.createdAt.localeCompare(a.createdAt));
}

/** Invoices of the demo company: one per order that went past the confirmation step. */
export function invoicesOf(orders: readonly MockOrder[]): S['Invoice'][] {
  const random = createRandom(37);
  return orders
    .filter(
      (order) =>
        order.companyId === COMPANY_TENANT.id &&
        order.status !== 'AWAITING_CONFIRMATION' &&
        order.status !== 'REFUSED' &&
        order.status !== 'CANCELLED',
    )
    .map((order, index) => ({
      id: random.uuid(),
      number: `FAC-2026-${String(5400 - index)}`,
      orderReference: order.reference,
      totalMillimes: order.totalMillimes,
      issuedAt: order.createdAt,
      status: order.status === 'VALIDATED' ? 'PAID' : 'UNPAID',
    }));
}

// The order circuit spans two accounts (company, then admin) and page reloads: orders and the
// company balance are kept in this tab's sessionStorage (demo data only; uploaded files are not
// kept, a demo transfer notice replaces them after a reload).
const ORDERS_KEY = 'fp_mock_orders_v3';

export function saveOrders(): void {
  try {
    const orders = db.orders.map(({ proof: _proof, ...order }) => order);
    sessionStorage.setItem(ORDERS_KEY, JSON.stringify({ orders, balances: db.company.balances }));
  } catch {
    // Storage unavailable (tests, private mode): the data simply restarts from the seed.
  }
}

function savedOrders(): { orders: MockOrder[]; balances: TypeBalances } | undefined {
  try {
    const raw = sessionStorage.getItem(ORDERS_KEY);
    return raw === null
      ? undefined
      : (JSON.parse(raw) as { orders: MockOrder[]; balances: TypeBalances });
  } catch {
    return undefined;
  }
}

function build(): MockDb {
  const now = Date.now();
  const merchant = buildMerchant(now);
  const base = buildAdmin(now, merchant.rateBps);
  const admin = {
    ...base,
    kycFiles: buildKycFiles(base.merchants, base.companies),
    payoutRequests: buildOtherPayouts(base.merchants, now),
    payoutEvents: new Map<string, S['PayoutEvent'][]>(),
    batchLines: new Map<string, S['AdminPayoutRequest'][]>(),
    transactions: buildTransactions(base.merchants, base.companies, now),
    contactMessages: buildContactMessages(now),
    documents: new Map<string, Blob>(),
  };
  const saved = savedOrders();
  const orders = saved?.orders ?? buildOrders(now, admin.companies);
  const company = buildCompany();
  if (saved !== undefined) company.balances = saved.balances;
  company.invoices = invoicesOf(orders);
  return {
    accounts: createDemoAccounts(),
    session: null,
    challenges: new Map(),
    merchant,
    company,
    admin,
    orders,
    employee: buildEmployee(now),
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
