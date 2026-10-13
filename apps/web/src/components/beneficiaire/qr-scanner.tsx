'use client';

import { Camera, CameraOff } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useRef, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/layout-blocks';

interface DetectedBarcode {
  readonly rawValue: string;
}
interface BarcodeDetectorLike {
  detect(source: HTMLVideoElement): Promise<DetectedBarcode[]>;
}
type BarcodeDetectorConstructor = new (options: { formats: string[] }) => BarcodeDetectorLike;

function detectorConstructor(): BarcodeDetectorConstructor | undefined {
  const candidate = (globalThis as { BarcodeDetector?: BarcodeDetectorConstructor })
    .BarcodeDetector;
  return typeof candidate === 'function' ? candidate : undefined;
}

/**
 * Scans a merchant QR with the camera (BarcodeDetector of the browser: Chrome and Edge on Android,
 * Safari 17+). Where it is not available, the manual code entry stays the way to pay.
 * The video stream is stopped as soon as a code is read or the scanner is closed.
 */
export function QrScanner({ onCode }: { onCode: (value: string) => void }) {
  const t = useTranslations('beneficiary.pay');
  const video = useRef<HTMLVideoElement>(null);
  const [active, setActive] = useState(false);
  const [error, setError] = useState<'unsupported' | 'denied' | undefined>(undefined);
  const supported = detectorConstructor() !== undefined;

  useEffect(() => {
    if (!active) return undefined;
    const Detector = detectorConstructor();
    if (Detector === undefined) return undefined;
    let stream: MediaStream | undefined;
    let timer: ReturnType<typeof setInterval> | undefined;
    let stopped = false;
    const detector = new Detector({ formats: ['qr_code'] });
    navigator.mediaDevices
      .getUserMedia({ video: { facingMode: 'environment' } })
      .then((media) => {
        if (stopped) {
          media.getTracks().forEach((track) => {
            track.stop();
          });
          return;
        }
        stream = media;
        const element = video.current;
        if (element === null) return;
        element.srcObject = media;
        void element.play();
        timer = setInterval(() => {
          void detector.detect(element).then((codes) => {
            const value = codes[0]?.rawValue;
            if (value !== undefined) {
              setActive(false);
              onCode(value);
            }
          });
        }, 400);
      })
      .catch(() => {
        setError('denied');
        setActive(false);
      });
    return () => {
      stopped = true;
      if (timer !== undefined) clearInterval(timer);
      stream?.getTracks().forEach((track) => {
        track.stop();
      });
    };
  }, [active, onCode]);

  if (!supported) {
    return <Alert tone="info">{t('scanUnsupported')}</Alert>;
  }
  return (
    <div className="flex flex-col gap-3">
      {error === 'denied' ? <Alert tone="warning">{t('scanDenied')}</Alert> : null}
      {active ? (
        <>
          <video
            ref={video}
            muted
            playsInline
            aria-label={t('scanVideo')}
            className="aspect-square w-full max-w-form-max-width rounded-card-mobile bg-navy object-cover"
          />
          <Button
            variant="secondary"
            icon={<CameraOff aria-hidden="true" className="size-icon-md" />}
            onClick={() => setActive(false)}
          >
            {t('scanStop')}
          </Button>
        </>
      ) : (
        <Button
          icon={<Camera aria-hidden="true" className="size-icon-md" />}
          onClick={() => {
            setError(undefined);
            setActive(true);
          }}
        >
          {t('scanStart')}
        </Button>
      )}
    </div>
  );
}
