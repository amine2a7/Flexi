import { HttpResponse } from 'msw';

/** Demo scanned document (title + lines) drawn in the browser; tiny PDF where no canvas exists. */
export async function renderDemoDocument(title: string, lines: readonly string[]): Promise<Blob> {
  if (typeof OffscreenCanvas === 'undefined') {
    return new Blob(['%PDF-1.4\n%demo\n'], { type: 'application/pdf' });
  }
  const canvas = new OffscreenCanvas(900, 600);
  const context = canvas.getContext('2d');
  if (context === null) return new Blob([], { type: 'image/png' });
  context.fillStyle = 'white';
  context.fillRect(0, 0, 900, 600);
  context.strokeStyle = 'silver';
  context.strokeRect(20, 20, 860, 560);
  context.fillStyle = 'black';
  context.font = 'bold 30px sans-serif';
  context.fillText(title, 50, 80);
  context.font = '22px sans-serif';
  lines.forEach((line, index) => {
    context.fillText(line, 50, 150 + index * 48);
  });
  context.font = 'italic 18px sans-serif';
  context.fillText('Document de démonstration — FlexiPay', 50, 550);
  return canvas.convertToBlob({ type: 'image/png' });
}

/** Binary response of a stored file: download only, never sniffed, never cached. */
export function fileResponse(blob: Blob, fileName: string): Response {
  return new HttpResponse(blob, {
    headers: {
      'Content-Type': blob.type || 'application/octet-stream',
      'Content-Disposition': `attachment; filename="${fileName.replace(/[^\w.-]/g, '_')}"`,
      'X-Content-Type-Options': 'nosniff',
      'Cache-Control': 'no-store',
    },
  });
}
