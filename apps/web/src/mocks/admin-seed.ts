import type { Schemas } from '@flexipay/api-client';
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
    const rate = merchant.commissionProfile.rateBps;
    const commission = Math.floor((gross * rate + 5_000) / 10_000);
    return {
      id: random.uuid(),
      reference: `VIR-2026-${String(8800 - index)}`,
      status: index < 5 ? 'REQUESTED' : random.pick(statuses),
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
    return {
      id: random.uuid(),
      reference: `PAY-${String(9900 - index)}`,
      merchantName: random.pick(activeMerchants).name,
      companyName: random.pick(activeCompanies).name,
      category: 'RESTAURATION' as const,
      amountMillimes: random.int(16, 240) * 500,
      status: recent && status === 'SETTLED' ? 'CONFIRMED' : status,
      createdAt: iso(createdAt),
    };
  });
}
