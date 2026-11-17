/**
 * Minimal PDF writer for the invoices (task 10): one A4 page of text lines in the standard
 * Helvetica font, WinAnsi encoding (French accents). No dependency (a library needs the approval
 * of Amine); enough for a detailed invoice. Arabic text is not supported by the standard fonts.
 */
export interface PdfLine {
  readonly text: string;
  /** Text at the right margin on the same line (amounts). */
  readonly right?: string;
  readonly bold?: boolean;
  readonly size?: number;
  /** Space before the line, in points. */
  readonly gap?: number;
}

const PAGE_WIDTH = 595;
const PAGE_HEIGHT = 842;
const MARGIN = 56;

/** WinAnsi bytes of a text, PDF string escapes included; characters outside it become « ? ». */
export function pdfString(text: string): string {
  let out = '';
  for (const char of text.normalize('NFC')) {
    const code = char.codePointAt(0) ?? 63;
    const byte =
      code === 0x20ac
        ? 0x80
        : code === 0x2019
          ? 0x92
          : code === 0x2013
            ? 0x96
            : code === 0xa0 || code === 0x202f
              ? 0x20
              : code;
    if (byte > 0xff) {
      out += '?';
      continue;
    }
    const c = String.fromCharCode(byte);
    out += c === '(' || c === ')' || c === '\\' ? `\\${c}` : c;
  }
  return `(${out})`;
}

/** Width of a text in Helvetica, close enough to align the amounts at the right margin. */
const widthOf = (text: string, size: number) => text.length * size * 0.5;

export function pdfDocument(title: string, lines: readonly PdfLine[]): Buffer {
  let y = PAGE_HEIGHT - MARGIN;
  const ops: string[] = [];
  for (const line of lines) {
    const size = line.size ?? 10;
    y -= (line.gap ?? 4) + size;
    const font = line.bold === true ? '/F2' : '/F1';
    ops.push(
      `BT ${font} ${String(size)} Tf ${String(MARGIN)} ${String(y)} Td ${pdfString(line.text)} Tj ET`,
    );
    if (line.right !== undefined) {
      const x = PAGE_WIDTH - MARGIN - widthOf(line.right, size);
      ops.push(
        `BT ${font} ${String(size)} Tf ${String(Math.round(x))} ${String(y)} Td ${pdfString(line.right)} Tj ET`,
      );
    }
  }
  const content = Buffer.from(ops.join('\n'), 'latin1');
  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ${String(PAGE_WIDTH)} ${String(PAGE_HEIGHT)}] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >>`,
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
    `<< /Length ${String(content.length)} >>\nstream\n${content.toString('latin1')}\nendstream`,
    `<< /Title ${pdfString(title)} /Producer (FlexiPay) >>`,
  ];
  let body = '%PDF-1.4\n%\xe2\xe3\xcf\xd3\n';
  const offsets: number[] = [];
  objects.forEach((object, index) => {
    offsets.push(Buffer.byteLength(body, 'latin1'));
    body += `${String(index + 1)} 0 obj\n${object}\nendobj\n`;
  });
  const xref = Buffer.byteLength(body, 'latin1');
  body += `xref\n0 ${String(objects.length + 1)}\n0000000000 65535 f \n`;
  for (const offset of offsets) body += `${String(offset).padStart(10, '0')} 00000 n \n`;
  body += `trailer\n<< /Size ${String(objects.length + 1)} /Root 1 0 R /Info ${String(objects.length)} 0 R >>\nstartxref\n${String(xref)}\n%%EOF\n`;
  return Buffer.from(body, 'latin1');
}

/** Amount in TND, French style (1 234,567 TND), for the invoices. */
export function tnd(millimes: bigint): string {
  const negative = millimes < 0n;
  const value = negative ? -millimes : millimes;
  const units = (value / 1000n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
  const fraction = (value % 1000n).toString().padStart(3, '0');
  return `${negative ? '-' : ''}${units},${fraction} TND`;
}

/** Rate in basis points, French style (19 %, 2,5 %). */
export function percent(bps: number): string {
  const units = Math.trunc(bps / 100);
  const fraction = String(bps % 100).padStart(2, '0').replace(/0+$/, '');
  return fraction === '' ? `${String(units)} %` : `${String(units)},${fraction} %`;
}
