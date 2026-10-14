import type { AddressInfo } from 'node:net';
import type { NestExpressApplication } from '@nestjs/platform-express';

export const WEB_ORIGIN = 'http://localhost:3001';

interface Cookie {
  readonly value: string;
  readonly path: string;
}

/**
 * Minimal browser for the API: keeps the cookies (with their Path), sends Origin and the web
 * channel header, and the CSRF token once known. Secure cookies are kept on http://127.0.0.1
 * like a browser does on localhost.
 */
export class WebClient {
  private readonly cookies = new Map<string, Cookie>();
  csrfToken: string | undefined;

  constructor(private readonly base: string) {}

  cookie(name: string): string | undefined {
    return this.cookies.get(name)?.value;
  }

  async call(
    method: string,
    path: string,
    options: { body?: unknown; headers?: Record<string, string>; csrf?: boolean } = {},
  ): Promise<{ status: number; body: Record<string, unknown>; headers: Headers }> {
    const cookieHeader = [...this.cookies.entries()]
      .filter(([, cookie]) => path.startsWith(cookie.path))
      .map(([name, cookie]) => `${name}=${cookie.value}`)
      .join('; ');
    const headers: Record<string, string> = {
      Origin: WEB_ORIGIN,
      'X-FlexiPay-Client': 'web',
      ...(cookieHeader === '' ? {} : { Cookie: cookieHeader }),
      ...(options.body === undefined ? {} : { 'Content-Type': 'application/json' }),
      ...((options.csrf ?? true) && this.csrfToken !== undefined
        ? { 'X-CSRF-Token': this.csrfToken }
        : {}),
      ...options.headers,
    };
    const response = await fetch(this.base + path, {
      method,
      headers,
      ...(options.body === undefined ? {} : { body: JSON.stringify(options.body) }),
    });
    for (const raw of response.headers.getSetCookie()) {
      const [pair = '', ...attributes] = raw.split(';').map((part) => part.trim());
      const index = pair.indexOf('=');
      const name = pair.slice(0, index);
      const value = pair.slice(index + 1);
      const pathAttribute = attributes.find((attribute) =>
        attribute.toLowerCase().startsWith('path='),
      );
      const expired = attributes.some((attribute) => /^expires=thu, 01 jan 1970/i.test(attribute));
      if (value === '' || expired) this.cookies.delete(name);
      else this.cookies.set(name, { value, path: pathAttribute?.slice(5) ?? '/' });
    }
    const text = await response.text();
    const body = text === '' ? {} : (JSON.parse(text) as Record<string, unknown>);
    if (typeof body.csrfToken === 'string') this.csrfToken = body.csrfToken;
    return { status: response.status, body, headers: response.headers };
  }
}

export async function listen(app: NestExpressApplication): Promise<string> {
  await app.listen(0, '127.0.0.1');
  const address = app.getHttpServer().address() as AddressInfo;
  return `http://127.0.0.1:${String(address.port)}`;
}
