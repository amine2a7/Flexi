import { Body, Controller, Get, HttpCode, Inject, Post, Req, Res } from '@nestjs/common';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { AllowSteps, Public, Self } from '../common/decorators.js';
import { REFRESH_COOKIE, cookiesOf } from '../common/http.js';
import { validationFailed } from '../common/problem.js';
import { parse } from '../common/validation.js';
import { AuthService } from './auth.service.js';
import { PASSWORD_POLICY } from './password.js';
import { SessionService } from './session.service.js';

const totp = z.string().regex(/^[0-9]{6}$/);
const recovery = z.string().regex(/^[A-HJ-NP-Z2-9]{10}$/);
const secret = z.string().min(1).max(256);
const identifier = z.string().min(1).max(254);

const loginBody = z.strictObject({ identifier, password: secret });
const mfaVerifyBody = z.union([
  z.strictObject({ challengeId: z.uuid(), code: totp }),
  z.strictObject({ challengeId: z.uuid(), recoveryCode: recovery }),
]);
const reEnrolBody = z.strictObject({
  currentPassword: secret.optional(),
  currentCode: z.union([totp, recovery]).optional(),
});
const enrolConfirmBody = z.strictObject({ code: totp });
const proofBody = z.strictObject({
  currentPassword: secret,
  currentCode: z.union([totp, recovery]),
});
const passwordChangeBody = z.strictObject({
  currentPassword: secret.optional(),
  newPassword: secret,
});
const forgotBody = z.strictObject({ identifier });
const resetBody = z.union([
  z.strictObject({
    token: z
      .string()
      .regex(/^[A-Za-z0-9_-]+$/)
      .max(256),
    newPassword: secret,
  }),
  z.strictObject({ identifier, otp: z.string().regex(/^[0-9]{6}$/), newPassword: secret }),
]);

/** `X-FlexiPay-Client: web` is required on every /v1/auth/* route of the web (contract §10). */
function requireWebChannel(req: Request): void {
  if (req.headers['x-flexipay-client'] !== 'web') {
    throw validationFailed([{ in: 'header', pointer: 'X-FlexiPay-Client', code: 'REQUIRED' }]);
  }
}

@Controller('v1/auth')
export class AuthController {
  constructor(
    @Inject(AuthService) private readonly auth: AuthService,
    @Inject(SessionService) private readonly sessions: SessionService,
  ) {}

  @Public()
  @Post('login')
  @HttpCode(200)
  async login(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    requireWebChannel(req);
    const input = parse(loginBody, body);
    const outcome = await this.auth.login(input.identifier, input.password);
    if (outcome.kind === 'challenge') return outcome.body;
    this.sessions.setCookies(res, outcome.issued);
    return this.sessions.result(outcome.issued);
  }

  @Public()
  @Post('mfa/verify')
  @HttpCode(200)
  async verify(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    requireWebChannel(req);
    const input = parse(mfaVerifyBody, body);
    const issued = await this.auth.verifyMfa(
      input.challengeId,
      'code' in input ? input.code : undefined,
      'recoveryCode' in input ? input.recoveryCode : undefined,
    );
    this.sessions.setCookies(res, issued);
    return this.sessions.result(issued);
  }

  @AllowSteps('MFA_ENROLL')
  @Self()
  @Post('mfa/enroll')
  @HttpCode(200)
  async enrol(@Req() req: Request, @Body() body: unknown) {
    requireWebChannel(req);
    return this.auth.startEnrolment(parse(reEnrolBody, body ?? {}));
  }

  @AllowSteps('MFA_ENROLL')
  @Self()
  @Post('mfa/enroll/confirm')
  @HttpCode(200)
  async confirmEnrolment(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    requireWebChannel(req);
    const { code } = parse(enrolConfirmBody, body);
    const { issued, recoveryCodes } = await this.auth.confirmEnrolment(code);
    this.sessions.setCookies(res, issued);
    return { ...this.sessions.result(issued), recoveryCodes };
  }

  @Self()
  @Post('mfa/recovery-codes')
  @HttpCode(200)
  async recoveryCodes(@Req() req: Request, @Body() body: unknown) {
    requireWebChannel(req);
    return { recoveryCodes: await this.auth.regenerateRecoveryCodes(parse(proofBody, body)) };
  }

  @AllowSteps('PASSWORD_CHANGE')
  @Self()
  @Post('password/change')
  @HttpCode(200)
  async changePassword(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Body() body: unknown,
  ) {
    requireWebChannel(req);
    const input = parse(passwordChangeBody, body);
    const issued = await this.auth.changePassword(input.currentPassword, input.newPassword);
    this.sessions.setCookies(res, issued);
    return this.sessions.result(issued);
  }

  @Public()
  @Get('password-policy')
  policy() {
    return PASSWORD_POLICY;
  }

  /**
   * Refresh by cookie: also how the web gets its CSRF token back after a page reload. Requires
   * the custom header (CORS preflight, contract §6 control 3).
   */
  @Public()
  @Post('refresh')
  @HttpCode(200)
  async refresh(@Req() req: Request, @Res({ passthrough: true }) res: Response) {
    if (req.headers['x-flexipay-client'] !== 'web') {
      throw validationFailed([{ in: 'header', pointer: 'X-FlexiPay-Client', code: 'REQUIRED' }]);
    }
    const issued = await this.auth.refresh(cookiesOf(req)[REFRESH_COOKIE]);
    this.sessions.setCookies(res, issued);
    return this.sessions.result(issued);
  }

  @AllowSteps('PASSWORD_CHANGE', 'MFA_ENROLL')
  @Self()
  @Post('logout')
  @HttpCode(204)
  async logout(@Req() req: Request, @Res({ passthrough: true }) res: Response): Promise<void> {
    requireWebChannel(req);
    await this.auth.logout(res);
  }

  @Public()
  @Post('password/forgot')
  @HttpCode(202)
  async forgot(@Req() req: Request, @Body() body: unknown): Promise<void> {
    requireWebChannel(req);
    await this.auth.forgotPassword(parse(forgotBody, body).identifier);
  }

  @Public()
  @Post('password/reset')
  @HttpCode(204)
  async reset(@Req() req: Request, @Body() body: unknown): Promise<void> {
    requireWebChannel(req);
    await this.auth.resetPassword(parse(resetBody, body));
  }
}

@Controller('v1/me')
export class MeController {
  constructor(@Inject(AuthService) private readonly auth: AuthService) {}

  @Self()
  @Get()
  me() {
    return this.auth.me();
  }

  @Self()
  @Post('onboarding-tour')
  @HttpCode(204)
  async tour(): Promise<void> {
    await this.auth.completeTour();
  }
}
