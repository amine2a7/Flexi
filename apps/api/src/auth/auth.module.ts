import { Module } from '@nestjs/common';
import { AuthController, MeController } from './auth.controller.js';
import { MobileAuthController } from './mobile-auth.controller.js';
import { AuthService } from './auth.service.js';

@Module({
  controllers: [AuthController, MeController, MobileAuthController],
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}
