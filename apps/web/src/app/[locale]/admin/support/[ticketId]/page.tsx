'use client';

import { useParams } from 'next/navigation';
import { AgentTicketView } from '@/components/support/agent-tickets';

/** A support ticket seen by FlexiPay (W-SUP). */
export default function AdminTicketPage() {
  const { ticketId } = useParams<{ ticketId: string }>();
  return <AgentTicketView ticketId={ticketId} />;
}
