// GENERATED FILE - DO NOT EDIT. Source: docs/design/design-tokens.json. Run `pnpm --filter @flexipay/ui-tokens generate`.
// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';

/// Colour tokens (`color.*`).
abstract final class FlexiColors {
  static const Color navy = Color(0xFF0B1D33);
  static const Color navyDeep = Color(0xFF12365A);
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldText = Color(0xFF047857);
  static const Color emeraldSoft = Color(0xFFD1FAE5);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFF718096);
  static const Color text = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textFaint = Color(0xFF94A3B8);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningText = Color(0xFFB45309);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerText = Color(0xFFB91C1C);
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoText = Color(0xFF1D4ED8);
  static const Color infoSoft = Color(0xFFDBEAFE);
  static const Color neutralText = Color(0xFF475569);
  static const Color typeFood = Color(0xFFEA580C);
  static const Color typeFoodSoft = Color(0xFFFFEDD5);
  static const Color typeFoodText = Color(0xFF9A3412);
  static const Color typeClothing = Color(0xFF7C3AED);
  static const Color typeClothingSoft = Color(0xFFEDE9FE);
  static const Color typeClothingText = Color(0xFF5B21B6);
  static const Color typeFuel = Color(0xFF0891B2);
  static const Color typeFuelSoft = Color(0xFFCFFAFE);
  static const Color typeFuelText = Color(0xFF155E75);
  static const Color typeGift = Color(0xFFDB2777);
  static const Color typeGiftSoft = Color(0xFFFCE7F3);
  static const Color typeGiftText = Color(0xFF9D174D);
  static const Color onEmerald = Color(0xFF0B1D33);
  static const Color onNavy = Color(0xFFFFFFFF);
  static const Color onNavyMuted = Color(0xFFCBD5E1);
  static const Color onDanger = Color(0xFFFFFFFF);
  static const Color overlay = Color.fromRGBO(11, 29, 51, 0.5);
}

/// Optional dark palette (`color-dark.*`), to be validated before use.
abstract final class FlexiColorsDark {
  static const Color bg = Color(0xFF0B1220);
  static const Color surface = Color(0xFF111B2E);
  static const Color border = Color(0xFF1E2A40);
  static const Color text = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF94A3B8);
}

/// Spacing tokens (`space.*`), logical pixels.
abstract final class FlexiSpace {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
}

/// Radius tokens (`radius.*`).
abstract final class FlexiRadius {
  static const double button = 12;
  static const double input = 12;
  static const double cardDesktop = 16;
  static const double cardMobile = 24;
  static const double cardMobileLg = 32;
  static const double badge = 999;
  static const double avatar = 999;
}

/// Size tokens (`size.*`) and focus ring (`focus.*`).
abstract final class FlexiSize {
  static const double inputHeight = 44;
  static const double buttonHeight = 44;
  static const double touchTargetMin = 44;
  static const double touchTargetMobile = 48;
  static const double desktopMaxWidth = 1280;
  static const double sidebarWidth = 264;
  static const double headerHeight = 64;
  static const double bottomNavHeight = 64;
  static const double toastMaxWidth = 420;
  static const double illustration = 160;
  static const double borderWidth = 1;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double avatarMd = 40;
  static const double avatarLg = 48;
  static const double tableRowHeight = 56;
  static const double chipHeight = 32;
  static const double modalMaxWidth = 480;
  static const double modalMaxWidthLg = 720;
  static const double authCardMaxWidth = 440;
  static const double formMaxWidth = 640;
  static const double qrCode = 192;
  static const double viewportMin = 360;
  static const double focusWidth = 2;
  static const double focusOffset = 2;
}

/// Opacity tokens (`opacity.*`).
abstract final class FlexiOpacity {
  static const double hover = 0.08;
  static const double pressed = 0.12;
  static const double disabled = 0.5;
}

/// Breakpoint tokens (`breakpoint.*`).
abstract final class FlexiBreakpoint {
  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
}

/// Motion tokens (`motion.*`).
abstract final class FlexiMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);
  static const Duration emphasis = Duration(milliseconds: 600);
  static const Duration bars = Duration(milliseconds: 700);
  static const Duration shake = Duration(milliseconds: 360);
  static const Duration bounce = Duration(milliseconds: 380);
  static const Duration copied = Duration(milliseconds: 1500);
  static const Duration success = Duration(milliseconds: 1600);
  static const Duration flash = Duration(milliseconds: 1600);
  static const Duration skeleton = Duration(milliseconds: 1200);
  static const Duration toast = Duration(milliseconds: 4000);
  static const Duration cascadeStep = Duration(milliseconds: 40);
  static const Duration barsStep = Duration(milliseconds: 80);
  static const Cubic easeOut = Cubic(0.2, 0, 0, 1);
  static const Cubic easeIn = Cubic(0.4, 0, 1, 1);
  static const Cubic easeSpring = Cubic(0.34, 1.56, 0.64, 1);
  static const double distanceRise = 8;
  static const double distanceShake = 7;
  static const double scalePress = 0.97;
  static const double scaleModal = 0.96;
  static const double scalePulse = 1.08;
  static const double scalePop = 0.6;
}

/// Shadow tokens (`shadow.*`).
abstract final class FlexiShadow {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color.fromRGBO(15, 23, 42, 0.06), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color.fromRGBO(15, 23, 42, 0.04), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color.fromRGBO(15, 23, 42, 0.08), offset: Offset(0, 4), blurRadius: 12),
  ];
}

/// Font tokens (`font.*`).
abstract final class FlexiFont {
  static const String family = 'Inter';
  static const List<String> familyFallback = ['Geist Sans', 'system-ui', 'sans-serif'];
  static const String familyAr = 'IBM Plex Sans Arabic';
  static const List<String> familyArFallback = ['Noto Sans Arabic', 'sans-serif'];
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight label = FontWeight.w500;
  static const FontWeight title = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Type scale (`type-scale.*`). Line height is expressed as a ratio of the font size.
abstract final class FlexiTypeScale {
  static const TextStyle micro = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle body = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyLg = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle label = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle titleSm = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle title = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headline = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle amount = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 32,
    height: 36 / 32,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle amountXl = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 40,
    height: 44 / 40,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle currency = TextStyle(
    fontFamily: FlexiFont.family,
    fontFamilyFallback: FlexiFont.familyFallback,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );
}

/// Status badge style (`status.*`): icon name is a Lucide name, label is an i18n key.
class FlexiStatusStyle {
  const FlexiStatusStyle({required this.labelKey, required this.icon, required this.bg, required this.fg});
  final String labelKey;
  final String icon;
  final Color bg;
  final Color fg;
}

abstract final class FlexiStatus {
  static const Map<String, FlexiStatusStyle> all = {
    'EN_ATTENTE': FlexiStatusStyle(
      labelKey: 'status.EN_ATTENTE',
      icon: 'Clock',
      bg: FlexiColors.warningSoft,
      fg: FlexiColors.warningText,
    ),
    'VALIDE': FlexiStatusStyle(
      labelKey: 'status.VALIDE',
      icon: 'CircleCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'A_REGLER': FlexiStatusStyle(
      labelKey: 'status.A_REGLER',
      icon: 'CalendarClock',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'REGLE': FlexiStatusStyle(
      labelKey: 'status.REGLE',
      icon: 'CheckCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'REFUSE': FlexiStatusStyle(
      labelKey: 'status.REFUSE',
      icon: 'CircleX',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
    'SUSPENDU': FlexiStatusStyle(
      labelKey: 'status.SUSPENDU',
      icon: 'CirclePause',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
    'ACTIF': FlexiStatusStyle(
      labelKey: 'status.ACTIF',
      icon: 'CircleCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'INVITE': FlexiStatusStyle(
      labelKey: 'status.INVITE',
      icon: 'Mail',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'DESACTIVE': FlexiStatusStyle(
      labelKey: 'status.DESACTIVE',
      icon: 'UserX',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'DESACTIVE_GRACE': FlexiStatusStyle(
      labelKey: 'status.DESACTIVE_GRACE',
      icon: 'Hourglass',
      bg: FlexiColors.warningSoft,
      fg: FlexiColors.warningText,
    ),
    'EN_LITIGE': FlexiStatusStyle(
      labelKey: 'status.EN_LITIGE',
      icon: 'Scale',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
    'EXPIRE': FlexiStatusStyle(
      labelKey: 'status.EXPIRE',
      icon: 'TimerOff',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'SUSPECT': FlexiStatusStyle(
      labelKey: 'status.SUSPECT',
      icon: 'ShieldAlert',
      bg: FlexiColors.warningSoft,
      fg: FlexiColors.warningText,
    ),
    'EN_ATTENTE_KYC': FlexiStatusStyle(
      labelKey: 'status.EN_ATTENTE_KYC',
      icon: 'Clock',
      bg: FlexiColors.warningSoft,
      fg: FlexiColors.warningText,
    ),
    'REJETE': FlexiStatusStyle(
      labelKey: 'status.REJETE',
      icon: 'CircleX',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
    'CREEE': FlexiStatusStyle(
      labelKey: 'status.CREEE',
      icon: 'FileText',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'PAYEE': FlexiStatusStyle(
      labelKey: 'status.PAYEE',
      icon: 'Banknote',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'RAPPROCHEE': FlexiStatusStyle(
      labelKey: 'status.RAPPROCHEE',
      icon: 'ArrowLeftRight',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'CREDITEE': FlexiStatusStyle(
      labelKey: 'status.CREDITEE',
      icon: 'CircleCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'ANNULEE': FlexiStatusStyle(
      labelKey: 'status.ANNULEE',
      icon: 'Ban',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'INITIE': FlexiStatusStyle(
      labelKey: 'status.INITIE',
      icon: 'CircleDashed',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'CONFIRME': FlexiStatusStyle(
      labelKey: 'status.CONFIRME',
      icon: 'CircleCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'DEMANDEE': FlexiStatusStyle(
      labelKey: 'status.DEMANDEE',
      icon: 'Clock',
      bg: FlexiColors.warningSoft,
      fg: FlexiColors.warningText,
    ),
    'CONTROLEE': FlexiStatusStyle(
      labelKey: 'status.CONTROLEE',
      icon: 'ShieldCheck',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'ENVOYEE': FlexiStatusStyle(
      labelKey: 'status.ENVOYEE',
      icon: 'Send',
      bg: FlexiColors.infoSoft,
      fg: FlexiColors.infoText,
    ),
    'EXECUTEE': FlexiStatusStyle(
      labelKey: 'status.EXECUTEE',
      icon: 'CheckCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'REJETEE': FlexiStatusStyle(
      labelKey: 'status.REJETEE',
      icon: 'CircleX',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
    'APPROUVEE': FlexiStatusStyle(
      labelKey: 'status.APPROUVEE',
      icon: 'CircleCheck',
      bg: FlexiColors.emeraldSoft,
      fg: FlexiColors.emeraldText,
    ),
    'INCONNU': FlexiStatusStyle(
      labelKey: 'status.INCONNU',
      icon: 'CircleHelp',
      bg: FlexiColors.border,
      fg: FlexiColors.neutralText,
    ),
    'REFUSEE': FlexiStatusStyle(
      labelKey: 'status.REFUSEE',
      icon: 'CircleX',
      bg: FlexiColors.dangerSoft,
      fg: FlexiColors.dangerText,
    ),
  };
}

/// Credit type style (`credit-type.*`): icon is a Lucide name, label an i18n key, solid for charts.
class FlexiCreditTypeStyle {
  const FlexiCreditTypeStyle({required this.labelKey, required this.icon, required this.bg, required this.fg, required this.solid});
  final String labelKey;
  final String icon;
  final Color bg;
  final Color fg;
  final Color solid;
}

abstract final class FlexiCreditType {
  static const Map<String, FlexiCreditTypeStyle> all = {
    'RESTAURATION': FlexiCreditTypeStyle(
      labelKey: 'creditType.RESTAURATION',
      icon: 'UtensilsCrossed',
      bg: FlexiColors.typeFoodSoft,
      fg: FlexiColors.typeFoodText,
      solid: FlexiColors.typeFood,
    ),
    'HABILLEMENT': FlexiCreditTypeStyle(
      labelKey: 'creditType.HABILLEMENT',
      icon: 'Shirt',
      bg: FlexiColors.typeClothingSoft,
      fg: FlexiColors.typeClothingText,
      solid: FlexiColors.typeClothing,
    ),
    'CARBURANT': FlexiCreditTypeStyle(
      labelKey: 'creditType.CARBURANT',
      icon: 'Fuel',
      bg: FlexiColors.typeFuelSoft,
      fg: FlexiColors.typeFuelText,
      solid: FlexiColors.typeFuel,
    ),
    'CADEAUX': FlexiCreditTypeStyle(
      labelKey: 'creditType.CADEAUX',
      icon: 'Gift',
      bg: FlexiColors.typeGiftSoft,
      fg: FlexiColors.typeGiftText,
      solid: FlexiColors.typeGift,
    ),
  };
}

/// Light theme built only from the tokens above.
abstract final class FlexiTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: FlexiColors.navy,
      onPrimary: FlexiColors.onNavy,
      secondary: FlexiColors.emerald,
      onSecondary: FlexiColors.onEmerald,
      error: FlexiColors.danger,
      onError: FlexiColors.onDanger,
      surface: FlexiColors.surface,
      onSurface: FlexiColors.text,
      onSurfaceVariant: FlexiColors.textMuted,
      outline: FlexiColors.borderStrong,
      outlineVariant: FlexiColors.border,
      scrim: FlexiColors.overlay,
    );
    const textTheme = TextTheme(
      displayMedium: FlexiTypeScale.amountXl,
      displaySmall: FlexiTypeScale.amount,
      headlineMedium: FlexiTypeScale.headline,
      titleLarge: FlexiTypeScale.title,
      titleMedium: FlexiTypeScale.titleSm,
      bodyLarge: FlexiTypeScale.bodyLg,
      bodyMedium: FlexiTypeScale.body,
      bodySmall: FlexiTypeScale.caption,
      labelLarge: FlexiTypeScale.label,
      labelMedium: FlexiTypeScale.label,
      labelSmall: FlexiTypeScale.micro,
    );
    final inputRadius = BorderRadius.circular(FlexiRadius.input);
    OutlineInputBorder border(Color color, [double width = FlexiSize.borderWidth]) =>
        OutlineInputBorder(borderRadius: inputRadius, borderSide: BorderSide(color: color, width: width));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: FlexiColors.bg,
      fontFamily: FlexiFont.family,
      fontFamilyFallback: FlexiFont.familyFallback,
      textTheme: textTheme.apply(bodyColor: FlexiColors.text, displayColor: FlexiColors.text),
      appBarTheme: const AppBarTheme(
        backgroundColor: FlexiColors.navy,
        foregroundColor: FlexiColors.onNavy,
        elevation: 0,
        toolbarHeight: FlexiSize.headerHeight,
      ),
      cardTheme: CardThemeData(
        color: FlexiColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlexiRadius.cardMobile)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FlexiColors.navy,
          foregroundColor: FlexiColors.onNavy,
          minimumSize: const Size(FlexiSize.touchTargetMobile, FlexiSize.touchTargetMobile),
          textStyle: FlexiTypeScale.label,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlexiRadius.button)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FlexiColors.surface,
        border: border(FlexiColors.borderStrong),
        enabledBorder: border(FlexiColors.borderStrong),
        focusedBorder: border(FlexiColors.navy, FlexiSize.focusWidth),
        errorBorder: border(FlexiColors.danger),
        focusedErrorBorder: border(FlexiColors.danger, FlexiSize.focusWidth),
      ),
      dividerTheme: const DividerThemeData(
        color: FlexiColors.border,
        thickness: FlexiSize.borderWidth,
      ),
    );
  }
}
