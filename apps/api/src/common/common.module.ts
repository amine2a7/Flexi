import { Global, Module } from '@nestjs/common';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { ENV, envProvider, KEYS, keysProvider, type Keys } from '../config/env.provider.js';
import { InvitationService } from '../auth/invitation.service.js';
import { SessionService } from '../auth/session.service.js';
import { AuditService } from './audit.service.js';
import { AuthGuard } from './auth.guard.js';
import { DbService } from './db.service.js';
import { FourEyesService } from './four-eyes.service.js';
import { IdempotencyService } from './idempotency.service.js';
import { keyringProvider, PiiService } from './pii.js';
import { OutboxService } from './outbox.service.js';
import { Paginator } from './pagination.js';
import { ProblemFilter } from './problem.filter.js';
import { FILE_STORAGE, LocalDiskStorage } from './storage.js';
import type { Env } from '../config/env.js';

/** Infrastructure shared by every module: database, sessions, guard, errors, idempotency. */
@Global()
@Module({
  providers: [
    envProvider(),
    keysProvider,
    DbService,
    keyringProvider,
    SessionService,
    AuditService,
    IdempotencyService,
    FourEyesService,
    PiiService,
    OutboxService,
    InvitationService,
    {
      provide: Paginator,
      inject: [KEYS],
      useFactory: (keys: Keys) => new Paginator(keys.session),
    },
    {
      provide: FILE_STORAGE,
      inject: [ENV],
      useFactory: (env: Env) => new LocalDiskStorage(env.uploadDir),
    },
    { provide: APP_GUARD, useClass: AuthGuard },
    { provide: APP_FILTER, useClass: ProblemFilter },
  ],
  exports: [
    ENV,
    KEYS,
    DbService,
    SessionService,
    AuditService,
    IdempotencyService,
    FourEyesService,
    PiiService,
    OutboxService,
    InvitationService,
    Paginator,
    FILE_STORAGE,
  ],
})
export class CommonModule {}
