'use client';

import type { Schemas } from '@flexipay/api-client';
import { StatusBadge } from '@/components/ui/status-badge';

// KYC statuses on the existing status tokens (colour + icon), with KYC wording.
const TOKEN_STATUS: Record<Schemas['KycStatus'], string> = {
  PENDING: 'PENDING',
  APPROVED: 'APPROVED',
  REJECTED: 'REJECTED',
};

export function KycStatusBadge({ status }: { status: Schemas['KycStatus'] }) {
  return <StatusBadge status={TOKEN_STATUS[status]} labelKey={`admin.kyc.statuses.${status}`} />;
}
