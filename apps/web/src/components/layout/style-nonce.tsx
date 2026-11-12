'use client';

/**
 * The dialogs (Radix, through react-remove-scroll) add a <style> element when they open; under the
 * strict CSP of a build it must carry the nonce of the page, read by that library from
 * `__webpack_nonce__`. The nonce is taken from a script that Next.js already stamped with it, when
 * this module is first evaluated in the browser (before any dialog opens). Never in a header, a
 * log or an attribute of ours: the browser keeps it out of the DOM attributes.
 */
if (typeof document !== 'undefined') {
  const nonce = document.querySelector<HTMLScriptElement>('script[nonce]')?.nonce;
  if (nonce !== undefined && nonce !== '') {
    (globalThis as { __webpack_nonce__?: string }).__webpack_nonce__ = nonce;
  }
}

export function StyleNonce() {
  return null;
}
