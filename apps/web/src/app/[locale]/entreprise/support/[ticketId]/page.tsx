'use client';

import { useParams } from 'next/navigation';
import { ClientTicketThread } from '@/components/support/client-tickets';

/** A support ticket and its conversation (W-SUP). */
export default function TicketPage() {
  const { ticketId } = useParams<{ ticketId: string }>();
  return <ClientTicketThread base="/entreprise/support" ticketId={ticketId} />;
}
