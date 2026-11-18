import { ConsoleLogger, type LogLevel } from '@nestjs/common';

const MASK = '[masqué]';

/**
 * Masks the secrets and the personal identifiers in a log line (SEC-1), whatever wrote it:
 * PIN, passwords, tokens, signatures, Argon2 hashes, CIN numbers, RIB and IBAN. The services
 * already never log them; this is the last barrier.
 */
const RULES: readonly [RegExp, string][] = [
  // "key": "value", key=value, key: value for the sensitive names.
  [
    /(["']?\b(?:password|newPassword|currentPassword|temporaryPassword|pin|newPin|code|otp|token|accessToken|refreshToken|csrfToken|secret|signature|authorization|cookie|iban|rib|nationalId|taxId|cin)\b["']?\s*[:=]\s*)("(?:[^"\\]|\\.)*"|'[^']*'|[^\s,;&}\]]+)/gi,
    `$1${MASK}`,
  ],
  [/\bBearer\s+[A-Za-z0-9._~+/-]+=*/g, `Bearer ${MASK}`],
  [/\$argon2(?:id|i|d)\$[^\s"',]+/g, MASK],
  // Session cookies (__Host-fp_at=..., __Host-fp_rt=...).
  [/(__Host-[A-Za-z_]+=)[^;\s"]+/g, `$1${MASK}`],
  // Tunisian IBAN (TN + 22 digits, spaces allowed) and RIB (20 digits).
  [/\bTN\d{2}(?:\s?\d){20}\b/g, `TN${MASK}`],
  [/\b\d{20}\b/g, MASK],
  // CIN number (8 digits).
  [/\b\d{8}\b/g, MASK],
  // Opaque tokens (32 characters or more of base64url), never a UUID (request ids stay readable).
  [
    /\b(?![0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b)[A-Za-z0-9_-]{32,}\b/g,
    MASK,
  ],
];

export function redact(text: string): string {
  return RULES.reduce(
    (current, [pattern, replacement]) => current.replace(pattern, replacement),
    text,
  );
}

/** Nest logger that writes nothing before it went through `redact`. */
export class RedactingLogger extends ConsoleLogger {
  protected override stringifyMessage(message: unknown, logLevel: LogLevel): string {
    // Masked before the colours are added (an escape code glued to a word hides it), then again.
    const clean = typeof message === 'string' ? redact(message) : message;
    return redact(String(super.stringifyMessage(clean, logLevel)));
  }

  protected override printStackTrace(stack: string | undefined): void {
    // Nest calls it without a stack for a plain message.
    if (typeof stack !== 'string' || stack === '') return;
    super.printStackTrace(redact(stack));
  }
}
