import { z } from 'zod';

// Open or closed categories of the side menu, remembered per user in this browser (request of
// 2026-11-05). A display preference only: never a token, never business data (securite S-PA-08).
// The key holds a hash of the user id, never the id nor the e-mail.
const openKeys = z.array(z.string().regex(/^[a-z]{1,20}$/)).max(20);

function storageKey(userId: string): string {
  // FNV-1a 32 bits: enough to tell two users of the same browser apart.
  let hash = 0x811c9dc5;
  for (const char of userId) {
    hash ^= char.charCodeAt(0);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return `fp.menu.${hash.toString(36)}`;
}

/** Categories left open by this user; empty when nothing (or something invalid) is stored. */
export function readOpenCategories(userId: string): string[] {
  try {
    const raw = window.localStorage.getItem(storageKey(userId));
    if (raw === null) return [];
    const parsed = openKeys.safeParse(JSON.parse(raw));
    return parsed.success ? parsed.data : [];
  } catch {
    return [];
  }
}

export function writeOpenCategories(userId: string, keys: readonly string[]): void {
  try {
    window.localStorage.setItem(storageKey(userId), JSON.stringify(keys));
  } catch {
    // Storage refused (private mode): the menu still works, it just forgets.
  }
}
