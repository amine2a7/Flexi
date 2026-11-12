import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module.js';
import { httpPipeline } from './common/http.js';
import { installTestClock, testClockHandler, testReconcileHandler } from './common/test-clock.js';
import { JobsService } from './jobs/jobs.service.js';
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
  // End-to-end tests only (never in production, see loadEnv): the days of the API move forward.
  if (env.TEST_CLOCK === '1' && env.NODE_ENV !== 'production') {
    installTestClock();
    app.use('/__test/clock', testClockHandler);
    app.use(
      '/__test/reconcile',
      testReconcileHandler(() => app.get(JobsService).reconcileBooks()),
    );
  }
  for (const middleware of httpPipeline(env)) app.use(middleware);
  app.enableShutdownHooks();
  return app;
}
