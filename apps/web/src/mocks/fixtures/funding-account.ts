import type { Schemas } from '@flexipay/api-client';

// FlexiPay bank account shown on every credit order (demo data, single place to edit). The real
// account comes from the server configuration: GET /v1/company/funding-account.
export const FUNDING_ACCOUNT: Schemas['FundingBankAccount'] = {
  bankName: 'Banque Internationale Arabe de Tunisie (BIAT)',
  holder: 'FlexiPay SA',
  rib: '08006000671234567891',
  iban: 'TN5908006000671234567891',
};
