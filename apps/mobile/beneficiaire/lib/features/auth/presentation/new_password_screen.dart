import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Première connexion : choix d'un mot de passe personnel.
class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .changePassword(_password.text);
      _password.clear();
      _confirm.clear();
      if (mounted) context.go(Routes.createPin);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final p = _password.text;
    final rules = [
      (l10n.ruleLength, p.length >= 8),
      (l10n.ruleUpper, RegExp('[A-Z]').hasMatch(p)),
      (l10n.ruleDigit, RegExp(r'\d').hasMatch(p)),
      (l10n.ruleMatch, p.isNotEmpty && p == _confirm.text),
    ];
    final valid = rules.every((r) => r.$2);
    return FpScreen(
      gap: FpSpace.x20,
      children: [
        ScreenHeader(
          title: l10n.newPasswordTitle,
          onBack: () => context.go(Routes.login),
        ),
        InfoBanner(
          text: l10n.newPasswordInfo,
          icon: FpIcons.key,
          tint: FpColors.greenTint,
          iconColor: FpColors.greenDark,
          textSize: 14,
        ),
        FpTextField(
          fieldKey: const Key('new-password'),
          label: l10n.newPasswordLabel,
          controller: _password,
          icon: FpIcons.lock,
          obscure: true,
          onChanged: (_) => setState(() {}),
        ),
        FpTextField(
          fieldKey: const Key('confirm-password'),
          label: l10n.confirmPasswordLabel,
          controller: _confirm,
          icon: FpIcons.lock,
          obscure: true,
          onChanged: (_) => setState(() {}),
        ),
        Column(
          children: [
            for (final (label, ok) in rules)
              Padding(
                padding: const EdgeInsets.only(bottom: FpSpace.x10),
                child: MergeSemantics(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: FpMotion.of(context, FpMotion.base),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ok ? FpColors.green : null,
                          border: Border.all(
                            color: ok ? FpColors.green : FpColors.dashStrong,
                            width: 2,
                          ),
                        ),
                        child: ok
                            ? const FpIcon(
                                FpIcons.check,
                                size: 16,
                                color: FpColors.surface,
                                strokeWidth: 3,
                              )
                            : null,
                      ),
                      const SizedBox(width: FpSpace.x10),
                      Expanded(
                        child: Text(
                          label,
                          style: FpText.body(
                            size: 14,
                            color: ok ? FpColors.greenDark : FpColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const Spacer(),
        FpButton(
          label: l10n.newPasswordSubmit,
          onPressed: valid && !_busy ? _save : null,
        ),
      ],
    );
  }
}
