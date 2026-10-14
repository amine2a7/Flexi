'use client';

import { useEffect, useRef, useState } from 'react';
import { cn } from '@/lib/cn';

/**
 * Green "to handle" counter of the navigation (animation 14): bounces (380 ms) each time the
 * count goes up, never when it goes down or at the first display.
 */
export function CounterBadge({
  count,
  label,
  className,
}: {
  count: number;
  label?: string;
  className: string;
}) {
  const previous = useRef(count);
  const [bounce, setBounce] = useState(false);
  useEffect(() => {
    // A new item arrived since the previous count (external state of the API).

    if (count > previous.current) setBounce(true);
    previous.current = count;
  }, [count]);
  return (
    <span
      className={cn(className, bounce && 'animate-bounce')}
      aria-label={label}
      onAnimationEnd={() => {
        setBounce(false);
      }}
    >
      {count}
    </span>
  );
}
