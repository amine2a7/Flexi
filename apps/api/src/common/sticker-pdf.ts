import { pdfString } from './pdf.js';
import { qrMatrix } from './qr.js';

/** 8 × 8 cm in points (1 cm = 72 / 2.54 pt). */
const SIDE = Math.round((8 * 72 * 100) / 2.54) / 100;
/** Colours of the charter (navy #0B1D33, green #12D68A), as PDF RGB fractions. */
const NAVY = '0.043 0.114 0.200';
const GREEN = '0.071 0.839 0.541';
/** Approximate width of a Helvetica text (bold slightly wider), to centre it. */
const widthOf = (text: string, size: number, bold: boolean) =>
  text.length * size * (bold ? 0.56 : 0.5);

const fmt = (n: number) => (Math.round(n * 100) / 100).toString();

/**
 * Printable sticker of a till (M4), 8 × 8 cm, to stick on the NFC sticker: FlexiPay logo (text),
 * names of the shop and of the till, QR of the signed link, instruction. Vector QR (rectangles).
 */
export function stickerPdf(input: {
  merchantName: string;
  registerName: string;
  url: string;
  instruction: readonly string[];
}): Buffer {
  const ops: string[] = [];
  const centred = (text: string, size: number, y: number, bold: boolean, color = NAVY) => {
    const x = Math.max(6, (SIDE - widthOf(text, size, bold)) / 2);
    ops.push(
      `${color} rg BT ${bold ? '/F2' : '/F1'} ${fmt(size)} Tf ${fmt(x)} ${fmt(y)} Td ${pdfString(text)} Tj ET`,
    );
  };
  // Logo: « Flexi » navy, « Pay » green.
  const logoSize = 16;
  const logoWidth = widthOf('FlexiPay', logoSize, true);
  const logoX = (SIDE - logoWidth) / 2;
  const top = SIDE - 22;
  ops.push(
    `${NAVY} rg BT /F2 ${fmt(logoSize)} Tf ${fmt(logoX)} ${fmt(top)} Td ${pdfString('Flexi')} Tj ET`,
  );
  ops.push(
    `${GREEN} rg BT /F2 ${fmt(logoSize)} Tf ${fmt(logoX + widthOf('Flexi', logoSize, true))} ${fmt(top)} Td ${pdfString('Pay')} Tj ET`,
  );
  centred(input.merchantName.slice(0, 40), 9, top - 14, true);
  centred(input.registerName.slice(0, 40), 8, top - 25, false);

  // QR with its quiet zone (4 modules), navy on white.
  const matrix = qrMatrix(input.url);
  const modules = matrix.length;
  const qrSide = 118;
  const module = qrSide / (modules + 8);
  const qrX = (SIDE - qrSide) / 2;
  const qrY = 30;
  ops.push(`1 1 1 rg ${fmt(qrX)} ${fmt(qrY)} ${fmt(qrSide)} ${fmt(qrSide)} re f`);
  ops.push(`${NAVY} rg`);
  matrix.forEach((row, y) => {
    row.forEach((dark, x) => {
      if (!dark) return;
      const px = qrX + (x + 4) * module;
      const py = qrY + qrSide - (y + 5) * module;
      ops.push(`${fmt(px)} ${fmt(py)} ${fmt(module + 0.02)} ${fmt(module + 0.02)} re`);
    });
  });
  ops.push('f');

  input.instruction.forEach((line, index) => {
    centred(line, 7, 18 - index * 9, index === 0);
  });

  const content = Buffer.from(ops.join('\n'), 'latin1');
  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ${fmt(SIDE)} ${fmt(SIDE)}] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >>`,
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
    `<< /Length ${String(content.length)} >>\nstream\n${content.toString('latin1')}\nendstream`,
    `<< /Title ${pdfString(`FlexiPay - ${input.registerName}`)} /Producer (FlexiPay) >>`,
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
