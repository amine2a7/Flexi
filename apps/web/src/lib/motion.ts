'use client';

import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { useCallback, useEffect, useRef, useState } from 'react';

// Animations of docs/design/animations/animations.md. Durations come from the motion tokens; a
// money action never waits for an animation (the effects below only follow what happened).

type MotionName = 'fast' | 'base' | 'slow' | 'emphasis' | 'success' | 'copied' | 'toast';

const DURATIONS = (tokensPreset.theme as { motion: { duration: Record<MotionName, number> } })
  .motion.duration;

/** Duration of a motion token, in milliseconds. */
export function motionMs(name: MotionName): number {
  return DURATIONS[name];
}

/** "Réduire les animations" asked by the system (no movement, no bounce, no counting). */
export function prefersReducedMotion(): boolean {
  // Without matchMedia (server, old browser, test DOM) nothing is assumed: values shown as is.
  if (typeof window === 'undefined' || typeof window.matchMedia !== 'function') return true;
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
}

/**
 * Plays a one-shot animation each time `trigger` changes (not at the first render): returns
 * whether the animation class is on, and the handler that removes it when it ends.
 */
export function useReplay(
  trigger: unknown,
  enabled = true,
): { active: boolean; onAnimationEnd: () => void } {
  const [active, setActive] = useState(false);
  const first = useRef(true);
  useEffect(() => {
    if (first.current) {
      first.current = false;
      return;
    }
    // Reacts to a change coming from the parent (an external event for this component).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (enabled) setActive(true);
  }, [trigger, enabled]);
  const onAnimationEnd = useCallback(() => {
    setActive(false);
  }, []);
  return { active, onAnimationEnd };
}

/** Success state of a button: on for 1,6 s (or `duration`) after `flash()`, then back to normal. */
export function useSuccessFlash(duration: MotionName = 'success'): [boolean, () => void] {
  const [on, setOn] = useState(false);
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  useEffect(
    () => () => {
      clearTimeout(timer.current);
    },
    [],
  );
  const flash = useCallback(() => {
    clearTimeout(timer.current);
    setOn(true);
    timer.current = setTimeout(() => {
      setOn(false);
    }, motionMs(duration));
  }, [duration]);
  return [on, flash];
}

/**
 * Integer counting from 0 to `target` in 600 ms, decelerating, at the first display only (a
 * later change of the value is shown at once). Off when motion is reduced.
 */
export function useCountUp(target: number, enabled: boolean): number {
  const [value, setValue] = useState(() => (enabled && !prefersReducedMotion() ? 0 : target));
  const played = useRef(!enabled);
  useEffect(() => {
    if (played.current || prefersReducedMotion()) {
      // The value changed after the first display: shown as is (never animated on refresh).

      setValue(target);
      return undefined;
    }
    played.current = true;
    const start = performance.now();
    const duration = motionMs('emphasis');
    let frame = 0;
    let done = false;
    const step = (now: number) => {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - (1 - progress) ** 3;
      setValue(Math.round(target * eased));
      if (progress < 1) frame = requestAnimationFrame(step);
      else done = true;
    };
    frame = requestAnimationFrame(step);
    return () => {
      cancelAnimationFrame(frame);
      // Interrupted before the end (remount in development): the next run plays it again.
      if (!done) played.current = false;
    };
  }, [target]);
  return value;
}
