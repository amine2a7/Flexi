import { Inject, Injectable, Logger, type OnModuleDestroy } from '@nestjs/common';
import pg from 'pg';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { PG_SESSION_OPTIONS, pgSsl } from '../config/database-urls.js';
import type { Tx } from '../common/db.service.js';

/** PostgreSQL channel of the till events (pg_notify is delivered at COMMIT only). */
const CHANNEL = 'checkout_events';

type Listener = (checkoutId: string) => void;

/**
 * Real-time events of the tills (M4). A business transaction calls `notify` (pg_notify, sent at
 * commit, never for a rolled-back change); one LISTEN connection per API process dispatches the
 * events to the SSE subscribers of the till, whichever API instance wrote the change.
 */
@Injectable()
export class CheckoutEvents implements OnModuleDestroy {
  private readonly logger = new Logger('CheckoutEvents');
  private readonly listeners = new Map<string, Set<Listener>>();
  private client: pg.Client | undefined;
  private connecting: Promise<void> | undefined;

  constructor(@Inject(ENV) private readonly env: Env) {}

  /** Queues an event of `registerId` in the transaction `tx` (sent if and when it commits). */
  async notify(tx: Tx, registerId: string, checkoutId: string): Promise<void> {
    await tx.$executeRaw`SELECT pg_notify(${CHANNEL}, ${`${registerId}:${checkoutId}`})`;
  }

  /** Subscribes to the events of one till; returns the unsubscription. */
  async subscribe(registerId: string, listener: Listener): Promise<() => void> {
    await this.connect();
    let set = this.listeners.get(registerId);
    if (set === undefined) {
      set = new Set();
      this.listeners.set(registerId, set);
    }
    set.add(listener);
    return () => {
      set.delete(listener);
      if (set.size === 0) this.listeners.delete(registerId);
    };
  }

  private async connect(): Promise<void> {
    if (this.client !== undefined) return;
    this.connecting ??= (async () => {
      const client = new pg.Client({
        connectionString: this.env.databaseUrl,
        options: PG_SESSION_OPTIONS,
        ssl: pgSsl(this.env),
      });
      client.on('notification', (message) => {
        const [registerId, checkoutId] = (message.payload ?? '').split(':');
        if (registerId === undefined || checkoutId === undefined) return;
        for (const listener of this.listeners.get(registerId) ?? []) listener(checkoutId);
      });
      client.on('error', (error) => {
        this.logger.error(`listen connection lost: ${error.constructor.name}`);
        this.client = undefined;
        this.connecting = undefined;
      });
      await client.connect();
      await client.query(`LISTEN ${CHANNEL}`);
      this.client = client;
    })();
    try {
      await this.connecting;
    } catch (error) {
      this.connecting = undefined;
      throw error;
    }
  }

  async onModuleDestroy(): Promise<void> {
    this.listeners.clear();
    const client = this.client;
    this.client = undefined;
    this.connecting = undefined;
    await client?.end().catch(() => undefined);
  }
}
