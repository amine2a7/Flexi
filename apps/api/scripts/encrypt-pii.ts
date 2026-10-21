// Encrypts the phones and IBAN still stored in clear (before migration 0016, securite B5-S11).
// Idempotent: values already sealed are left as they are. Runs as the owner, in one transaction.
import { fileURLToPath } from 'node:url';
import pg from 'pg';
import { isSealed, phoneIndex, sealPii } from '../src/common/pii.js';
import { databaseUrls, PG_SESSION_OPTIONS } from '../src/config/database-urls.js';
import { loadEnv } from '../src/config/env.js';

const COLUMNS = [
  ['merchants', 'phone'],
  ['merchants', 'iban'],
  ['payout_requests', 'iban'],
  ['companies', 'phone'],
  ['employees', 'phone'],
  ['contact_messages', 'phone'],
  ['users', 'phone'],
] as const;

export async function encryptPii(): Promise<number> {
  const env = loadEnv();
  const key = Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64');
  const client = new pg.Client({
    connectionString: databaseUrls(process.env).migrationUrl,
    options: PG_SESSION_OPTIONS,
  });
  await client.connect();
  let sealed = 0;
  try {
    await client.query('BEGIN');
    for (const [table, column] of COLUMNS) {
      const rows = await client.query<{ id: string; value: string }>(
        `SELECT id::text AS id, ${column} AS value FROM ${table} WHERE ${column} IS NOT NULL`,
      );
      for (const row of rows.rows) {
        if (isSealed(row.value)) continue;
        if (table === 'users') {
          await client.query(`UPDATE users SET phone = $2, phone_hash = $3 WHERE id = $1`, [
            row.id,
            sealPii(key, row.value),
            phoneIndex(key, row.value),
          ]);
        } else {
          await client.query(`UPDATE ${table} SET ${column} = $2 WHERE id = $1`, [
            row.id,
            sealPii(key, row.value),
          ]);
        }
        sealed += 1;
      }
    }
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    await client.end();
  }
  return sealed;
}

if (process.argv[1] !== undefined && fileURLToPath(import.meta.url) === process.argv[1]) {
  console.log(`${String(await encryptPii())} value(s) encrypted`);
}
