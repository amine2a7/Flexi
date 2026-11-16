import 'package:flutter/material.dart';

import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Thème Material aligné sur le prototype (fond, polices, couleurs).
abstract final class FpTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: FpColors.green,
        primary: FpColors.navy,
        secondary: FpColors.green,
        surface: FpColors.surface,
        error: FpColors.danger,
      ),
      scaffoldBackgroundColor: FpColors.background,
      fontFamily: FpFonts.inter,
      fontFamilyFallback: FpFonts.fallback,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: FpColors.ink,
        displayColor: FpColors.ink,
        fontFamily: FpFonts.inter,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: FpColors.navy,
        selectionColor: FpColors.greenTint,
        selectionHandleColor: FpColors.greenDark,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FpColors.navy,
        contentTextStyle: FpText.body(size: 14, color: FpColors.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
