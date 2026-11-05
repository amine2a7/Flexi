// Deterministic pseudo-random generator for the mock data: same data at every start, so tests and
// screenshots are reproducible. Mock code only (never shipped, see test/build).

export interface Random {
  readonly next: () => number;
  readonly int: (min: number, max: number) => number;
  readonly pick: <T>(items: readonly T[]) => T;
  readonly uuid: () => string;
  readonly digits: (length: number) => string;
}

export function createRandom(seed: number): Random {
  let state = seed >>> 0;
  const next = (): number => {
    // mulberry32
    state = (state + 0x6d2b79f5) >>> 0;
    let t = state;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
  const int = (min: number, max: number): number => min + Math.floor(next() * (max - min + 1));
  const pick = <T>(items: readonly T[]): T => {
    const item = items[int(0, items.length - 1)];
    if (item === undefined) throw new Error('pick from an empty list');
    return item;
  };
  const hex = (length: number): string =>
    Array.from({ length }, () => int(0, 15).toString(16)).join('');
  const uuid = (): string =>
    `${hex(8)}-${hex(4)}-7${hex(3)}-${pick(['8', '9', 'a', 'b'])}${hex(3)}-${hex(12)}`;
  const digits = (length: number): string =>
    Array.from({ length }, () => String(int(0, 9))).join('');
  return { next, int, pick, uuid, digits };
}

export const MINUTE = 60_000;
export const DAY = 24 * 60 * MINUTE;

/** RFC 3339 UTC timestamp with milliseconds (contract `Timestamp`). */
export function iso(time: number): string {
  return new Date(time).toISOString();
}

/** Calendar date `YYYY-MM-DD` (contract `CalendarDate`). */
export function calendarDate(time: number): string {
  return new Date(time).toISOString().slice(0, 10);
}

export const FIRST_NAMES = [
  'Ahmed',
  'Mohamed',
  'Youssef',
  'Amine',
  'Sami',
  'Karim',
  'Walid',
  'Hichem',
  'Nizar',
  'Bilel',
  'Oussama',
  'Firas',
  'Aymen',
  'Mehdi',
  'Skander',
  'Fatma',
  'Leïla',
  'Amira',
  'Sarra',
  'Ines',
  'Mariem',
  'Rania',
  'Nour',
  'Salma',
  'Khadija',
  'Hela',
  'Asma',
  'Olfa',
  'Imen',
  'Yasmine',
] as const;

export const LAST_NAMES = [
  'Ben Ali',
  'Trabelsi',
  'Jaziri',
  'Gharbi',
  'Hammami',
  'Ben Salah',
  'Mejri',
  'Khalfaoui',
  'Chaabane',
  'Dridi',
  'Ayari',
  'Sassi',
  'Zouari',
  'Ben Amor',
  'Kammoun',
  'Masmoudi',
  'Jebali',
  'Ferchichi',
  'Tlili',
  'Bouaziz',
] as const;

export const CITIES = [
  'Tunis',
  'Sfax',
  'Sousse',
  'Ariana',
  'Ben Arous',
  'Nabeul',
  'Bizerte',
  'Monastir',
  'Kairouan',
  'Gabès',
  'La Marsa',
  'Manouba',
  'Hammamet',
  'Mahdia',
] as const;

/** Tunisian mobile number in E.164 (+216 then 8 digits starting with 2, 5 or 9). */
export function tunisianPhone(random: Random): string {
  return `+216${random.pick(['2', '5', '9'])}${random.digits(7)}`;
}
