import { Body, Controller, HttpCode, Inject, Post } from '@nestjs/common';
import { z } from 'zod';
import { AllowSteps, Public, Self } from '../common/decorators.js';
import { parse } from '../common/validation.js';
import { AuthService } from './auth.service.js';
import { SessionService } from './session.service.js';

const secret = z.string().min(1).max(256);
const deviceId = z.string().regex(/^[A-Za-z0-9_-]{16,128}$/);

const loginBody = z.strictObject({
  identifier: z.string().min(1).max(254),
  password: secret,
  deviceId,
});
const mfaBody = z.union([
  z.strictObject({ challengeId: z.uuid(), code: z.string().regex(/^[0-9]{6}$/), deviceId }),
  z.strictObject({
    challengeId: z.uuid(),
    recoveryCode: z.string().regex(/^[A-HJ-NP-Z2-9]{10}$/),
    deviceId,
  }),
]);
const passwordChangeBody = z.strictObject({
  currentPassword: secret.optional(),
  newPassword: secret,
});
const refreshBody = z.strictObject({
  refreshToken: z.string().regex(/^[A-Za-z0-9_-]{20,256}$/),
  deviceId,
});

/**
 * Sign-in of the mobile apps (M4): same rules as the web (Argon2id, failure counters, MFA for the
 * merchants, password change at the first sign-in), tokens in the body instead of cookies, the
 * session bound to the device. Access token 15 min, rotating refresh token, revoked at sign-out.
 */
@Controller('v1/mobile/auth')
export class MobileAuthController {
  constructor(
    @Inject(AuthService) private readonly auth: AuthService,
    @Inject(SessionService) private readonly sessions: SessionService,
  ) {}

  @Public()
  @Post('login')
  @HttpCode(200)
  async login(@Body() body: unknown) {
    const input = parse(loginBody, body);
    const outcome = await this.auth.login(input.identifier, input.password, {
      deviceId: input.deviceId,
    });
    if (outcome.kind === 'challenge') return outcome.body;
    return this.sessions.mobileResult(outcome.issued);
  }

  @Public()
  @Post('mfa/verify')
  @HttpCode(200)
  async verify(@Body() body: unknown) {
    const input = parse(mfaBody, body);
    const issued = await this.auth.verifyMfa(
      input.challengeId,
      'code' in input ? input.code : undefined,
      'recoveryCode' in input ? input.recoveryCode : undefined,
      { deviceId: input.deviceId },
    );
    return this.sessions.mobileResult(issued);
  }

  @AllowSteps('PASSWORD_CHANGE')
  @Self()
  @Post('password/change')
  @HttpCode(200)
  async changePassword(@Body() body: unknown) {
    const input = parse(passwordChangeBody, body);
    return this.sessions.mobileResult(
      await this.auth.changePassword(input.currentPassword, input.newPassword),
    );
  }

  @Public()
  @Post('refresh')
  @HttpCode(200)
  async refresh(@Body() body: unknown) {
    const input = parse(refreshBody, body);
    const issued = await this.auth.refresh(input.refreshToken, { deviceId: input.deviceId });
    return this.sessions.mobileResult(issued);
  }

  @AllowSteps('PASSWORD_CHANGE', 'MFA_ENROLL')
  @Self()
  @Post('logout')
  @HttpCode(204)
  async logout(): Promise<void> {
    await this.auth.revokeCurrent();
  }
}
