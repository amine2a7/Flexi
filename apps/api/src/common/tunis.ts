// Business calendar in Africa/Tunis (decision of 2026-10-09): days and months of the limits, D+2,
// expiries. The API speaks UTC timestamps; these helpers only cut the calendar.
const PARTS = new Intl.DateTimeFormat('en-CA', {
  timeZone: 'Africa/Tunis',
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  weekday: 'short',
});

function parts(date: Date): { year: string; month: string; day: string; weekday: string } {
  const map = Object.fromEntries(PARTS.formatToParts(date).map((part) => [part.type, part.value]));
  return {
    year: map.year ?? '',
    month: map.month ?? '',
    day: map.day ?? '',
    weekday: map.weekday ?? '',
  };
}

/** `YYYY-MM-DD` of the business day of `date`. */
export function businessDay(date: Date = new Date()): string {
  const { year, month, day } = parts(date);
  return `${year}-${month}-${day}`;
}

/** `YYYY-MM` of the business month of `date`. */
export function businessMonth(date: Date = new Date()): string {
  return businessDay(date).slice(0, 7);
}

/** UTC instant where the business day `YYYY-MM-DD` starts (Tunisia: UTC+1, no DST). */
export function startOfBusinessDay(day: string): Date {
  return new Date(`${day}T00:00:00+01:00`);
}

/** Start of the business month `YYYY-MM` (or of the current one). */
export function startOfBusinessMonth(month: string = businessMonth()): Date {
  return new Date(`${month}-01T00:00:00+01:00`);
}

/** The `count` last business months, oldest first, ending with the current one. */
export function lastMonths(count: number, now: Date = new Date()): string[] {
  const [year = 0, month = 1] = businessMonth(now).split('-').map(Number);
  return Array.from({ length: count }, (_, index) => {
    const date = new Date(Date.UTC(year, month - 1 - (count - 1 - index), 1));
    return `${String(date.getUTCFullYear())}-${String(date.getUTCMonth() + 1).padStart(2, '0')}`;
  });
}

/** Business day + `count` calendar days (spec 08: D+2 in calendar days, Africa/Tunis). */
export function addDays(day: string, count: number): string {
  const date = new Date(`${day}T12:00:00Z`);
  date.setUTCDate(date.getUTCDate() + count);
  return date.toISOString().slice(0, 10);
}

/** Calendar date (`YYYY-MM-DD`) stored as a DATE column -> JS Date at UTC midnight. */
export function dateOnly(day: string): Date {
  return new Date(`${day}T00:00:00Z`);
}

/** DATE column (UTC midnight) -> `YYYY-MM-DD`. */
export function dayOf(date: Date): string {
  return date.toISOString().slice(0, 10);
}

/** Adds `months` calendar months (credit validity). */
export function addMonths(date: Date, months: number): Date {
  const next = new Date(date.getTime());
  next.setUTCMonth(next.getUTCMonth() + months);
  return next;
}
