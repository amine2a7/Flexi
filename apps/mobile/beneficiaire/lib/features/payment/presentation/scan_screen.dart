import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/routes.dart';
import '../data/nfc_reader.dart';
import '../domain/payment.dart';
import 'checkout_opener.dart';

/// Scanner le QR imprimé sur l'autocollant de la caisse (même lien que la puce NFC).
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _handled = false;

  Future<void> _detected(BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes.map((b) => b.rawValue).nonNulls.firstOrNull;
    if (raw == null) return;
    _handled = true;
    final link = StickerLink.parse(raw);
    if (link == null) {
      context.pushReplacement(
        Routes.payRefused,
        extra: const PaymentRefusal(reason: RefusalReason.stickerInvalid),
      );
      return;
    }
    await openCheckout(
      context,
      ref,
      (repo) => repo.bySticker(link),
      replace: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final camera = ref.watch(qrCameraEnabledProvider);
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.payScanTitle, onBack: () => context.pop()),
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(FpRadius.card),
            child: ColoredBox(
              color: FpColors.navy,
              child: camera
                  ? MobileScanner(
                      controller: MobileScannerController(
                        formats: const [BarcodeFormat.qrCode],
                      ),
                      onDetect: _detected,
                    )
                  : const Center(
                      child: FpIcon(
                        FpIcons.qr,
                        size: 64,
                        color: FpColors.onNavyMuted,
                      ),
                    ),
            ),
          ),
        ),
        Text(
          l10n.payNfcHint,
          textAlign: TextAlign.center,
          style: FpText.body(size: 14, color: FpColors.muted, height: 1.5),
        ),
      ],
    );
  }
}
