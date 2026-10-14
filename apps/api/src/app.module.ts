import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module.js';
import { CommonModule } from './common/common.module.js';
import { HealthController } from './health/health.controller.js';
import { LedgerModule } from './ledger/ledger.module.js';
import { OrdersModule } from './orders/orders.module.js';
import { PlatformModule } from './platform/platform.module.js';

@Module({
  imports: [CommonModule, LedgerModule, PlatformModule, AuthModule, OrdersModule],
  controllers: [HealthController],
})
export class AppModule {}
