import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Connexion par e-mail et mot de passe, sous forme de « ticket d'accès ».
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final _email = TextEditingController(
    text: ref.read(appConfigProvider).useFakeData
        ? 'yasmine@flexipay.test'
        : '',
  );
  final _password = TextEditingController();
  bool _obscure = true;
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
      final result = await ref
          .read(authControllerProvider.notifier)
          .login(_email.text, _password.text);
      _password.clear();
      if (!mounted) return;
      if (result.mustChangePassword) {
        context.go(Routes.newPassword);
      } else if (result.needsPin) {
        context.go(Routes.createPin);
      } else {
        context.go(Routes.home);
      }
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
      top: FpSpace.x8,
      children: [
        Center(
          child: GestureDetector(
            onLongPress: () => context.push(Routes.catalog),
            child: const Mascot(size: 104),
          ),
        ),
        FpRise(
          child: TicketCard(
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: CapsLabel(l10n.loginTicketLabel)),
                    TagChip(
                      label: l10n.loginTicketNumber('0001'),
                      tint: FpColors.greenTint,
                      color: FpColors.greenDark,
                    ),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.loginTitle,
                    style: FpText.display(size: 36, color: FpColors.navy),
                  ),
                ),
                const SizedBox(height: FpSpace.x16),
                Text(l10n.loginSubtitle, style: FpText.muted14),
              ],
            ),
            bottom: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FpTextField(
                    fieldKey: const Key('login-email'),
                    label: l10n.emailLabel,
                    controller: _email,
                    icon: FpIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: FpSpace.x16),
                  FpTextField(
                    fieldKey: const Key('login-password'),
                    label: l10n.passwordLabel,
                    controller: _password,
                    icon: FpIcons.lock,
                    obscure: _obscure,
                    autofillHints: const [AutofillHints.password],
                    trailing: FpPressable(
                      semanticLabel: _obscure
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: FpIcon(
                            FpIcons.eye,
                            size: 20,
                            color: FpColors.muted,
                          ),
                        ),
                      ),
                    ),
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
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FpLink(
                      label: l10n.forgotPassword,
                      onTap: () => context.push(Routes.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: FpSpace.x8),
                  FpButton(
                    label: l10n.loginSubmit,
                    onPressed: _busy ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: FpLink(
            label: l10n.loginWithPin,
            icon: FpIcons.fingerprint,
            onTap: () => context.go(Routes.unlock),
          ),
        ),
        Text(
          l10n.loginHelp,
          textAlign: TextAlign.center,
          style: FpText.body(size: 13, color: FpColors.muted),
        ),
      ],
    );
  }
}
