import 'package:flutter/widgets.dart';

import 'fp_tokens.dart';

/// Familles de polices embarquées dans fp_ui.
abstract final class FpFonts {
  static const inter = 'packages/fp_ui/Inter';
  static const condensed = 'packages/fp_ui/BarlowCondensed';
  static const arabic = 'packages/fp_ui/IBMPlexSansArabic';

  /// L'arabe retombe sur IBM Plex Sans Arabic.
  static const fallback = [arabic];
}

/// Styles de texte : Inter pour le texte, Barlow Condensed pour les montants et titres.
abstract final class FpText {
  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = FpColors.ink,
    double? height,
  }) => TextStyle(
    fontFamily: FpFonts.inter,
    fontFamilyFallback: FpFonts.fallback,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  static TextStyle display({
    double size = 30,
    FontWeight weight = FontWeight.w800,
    Color color = FpColors.ink,
    double? height = 1,
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: FpFonts.condensed,
    fontFamilyFallback: FpFonts.fallback,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing * size,
  );

  /// Libellé en capitales espacées (« SOLDE DISPONIBLE »).
  static TextStyle caps({Color color = FpColors.muted, double size = 12}) =>
      body(
        size: size,
        weight: FontWeight.w700,
        color: color,
      ).copyWith(letterSpacing: 0.08 * size);

  static TextStyle get title => body(size: 18, weight: FontWeight.w700);
  static TextStyle get rowTitle => body(size: 15, weight: FontWeight.w600);
  static TextStyle get rowSubtitle => body(size: 12.5, color: FpColors.muted);
  static TextStyle get label => body(size: 13, weight: FontWeight.w600);
  static TextStyle get small => body(size: 12, color: FpColors.muted);
  static TextStyle get muted14 =>
      body(size: 14, color: FpColors.muted, height: 1.5);
}
