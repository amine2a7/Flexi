import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Connexion Pro : même écran pour le propriétaire et le caissier.
/// Un appui long sur le logo ouvre le catalogue caché.
class ProLoginScreen extends ConsumerStatefulWidget {
  const ProLoginScreen({super.key});

  @override
  ConsumerState<ProLoginScreen> createState() => _ProLoginScreenState();
}

class _ProLoginScreenState extends ConsumerState<ProLoginScreen> {
  late final _email = TextEditingController(
    text: ref.read(appConfigProvider).demo ? 'sami@flexipay.test' : '',
  );
  final _password = TextEditingController();
  bool _busy = false;
  bool _error = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(_email.text, _password.text);
      _password.clear();
      if (mounted) context.go(ProRoutes.collect);
    } on AppFailure {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return FpScreen(
      gap: FpSpace.x20,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x8),
          child: Column(
            children: [
              GestureDetector(
                onLongPress: () => context.push(ProRoutes.catalog),
                child: Semantics(
                  header: true,
                  label: l10n.appNamePro,
                  excludeSemantics: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: l10n.brandFlexi),
                        TextSpan(
                          text: l10n.brandPay,
                          style: FpText.display(
                            size: 44,
                            color: FpColors.greenDark,
                          ),
                        ),
                        TextSpan(text: ' ${l10n.brandPro}'),
                      ],
                    ),
                    style: FpText.display(size: 44, color: FpColors.navy),
                  ),
                ),
              ),
              const SizedBox(height: FpSpace.x8),
              TagChip(
                label: l10n.proMerchantSpace,
                tint: FpColors.navy,
                color: FpColors.surface,
                height: 28,
              ),
            ],
          ),
        ),
        FpRise(
          child: TicketCard(
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CapsLabel(l10n.loginTicketLabel),
                const SizedBox(height: FpSpace.x16),
                Text(
                  l10n.loginTitle,
                  style: FpText.display(size: 32, color: FpColors.navy),
                ),
                const SizedBox(height: FpSpace.x16),
                Text(l10n.proLoginSubtitle, style: FpText.muted14),
              ],
            ),
            bottom: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FpTextField(
                    fieldKey: const Key('pro-email'),
                    label: l10n.emailLabel,
                    controller: _email,
                    icon: FpIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: FpSpace.x16),
                  FpTextField(
                    fieldKey: const Key('pro-password'),
                    label: l10n.passwordLabel,
                    controller: _password,
                    icon: FpIcons.lock,
                    obscure: true,
                    autofillHints: const [AutofillHints.password],
                  ),
                  if (_error) ...[
                    const SizedBox(height: FpSpace.x10),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.loginError,
                        style: FpText.body(size: 13, color: FpColors.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: FpSpace.x16),
                  FpButton(
                    label: l10n.loginSubmit,
                    onPressed: _busy ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          l10n.proLoginHelp,
          textAlign: TextAlign.center,
          style: FpText.body(size: 13, color: FpColors.muted),
        ),
      ],
    );
  }
}
