import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import 'pro_login_screen.dart';

/// Première connexion Pro (mot de passe temporaire du propriétaire ou du caissier).
class ProPasswordScreen extends ConsumerWidget {
  const ProPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NewPasswordView(
    onBack: () async {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) context.go(ProRoutes.login);
    },
    onSubmit: (password) async {
      final result = await ref
          .read(authControllerProvider.notifier)
          .changePassword(password);
      if (!context.mounted) return;
      // La double authentification s'active depuis l'espace web : retour à la connexion.
      if (result.needsMfaEnrollment) {
        context.go(ProRoutes.login, extra: ProLoginNotice.mfaEnroll);
      } else {
        context.go(ProRoutes.collect);
      }
    },
  );
}
