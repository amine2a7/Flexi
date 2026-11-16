import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';

/// Les 4 points du PIN saisi.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.length = 4});

  final int filled;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: FpL10n.of(context).pinEntered,
      value: '$filled / $length',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < length; i++) ...[
            if (i > 0) const SizedBox(width: FpSpace.x18),
            AnimatedContainer(
              duration: FpMotion.of(context, FpMotion.fast),
              width: FpSize.pinDot,
              height: FpSize.pinDot,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled ? FpColors.navy : null,
                border: Border.all(color: FpColors.navy, width: 2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Clavier PIN 3 × 4 : chiffres, empreinte (facultative) et effacement.
///
/// Le PIN reste dans l'état de l'écran le temps de la saisie, puis part au serveur ;
/// il n'est jamais écrit sur le téléphone.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  /// `null` : la touche empreinte est masquée.
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    Widget key(String k) {
      if (k == 'bio') {
        if (onBiometric == null) return const SizedBox(height: FpSize.pinKey);
        return _Key(
          label: l10n.pinKeyBiometric,
          onTap: onBiometric!,
          child: const FpIcon(
            FpIcons.fingerprint,
            size: 28,
            color: FpColors.greenDark,
          ),
        );
      }
      if (k == 'del') {
        return _Key(
          label: l10n.pinKeyDelete,
          onTap: onDelete,
          child: const FpIcon(FpIcons.backspace, size: 26, color: FpColors.ink),
        );
      }
      return _Key(
        label: k,
        onTap: () => onDigit(k),
        filled: true,
        child: Text(
          k,
          style: FpText.display(size: 30, weight: FontWeight.w700),
        ),
      );
    }

    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['bio', '0', 'del'],
    ];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: FpSpace.x10),
            Row(
              children: [
                for (var c = 0; c < 3; c++) ...[
                  if (c > 0) const SizedBox(width: FpSpace.x10),
                  Expanded(child: key(rows[r][c])),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.label,
    required this.onTap,
    required this.child,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return FpPressable(
      semanticLabel: label,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        height: FpSize.pinKey,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? FpColors.surface : null,
          borderRadius: BorderRadius.circular(FpRadius.key),
          border: filled ? Border.all(color: FpColors.border) : null,
        ),
        child: ExcludeSemantics(child: child),
      ),
    );
  }
}
