import 'package:flutter/widgets.dart';

import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';
import 'ticket_card.dart';

/// Ticket marine du solde : libellé, pastille, grand montant, puis contenu sous la perforation.
class BalanceHero extends StatelessWidget {
  const BalanceHero({
    super.key,
    required this.label,
    required this.amount,
    this.badge,
    this.amountSize = 64,
    this.suffix,
    this.bottom,
  });

  final String label;

  /// Millimes.
  final int amount;

  /// Pastille à droite du libellé (« Offert par BIAT »).
  final String? badge;
  final double amountSize;

  /// Remplace « TND » (ex. « / 50 TND »).
  final String? suffix;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return TicketCard(
      dark: true,
      padding: FpSpace.x22,
      top: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: CapsLabel(label, color: FpColors.onNavyMuted)),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FpSpace.x10,
                    vertical: FpSpace.x4,
                  ),
                  decoration: BoxDecoration(
                    color: FpColors.onNavyFill,
                    borderRadius: BorderRadius.circular(FpRadius.pill),
                  ),
                  child: Text(
                    badge!,
                    style: FpText.body(
                      size: 12,
                      weight: FontWeight.w700,
                      color: FpColors.surface,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FpSpace.x16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: AmountText(
                  amount,
                  size: amountSize,
                  color: FpColors.surface,
                  showCurrency: suffix == null,
                  currencySize: amountSize * 0.375,
                  currencyColor: FpColors.green,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: FpSpace.x8),
                Text(
                  suffix!,
                  style: FpText.display(
                    size: amountSize * 0.39,
                    color: FpColors.green,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      bottom: bottom,
    );
  }
}
