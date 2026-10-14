import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module.js';
import { CommonModule } from './common/common.module.js';
import { HealthController } from './health/health.controller.js';

@Module({
  imports: [CommonModule, AuthModule],
  controllers: [HealthController],
})
export class AppModule {}
