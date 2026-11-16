import 'package:flutter/widgets.dart';

import '../tokens/fp_tokens.dart';

/// Ligne pointillée (perforation du ticket).
class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.color = FpColors.dash,
    this.thickness = 2,
    this.dash = 6,
    this.gap = 4,
  });

  final Color color;
  final double thickness;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      width: double.infinity,
      child: CustomPaint(painter: _DashPainter(color, thickness, dash, gap)),
    );
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color, this.thickness, this.dash, this.gap);

  final Color color;
  final double thickness;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;
    final y = size.height / 2;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dash).clamp(0, size.width), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) =>
      old.color != color || old.thickness != thickness;
}

/// Bordure pointillée arrondie (cartes « pas encore de crédit », mot de passe affiché).
class DashedBorderBox extends StatelessWidget {
  const DashedBorderBox({
    super.key,
    required this.child,
    this.radius = FpRadius.card,
    this.color = FpColors.dashStrong,
    this.fill,
    this.strokeWidth = 1,
  });

  final Widget child;
  final double radius;
  final Color color;
  final Color? fill;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(radius, color, fill, strokeWidth),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter(this.radius, this.color, this.fill, this.strokeWidth);

  final double radius;
  final Color color;
  final Color? fill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    if (fill != null) canvas.drawRRect(rrect, Paint()..color = fill!);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final path = Path()..addRRect(rrect.deflate(strokeWidth / 2));
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 7) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.fill != fill || old.radius != radius;
}

/// Forme ticket : carte arrondie, deux encoches latérales et perforation pointillée.
///
/// [top] est au-dessus de la perforation, [bottom] en dessous.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.top,
    this.bottom,
    this.dark = false,
    this.padding = FpSpace.x24,
    this.gap = FpSpace.x16,
    this.notchColor = FpColors.background,
  });

  final Widget top;
  final Widget? bottom;

  /// Ticket marine (solde) ou blanc (connexion, reçu, code de paiement).
  final bool dark;
  final double padding;
  final double gap;

  /// Couleur du fond de l'écran, visible dans les encoches.
  final Color notchColor;

  @override
  Widget build(BuildContext context) {
    final perforation = SizedBox(
      height: FpSize.notch,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: DashedLine(
              color: dark ? FpColors.onNavyDash : FpColors.dash,
            ),
          ),
          Positioned(left: -15, top: 0, child: _notch()),
          Positioned(right: -15, top: 0, child: _notch()),
        ],
      ),
    );
    final half = (gap - FpSize.notch / 2).clamp(0.0, gap);
    return Container(
      decoration: BoxDecoration(
        color: dark ? FpColors.navy : FpColors.surface,
        borderRadius: BorderRadius.circular(FpRadius.ticket),
        border: dark ? null : Border.all(color: FpColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(padding, padding, padding, half),
            child: top,
          ),
          perforation,
          if (bottom != null)
            Padding(
              padding: EdgeInsets.fromLTRB(padding, half, padding, padding),
              child: bottom,
            )
          else
            SizedBox(height: padding - FpSize.notch / 2),
        ],
      ),
    );
  }

  Widget _notch() => Container(
    width: FpSize.notch,
    height: FpSize.notch,
    decoration: BoxDecoration(
      color: notchColor,
      shape: BoxShape.circle,
      border: dark ? null : Border.all(color: FpColors.border),
    ),
  );
}
