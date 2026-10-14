import type { Schemas } from '@flexipay/api-client';
import { DEFAULT_TYPE_SETTINGS } from './credit-types';
import { COMPANY_TENANT, MERCHANT_TENANT } from './fixtures/accounts';
import { DAY, FIRST_NAMES, LAST_NAMES, MINUTE, createRandom, iso } from './fixtures/random';

type S = Schemas;

// Admin-only demo data: KYC files, payout requests of the other merchants, global transactions.

const ADMINS = ['Amine K.', 'Hela R.'] as const;
const KYC_REJECTION =
  "Extrait du registre de commerce de plus de 3 mois : merci d'en transmettre un récent.";

const MERCHANT_DOCUMENTS: readonly S['KycDocumentType'][] = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID',
  'BANK_DETAILS',
];
const COMPANY_DOCUMENTS: readonly S['KycDocumentType'][] = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID',
];

function kycStatus(status: S['AccountStatus']): S['KycStatus'] {
  if (status === 'PENDING_KYC') return 'PENDING';
  if (status === 'REJECTED') return 'REJECTED';
  return 'APPROVED';
}

export function buildKycFiles(
  merchants: readonly S['MerchantAccount'][],
  companies: readonly S['CompanyAccount'][],
): S['KycFile'][] {
  const random = createRandom(41);
  const accounts = [
    ...merchants.map((merchant) => ({ type: 'MERCHANT' as const, account: merchant })),
    ...companies.map((company) => ({ type: 'COMPANY' as const, account: company })),
  ];
  return accounts
    .map(({ type, account }) => {
      const submitted = new Date(account.createdAt).getTime() + DAY;
      const status = kycStatus(account.status);
      const contact = `${random.pick(FIRST_NAMES)} ${random.pick(LAST_NAMES).charAt(0)}.`;
      const documents = (type === 'MERCHANT' ? MERCHANT_DOCUMENTS : COMPANY_DOCUMENTS).map(
        (documentType, index): S['KycDocument'] => ({
          id: random.uuid(),
          type: documentType,
          fileName: `${documentType.toLowerCase().replaceAll('_', '-')}.png`,
          contentType: 'image/png',
          sizeBytes: random.int(120_000, 1_400_000),
          uploadedAt: iso(submitted + index * MINUTE),
        }),
      );
      const history: S['KycEvent'][] = [
        { action: 'SUBMITTED', occurredAt: iso(submitted), actorName: contact },
      ];
      if (status === 'APPROVED') {
        history.push({
          action: 'APPROVED',
          occurredAt: iso(submitted + 20 * 60 * MINUTE),
          actorName: random.pick(ADMINS),
        });
      }
      if (status === 'REJECTED') {
        history.push({
          action: 'REJECTED',
          occurredAt: iso(submitted + 26 * 60 * MINUTE),
          actorName: random.pick(ADMINS),
          reason: KYC_REJECTION,
        });
      }
      return {
        id: random.uuid(),
        accountType: type,
        accountId: account.id,
        accountName: account.name,
        city: account.city,
        status,
        submittedAt: iso(submitted),
        documentsCount: documents.length,
        documents,
        ...(status === 'REJECTED' ? { rejectionReason: KYC_REJECTION } : {}),
        history,
      };
    })
    .filter((file) => file.accountId !== COMPANY_TENANT.id || file.status === 'APPROVED');
}

/** IBAN of a demo merchant (TN + 22 digits); the demo shop ends in 4821 like its masked RIB. */
export function demoIban(merchantId: string, digits: () => string): string {
  return merchantId === MERCHANT_TENANT.id ? 'TN5904018104003691234821' : `TN59${digits()}`;
}

export function buildOtherPayouts(
  merchants: readonly S['MerchantAccount'][],
  now: number,
): S['AdminPayoutRequest'][] {
  const random = createRandom(43);
  const others = merchants.filter(
    (merchant) => merchant.id !== MERCHANT_TENANT.id && merchant.status === 'APPROVED',
  );
  const statuses: S['PayoutRequestStatus'][] = [
    'EXECUTED',
    'EXECUTED',
    'SENT',
    'CHECKED',
    'REJECTED',
  ];
  return Array.from({ length: 26 }, (_, index) => {
    const merchant = random.pick(others);
    const gross = random.int(150, 3_800) * 1_000;
    const creditType = random.pick(merchant.acceptedCreditTypes);
    // Own rate of the shop, otherwise the rate of the credit type (decision of 2026-10-14).
    const rate =
      merchant.commissionProfile?.rateBps ??
      DEFAULT_TYPE_SETTINGS.find((item) => item.creditType === creditType)?.commissionRateBps ??
      0;
    const commission = Math.floor((gross * rate + 5_000) / 10_000);
    return {
      id: random.uuid(),
      reference: `VIR-2026-${String(8800 - index)}`,
      status: index < 5 ? 'REQUESTED' : random.pick(statuses),
      creditType,
      merchantId: merchant.id,
      merchantName: merchant.name,
      grossMillimes: gross,
      commissionRateBps: rate,
      commissionMillimes: commission,
      netMillimes: gross - commission,
      requestedAt: iso(now - (index * 2 + 1) * DAY - random.int(0, 600) * MINUTE),
      iban: demoIban(merchant.id, () => random.digits(20)),
    };
  });
}

export function buildTransactions(
  merchants: readonly S['MerchantAccount'][],
  companies: readonly S['CompanyAccount'][],
  now: number,
): S['AdminTransaction'][] {
  const random = createRandom(47);
  const activeMerchants = merchants.filter((merchant) => merchant.status === 'APPROVED');
  const activeCompanies = companies.filter((company) => company.status === 'APPROVED');
  const statuses: S['PaymentStatus'][] = ['SETTLED', 'SETTLED', 'SETTLED', 'CONFIRMED', 'REFUSED'];
  return Array.from({ length: 180 }, (_, index) => {
    const createdAt = now - index * 95 * MINUTE - random.int(0, 80) * MINUTE;
    const recent = now - createdAt < 2 * DAY;
    const status = random.pick(statuses);
    const merchant = random.pick(activeMerchants);
    return {
      id: random.uuid(),
      reference: `PAY-${String(9900 - index)}`,
      merchantName: merchant.name,
      companyName: random.pick(activeCompanies).name,
      creditType: random.pick(merchant.acceptedCreditTypes),
      amountMillimes: random.int(16, 240) * 500,
      status: recent && status === 'SETTLED' ? 'CONFIRMED' : status,
      createdAt: iso(createdAt),
    };
  });
}

const CONTACT_SAMPLES: readonly {
  name: string;
  company: string | null;
  type: S['ContactRequesterType'];
  message: string;
}[] = [
  {
    name: 'Sami Gharbi',
    company: 'Tunis Logistique',
    type: 'COMPANY',
    message:
      'Nous avons 140 salariés et souhaitons remplacer nos tickets papier. Pouvez-vous nous rappeler pour une présentation ?',
  },
  {
    name: 'Rim Haddad',
    company: 'Pâtisserie Les Délices',
    type: 'MERCHANT',
    message:
      'Je tiens une pâtisserie à La Marsa. Comment accepter les paiements FlexiPay et sous quel délai suis-je réglée ?',
  },
  {
    name: 'Karim Ben Salem',
    company: null,
    type: 'OTHER',
    message: 'Mon employeur utilise FlexiPay : puis-je ajouter un membre de ma famille ?',
  },
  {
    name: 'Leila Mansour',
    company: 'Station Total Ariana',
    type: 'MERCHANT',
    message: 'Nous voulons accepter le type Carburant. Quels documents faut-il fournir ?',
  },
  {
    name: 'Anis Trabelsi',
    company: 'Clinique El Amen',
    type: 'COMPANY',
    message: 'Quelle est la commission pour une entreprise et peut-on offrir des cartes Cadeaux ?',
  },
];

/** Messages received by the public "Contact us" form (admin "Messages" page). */
export function buildContactMessages(now: number): S['ContactMessage'][] {
  const random = createRandom(53);
  return CONTACT_SAMPLES.map((sample, index): S['ContactMessage'] => {
    const handled = index >= 3;
    const receivedAt = now - (index * 2 + 1) * DAY + random.int(0, 600) * MINUTE;
    const slug = sample.name.toLowerCase().replace(/[^a-z]+/g, '.');
    return {
      id: random.uuid(),
      reference: `MSG-${String(1040 - index)}`,
      name: sample.name,
      email: `${slug}@exemple.tn`,
      phone: index % 2 === 0 ? `+2162${random.digits(7)}` : null,
      companyName: sample.company,
      requesterType: sample.type,
      message: sample.message,
      status: handled ? 'HANDLED' : 'NEW',
      receivedAt: iso(receivedAt),
      handledAt: handled ? iso(receivedAt + DAY / 4) : null,
      handledBy: handled ? 'Hela R.' : null,
      note: handled ? 'Rappel effectué, documentation envoyée.' : null,
    };
  });
}
