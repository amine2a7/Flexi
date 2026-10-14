import { Inject, Injectable, type CanActivate, type ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import type { Role, SessionStep } from '../generated/prisma/enums.js';
import { SessionService } from '../auth/session.service.js';
import { DbService } from './db.service.js';
import { PUBLIC, ROLES, STEPS } from './decorators.js';
import { ACCESS_COOKIE, REFRESH_COOKIE, cookiesOf } from './http.js';
import { ApiProblem, problems } from './problem.js';
import { currentContext } from './request-context.js';

const UNSAFE = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);

/**
 * Global guard, deny by default (contract §6): every route needs a live session unless marked
 * `@Public()`; restricted session states only reach their own routes (§10); unsafe methods
 * authenticated by cookie need the CSRF token; `@Roles()` restricts the roles.
 */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    @Inject(Reflector) private readonly reflector: Reflector,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(DbService) private readonly db: DbService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const targets = [context.getHandler(), context.getClass()];
    if (this.reflector.getAllAndOverride<boolean | undefined>(PUBLIC, targets) ?? false) return true;
    const req = context.switchToHttp().getRequest<Request>();
    const cookies = cookiesOf(req);
    const bearer = /^Bearer ([A-Za-z0-9_-]{20,})$/.exec(req.headers.authorization ?? '')?.[1];
    const cookieToken = cookies[ACCESS_COOKIE];
    // One mechanism per request: cookie and Authorization together are refused.
    if (bearer !== undefined && (cookieToken !== undefined || REFRESH_COOKIE in cookies)) {
      throw problems.unauthenticated();
    }
    const token = bearer ?? cookieToken;
    if (token === undefined || token === '') throw problems.unauthenticated();
    const session = await this.sessions.authenticate(token);

    const allowedSteps =
      this.reflector.getAllAndOverride<SessionStep[] | undefined>(STEPS, targets) ?? [];
    if (session.step !== 'NONE' && !allowedSteps.includes(session.step)) {
      throw new ApiProblem(
        403,
        session.step === 'PASSWORD_CHANGE' ? 'PASSWORD_CHANGE_REQUIRED' : 'MFA_ENROLLMENT_REQUIRED',
      );
    }
    if (bearer === undefined && UNSAFE.has(req.method)) {
      const header = req.headers['x-csrf-token'];
      if (!this.sessions.checkCsrf(session.id, typeof header === 'string' ? header : undefined)) {
        throw problems.csrf();
      }
    }
    const user = await this.db.system((tx) =>
      tx.user.findUnique({
        where: { id: session.userId },
        include: { employee: { select: { companyId: true } } },
      }),
    );
    if (user?.status !== 'ACTIVE') throw problems.unauthenticated();
    const roles = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES, targets);
    if (roles !== undefined && !roles.includes(user.role)) throw problems.forbidden();

    const ctx = currentContext();
    if (ctx === undefined) throw new Error('request context missing');
    ctx.principal = {
      userId: user.id,
      sessionId: session.id,
      role: user.role,
      subRole: user.subRole,
      displayName: user.displayName,
      step: session.step,
      // A beneficiary reads the name of its company: its company id joins the RLS context.
      companyId: user.companyId ?? user.employee?.companyId ?? null,
      merchantId: user.merchantId,
      employeeId: user.employeeId,
    };
    return true;
  }
}
