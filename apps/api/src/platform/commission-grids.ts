import { isDefaultTier, tierFor, type CommissionTier } from '@flexipay/shared';
import type { Tx } from '../common/db.service.js';
import { uuidv7 } from '../common/crypto.js';
import { toMillimes } from '../common/money.js';
import type {
  CommissionGrid,
  CommissionTier as TierRow,
  Prisma,
} from '../generated/prisma/client.js';

/** Owner of a grid: a company (rate on each order) or a merchant (rate on each payout). */
export type GridOwner = { companyId: string } | { merchantId: string };

export interface GridBody {
  tiers: CommissionTier[];
  effectiveFrom: string;
}

/** Prisma include of the current version (latest one) with its lines in order. */
export const currentGridInclude = {
  orderBy: [{ effectiveFrom: 'desc' }, { id: 'desc' }],
  take: 1,
  include: { tiers: { orderBy: { position: 'asc' } } },
} satisfies Prisma.Company$commissionGridsArgs;

export const tierBody = (row: TierRow): CommissionTier => ({
  rateBps: row.rateBps,
  minMillimes: row.minMillimes === null ? null : toMillimes(row.minMillimes),
  maxMillimes: row.maxMillimes === null ? null : toMillimes(row.maxMillimes),
});

/** Body of the current grid of an owner loaded with `currentGridInclude`; null without grid. */
export function gridBody(
  grids: readonly (CommissionGrid & { tiers: TierRow[] })[],
): GridBody | null {
  const [grid] = grids;
  return grid === undefined
    ? null
    : { tiers: grid.tiers.map(tierBody), effectiveFrom: grid.effectiveFrom.toISOString() };
}

const ownerWhere = (owner: GridOwner) =>
  'companyId' in owner ? { companyId: owner.companyId } : { merchantId: owner.merchantId };

export async function currentGrid(tx: Tx, owner: GridOwner): Promise<GridBody | null> {
  const grids = await tx.commissionGrid.findMany({
    where: ownerWhere(owner),
    ...currentGridInclude,
  });
  return gridBody(grids);
}

/** Rate of an amount on the current grid of an owner; undefined when it has no grid. */
export async function gridRate(
  tx: Tx,
  owner: GridOwner,
  amountMillimes: bigint,
): Promise<number | undefined> {
  const grid = await currentGrid(tx, owner);
  return grid === null ? undefined : tierFor(grid.tiers, toMillimes(amountMillimes)).rateBps;
}

/** Default rate of a grid (shown on dashboards); null without grid. */
export const defaultRate = (grid: GridBody | null): number | null =>
  grid?.tiers.find(isDefaultTier)?.rateBps ?? null;

/** New version of a grid (never an update: versions are the history). Tiers are validated. */
export async function installGrid(
  tx: Tx,
  owner: GridOwner,
  tiers: readonly CommissionTier[],
  meta: { approvalId?: string; createdBy: string | null },
): Promise<void> {
  const id = uuidv7();
  await tx.commissionGrid.create({
    data: {
      id,
      ...ownerWhere(owner),
      approvalId: meta.approvalId ?? null,
      createdBy: meta.createdBy,
      tiers: {
        create: tiers.map((tier, position) => ({
          position,
          rateBps: tier.rateBps,
          minMillimes: tier.minMillimes === null ? null : BigInt(tier.minMillimes),
          maxMillimes: tier.maxMillimes === null ? null : BigInt(tier.maxMillimes),
        })),
      },
    },
  });
}
