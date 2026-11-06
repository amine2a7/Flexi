// Minimal web browser for the demo seed: keeps the cookies (with their Path), sends the Origin, the
// web channel header and the CSRF token, like the web app. Errors stop the seed with their code.
import { randomUUID } from 'node:crypto';

interface Cookie {
  readonly value: string;
  readonly path: string;
}

export type Body = Record<string, unknown>;

export class WebClient {
  private readonly cookies = new Map<string, Cookie>();
  private csrfToken: string | undefined;

  constructor(
    private readonly base: string,
    private readonly origin: string,
    readonly label: string,
  ) {}

  /** A call; `expect` lists the accepted statuses (2xx by default). */
  async call(
    method: string,
    path: string,
    options: { body?: unknown; form?: FormData; key?: boolean; expect?: number[] } = {},
  ): Promise<Body> {
    const cookieHeader = [...this.cookies.entries()]
      .filter(([, cookie]) => path.startsWith(cookie.path))
      .map(([name, cookie]) => `${name}=${cookie.value}`)
      .join('; ');
    const headers: Record<string, string> = {
      Origin: this.origin,
      'X-FlexiPay-Client': 'web',
      ...(cookieHeader === '' ? {} : { Cookie: cookieHeader }),
      ...(options.body === undefined ? {} : { 'Content-Type': 'application/json' }),
      ...(this.csrfToken === undefined ? {} : { 'X-CSRF-Token': this.csrfToken }),
      ...(options.key === true ? { 'Idempotency-Key': randomUUID() } : {}),
    };
    const response = await fetch(this.base + path, {
      method,
      headers,
      ...(options.body === undefined ? {} : { body: JSON.stringify(options.body) }),
      ...(options.form === undefined ? {} : { body: options.form }),
    });
    for (const raw of response.headers.getSetCookie()) {
      const [pair = '', ...attributes] = raw.split(';').map((part) => part.trim());
      const index = pair.indexOf('=');
      const name = pair.slice(0, index);
      const value = pair.slice(index + 1);
      const pathAttribute = attributes.find((item) => item.toLowerCase().startsWith('path='));
      const expired = attributes.some((item) => /^expires=thu, 01 jan 1970/i.test(item));
      if (value === '' || expired) this.cookies.delete(name);
      else this.cookies.set(name, { value, path: pathAttribute?.slice(5) ?? '/' });
    }
    const text = await response.text();
    const body = text === '' ? {} : (JSON.parse(text) as Body);
    if (typeof body.csrfToken === 'string') this.csrfToken = body.csrfToken;
    const accepted = options.expect ?? [];
    if (!(response.ok || accepted.includes(response.status))) {
      throw new Error(
        `demo seed: ${this.label} ${method} ${path} -> ${String(response.status)} ${String(body.code)}`,
      );
    }
    return { ...body, status: response.status };
  }

  /** Password then the fixed demo MFA code (DEMO_FIXED_MFA_CODE, development only). */
  async signIn(email: string, password: string, mfaCode: string): Promise<this> {
    const login = await this.call('POST', '/v1/auth/login', {
      body: { identifier: email, password },
    });
    if (login.challengeId !== undefined) {
      await this.call('POST', '/v1/auth/mfa/verify', {
        body: { challengeId: login.challengeId, code: mfaCode },
      });
    }
    return this;
  }
}
