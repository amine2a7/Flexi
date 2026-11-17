import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../demo/pro_demo_panel.dart';
import '../features/auth/presentation/pro_login_screen.dart';
import '../features/collect/domain/collect.dart';
import '../features/collect/presentation/collect_screen.dart';
import '../features/collect/presentation/result_screen.dart';
import '../features/collect/presentation/waiting_screen.dart';
import '../features/day/presentation/day_screen.dart';
import '../features/payouts/presentation/balance_screen.dart';
import '../features/payouts/presentation/payouts_screen.dart';
import '../features/registers/presentation/registers_screen.dart';
import '../features/registers/presentation/sticker_screen.dart';
import '../features/team/presentation/team_screen.dart';
import 'routes.dart';

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: ProRoutes.login,
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final path = state.uri.path;
      final auth = ref.read(authControllerProvider);
      if (ProRoutes.public.contains(path)) return null;
      if (!auth.unlocked) return ProRoutes.login;
      // Le caissier ne voit que Encaisser et sa journée.
      if (ProRoutes.ownerOnly.contains(path) &&
          !(auth.session?.isOwner ?? false)) {
        return ProRoutes.collect;
      }
      return null;
    },
    routes: [
      GoRoute(path: ProRoutes.login, builder: (_, _) => const ProLoginScreen()),
      GoRoute(
        path: ProRoutes.catalog,
        builder: (_, _) => FpCatalogPage(
          demoPanel: ref.read(appConfigProvider).demo
              ? const ProDemoPanel()
              : null,
        ),
      ),
      GoRoute(
        path: ProRoutes.result,
        builder: (_, state) =>
            ResultScreen(result: state.extra! as TillCheckout),
      ),
      GoRoute(
        path: ProRoutes.waiting,
        builder: (_, state) =>
            WaitingScreen(checkout: state.extra! as TillCheckout),
      ),
      GoRoute(
        path: ProRoutes.registers,
        builder: (_, _) => const RegistersScreen(),
      ),
      GoRoute(
        path: ProRoutes.sticker,
        builder: (_, state) =>
            StickerScreen(register: state.extra! as TillRegister),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _ProShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: ProRoutes.collect,
            builder: (_, _) => const CollectScreen(),
          ),
          GoRoute(path: ProRoutes.day, builder: (_, _) => const DayScreen()),
          GoRoute(
            path: ProRoutes.balance,
            builder: (_, _) => const BalanceScreen(),
          ),
          GoRoute(
            path: ProRoutes.payouts,
            builder: (_, _) => const PayoutsScreen(),
          ),
          GoRoute(path: ProRoutes.team, builder: (_, _) => const TeamScreen()),
        ],
      ),
    ],
  );
});

/// Barre du bas selon le rôle : le propriétaire voit tout, le caissier Aujourd'hui + Encaisser.
class _ProShell extends ConsumerWidget {
  const _ProShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final owner = ref.watch(authControllerProvider).session?.isOwner ?? false;
    FpNavItem tab(FpIcons icon, String label, String path) => FpNavItem(
      icon: icon,
      label: label,
      selected: location == path,
      onTap: () => context.go(path),
    );
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: FpBottomNav(
        leading: [
          tab(FpIcons.list, l10n.proNavToday, ProRoutes.day),
          if (owner) tab(FpIcons.wallet, l10n.proNavBalance, ProRoutes.balance),
        ],
        trailing: [
          if (owner) tab(FpIcons.bank, l10n.proNavPayouts, ProRoutes.payouts),
          if (owner) tab(FpIcons.family, l10n.proNavTeam, ProRoutes.team),
        ],
        centerIcon: FpIcons.scan,
        centerLabel: l10n.proNavCollect,
        onCenter: () => context.go(ProRoutes.collect),
      ),
    );
  }
}
