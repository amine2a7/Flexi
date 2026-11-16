import 'package:flutter/widgets.dart';

import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';

/// Filtre en pastille (38 px). Sélectionné : fond marine, texte blanc.
class FpChip extends StatelessWidget {
  const FpChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.dot,
    this.height = 38,
    this.fontSize = 13,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Point de couleur avant le libellé (type de crédit).
  final Color? dot;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: FpPressable(
        onTap: onTap,
        semanticLabel: label,
        child: AnimatedContainer(
          duration: FpMotion.of(context, FpMotion.base),
          curve: FpMotion.curve,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: FpSpace.x14),
          decoration: BoxDecoration(
            color: selected ? FpColors.navy : FpColors.surface,
            borderRadius: BorderRadius.circular(FpRadius.pill),
            border: Border.all(
              color: selected ? FpColors.navy : FpColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dot != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected && dot == FpColors.navy
                        ? FpColors.surface
                        : dot,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: FpSpace.x6),
              ],
              Text(
                label,
                style: FpText.body(
                  size: fontSize,
                  weight: dot == null ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? FpColors.surface : FpColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Étiquette teintée non interactive (« Restauration », « En cours »).
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.tint,
    required this.color,
    this.height = 26,
    this.dot,
  });

  final String label;
  final Color tint;
  final Color color;
  final double height;
  final Color? dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.x10),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(FpRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot != null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: FpSpace.x6),
          ],
          Text(
            label,
            style: FpText.body(size: 12, weight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

/// Choix exclusif en grille (thème, langue) : sélection marine.
class SegmentedChoice extends StatelessWidget {
  const SegmentedChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.label,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      container: true,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: FpSpace.x8),
            Expanded(
              child: Semantics(
                inMutuallyExclusiveGroup: true,
                checked: i == selected,
                child: FpPressable(
                  onTap: () => onSelected(i),
                  semanticLabel: options[i],
                  child: AnimatedContainer(
                    duration: FpMotion.of(context, FpMotion.base),
                    height: FpSize.iconButton,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected
                          ? FpColors.navy
                          : FpColors.background,
                      borderRadius: BorderRadius.circular(FpRadius.md),
                    ),
                    child: Text(
                      options[i],
                      style: FpText.body(
                        size: 14,
                        weight: FontWeight.w600,
                        color: i == selected ? FpColors.surface : FpColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bascule à onglets sur fond gris (« Scanner le QR / Saisir le code »).
class ToggleTabs extends StatelessWidget {
  const ToggleTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FpSpace.x4),
      decoration: BoxDecoration(
        color: FpColors.track,
        borderRadius: BorderRadius.circular(FpRadius.field),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: FpSpace.x4),
            Expanded(
              child: Semantics(
                inMutuallyExclusiveGroup: true,
                checked: i == selected,
                child: FpPressable(
                  onTap: () => onSelected(i),
                  semanticLabel: options[i],
                  child: AnimatedContainer(
                    duration: FpMotion.of(context, FpMotion.base),
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? FpColors.surface : null,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: i == selected
                          ? const [
                              BoxShadow(
                                color: FpColors.shadow,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      options[i],
                      style: FpText.body(size: 14, weight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Carte de choix de type de crédit (bordure 2 px de la couleur du type si choisie).
class TypeOption extends StatelessWidget {
  const TypeOption({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.amount,
    this.height = 52,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  /// Solde affiché sous le libellé (écran Payer).
  final Widget? amount;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: FpPressable(
        onTap: onTap,
        semanticLabel: label,
        child: AnimatedContainer(
          duration: FpMotion.of(context, FpMotion.base),
          constraints: BoxConstraints(minHeight: height),
          padding: EdgeInsets.symmetric(
            horizontal: FpSpace.x14,
            vertical: amount == null ? 0 : FpSpace.x12,
          ),
          decoration: BoxDecoration(
            color: FpColors.surface,
            borderRadius: BorderRadius.circular(
              amount == null ? FpRadius.field : FpRadius.button,
            ),
            border: Border.all(
              color: selected ? color : FpColors.border,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: amount == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Container(
                width: amount == null ? 9 : 10,
                height: amount == null ? 9 : 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: amount == null ? FpSpace.x8 : FpSpace.x10),
              Flexible(
                child: amount == null
                    ? Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: FpText.body(size: 14, weight: FontWeight.w700),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: FpText.label),
                          const SizedBox(height: FpSpace.x2),
                          amount!,
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
