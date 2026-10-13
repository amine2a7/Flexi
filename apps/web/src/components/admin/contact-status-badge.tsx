import type { Schemas } from '@flexipay/api-client';
import { StatusBadge } from '@/components/ui/status-badge';

/** NEW waits for an admin (pending colours), HANDLED is done (confirmed colours). */
export function ContactStatusBadge({ status }: { status: Schemas['ContactMessageStatus'] }) {
  return (
    <StatusBadge
      status={status === 'NEW' ? 'PENDING' : 'COMPLETED'}
      labelKey={`adminMessages.status.${status}`}
    />
  );
}
