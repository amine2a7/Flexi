import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';
import 'ticket_card.dart';

/// Encadré du mot de passe affiché une seule fois, avec le bouton Copier.
///
/// Le mot de passe vit seulement dans ce widget : il n'est ni stocké ni journalisé.
class OneTimePasswordBox extends StatefulWidget {
  const OneTimePasswordBox({super.key, required this.password});

  final String password;

  @override
  State<OneTimePasswordBox> createState() => _OneTimePasswordBoxState();
}

class _OneTimePasswordBoxState extends State<OneTimePasswordBox> {
  bool _copied = false;

  Future<void> _copy() async {
    setState(() => _copied = true);
    await Clipboard.setData(ClipboardData(text: widget.password));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return DashedBorderBox(
      radius: FpRadius.field,
      fill: FpColors.background,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: SelectableText(
                  widget.password,
                  style: FpText.display(size: 28, letterSpacing: 0.08),
                ),
              ),
            ),
            FpPressable(
              onTap: _copy,
              semanticLabel: _copied ? l10n.copied : l10n.copy,
              child: Container(
                height: FpSize.iconButton,
                padding: const EdgeInsets.symmetric(horizontal: FpSpace.x14),
                decoration: BoxDecoration(
                  color: FpColors.navy,
                  borderRadius: BorderRadius.circular(FpRadius.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FpIcon(
                      FpIcons.copy,
                      size: 18,
                      color: FpColors.surface,
                    ),
                    const SizedBox(width: FpSpace.x6),
                    Text(
                      _copied ? l10n.copied : l10n.copy,
                      style: FpText.body(
                        weight: FontWeight.w700,
                        color: FpColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Volet du bas « mot de passe affiché une seule fois + Copier ».
class OneTimePasswordSheet extends StatelessWidget {
  const OneTimePasswordSheet({
    super.key,
    required this.title,
    required this.message,
    required this.password,
    required this.actionLabel,
    required this.onAction,
    this.showCheck = true,
  });

  final String title;

  /// Peut contenir du `**gras**`.
  final String message;
  final String password;
  final String actionLabel;
  final VoidCallback onAction;
  final bool showCheck;

  /// Ouvre le volet ; il ne se ferme pas d'un glissement accidentel.
  static Future<void> show(BuildContext context, OneTimePasswordSheet sheet) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: FpColors.surface,
      barrierColor: FpColors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FpRadius.ticket),
        ),
      ),
      sheetAnimationStyle: AnimationStyle(
        duration: FpMotion.of(context, FpMotion.slow),
        curve: FpMotion.curve,
      ),
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: FpColors.dash,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (showCheck) ...[
              const SizedBox(height: FpSpace.x14),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: FpColors.greenTint,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const FpIcon(
                    FpIcons.check,
                    size: 28,
                    color: FpColors.greenDark,
                    strokeWidth: 2.6,
                  ),
                ),
              ),
            ],
            const SizedBox(height: FpSpace.x14),
            Semantics(
              header: true,
              child: Text(
                title,
                style: FpText.body(size: 22, weight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: FpSpace.x14),
            MarkupText(
              message,
              style: FpText.body(size: 14, color: FpColors.muted, height: 1.5),
            ),
            const SizedBox(height: FpSpace.x14),
            OneTimePasswordBox(password: password),
            const SizedBox(height: FpSpace.x14),
            FpButton(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}
