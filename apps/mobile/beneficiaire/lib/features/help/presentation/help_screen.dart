import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';

/// Aide : questions fréquentes (une ouverte à la fois) et contacts.
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  int _open = 0;

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(FpL10n.of(context).copied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final profile = ref.watch(profileProvider).value;
    final faq = [
      (l10n.faq1Q, l10n.faq1A),
      (l10n.faq2Q, l10n.faq2A),
      (l10n.faq3Q, l10n.faq3A),
      (l10n.faq4Q, l10n.faq4A),
    ];
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        ScreenHeader(
          title: l10n.helpTitle,
          onBack: () =>
              context.canPop() ? context.pop() : context.go(Routes.login),
        ),
        Row(
          children: [
            const Mascot(size: 88),
            const SizedBox(width: FpSpace.x14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.helpHeadline,
                      style: FpText.display(size: 32, color: FpColors.navy),
                    ),
                  ),
                  const SizedBox(height: FpSpace.x4),
                  Text(
                    l10n.helpSubtitle,
                    style: FpText.body(size: 14, color: FpColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        ListGroup(
          insetDividers: false,
          children: [
            for (var i = 0; i < faq.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    button: true,
                    expanded: _open == i,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _open = _open == i ? -1 : i),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 56),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: FpSpace.x16,
                            vertical: FpSpace.x14,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(faq[i].$1, style: FpText.rowTitle),
                              ),
                              const SizedBox(width: FpSpace.x12),
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: FpColors.divider,
                                  shape: BoxShape.circle,
                                ),
                                child: ExcludeSemantics(
                                  child: Text(
                                    _open == i ? '−' : '+',
                                    style: FpText.body(
                                      size: 18,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _Expand(
                    open: _open == i,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq[i].$2,
                        style: FpText.body(
                          size: 14,
                          color: FpColors.inkSoft,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        ListGroup(
          children: [
            ListRow(
              leading: const IconTile(
                tint: FpColors.clothingTint,
                color: FpColors.clothing,
                icon: FpIcons.mail,
              ),
              title: l10n.writeSupport,
              subtitle: profile?.supportEmail,
              chevron: true,
              onTap: profile == null ? null : () => _copy(profile.supportEmail),
            ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                icon: FpIcons.family,
              ),
              title: l10n.yourHr,
              subtitle: profile == null
                  ? null
                  : '${profile.company} · ${profile.hrName}',
              chevron: true,
              onTap: profile == null ? null : () => _copy(profile.hrEmail),
            ),
          ],
        ),
      ],
    );
  }
}

/// Réponse dépliable ; sans animation si le système demande de les réduire.
class _Expand extends StatelessWidget {
  const _Expand({required this.open, required this.child});

  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final content = open ? child : const SizedBox(width: double.infinity);
    if (FpMotion.reduced(context)) return content;
    return AnimatedSize(
      duration: FpMotion.base,
      curve: FpMotion.curve,
      child: content,
    );
  }
}
