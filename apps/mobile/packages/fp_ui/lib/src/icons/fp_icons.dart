import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tokens/fp_tokens.dart';

/// Icônes au trait du prototype (viewBox 24, trait arrondi).
enum FpIcons {
  qr(
    '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 14h3v3h-3zM20 14v.01M14 20h.01M17 20h4v-3"/>',
  ),
  chevronRight('<path d="M9 6l6 6-6 6"/>'),
  chevronLeft('<path d="M15 18l-6-6 6-6"/>'),
  family(
    '<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c0-3.5 3-5.5 6.5-5.5s6.5 2 6.5 5.5M16 4.5a3.5 3.5 0 0 1 0 7M18.5 14.8c1.9.7 3 2.4 3 5.2"/>',
  ),
  user('<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>'),
  check('<path d="M5 12l5 5 9-10"/>'),
  store('<path d="M3 9l1.5-5h15L21 9M4 9v11h16V9M9 20v-6h6v6"/>'),
  bank('<path d="M3 10l9-6 9 6M5 10v8M9 10v8M15 10v8M19 10v8M3 21h18"/>'),
  home('<path d="M3 10.5 12 3l9 7.5V21h-6v-6H9v6H3z"/>'),
  clock('<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>'),
  lock(
    '<rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>',
  ),
  wallet(
    '<path d="M3 7a2 2 0 0 1 2-2h13v4"/><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M16 13h2"/>',
  ),
  scan('<path d="M3 7V4h3M21 7V4h-3M3 17v3h3M21 17v3h-3M7 12h10"/>'),
  plus('<path d="M12 5v14M5 12h14"/>'),
  mail(
    '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>',
  ),
  list('<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>'),
  fingerprint(
    '<path d="M12 11c0 3-1 6-3 8M8 8.5A5 5 0 0 1 17 11c0 2-.3 4-1 6M5 12a7 7 0 0 1 1.5-4.4M12 3a8 8 0 0 1 8 8c0 1.5-.1 3-.4 4.3M15.5 20c.3-.6.5-1.3.7-2"/>',
  ),
  arrowDown('<path d="M12 5v14M5 12l7 7 7-7"/>'),
  bell(
    '<path d="M6 8a6 6 0 1 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
  ),
  close('<path d="M6 6l12 12M18 6L6 18"/>'),
  food(
    '<path d="M6 3v6a2 2 0 0 0 2 2v10M4 3v5M8 3v5M17 21V3c-2.5 1.5-3 5-3 8h3"/>',
  ),
  fuel(
    '<path d="M4 21V5a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v16M3 21h12M6 8h6M14 10h2a2 2 0 0 1 2 2v5a1.5 1.5 0 0 0 3 0V9l-3-3"/>',
  ),
  clothing('<path d="M8 3l4 2 4-2 5 4-3 3-2-1v12H8V9l-2 1-3-3z"/>'),
  gift(
    '<rect x="3" y="8" width="18" height="4" rx="1"/><path d="M5 12v9h14v-9M12 8v13M12 8C10 4 6 4 6 6.5S10 8 12 8zM12 8c2-4 6-4 6-1.5S14 8 12 8z"/>',
  ),
  share(
    '<path d="M4 12v7a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7M16 6l-4-4-4 4M12 2v13"/>',
  ),
  backspace('<path d="M21 5H9l-6 7 6 7h12z"/><path d="M17 9l-6 6M11 9l6 6"/>'),
  key('<circle cx="8" cy="15" r="4"/><path d="M11 12l9-9M17 6l3 3"/>'),
  copy(
    '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h10"/>',
  ),
  wifiOff(
    '<path d="M2 2l20 20M8.5 16.5a5 5 0 0 1 7 0M5 13a10 10 0 0 1 5.2-2.8M19 13a10 10 0 0 0-2.4-1.7M2 8.8a15 15 0 0 1 4.2-2.7M22 8.8A15 15 0 0 0 10.7 5M12 20h.01"/>',
  ),
  info('<circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v4h1"/>'),
  calendar(
    '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4"/>',
  ),
  map('<path d="M9 4L3 6v14l6-2 6 2 6-2V4l-6 2z"/><path d="M9 4v14M15 6v14"/>'),
  undo('<path d="M9 14L4 9l5-5"/><path d="M4 9h11a5 5 0 0 1 0 10h-3"/>'),
  edit('<path d="M4 20h4L19 9l-4-4L4 16z"/>'),
  refresh('<path d="M20 11a8 8 0 1 0-2.3 5.7M20 4v7h-7"/>'),
  eye(
    '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
  ),
  logout('<path d="M15 4h4v16h-4M10 17l5-5-5-5M15 12H3"/>'),
  help(
    '<circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.5 2.5 0 1 1 3.5 2.3c-.6.3-1 .9-1 1.7M12 17h.01"/>',
  ),
  ban('<circle cx="12" cy="12" r="9"/><path d="M5.6 5.6l12.8 12.8"/>'),
  search('<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>');

  const FpIcons(this.body);

  /// Contenu SVG (sans la balise racine).
  final String body;

  String svg(double strokeWidth) =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
      'stroke="currentColor" stroke-width="$strokeWidth" stroke-linecap="round" '
      'stroke-linejoin="round">$body</svg>';
}

/// Icône du prototype, colorée par [color] (par défaut la couleur du texte).
class FpIcon extends StatelessWidget {
  const FpIcon(
    this.icon, {
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth = 2,
  });

  final FpIcons icon;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final c = color ?? DefaultTextStyle.of(context).style.color ?? FpColors.ink;
    return ExcludeSemantics(
      child: SvgPicture.string(
        icon.svg(strokeWidth),
        width: size,
        height: size,
        theme: SvgTheme(currentColor: c),
      ),
    );
  }
}
