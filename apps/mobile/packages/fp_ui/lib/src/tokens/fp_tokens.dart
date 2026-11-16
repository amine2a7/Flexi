import 'package:flutter/widgets.dart';

/// Couleurs du prototype mobile (docs/design/mobile/flexipay-prototype-mobile.html).
/// Aucune couleur n'est écrite ailleurs que dans ce fichier.
abstract final class FpColors {
  static const background = Color(0xFFF4F6F9);
  static const surface = Color(0xFFFFFFFF);
  static const navy = Color(0xFF0B1D33);
  static const green = Color(0xFF12D68A);
  static const greenDark = Color(0xFF087A4C);
  static const greenTint = Color(0xFFE3F8EF);
  static const ink = Color(0xFF0F1B2A);
  static const inkSoft = Color(0xFF3D4A5C);
  static const muted = Color(0xFF5B6878);
  static const border = Color(0xFFE1E6ED);
  static const divider = Color(0xFFEEF1F5);
  static const track = Color(0xFFE9EDF2);
  static const dash = Color(0xFFD5DCE4);
  static const dashStrong = Color(0xFFC9D1DC);
  static const ghostSurface = Color(0xFFF9FAFC);
  static const unreadSurface = Color(0xFFF7FFFB);
  static const onNavyMuted = Color(0xFFB9C6D6);
  static const onNavyFill = Color(0x1FFFFFFF);
  static const onNavyTrack = Color(0x26FFFFFF);
  static const onNavyDash = Color(0x40FFFFFF);
  static const onNavyOutline = Color(0x59FFFFFF);
  static const danger = Color(0xFFC2362B);
  static const dangerTint = Color(0xFFFCEBE9);
  static const dangerBorder = Color(0xFFF3C9C4);
  static const warningTint = Color(0xFFFFF3DC);
  static const warningInk = Color(0xFF6B3F00);
  static const warningIcon = Color(0xFF9A5B00);
  static const scrim = Color(0x730B1D33);
  static const shadow = Color(0x260B1D33);
  static const payGlow = Color(0x6612D68A);

  // Types de crédit : plein (barres, icônes) et teinte (fonds de pastille).
  static const food = Color(0xFF14A06A);
  static const foodTint = Color(0xFFE3F5EC);
  static const clothing = Color(0xFF2F6FE0);
  static const clothingTint = Color(0xFFE6EEFB);
  static const fuel = Color(0xFFD9761A);
  static const fuelTint = Color(0xFFFBEEDF);
  static const gifts = Color(0xFF8A4FD6);
  static const giftsTint = Color(0xFFF1E9FB);
}

/// Espacements (px logiques).
abstract final class FpSpace {
  static const double x2 = 2;
  static const double x4 = 4;
  static const double x6 = 6;
  static const double x8 = 8;
  static const double x10 = 10;
  static const double x12 = 12;
  static const double x14 = 14;
  static const double x16 = 16;
  static const double x18 = 18;
  static const double x20 = 20;
  static const double x22 = 22;
  static const double x24 = 24;
  static const double x28 = 28;
  static const double x32 = 32;
  static const double x40 = 40;
  static const double x56 = 56;

  /// Marge latérale des écrans.
  static const double screen = 20;

  /// Espace réservé en bas d'un écran avec barre de navigation.
  static const double navReserve = 120;
}

/// Rayons.
abstract final class FpRadius {
  static const double sm = 10;
  static const double md = 12;
  static const double field = 14;
  static const double button = 16;
  static const double key = 18;
  static const double card = 20;
  static const double ticket = 24;
  static const double pill = 999;
}

/// Tailles fixes de composants.
abstract final class FpSize {
  static const double button = 54;
  static const double buttonCompact = 48;
  static const double field = 52;
  static const double iconButton = 44;
  static const double tile = 44;
  static const double notch = 28;
  static const double pinKey = 62;
  static const double pinDot = 16;
  static const double navHeight = 92;
  static const double payButton = 68;
}

/// Mouvement : 120 / 200 / 320 / 600 ms, courbe (0.2, 0, 0, 1).
abstract final class FpMotion {
  static const fast = Duration(milliseconds: 120);
  static const base = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 320);
  static const emphasis = Duration(milliseconds: 600);
  static const curve = Cubic(0.2, 0, 0, 1);

  /// Rebond du tampon APPROUVÉ.
  static const stampCurve = Cubic(0.34, 1.56, 0.64, 1);

  /// `true` si le système demande de réduire les animations.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Durée effective : zéro si les animations sont réduites.
  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}
