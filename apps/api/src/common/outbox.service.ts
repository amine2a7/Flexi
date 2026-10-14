import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { uuidv7 } from './crypto.js';

export interface OutgoingMessage {
  /** E-mail address, or phone number for an SMS. */
  readonly to: string;
  readonly subject: string;
  readonly text: string;
}

/**
 * Messages to users (invitations, password reset). No e-mail or SMS provider yet: in development
 * each message is a file of var/outbox (ignored by Git), never a log line. In production the API
 * refuses to pretend it sent anything (warning without the content).
 */
@Injectable()
export class OutboxService {
  private readonly logger = new Logger('Outbox');

  constructor(@Inject(ENV) private readonly env: Env) {}

  async send(message: OutgoingMessage): Promise<void> {
    if (this.env.NODE_ENV === 'production') {
      this.logger.warn(`message "${message.subject}" not sent: no e-mail / SMS provider`);
      return;
    }
    const dir = join(this.env.uploadDir, '..', 'outbox');
    await mkdir(dir, { recursive: true });
    const name = `${new Date().toISOString().replaceAll(':', '-')}-${uuidv7()}.txt`;
    await writeFile(
      join(dir, name),
      `To: ${message.to}\nSubject: ${message.subject}\n\n${message.text}\n`,
      { flag: 'wx' },
    );
  }

  /** Web address of the sign-in page, in French (the language of the messages for now). */
  signInUrl(): string {
    return `${this.env.webOrigins[0] ?? 'http://localhost:3001'}/fr/login`;
  }

  webOrigin(): string {
    return this.env.webOrigins[0] ?? 'http://localhost:3001';
  }
}
