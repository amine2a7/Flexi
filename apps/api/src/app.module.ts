import { Module } from '@nestjs/common';
import { AdminModule } from './admin/admin.module.js';
import { AuthModule } from './auth/auth.module.js';
import { CommonModule } from './common/common.module.js';
import { HealthController } from './health/health.controller.js';
import { LedgerModule } from './ledger/ledger.module.js';
import { KycModule } from './kyc/kyc.module.js';
import { FamilyModule } from './family/family.module.js';
import { RiskModule } from './risk/risk.module.js';
import { UsersModule } from './users/users.module.js';
import { OrdersModule } from './orders/orders.module.js';
import { PaymentsModule } from './payments/payments.module.js';
import { PayoutsModule } from './payouts/payouts.module.js';
import { PlatformModule } from './platform/platform.module.js';

@Module({
  imports: [
    CommonModule,
    LedgerModule,
    PlatformModule,
    AuthModule,
    OrdersModule,
    PaymentsModule,
    PayoutsModule,
    AdminModule,
    UsersModule,
    RiskModule,
    KycModule,
    FamilyModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
