// The web mock (MSW) refuses exactly what the server refuses: its route table must stay equal to
// the @Can of the controllers. After a permission change, regenerate the JSON from this table.
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';
import { routePermissionTable } from '../route-permission-table.js';

const MOCK_TABLE = join(
  import.meta.dirname,
  '..',
  '..',
  '..',
  'web',
  'src',
  'mocks',
  'fixtures',
  'route-permissions.json',
);

describe('route permissions of the web mock', () => {
  it('equal the permissions of the server routes', async () => {
    expect(JSON.parse(readFileSync(MOCK_TABLE, 'utf8'))).toEqual(await routePermissionTable());
  }, 60_000);
});
