import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import {
  releaseAll,
  startPostgres,
  type CleanupStep,
  type StartedPostgres,
} from '../../src/index.js';

describe('PostgreSQL 16 (Testcontainers)', () => {
  let db: StartedPostgres;
  let admin: pg.Client;
  let app: pg.Client;
  // beforeAll may fail half-way: afterAll releases only what was actually created.
  const cleanup: CleanupStep[] = [];

  beforeAll(async () => {
    db = await startPostgres();
    cleanup.push(() => db.stop());
    admin = new pg.Client({ connectionString: db.adminConnectionUri });
    await admin.connect();
    cleanup.push(() => admin.end());
    app = new pg.Client({ connectionString: db.appConnectionUri });
    await app.connect();
    cleanup.push(() => app.end());
  });

  afterAll(async () => {
    await releaseAll(cleanup);
  });

  it('runs a PostgreSQL 16 server', async () => {
    const res = await admin.query<{ server_version_num: string }>('SHOW server_version_num');
    const version = Number(res.rows[0]?.server_version_num);
    expect(version).toBeGreaterThanOrEqual(160000);
    expect(version).toBeLessThan(170000);
  });

  it('publishes the port on the loopback interface only', () => {
    expect(db.hostBindingIps).toEqual(['127.0.0.1']);
  });

  it('connects the application with a role that is neither superuser nor BYPASSRLS', async () => {
    const res = await app.query<{
      rolsuper: boolean;
      rolbypassrls: boolean;
      rolcreaterole: boolean;
    }>('SELECT rolsuper, rolbypassrls, rolcreaterole FROM pg_roles WHERE rolname = current_user');
    expect(res.rows[0]).toEqual({ rolsuper: false, rolbypassrls: false, rolcreaterole: false });
  });

  it('applies row-level security to the application role', async () => {
    await admin.query(`
      CREATE TABLE rls_probe (company_id INT NOT NULL, label TEXT NOT NULL);
      ALTER TABLE rls_probe ENABLE ROW LEVEL SECURITY;
      CREATE POLICY rls_probe_tenant ON rls_probe
        USING (company_id = current_setting('app.company_id')::int);
      INSERT INTO rls_probe VALUES (1, 'a'), (2, 'b');
    `);
    await admin.query(`GRANT SELECT ON rls_probe TO ${db.appRole}`);
    await app.query('BEGIN');
    await app.query("SELECT set_config('app.company_id', $1, true)", ['1']);
    const res = await app.query<{ label: string }>('SELECT label FROM rls_probe');
    await app.query('COMMIT');
    expect(res.rows).toEqual([{ label: 'a' }]);
  });

  it('stores millimes as BIGINT without loss (driver returns int8 as string)', async () => {
    const res = await admin.query<{ v: string }>('SELECT $1::bigint AS v', ['9007199254740991']);
    expect(res.rows[0]?.v).toBe('9007199254740991');
  });

  it('enforces a non-negative balance with a CHECK constraint', async () => {
    await admin.query(
      'CREATE TEMP TABLE probe_balance (balance_millimes BIGINT NOT NULL CHECK (balance_millimes >= 0))',
    );
    await expect(
      admin.query('INSERT INTO probe_balance (balance_millimes) VALUES ($1)', [-1]),
    ).rejects.toThrow();
  });
});
