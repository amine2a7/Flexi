import { Controller, Get } from '@nestjs/common';
import { Public } from '../common/decorators.js';

/** Liveness only: no version, host, dependency or configuration information (contract). */
@Controller()
export class HealthController {
  @Public()
  @Get('health')
  health(): { status: 'ok' } {
    return { status: 'ok' };
  }
}
