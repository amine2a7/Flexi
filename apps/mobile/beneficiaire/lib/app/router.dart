import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:go_router/go_router.dart';

/// Routes de l'app bénéficiaire.
abstract final class Routes {
  static const splash = '/';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const _BootScreen(),
      ),
    ],
  );
});

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(FpL10n.of(context).appName)));
  }
}
