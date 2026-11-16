import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../tokens/fp_tokens.dart';

/// QR de paiement : modules marine sur blanc, cadre arrondi 16 px du prototype.
class PaymentQr extends StatelessWidget {
  const PaymentQr({
    super.key,
    required this.data,
    required this.semanticLabel,
    this.size = 231,
  });

  final String data;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Container(
        padding: const EdgeInsets.all(FpSpace.x10),
        decoration: BoxDecoration(
          color: FpColors.surface,
          borderRadius: BorderRadius.circular(FpRadius.button),
          border: Border.all(color: FpColors.border, width: 2),
        ),
        child: ExcludeSemantics(
          child: QrImageView(
            data: data,
            size: size,
            padding: EdgeInsets.zero,
            backgroundColor: FpColors.surface,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: FpColors.navy,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: FpColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
