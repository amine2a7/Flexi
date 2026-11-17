/**
 * QR code encoder (ISO/IEC 18004), byte mode, error correction level M, versions 1 to 10: enough
 * for the sticker link of a till (about 75 characters). No dependency (a library needs the approval
 * of Amine, like the PDF writer). Returns the module matrix, `true` = dark module.
 */

const ECC_CODEWORDS_PER_BLOCK_M = [-1, 10, 16, 26, 18, 24, 16, 18, 22, 22, 26];
const ERROR_BLOCKS_M = [-1, 1, 1, 1, 2, 2, 4, 4, 4, 5, 5];
const MAX_VERSION = 10;
/** Format bits of level M (00). */
const ECL_M_BITS = 0;

function rawDataModules(version: number): number {
  let result = (16 * version + 128) * version + 64;
  if (version >= 2) {
    const align = Math.floor(version / 7) + 2;
    result -= (25 * align - 10) * align - 55;
    if (version >= 7) result -= 36;
  }
  return result;
}

function dataCodewords(version: number): number {
  return (
    Math.floor(rawDataModules(version) / 8) -
    (ECC_CODEWORDS_PER_BLOCK_M[version] ?? 0) * (ERROR_BLOCKS_M[version] ?? 0)
  );
}

// ---------------------------------------------------------------- Reed-Solomon over GF(256)

function gfMultiply(x: number, y: number): number {
  let z = 0;
  for (let i = 7; i >= 0; i--) {
    z = (z << 1) ^ ((z >>> 7) * 0x11d);
    z ^= ((y >>> i) & 1) * x;
  }
  return z & 0xff;
}

function rsDivisor(degree: number): number[] {
  const result = new Array<number>(degree).fill(0);
  result[degree - 1] = 1;
  let root = 1;
  for (let i = 0; i < degree; i++) {
    for (let j = 0; j < result.length; j++) {
      result[j] = gfMultiply(result[j] ?? 0, root);
      if (j + 1 < result.length) result[j] = (result[j] ?? 0) ^ (result[j + 1] ?? 0);
    }
    root = gfMultiply(root, 0x02);
  }
  return result;
}

function rsRemainder(data: readonly number[], divisor: readonly number[]): number[] {
  const result = new Array<number>(divisor.length).fill(0);
  for (const byte of data) {
    const factor = byte ^ (result.shift() ?? 0);
    result.push(0);
    divisor.forEach((coef, i) => {
      result[i] = (result[i] ?? 0) ^ gfMultiply(coef, factor);
    });
  }
  return result;
}

// ---------------------------------------------------------------- matrix

class Matrix {
  readonly size: number;
  readonly modules: boolean[][];
  readonly isFunction: boolean[][];

  constructor(readonly version: number) {
    this.size = version * 4 + 17;
    this.modules = Array.from({ length: this.size }, () =>
      new Array<boolean>(this.size).fill(false),
    );
    this.isFunction = Array.from({ length: this.size }, () =>
      new Array<boolean>(this.size).fill(false),
    );
  }

  set(x: number, y: number, dark: boolean): void {
    const row = this.modules[y];
    const fn = this.isFunction[y];
    if (row === undefined || fn === undefined) return;
    row[x] = dark;
    fn[x] = true;
  }

  get(x: number, y: number): boolean {
    return this.modules[y]?.[x] ?? false;
  }

  alignmentPositions(): number[] {
    if (this.version === 1) return [];
    const count = Math.floor(this.version / 7) + 2;
    const step = Math.ceil((this.version * 4 + 4) / (count * 2 - 2)) * 2;
    const result = [6];
    for (let pos = this.size - 7; result.length < count; pos -= step) result.splice(1, 0, pos);
    return result;
  }

  drawFunctionPatterns(): void {
    for (let i = 0; i < this.size; i++) {
      this.set(6, i, i % 2 === 0);
      this.set(i, 6, i % 2 === 0);
    }
    this.drawFinder(3, 3);
    this.drawFinder(this.size - 4, 3);
    this.drawFinder(3, this.size - 4);
    const align = this.alignmentPositions();
    const n = align.length;
    for (let i = 0; i < n; i++) {
      for (let j = 0; j < n; j++) {
        if ((i === 0 && j === 0) || (i === 0 && j === n - 1) || (i === n - 1 && j === 0)) continue;
        this.drawAlignment(align[i] ?? 0, align[j] ?? 0);
      }
    }
    this.drawFormatBits(0);
    this.drawVersion();
  }

  private drawFinder(x: number, y: number): void {
    for (let dy = -4; dy <= 4; dy++) {
      for (let dx = -4; dx <= 4; dx++) {
        const dist = Math.max(Math.abs(dx), Math.abs(dy));
        const xx = x + dx;
        const yy = y + dy;
        if (xx >= 0 && xx < this.size && yy >= 0 && yy < this.size) {
          this.set(xx, yy, dist !== 2 && dist !== 4);
        }
      }
    }
  }

  private drawAlignment(x: number, y: number): void {
    for (let dy = -2; dy <= 2; dy++) {
      for (let dx = -2; dx <= 2; dx++) {
        this.set(x + dx, y + dy, Math.max(Math.abs(dx), Math.abs(dy)) !== 1);
      }
    }
  }

  drawFormatBits(mask: number): void {
    const data = (ECL_M_BITS << 3) | mask;
    let rem = data;
    for (let i = 0; i < 10; i++) rem = (rem << 1) ^ ((rem >>> 9) * 0x537);
    const bits = ((data << 10) | rem) ^ 0x5412;
    const bit = (i: number) => ((bits >>> i) & 1) !== 0;
    for (let i = 0; i <= 5; i++) this.set(8, i, bit(i));
    this.set(8, 7, bit(6));
    this.set(8, 8, bit(7));
    this.set(7, 8, bit(8));
    for (let i = 9; i < 15; i++) this.set(14 - i, 8, bit(i));
    for (let i = 0; i < 8; i++) this.set(this.size - 1 - i, 8, bit(i));
    for (let i = 8; i < 15; i++) this.set(8, this.size - 15 + i, bit(i));
    this.set(8, this.size - 8, true);
  }

  private drawVersion(): void {
    if (this.version < 7) return;
    let rem = this.version;
    for (let i = 0; i < 12; i++) rem = (rem << 1) ^ ((rem >>> 11) * 0x1f25);
    const bits = (this.version << 12) | rem;
    for (let i = 0; i < 18; i++) {
      const dark = ((bits >>> i) & 1) !== 0;
      const a = this.size - 11 + (i % 3);
      const b = Math.floor(i / 3);
      this.set(a, b, dark);
      this.set(b, a, dark);
    }
  }

  drawCodewords(data: readonly number[]): void {
    let i = 0;
    for (let right = this.size - 1; right >= 1; right -= 2) {
      if (right === 6) right = 5;
      for (let vert = 0; vert < this.size; vert++) {
        for (let j = 0; j < 2; j++) {
          const x = right - j;
          const upward = ((right + 1) & 2) === 0;
          const y = upward ? this.size - 1 - vert : vert;
          if (!(this.isFunction[y]?.[x] ?? true) && i < data.length * 8) {
            const row = this.modules[y];
            if (row !== undefined) row[x] = (((data[i >>> 3] ?? 0) >>> (7 - (i & 7))) & 1) !== 0;
            i++;
          }
        }
      }
    }
  }

  applyMask(mask: number): void {
    for (let y = 0; y < this.size; y++) {
      for (let x = 0; x < this.size; x++) {
        let invert: boolean;
        switch (mask) {
          case 0:
            invert = (x + y) % 2 === 0;
            break;
          case 1:
            invert = y % 2 === 0;
            break;
          case 2:
            invert = x % 3 === 0;
            break;
          case 3:
            invert = (x + y) % 3 === 0;
            break;
          case 4:
            invert = (Math.floor(x / 3) + Math.floor(y / 2)) % 2 === 0;
            break;
          case 5:
            invert = ((x * y) % 2) + ((x * y) % 3) === 0;
            break;
          case 6:
            invert = (((x * y) % 2) + ((x * y) % 3)) % 2 === 0;
            break;
          default:
            invert = (((x + y) % 2) + ((x * y) % 3)) % 2 === 0;
        }
        const row = this.modules[y];
        if (row !== undefined && !(this.isFunction[y]?.[x] ?? true) && invert) row[x] = !row[x];
      }
    }
  }

  /** Penalty of the current symbol (rules N1 to N4), to choose the mask. */
  penalty(): number {
    let result = 0;
    const lines = (getter: (a: number, b: number) => boolean) => {
      for (let a = 0; a < this.size; a++) {
        let run = 1;
        for (let b = 1; b <= this.size; b++) {
          if (b < this.size && getter(a, b) === getter(a, b - 1)) {
            run++;
          } else {
            if (run >= 5) result += 3 + (run - 5);
            run = 1;
          }
        }
        // N3: finder-like pattern 1011101 with 4 light modules on one side.
        for (let b = 0; b + 10 < this.size; b++) {
          const p = [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0].map((v, k) => getter(a, b + k) === (v === 1));
          const q = [0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1].map((v, k) => getter(a, b + k) === (v === 1));
          if (p.every(Boolean) || q.every(Boolean)) result += 40;
        }
      }
    };
    lines((y, x) => this.get(x, y));
    lines((x, y) => this.get(x, y));
    for (let y = 0; y + 1 < this.size; y++) {
      for (let x = 0; x + 1 < this.size; x++) {
        const c = this.get(x, y);
        if (c === this.get(x + 1, y) && c === this.get(x, y + 1) && c === this.get(x + 1, y + 1)) {
          result += 3;
        }
      }
    }
    let dark = 0;
    for (const row of this.modules) for (const cell of row) if (cell) dark++;
    const total = this.size * this.size;
    result += Math.floor(Math.abs(dark * 20 - total * 10) / total) * 10;
    return result;
  }
}

function encodeData(bytes: Uint8Array, version: number): number[] {
  const capacityBits = dataCodewords(version) * 8;
  const bits: number[] = [];
  const push = (value: number, length: number) => {
    for (let i = length - 1; i >= 0; i--) bits.push((value >>> i) & 1);
  };
  push(0b0100, 4);
  push(bytes.length, version <= 9 ? 8 : 16);
  for (const byte of bytes) push(byte, 8);
  push(0, Math.min(4, capacityBits - bits.length));
  push(0, (8 - (bits.length % 8)) % 8);
  for (let pad = 0xec; bits.length < capacityBits; pad ^= 0xec ^ 0x11) push(pad, 8);
  const codewords: number[] = [];
  for (let i = 0; i < bits.length; i += 8) {
    codewords.push(bits.slice(i, i + 8).reduce((acc, bit) => (acc << 1) | bit, 0));
  }
  return codewords;
}

function addEccAndInterleave(data: readonly number[], version: number): number[] {
  const blocks = ERROR_BLOCKS_M[version] ?? 1;
  const ecc = ECC_CODEWORDS_PER_BLOCK_M[version] ?? 0;
  const raw = Math.floor(rawDataModules(version) / 8);
  const shortBlocks = blocks - (raw % blocks);
  const shortLength = Math.floor(raw / blocks);
  const divisor = rsDivisor(ecc);
  const all: number[][] = [];
  for (let i = 0, k = 0; i < blocks; i++) {
    const length = shortLength - ecc + (i < shortBlocks ? 0 : 1);
    const dat = data.slice(k, k + length);
    k += length;
    const block = [...dat];
    if (i < shortBlocks) block.push(0);
    all.push([...block, ...rsRemainder(dat, divisor)]);
  }
  const result: number[] = [];
  for (let i = 0; i < (all[0]?.length ?? 0); i++) {
    all.forEach((block, j) => {
      if (i !== shortLength - ecc || j >= shortBlocks) result.push(block[i] ?? 0);
    });
  }
  return result;
}

/**
 * QR matrix of `text` (UTF-8, byte mode, level M). Throws beyond version 10. `forcedMask` is for
 * the tests (comparison with a reference encoder); otherwise the mask of lowest penalty is used.
 */
export function qrMatrix(text: string, forcedMask?: number): boolean[][] {
  const bytes = new TextEncoder().encode(text);
  let version = 1;
  for (; version <= MAX_VERSION; version++) {
    const countBits = version <= 9 ? 8 : 16;
    if (4 + countBits + bytes.length * 8 <= dataCodewords(version) * 8) break;
  }
  if (version > MAX_VERSION) throw new Error('qr: text too long');
  const codewords = addEccAndInterleave(encodeData(bytes, version), version);
  let best: Matrix | undefined;
  let bestPenalty = Number.POSITIVE_INFINITY;
  const masks = forcedMask === undefined ? [0, 1, 2, 3, 4, 5, 6, 7] : [forcedMask];
  for (const mask of masks) {
    const m = new Matrix(version);
    m.drawFunctionPatterns();
    m.drawCodewords(codewords);
    m.applyMask(mask);
    m.drawFormatBits(mask);
    const penalty = m.penalty();
    if (penalty < bestPenalty) {
      best = m;
      bestPenalty = penalty;
    }
  }
  if (best === undefined) throw new Error('qr: no mask');
  return best.modules;
}
