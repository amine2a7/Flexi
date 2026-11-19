import { Logger } from '@nestjs/common';
import { createApp } from './app.factory.js';
import { loadEnv } from './config/env.js';

async function bootstrap(): Promise<void> {
  const env = loadEnv();
  const app = await createApp(env);
  // Local only by default; API_HOST=0.0.0.0 opens it to the Wi-Fi (tests on a real phone).
  await app.listen(env.API_PORT, env.API_HOST);
  new Logger('FlexiPay').log(`API listening on http://${env.API_HOST}:${String(env.API_PORT)}`);
}

void bootstrap();
