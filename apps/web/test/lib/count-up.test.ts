// @vitest-environment jsdom
// TEST-FIRST (page sweep of 2026-10-25): the first animation frame may carry a timestamp earlier
// than the start of the count; the counted amount must never go below 0 (the company dashboard
// crashed on « Amount in millimes must be an integer between 0 and … »).
import { act, renderHook } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { useCountUp } from '@/lib/motion';

afterEach(() => {
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe('useCountUp', () => {
  it('never shows a negative value when the frame timestamp precedes the start', () => {
    vi.stubGlobal('matchMedia', () => ({ matches: false }));
    vi.spyOn(performance, 'now').mockReturnValue(1_000);
    const frames: FrameRequestCallback[] = [];
    vi.stubGlobal('requestAnimationFrame', (callback: FrameRequestCallback) => {
      frames.push(callback);
      return frames.length;
    });
    vi.stubGlobal('cancelAnimationFrame', () => undefined);
    const { result } = renderHook(() => useCountUp(48_250_000, true));
    act(() => {
      frames.shift()?.(990); // 10 ms before `start`
    });
    expect(result.current).toBeGreaterThanOrEqual(0);
    expect(Number.isInteger(result.current)).toBe(true);
  });
});
