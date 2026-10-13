import { useMemo } from 'react';
import { encodeQr } from '@/lib/qr';

const QUIET_ZONE = 4;

/** QR code drawn in SVG (dark on white, quiet zone included), readable by any scanner. */
export function QrCode({ value, label }: { value: string; label: string }) {
  const modules = useMemo(() => encodeQr(value), [value]);
  const size = modules.length + QUIET_ZONE * 2;
  const path = modules
    .flatMap((row, y) =>
      row.map((dark, x) =>
        dark ? `M${String(x + QUIET_ZONE)} ${String(y + QUIET_ZONE)}h1v1h-1z` : '',
      ),
    )
    .join('');
  return (
    <svg
      role="img"
      aria-label={label}
      viewBox={`0 0 ${String(size)} ${String(size)}`}
      shapeRendering="crispEdges"
      className="size-qr-code rounded-card-desktop bg-surface text-text"
    >
      <rect width={size} height={size} className="fill-surface" />
      <path d={path} className="fill-current" />
    </svg>
  );
}
