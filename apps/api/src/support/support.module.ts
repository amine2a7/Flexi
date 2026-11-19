import {
  Inject,
  Injectable,
  Logger,
  Module,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { SearchController } from '../search/search.controller.js';
import { SearchService } from '../search/search.service.js';
import { AdminSupportController, SupportController } from './support.controller.js';
import { SupportService } from './support.service.js';

const EVERY_MS = 10 * 60_000;

/** Closes the tickets resolved 7 days ago (API process; BullMQ later, like the other jobs). */
@Injectable()
export class SupportJobs implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger('SupportJobs');
  private timer: NodeJS.Timeout | undefined;

  constructor(
    @Inject(ENV) private readonly env: Env,
    @Inject(SupportService) private readonly support: SupportService,
  ) {}

  onApplicationBootstrap(): void {
    if (this.env.NODE_ENV === 'test') return;
    this.timer = setInterval(() => void this.run(), EVERY_MS);
    this.timer.unref();
  }

  onApplicationShutdown(): void {
    if (this.timer !== undefined) clearInterval(this.timer);
  }

  async run(): Promise<void> {
    try {
      await this.support.closeResolved();
    } catch (error) {
      this.logger.error(
        `job support failed: ${error instanceof Error ? error.constructor.name : 'unknown'}`,
      );
    }
  }
}

/** Support tickets and the global search (W-SUP). */
@Module({
  controllers: [SupportController, AdminSupportController, SearchController],
  providers: [SupportService, SupportJobs, SearchService],
  exports: [SupportService],
})
export class SupportModule {}
