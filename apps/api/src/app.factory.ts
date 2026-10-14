import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module.js';
import { httpPipeline } from './common/http.js';
import type { Env } from './config/env.js';

/** The API application (used by main.ts and by the integration tests). */
export async function createApp(env: Env, logs = true): Promise<NestExpressApplication> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // Body parsing, CORS and security headers are done by httpPipeline (contract §6 and §8).
    bodyParser: false,
    logger: logs ? ['error', 'warn', 'log'] : ['error'],
  });
  app.disable('x-powered-by');
  app.set('trust proxy', false);
  app.set('etag', false);
  for (const middleware of httpPipeline(env)) app.use(middleware);
  app.enableShutdownHooks();
  return app;
}
