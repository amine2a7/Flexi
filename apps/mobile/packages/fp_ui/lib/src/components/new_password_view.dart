import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';
import 'basics.dart';
import 'layout.dart';

/// Première connexion : choix d'un mot de passe personnel (règles affichées en direct).
/// Le mot de passe ne fait que passer : [onSubmit] l'envoie au serveur, rien n'est gardé.
class NewPasswordView extends StatefulWidget {
  const NewPasswordView({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  /// Lève une [AppFailure] si le serveur refuse le mot de passe.
  final Future<void> Function(String password) onSubmit;
  final VoidCallback onBack;

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onSubmit(_password.text);
      _password.clear();
      _confirm.clear();
    } on AppFailure {
      if (mounted) setState(() => _failed = true);
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
        ScreenHeader(title: l10n.newPasswordTitle, onBack: widget.onBack),
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
        if (_failed)
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.passwordRefused,
              textAlign: TextAlign.center,
              style: FpText.body(size: 13, color: FpColors.danger),
            ),
          ),
      ],
    );
  }
}
