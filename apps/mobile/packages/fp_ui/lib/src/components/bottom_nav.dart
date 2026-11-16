import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';

/// Onglet de la barre du bas.
class FpNavItem {
  const FpNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final FpIcons icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
}

/// Barre du bas à 5 colonnes avec le bouton central surélevé (Payer ou Encaisser).
/// Une colonne vide est laissée si un rôle a moins d'onglets (caissier).
class FpBottomNav extends StatelessWidget {
  const FpBottomNav({
    super.key,
    required this.leading,
    required this.trailing,
    required this.centerIcon,
    required this.centerLabel,
    required this.onCenter,
  });

  /// Deux onglets au plus à gauche, deux à droite.
  final List<FpNavItem> leading;
  final List<FpNavItem> trailing;
  final FpIcons centerIcon;
  final String centerLabel;
  final VoidCallback onCenter;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    Widget slot(List<FpNavItem> items, int i) => Expanded(
      child: i < items.length ? _Tab(item: items[i]) : const SizedBox(),
    );
    // Le bouton central dépasse de 12 px au-dessus de la barre (marge −40 du prototype).
    const overhang = 12.0;
    return Semantics(
      container: true,
      label: FpL10n.of(context).mainNavigation,
      child: SizedBox(
        height: overhang + FpSize.navHeight + bottomInset,
        child: Stack(
          children: [
            Positioned.fill(
              top: overhang,
              child: Container(
                padding: EdgeInsets.only(
                  top: FpSpace.x6,
                  bottom: FpSpace.x14 + bottomInset,
                ),
                decoration: const BoxDecoration(
                  color: FpColors.surface,
                  border: Border(top: BorderSide(color: FpColors.border)),
                ),
                child: Row(
                  children: [
                    slot(leading, 0),
                    slot(leading, 1),
                    const Spacer(),
                    slot(trailing, 0),
                    slot(trailing, 1),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _CenterButton(
                icon: centerIcon,
                label: centerLabel,
                onTap: onCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item});

  final FpNavItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.selected ? FpColors.navy : FpColors.muted;
    return Semantics(
      selected: item.selected,
      button: true,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FpIcon(item.icon, size: 24, color: color),
            const SizedBox(height: FpSpace.x4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FpText.body(
                size: 11,
                weight: item.selected ? FontWeight.w700 : FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: FpSpace.x4),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.selected ? FpColors.green : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FpIcons icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FpPressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        width: FpSize.payButton,
        height: FpSize.payButton,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: FpColors.green,
          shape: BoxShape.circle,
          border: Border.all(color: FpColors.background, width: 6),
          boxShadow: const [
            BoxShadow(
              color: FpColors.payGlow,
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FpIcon(icon, size: 28, color: FpColors.navy, strokeWidth: 2.2),
      ),
    );
  }
}
