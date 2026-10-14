import { defineConfig } from 'prisma/config';
import { databaseUrls } from './src/config/database-urls.js';

// Migrations run as the owner (admin URL of the FlexiPay database); the API connects with the
// application role (NOSUPERUSER NOBYPASSRLS) so that Row-Level Security applies to it.
export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: { path: 'prisma/migrations' },
  datasource: { url: databaseUrls(process.env).migrationUrl },
});
