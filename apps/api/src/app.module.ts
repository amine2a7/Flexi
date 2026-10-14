import { Module } from '@nestjs/common';
import { CommonModule } from './common/common.module.js';
import { HealthController } from './health/health.controller.js';

@Module({
  imports: [CommonModule],
  controllers: [HealthController],
})
export class AppModule {}
