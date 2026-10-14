import { Logger } from '@nestjs/common';
import { createApp } from './app.factory.js';
import { loadEnv } from './config/env.js';

async function bootstrap(): Promise<void> {
  const env = loadEnv();
  const app = await createApp(env);
  await app.listen(env.API_PORT, '127.0.0.1');
  new Logger('FlexiPay').log(`API listening on http://localhost:${String(env.API_PORT)}`);
}

void bootstrap();
