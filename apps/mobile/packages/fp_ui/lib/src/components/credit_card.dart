import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';
import 'credit_style.dart';
import 'ticket_card.dart';

/// Pastille carrée arrondie avec icône ou initiales, sur la teinte du type.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.tint,
    required this.color,
    this.icon,
    this.text,
    this.size = FpSize.tile,
    this.round = false,
  });

  final Color tint;
  final Color color;
  final FpIcons? icon;
  final String? text;
  final double size;

  /// Avatar rond (initiale d'une personne).
  final bool round;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tint,
        shape: round ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: round ? null : BorderRadius.circular(FpRadius.field),
      ),
      child: icon != null
          ? FpIcon(icon!, size: 22, color: color)
          : ExcludeSemantics(
              child: Text(
                text ?? '',
                style: FpText.body(
                  size: round ? size * 0.4 : 16,
                  weight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
    );
  }
}

/// Carte « Mes crédits » : type, solde, progression et plafond reçu.
/// Sans crédit, la carte est pointillée et grisée.
class CreditCard extends StatelessWidget {
  const CreditCard({
    super.key,
    required this.type,
    required this.balance,
    required this.received,
    this.onTap,
  });

  final CreditType type;

  /// Millimes ; `null` si aucun crédit de ce type.
  final int? balance;
  final int? received;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final empty = balance == null || received == null || received == 0;
    final content = Padding(
      padding: const EdgeInsets.all(FpSpace.x16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            tint: type.tint,
            color: type.color,
            icon: type.icon,
            size: 40,
          ),
          const SizedBox(height: FpSpace.x10),
          Text(
            type.label(l10n),
            style: FpText.body(size: 13, color: FpColors.muted),
          ),
          const SizedBox(height: FpSpace.x10),
          if (empty)
            Text(
              l10n.noCreditYet,
              style: FpText.body(size: 13, color: FpColors.muted, height: 1.4),
            )
          else ...[
            AmountText(balance!, size: 30, showCurrency: false),
            const SizedBox(height: FpSpace.x10),
            FpProgressBar(value: balance! / received!, color: type.color),
            const SizedBox(height: FpSpace.x10),
            Text(
              l10n.outOf(
                Tnd.format(received!, currency: l10n.currency, compact: true),
              ),
              style: FpText.small,
            ),
          ],
        ],
      ),
    );
    final card = empty
        ? DashedBorderBox(fill: FpColors.ghostSurface, child: content)
        : Container(
            decoration: BoxDecoration(
              color: FpColors.surface,
              borderRadius: BorderRadius.circular(FpRadius.card),
              border: Border.all(color: FpColors.border),
            ),
            child: content,
          );
    return FpPressable(
      onTap: onTap,
      semanticLabel: empty
          ? '${type.label(l10n)}, ${l10n.noCreditYet}'
          : '${type.label(l10n)}, ${Tnd.format(balance!, currency: l10n.currency)}',
      child: card,
    );
  }
}
