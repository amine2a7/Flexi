import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Première connexion : choix d'un mot de passe personnel, puis le PIN si aucun n'existe.
class NewPasswordScreen extends ConsumerWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NewPasswordView(
    onBack: () => context.go(Routes.login),
    onSubmit: (password) async {
      final result = await ref
          .read(authControllerProvider.notifier)
          .changePassword(password);
      if (!context.mounted) return;
      context.go(result.needsPin ? Routes.createPin : Routes.home);
    },
  );
}
