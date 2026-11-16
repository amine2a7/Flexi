import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';

import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

enum StampKind { approved, refused }

/// Tampon APPROUVÉ (rebond 600 ms) ou REFUSÉ (secousse 420 ms).
/// Sans animation si le système demande de réduire les animations.
class Stamp extends StatefulWidget {
  const Stamp({
    super.key,
    required this.kind,
    this.size = 36,
    this.animate = true,
    this.background,
  });

  final StampKind kind;

  /// Taille du texte (36 écran de résultat, 24 reçu).
  final double size;
  final bool animate;

  /// Fond derrière le texte (le tampon chevauche le ticket).
  final Color? background;

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  bool get _approved => widget.kind == StampKind.approved;
  Duration get _delay => Duration(milliseconds: _approved ? 250 : 150);
  Duration get _length =>
      _approved ? FpMotion.emphasis : const Duration(milliseconds: 420);

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: _delay + _length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.animate || FpMotion.reduced(context)) {
      _c.value = 1;
    } else if (_c.value == 0 && !_c.isAnimating) {
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
    final l10n = FpL10n.of(context);
    final color = _approved ? FpColors.greenDark : FpColors.danger;
    final small = widget.size < 30;
    final angle = (small ? -6 : (_approved ? -10 : -8)) * math.pi / 180;
    final label = Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 14 : (_approved ? 18 : 16),
        vertical: small ? 4 : (_approved ? 8 : 6),
      ),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: BorderRadius.circular(small ? FpRadius.sm : FpRadius.md),
        border: Border.all(color: color, width: small ? 3 : 4),
      ),
      child: Text(
        _approved ? l10n.stampApproved : l10n.stampRefused,
        style: FpText.display(
          size: widget.size,
          color: color,
          letterSpacing: 0.1,
        ),
      ),
    );
    return Semantics(
      label: _approved ? l10n.stampApproved : l10n.stampRefused,
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final start =
              _delay.inMilliseconds / (_delay + _length).inMilliseconds;
          final t = ((_c.value - start) / (1 - start)).clamp(0.0, 1.0);
          if (_approved) {
            // 0 → 60 % : 1,8 → 0,94 ; 60 → 100 % : 0,94 → 1.
            final scale = t < 0.6
                ? 1.8 - (1.8 - 0.94) * FpMotion.stampCurve.transform(t / 0.6)
                : 0.94 + 0.06 * ((t - 0.6) / 0.4);
            final opacity = (t / 0.6).clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: angle,
                child: Transform.scale(scale: scale, child: child),
              ),
            );
          }
          // Secousse : 0, −8, 8, −4, 0 px.
          const keys = [0.0, -8.0, 8.0, -4.0, 0.0];
          final pos = t * 4;
          final i = pos.floor().clamp(0, 3);
          final dx = keys[i] + (keys[i + 1] - keys[i]) * (pos - i);
          return Transform.rotate(
            angle: angle,
            child: Transform.translate(offset: Offset(dx, 0), child: child),
          );
        },
        child: label,
      ),
    );
  }
}
