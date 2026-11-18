// Migration of the personal data already stored (SEC-1): every phone, IBAN, CIN number and tax id
// is sealed with the active data key (envelope), whether it was in clear (before migration 0016)
// or sealed with DATA_ENCRYPTION_KEY; the blind indexes are computed with BLIND_INDEX_KEY.
// Idempotent; runs as fp_migrate after the migrations (db-migrate.ts), in one transaction.
import { fileURLToPath } from 'node:url';
import pg from 'pg';
import {
  blindIndex,
  isEnvelope,
  isSealedValue,
  openWith,
  sealWith,
  unwrapKeys,
  type DataKeyRow,
  type KeyRing,
} from '../src/common/keyring.js';
import { normaliseNationalId, normaliseTaxId } from '../src/common/pii.js';
import { databaseUrls, PG_SESSION_OPTIONS, pgSsl } from '../src/config/database-urls.js';

const COLUMNS = [
  ['merchants', 'phone'],
  ['merchants', 'iban'],
  ['merchants', 'national_id'],
  ['merchants', 'tax_id'],
  ['payout_requests', 'iban'],
  ['companies', 'phone'],
  ['companies', 'national_id'],
  ['companies', 'tax_id'],
  ['employees', 'phone'],
  ['contact_messages', 'phone'],
  ['users', 'phone'],
] as const;

/** Blind index written next to a column (same row), from the value in clear. */
const INDEXES: Readonly<Record<string, readonly [string, string, (v: string) => string]>> = {
  'users.phone': ['phone_hash', 'phone', (v) => v],
  'merchants.iban': ['iban_index', 'iban', (v) => v],
  'merchants.national_id': ['national_id_index', 'cin', normaliseNationalId],
  'merchants.tax_id': ['tax_id_index', 'tax', normaliseTaxId],
  'companies.national_id': ['national_id_index', 'cin', normaliseNationalId],
  'companies.tax_id': ['tax_id_index', 'tax', normaliseTaxId],
};

function key(name: string): Buffer {
  const value = Buffer.from(process.env[name] ?? '', 'base64');
  if (value.length < 32) throw new Error(`${name} is missing or shorter than 32 bytes`);
  return value;
}

export async function encryptPii(): Promise<number> {
  const client = new pg.Client({
    connectionString: databaseUrls(process.env).migrationUrl,
    options: PG_SESSION_OPTIONS,
    ssl: pgSsl(process.env),
  });
  await client.connect();
  let changed = 0;
  try {
    await client.query('BEGIN');
    const rows = await client.query<DataKeyRow>(
      'SELECT id, wrapped_key, retired_at FROM data_keys ORDER BY id',
    );
    const ring: KeyRing = {
      ...unwrapKeys(key('DATA_MASTER_KEY'), rows.rows),
      legacy: key('DATA_ENCRYPTION_KEY'),
      blind: key('BLIND_INDEX_KEY'),
    };
    for (const [table, column] of COLUMNS) {
      const index = INDEXES[`${table}.${column}`];
      const values = await client.query<{ id: string; value: string }>(
        `SELECT id::text AS id, ${column} AS value FROM ${table} WHERE ${column} IS NOT NULL`,
      );
      for (const row of values.rows) {
        const clear = isSealedValue(row.value) ? openWith(ring, row.value) : row.value;
        const sealed = isEnvelope(row.value) ? row.value : sealWith(ring, clear);
        if (index === undefined) {
          if (sealed === row.value) continue;
          await client.query(`UPDATE ${table} SET ${column} = $2 WHERE id = $1::uuid`, [
            row.id,
            sealed,
          ]);
        } else {
          const [indexColumn, kind, normalise] = index;
          await client.query(
            `UPDATE ${table} SET ${column} = $2, ${indexColumn} = $3 WHERE id = $1::uuid`,
            [row.id, sealed, blindIndex(ring.blind, kind, normalise(clear))],
          );
        }
        changed += 1;
      }
    }
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    await client.end();
  }
  return changed;
}

if (process.argv[1] !== undefined && fileURLToPath(import.meta.url) === process.argv[1]) {
  console.log(`${String(await encryptPii())} value(s) sealed or indexed`);
}
