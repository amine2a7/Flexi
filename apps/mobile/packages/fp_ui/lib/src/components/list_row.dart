import 'package:flutter/widgets.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';

/// Ligne de liste : pastille, titre, sous-titre et montant ou chevron.
class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.chevron = false,
    this.titleColor,
  });

  final Widget leading;
  final String title;
  final String? subtitle;

  /// Montant (voir [ListRow.amount]) ou autre widget.
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Ajoute un chevron (lien vers un détail).
  final bool chevron;
  final Color? titleColor;

  /// Montant signé aligné à droite (« −57,500 », « +300,000 »).
  static Widget amount(String text, {Color color = FpColors.ink}) =>
      Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          text,
          style: FpText.display(
            size: 20,
            weight: FontWeight.w700,
            color: color,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.x16,
        vertical: FpSpace.x14,
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: FpSpace.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: FpText.rowTitle.copyWith(color: titleColor)),
                if (subtitle != null) ...[
                  const SizedBox(height: FpSpace.x2),
                  Text(subtitle!, style: FpText.rowSubtitle),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: FpSpace.x8),
            trailing!,
          ],
          if (chevron)
            Transform.flip(
              flipX: rtl,
              child: const FpIcon(
                FpIcons.chevronRight,
                size: 18,
                color: FpColors.muted,
              ),
            ),
        ],
      ),
    );
    if (onTap == null) return MergeSemantics(child: row);
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: row,
        ),
      ),
    );
  }
}

/// Groupe de lignes dans une carte blanche, séparées par un filet.
class ListGroup extends StatelessWidget {
  const ListGroup({
    super.key,
    required this.children,
    this.insetDividers = true,
  });

  final List<Widget> children;
  final bool insetDividers;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FpColors.surface,
        borderRadius: BorderRadius.circular(FpRadius.card),
        border: Border.all(color: FpColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(
                  horizontal: insetDividers ? FpSpace.x16 : 0,
                ),
                color: FpColors.divider,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Titre de section avec action à droite (« Activité · Tout voir »).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: FpText.title),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Intitulé de groupe de dates (« AUJOURD'HUI »).
class DayHeader extends StatelessWidget {
  const DayHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: FpSpace.x8),
    child: Semantics(
      header: true,
      child: Text(
        text.toUpperCase(),
        style: FpText.body(
          size: 13,
          weight: FontWeight.w700,
          color: FpColors.muted,
        ).copyWith(letterSpacing: 0.06 * 13),
      ),
    ),
  );
}

/// Trois statistiques séparées par des filets verticaux.
class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.stats, this.topDivider = true});

  /// (valeur, libellé)
  final List<(String, String)> stats;
  final bool topDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topDivider ? FpSpace.x14 : 0),
      decoration: topDivider
          ? const BoxDecoration(
              border: Border(top: BorderSide(color: FpColors.divider)),
            )
          : null,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++)
              Expanded(
                child: Container(
                  padding: EdgeInsetsDirectional.only(
                    start: i == 0 ? 0 : FpSpace.x14,
                  ),
                  decoration: i == 0
                      ? null
                      : const BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(color: FpColors.divider),
                          ),
                        ),
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stats[i].$1, style: FpText.display(size: 28)),
                        Text(stats[i].$2, style: FpText.small),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Avatar rond avec initiale.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initial,
    required this.color,
    this.size = FpSize.tile,
  });

  final String initial;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: ExcludeSemantics(
        child: Text(
          initial,
          style: FpText.body(
            size: size * 0.4,
            weight: FontWeight.w800,
            color: FpColors.surface,
          ),
        ),
      ),
    );
  }
}

/// Ligne de détail « libellé … valeur ».
class DetailLine extends StatelessWidget {
  const DetailLine({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: FpText.body(size: 14, color: FpColors.muted),
            ),
          ),
          const SizedBox(width: FpSpace.x12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: FpText.body(
                size: 14,
                weight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton-pastille d'action dans une ligne (lien « Tout voir »).
class TextAction extends StatelessWidget {
  const TextAction({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FpPressable(
      onTap: onTap,
      semanticLabel: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FpSpace.x8),
        child: Text(
          label,
          style: FpText.body(
            size: 13,
            weight: FontWeight.w700,
            color: FpColors.greenDark,
          ),
        ),
      ),
    );
  }
}
