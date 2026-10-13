// Minimal QR Code encoder (ISO/IEC 18004), byte mode, error correction level M, versions 1 to 3
// (single error-correction block), mask 0. Enough for the short payment payloads of FlexiPay
// (`flexipay:pay:<8 digits>`, `flexipay:merchant:<6 digits>`); no dependency, no network.

interface VersionInfo {
  readonly version: number;
  readonly dataCodewords: number;
  readonly ecCodewords: number;
  readonly alignment: readonly number[];
}

// Level M, one block: total codewords 26 / 44 / 70.
const VERSIONS: readonly VersionInfo[] = [
  { version: 1, dataCodewords: 16, ecCodewords: 10, alignment: [] },
  { version: 2, dataCodewords: 28, ecCodewords: 16, alignment: [6, 18] },
  { version: 3, dataCodewords: 44, ecCodewords: 26, alignment: [6, 22] },
];

const FORMAT_BITS_LEVEL_M = 0;
const MASK = 0;

function gfMultiply(x: number, y: number): number {
  let z = 0;
  for (let i = 7; i >= 0; i -= 1) {
    z = (z << 1) ^ ((z >>> 7) * 0x11d);
    z ^= ((y >>> i) & 1) * x;
  }
  return z & 0xff;
}

function reedSolomonDivisor(degree: number): number[] {
  const result = new Array<number>(degree).fill(0);
  result[degree - 1] = 1;
  let root = 1;
  for (let i = 0; i < degree; i += 1) {
    for (let j = 0; j < result.length; j += 1) {
      result[j] = gfMultiply(result[j] ?? 0, root);
      if (j + 1 < result.length) result[j] = (result[j] ?? 0) ^ (result[j + 1] ?? 0);
    }
    root = gfMultiply(root, 0x02);
  }
  return result;
}

function reedSolomonRemainder(data: readonly number[], divisor: readonly number[]): number[] {
  const result = new Array<number>(divisor.length).fill(0);
  for (const byte of data) {
    const factor = byte ^ (result.shift() ?? 0);
    result.push(0);
    divisor.forEach((coefficient, index) => {
      result[index] = (result[index] ?? 0) ^ gfMultiply(coefficient, factor);
    });
  }
  return result;
}

function dataCodewords(bytes: Uint8Array, info: VersionInfo): number[] {
  const bits: number[] = [];
  const push = (value: number, length: number) => {
    for (let i = length - 1; i >= 0; i -= 1) bits.push((value >>> i) & 1);
  };
  push(0b0100, 4); // byte mode
  push(bytes.length, 8); // character count (versions 1 to 9)
  bytes.forEach((byte) => {
    push(byte, 8);
  });
  const capacity = info.dataCodewords * 8;
  push(0, Math.min(4, capacity - bits.length)); // terminator
  while (bits.length % 8 !== 0) bits.push(0);
  const codewords: number[] = [];
  for (let i = 0; i < bits.length; i += 8) {
    codewords.push(bits.slice(i, i + 8).reduce((acc, bit) => (acc << 1) | bit, 0));
  }
  for (let pad = 0xec; codewords.length < info.dataCodewords; pad ^= 0xec ^ 0x11) {
    codewords.push(pad);
  }
  return codewords;
}

/** Encodes `text` (UTF-8) as a QR matrix; `true` = dark module. Throws when the text is too long. */
export function encodeQr(text: string): boolean[][] {
  const bytes = new TextEncoder().encode(text);
  const info = VERSIONS.find((candidate) => bytes.length * 8 + 12 <= candidate.dataCodewords * 8);
  if (info === undefined) throw new RangeError('QR payload too long');
  const size = info.version * 4 + 17;
  const modules = Array.from({ length: size }, () => new Array<boolean>(size).fill(false));
  const reserved = Array.from({ length: size }, () => new Array<boolean>(size).fill(false));
  const set = (x: number, y: number, dark: boolean) => {
    const row = modules[y];
    const reservedRow = reserved[y];
    if (row === undefined || reservedRow === undefined) return;
    row[x] = dark;
    reservedRow[x] = true;
  };

  // Timing patterns, then finder patterns with their separators.
  for (let i = 0; i < size; i += 1) {
    set(6, i, i % 2 === 0);
    set(i, 6, i % 2 === 0);
  }
  for (const [cx, cy] of [
    [3, 3],
    [size - 4, 3],
    [3, size - 4],
  ] as const) {
    for (let dy = -4; dy <= 4; dy += 1) {
      for (let dx = -4; dx <= 4; dx += 1) {
        const distance = Math.max(Math.abs(dx), Math.abs(dy));
        const x = cx + dx;
        const y = cy + dy;
        if (x >= 0 && x < size && y >= 0 && y < size) set(x, y, distance !== 2 && distance !== 4);
      }
    }
  }
  // Alignment pattern (versions 2 and 3: one, at the last position).
  const last = info.alignment[info.alignment.length - 1];
  if (last !== undefined) {
    for (let dy = -2; dy <= 2; dy += 1) {
      for (let dx = -2; dx <= 2; dx += 1) {
        set(last + dx, last + dy, Math.max(Math.abs(dx), Math.abs(dy)) !== 1);
      }
    }
  }
  // Format information (level M, mask 0) and the dark module.
  const formatData = (FORMAT_BITS_LEVEL_M << 3) | MASK;
  let remainder = formatData;
  for (let i = 0; i < 10; i += 1) remainder = (remainder << 1) ^ ((remainder >>> 9) * 0x537);
  const format = ((formatData << 10) | remainder) ^ 0x5412;
  const bit = (i: number) => ((format >>> i) & 1) !== 0;
  for (let i = 0; i <= 5; i += 1) set(8, i, bit(i));
  set(8, 7, bit(6));
  set(8, 8, bit(7));
  set(7, 8, bit(8));
  for (let i = 9; i < 15; i += 1) set(14 - i, 8, bit(i));
  for (let i = 0; i < 8; i += 1) set(size - 1 - i, 8, bit(i));
  for (let i = 8; i < 15; i += 1) set(8, size - 15 + i, bit(i));
  set(8, size - 8, true);

  // Data and error correction codewords, zigzag from the bottom right, mask 0 on data modules.
  const data = dataCodewords(bytes, info);
  const codewords = [...data, ...reedSolomonRemainder(data, reedSolomonDivisor(info.ecCodewords))];
  let index = 0;
  for (let right = size - 1; right >= 1; right -= 2) {
    if (right === 6) right = 5;
    for (let vertical = 0; vertical < size; vertical += 1) {
      for (let j = 0; j < 2; j += 1) {
        const x = right - j;
        const upward = ((right + 1) & 2) === 0;
        const y = upward ? size - 1 - vertical : vertical;
        if (reserved[y]?.[x] === true) continue;
        let dark = false;
        if (index < codewords.length * 8) {
          dark = (((codewords[index >>> 3] ?? 0) >>> (7 - (index & 7))) & 1) !== 0;
          index += 1;
        }
        const row = modules[y];
        if (row !== undefined) row[x] = (x + y) % 2 === 0 ? !dark : dark;
      }
    }
  }
  return modules;
}
