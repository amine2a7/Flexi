import 'reflect-metadata';
import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module.js';
import { loadEnv } from './config/env.js';
import { httpPipeline } from './common/http.js';

async function bootstrap(): Promise<void> {
  const env = loadEnv();
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // Body parsing, CORS and security headers are done by httpPipeline (contract §6 and §8).
    bodyParser: false,
    logger: ['error', 'warn', 'log'],
  });
  app.disable('x-powered-by');
  app.set('trust proxy', false);
  app.set('etag', false);
  for (const middleware of httpPipeline(env)) app.use(middleware);
  app.enableShutdownHooks();
  await app.listen(env.API_PORT, '127.0.0.1');
  new Logger('FlexiPay').log(`API listening on http://localhost:${String(env.API_PORT)}`);
}

void bootstrap();
