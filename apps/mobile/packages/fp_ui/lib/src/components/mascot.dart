import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tokens/fp_tokens.dart';

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Mascotte FlexiPay (assiette souriante, fourchette et couteau), qui flotte doucement.
class Mascot extends StatefulWidget {
  const Mascot({super.key, this.size = 104, this.animate = true});

  final double size;
  final bool animate;

  static final String svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96">'
      '<circle cx="48" cy="52" r="34" fill="${_hex(FpColors.surface)}" stroke="${_hex(FpColors.border)}" stroke-width="2"/>'
      '<circle cx="48" cy="52" r="25" fill="none" stroke="${_hex(FpColors.greenTint)}" stroke-width="4"/>'
      '<circle cx="39" cy="49" r="4.5" fill="${_hex(FpColors.navy)}"/>'
      '<circle cx="57" cy="49" r="4.5" fill="${_hex(FpColors.navy)}"/>'
      '<circle cx="40.5" cy="47.5" r="1.5" fill="${_hex(FpColors.surface)}"/>'
      '<circle cx="58.5" cy="47.5" r="1.5" fill="${_hex(FpColors.surface)}"/>'
      '<path d="M40 59c4 4 12 4 16 0" fill="none" stroke="${_hex(FpColors.navy)}" stroke-width="3" stroke-linecap="round"/>'
      '<circle cx="33" cy="58" r="3.5" fill="${_hex(FpColors.green)}" opacity="0.5"/>'
      '<circle cx="63" cy="58" r="3.5" fill="${_hex(FpColors.green)}" opacity="0.5"/>'
      '<path d="M8 22v14a4 4 0 0 0 4 4v18M5 22v8M11 22v8" fill="none" stroke="${_hex(FpColors.navy)}" stroke-width="3" stroke-linecap="round"/>'
      '<path d="M88 58V22c-5 3-6 10-6 16h6" fill="none" stroke="${_hex(FpColors.navy)}" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>'
      '</svg>';

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.animate || FpMotion.reduced(context)) {
      _c.stop();
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final picture = SvgPicture.string(
      Mascot.svg,
      width: widget.size,
      height: widget.size,
    );
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => Transform.translate(
          // Montée de 5 px puis retour, en douceur.
          offset: Offset(
            0,
            -5 * (0.5 - 0.5 * math.cos(2 * math.pi * _c.value)),
          ),
          child: child,
        ),
        child: picture,
      ),
    );
  }
}
