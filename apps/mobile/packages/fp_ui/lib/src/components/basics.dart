import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Zone tactile avec l'effet « fp-press » (échelle 0,96 en 120 ms).
class FpPressable extends StatefulWidget {
  const FpPressable({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.button = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool button;

  @override
  State<FpPressable> createState() => _FpPressableState();
}

class _FpPressableState extends State<FpPressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap != null && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: widget.button,
      enabled: widget.onTap != null,
      label: widget.semanticLabel,
      // Un libellé explicite remplace celui des enfants (sinon « Augmenter » et « + » fusionnent).
      excludeSemantics: widget.semanticLabel != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        child: AnimatedScale(
          scale: _down ? 0.96 : 1,
          duration: FpMotion.of(context, FpMotion.fast),
          curve: FpMotion.curve,
          child: widget.child,
        ),
      ),
    );
  }
}

enum FpButtonVariant { primary, secondary, navy, danger }

/// Bouton principal (54 px) ou compact (48 px). Grisé si [onPressed] est nul.
class FpButton extends StatelessWidget {
  const FpButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = FpButtonVariant.primary,
    this.compact = false,
    this.onNavy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final FpIcons? icon;
  final FpButtonVariant variant;
  final bool compact;

  /// Bouton secondaire posé sur un fond marine (contour blanc translucide).
  final bool onNavy;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final (bg, fg, border) = disabled
        ? (FpColors.track, FpColors.muted, null)
        : switch (variant) {
            FpButtonVariant.primary => (FpColors.green, FpColors.navy, null),
            FpButtonVariant.secondary =>
              onNavy
                  ? (
                      Colors.transparent,
                      FpColors.surface,
                      FpColors.onNavyOutline,
                    )
                  : (FpColors.surface, FpColors.ink, FpColors.border),
            FpButtonVariant.navy => (FpColors.navy, FpColors.surface, null),
            FpButtonVariant.danger => (
              FpColors.dangerTint,
              FpColors.danger,
              FpColors.dangerBorder,
            ),
          };
    final height = compact ? FpSize.buttonCompact : FpSize.button;
    return FpPressable(
      onTap: onPressed,
      semanticLabel: label,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(
            compact ? FpRadius.field : FpRadius.button,
          ),
          border: border == null ? null : Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: FpSpace.x16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              FpIcon(
                icon!,
                size: compact ? 18 : 20,
                color: fg,
                strokeWidth: icon == FpIcons.qr ? 2.2 : 2,
              ),
              const SizedBox(width: FpSpace.x8),
            ],
            Flexible(
              child: ExcludeSemantics(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FpText.body(
                    size: compact ? 15 : 16,
                    weight: FontWeight.w700,
                    color: fg,
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

/// Lien texte vert foncé (« Mot de passe oublié ? »).
class FpLink extends StatelessWidget {
  const FpLink({
    super.key,
    required this.label,
    required this.onTap,
    this.size = 14,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final double size;
  final FpIcons? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: FpSize.iconButton),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                FpIcon(icon!, size: 20, color: FpColors.greenDark),
                const SizedBox(width: FpSpace.x8),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: FpText.body(
                    size: size,
                    weight: FontWeight.w600,
                    color: FpColors.greenDark,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bouton carré 44 px (retour, partager, notifications).
class FpSquareButton extends StatelessWidget {
  const FpSquareButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = false,
  });

  final FpIcons icon;
  final String label;
  final VoidCallback onTap;

  /// Pastille rouge (notifications non lues).
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final rtlFlip =
        icon == FpIcons.chevronLeft &&
        Directionality.of(context) == TextDirection.rtl;
    return FpPressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        width: FpSize.iconButton,
        height: FpSize.iconButton,
        decoration: BoxDecoration(
          color: FpColors.surface,
          borderRadius: BorderRadius.circular(FpRadius.field),
          border: Border.all(color: FpColors.border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.flip(
              flipX: rtlFlip,
              child: FpIcon(icon, size: 22, color: FpColors.ink),
            ),
            if (badge)
              PositionedDirectional(
                top: 8,
                end: 9,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: FpColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: FpColors.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// En-tête d'écran : retour, titre centré, action facultative.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    this.sideWidth = FpSize.iconButton,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// Largeur des deux côtés (plus large pour un lien texte comme « Tout lire »).
  final double sideWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return Row(
      children: [
        SizedBox(
          width: sideWidth,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: onBack == null
                ? null
                : FpSquareButton(
                    icon: FpIcons.chevronLeft,
                    label: l10n.back,
                    onTap: onBack!,
                  ),
          ),
        ),
        const SizedBox(width: FpSpace.x12),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: FpText.title,
            ),
          ),
        ),
        const SizedBox(width: FpSpace.x12),
        SizedBox(
          width: sideWidth,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: trailing,
          ),
        ),
      ],
    );
  }
}

/// Carte blanche arrondie 20 px.
class FpCard extends StatelessWidget {
  const FpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(FpSpace.x18),
    this.color = FpColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(FpRadius.card),
        border: Border.all(color: FpColors.border),
      ),
      child: child,
    );
  }
}

/// Libellé en capitales espacées.
class CapsLabel extends StatelessWidget {
  const CapsLabel(this.text, {super.key, this.color = FpColors.muted});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: FpText.caps(color: color));
}

/// Barre de progression arrondie.
class FpProgressBar extends StatelessWidget {
  const FpProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 6,
    this.track = FpColors.track,
    this.animate = false,
  });

  /// Entre 0 et 1.
  final double value;
  final Color color;
  final double height;
  final Color track;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(FpRadius.pill),
      child: Container(
        height: height,
        color: track,
        alignment: AlignmentDirectional.centerStart,
        child: animate
            ? AnimatedFractionallySizedBox(
                widthFactor: v,
                heightFactor: 1,
                duration: FpMotion.of(context, const Duration(seconds: 1)),
                child: ColoredBox(color: color),
              )
            : FractionallySizedBox(
                widthFactor: v,
                heightFactor: 1,
                child: ColoredBox(color: color),
              ),
      ),
    );
  }
}

/// Barre segmentée (répartition par type).
class SegmentBar extends StatelessWidget {
  const SegmentBar({
    super.key,
    required this.segments,
    this.height = 8,
    this.track = FpColors.track,
  });

  final List<(int, Color)> segments;
  final double height;
  final Color track;

  @override
  Widget build(BuildContext context) {
    final parts = segments.where((s) => s.$1 > 0).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(FpRadius.pill),
      child: Container(
        height: height,
        color: track,
        child: Row(
          children: [
            for (final s in parts)
              Expanded(
                flex: s.$1,
                child: ColoredBox(color: s.$2),
              ),
          ],
        ),
      ),
    );
  }
}

/// Texte avec passages en gras marqués `**ainsi**` dans les traductions.
class MarkupText extends StatelessWidget {
  const MarkupText(
    this.text, {
    super.key,
    required this.style,
    this.boldColor,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Color? boldColor;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd
                  ? TextStyle(fontWeight: FontWeight.w700, color: boldColor)
                  : null,
            ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

/// Montant en Barlow Condensed suivi de la devise plus petite (« 142,500 TND »).
class AmountText extends StatelessWidget {
  const AmountText(
    this.millimes, {
    super.key,
    this.size = 48,
    this.currencySize,
    this.color = FpColors.ink,
    this.currencyColor,
    this.signed = false,
    this.showCurrency = true,
  });

  final int millimes;
  final double size;
  final double? currencySize;
  final Color color;
  final Color? currencyColor;
  final bool signed;
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final number = Tnd.format(millimes, currency: null, signed: signed);
    final full = Tnd.format(millimes, currency: l10n.currency, signed: signed);
    return Semantics(
      container: true,
      label: full,
      excludeSemantics: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: number),
              if (showCurrency) ...[
                const TextSpan(text: ' '),
                TextSpan(
                  text: l10n.currency,
                  style: FpText.display(
                    size: currencySize ?? (size * 0.375).roundToDouble(),
                    color: currencyColor ?? color,
                  ),
                ),
              ],
            ],
          ),
          style: FpText.display(size: size, color: color),
        ),
      ),
    );
  }
}

/// Champ de saisie du prototype (52 px, icône à gauche).
class FpTextField extends StatelessWidget {
  const FpTextField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.trailing,
    this.onChanged,
    this.autofillHints,
    this.fieldKey,
  });

  final String label;
  final TextEditingController controller;
  final FpIcons? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: FpText.label),
        const SizedBox(height: FpSpace.x6),
        Container(
          height: FpSize.field,
          padding: const EdgeInsets.symmetric(horizontal: FpSpace.x14),
          decoration: BoxDecoration(
            color: FpColors.surface,
            borderRadius: BorderRadius.circular(FpRadius.field),
            border: Border.all(color: FpColors.border),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                FpIcon(icon!, size: 20, color: FpColors.muted),
                const SizedBox(width: FpSpace.x10),
              ],
              Expanded(
                child: Semantics(
                  label: label,
                  child: TextField(
                    key: fieldKey,
                    controller: controller,
                    obscureText: obscure,
                    keyboardType: keyboardType,
                    onChanged: onChanged,
                    autofillHints: autofillHints,
                    enableSuggestions: !obscure,
                    autocorrect: false,
                    style: FpText.body(size: 15),
                    cursorColor: FpColors.navy,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ],
    );
  }
}

/// Interrupteur 52 × 32 du prototype.
class FpSwitch extends StatelessWidget {
  const FpSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: FpMotion.of(context, FpMotion.base),
          curve: FpMotion.curve,
          width: 52,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? FpColors.green : FpColors.dashStrong,
            borderRadius: BorderRadius.circular(FpRadius.pill),
          ),
          child: AnimatedAlign(
            duration: FpMotion.of(context, FpMotion.base),
            curve: FpMotion.curve,
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: FpColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: FpColors.shadow,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Encadré d'information teinté (icône + texte).
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.text,
    required this.icon,
    required this.tint,
    required this.iconColor,
    this.textSize = 13,
  });

  final String text;
  final FpIcons icon;
  final Color tint;
  final Color iconColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.x16,
        vertical: FpSpace.x14,
      ),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(FpRadius.button),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FpIcon(icon, size: 20, color: iconColor),
          const SizedBox(width: FpSpace.x12),
          Expanded(
            child: MarkupText(
              text,
              style: FpText.body(
                size: textSize,
                color: FpColors.navy,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Apparition « fp-rise » : fondu + montée de 12 px en 320 ms, avec délai.
class FpRise extends StatefulWidget {
  const FpRise({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<FpRise> createState() => _FpRiseState();
}

class _FpRiseState extends State<FpRise> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: FpMotion.slow + widget.delay,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (FpMotion.reduced(context)) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start =
        widget.delay.inMilliseconds /
        (FpMotion.slow + widget.delay).inMilliseconds;
    final a = CurvedAnimation(
      parent: _c,
      curve: Interval(start, 1, curve: FpMotion.curve),
    );
    return AnimatedBuilder(
      animation: a,
      builder: (context, child) => Opacity(
        opacity: a.value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - a.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
