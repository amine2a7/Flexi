/**
 * Secrets typed by a user in a support message (W-SUP): a PIN, a password or a card number is
 * masked BEFORE the text is saved, so that it is never stored, shown to an agent or logged.
 * The mask is a run of bullets; the last 4 digits of a card stay (enough to recognise it).
 */
export interface Redacted {
  readonly text: string;
  readonly redacted: boolean;
}

const BULLETS = '••••';

// « PIN 1234 », « mon code pin est : 1234 », « code secret 1234 », « الرمز السري 1234 ».
const PIN =
  /(\bcode\s+pin\b|\bpin\b|\bcode\s+(?:secret|confidentiel)\b|الرمز\s+السري|رمز\s+سري|الرمز|رمز)([^\d\n]{0,24}?)(\d{4,6})(?!\d)/giu;

// « mot de passe : Abc123! », « mdp = x », « password is x », « كلمة السر x ».
const PASSWORD =
  /(\bmot\s+de\s+passe\b|\bmdp\b|\bpassword\b|\bpasswd\b|\bpwd\b|كلمة\s+(?:السر|المرور))(\s*(?::|=|\best\b|\bis\b|c['’]est)\s*["'«“]?\s*)([^\s"'»”]{3,})/giu;

// 13 to 19 digits, spaces or dashes allowed between them.
const CARD = /(?<![\d])(?:\d[ -]?){12,18}\d(?![\d])/gu;

function luhn(digits: string): boolean {
  let sum = 0;
  let double = false;
  for (let i = digits.length - 1; i >= 0; i -= 1) {
    let n = digits.charCodeAt(i) - 48;
    if (double) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    double = !double;
  }
  return sum % 10 === 0;
}

export function redactSecrets(input: string): Redacted {
  let redacted = false;
  let text = input.replace(CARD, (match) => {
    const digits = match.replace(/[ -]/g, '');
    if (digits.length < 13 || digits.length > 19 || !luhn(digits)) return match;
    redacted = true;
    return `${BULLETS} ${BULLETS} ${BULLETS} ${digits.slice(-4)}`;
  });
  text = text.replace(PIN, (_match, keyword: string, between: string) => {
    redacted = true;
    return `${keyword}${between}${BULLETS}`;
  });
  text = text.replace(PASSWORD, (_match, keyword: string, between: string) => {
    redacted = true;
    return `${keyword}${between}${BULLETS}${BULLETS}`;
  });
  return { text, redacted };
}
