import { uuidv7 } from '../common/crypto.js';
import type { Tx } from '../common/db.service.js';
import { addDays, businessDay, dateOnly } from '../common/tunis.js';

/**
 * Next scheduled batch a checked payout joins, created at D+2 when there is none. It stays locked
 * while the payout joins it: the settlement job (SKIP LOCKED) leaves it for its next run instead
 * of executing it without this payout (ledger-auditor N1).
 */
export async function nextBatch(tx: Tx) {
  const today = businessDay();
  const [open] = await tx.$queryRaw<{ id: string }[]>`
    SELECT id FROM settlement_batches
     WHERE status = 'SCHEDULED' AND settlement_date > ${dateOnly(today)}::date
     ORDER BY settlement_date LIMIT 1 FOR UPDATE`;
  if (open !== undefined) return tx.settlementBatch.findUniqueOrThrow({ where: { id: open.id } });
  const [sequence] = await tx.$queryRaw<
    { value: bigint }[]
  >`SELECT nextval('batch_reference_seq') AS value`;
  return tx.settlementBatch.create({
    data: {
      id: uuidv7(),
      reference: `LOT-${today.slice(0, 4)}-${String(sequence?.value ?? 0n)}`,
      settlementDate: dateOnly(addDays(today, 2)),
    },
  });
}
