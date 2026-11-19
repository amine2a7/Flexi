import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../demo/demo_panel.dart';
import '../features/auth/presentation/create_pin_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/locked_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/new_password_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/quick_pin_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/family/presentation/family_add_screen.dart';
import '../features/family/presentation/family_member_screen.dart';
import '../features/family/presentation/family_screen.dart';
import '../features/help/presentation/help_screen.dart';
import '../features/help/presentation/support_screens.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/history/presentation/receipt_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/merchants/presentation/discover_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/payment/domain/payment.dart';
import '../features/payment/presentation/approved_screen.dart';
import '../features/payment/presentation/confirm_pin_screen.dart';
import '../features/payment/presentation/code_screen.dart';
import '../features/payment/presentation/pay_screen.dart';
import '../features/payment/presentation/refused_screen.dart';
import '../features/payment/presentation/scan_screen.dart';
import '../features/payment/presentation/sticker_link_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/wallet/presentation/credit_screen.dart';
import 'pending_link.dart';
import 'routes.dart';

/// Rafraîchit le routeur quand la session change (verrouillage, déconnexion).
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthListenable(ref);
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    redirect: (context, state) {
      final path = state.uri.path;
      final unlocked = ref.read(authControllerProvider).unlocked;
      if (unlocked || Routes.public.contains(path)) return null;
      if (path.startsWith(Routes.stickerPrefix)) {
        ref.read(pendingLinkProvider.notifier).keep(state.uri.toString());
      }
      return ref.read(authControllerProvider).session == null
          ? Routes.login
          : Routes.unlock;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.newPassword,
        builder: (_, _) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: Routes.createPin,
        builder: (_, _) => const CreatePinScreen(),
      ),
      GoRoute(
        path: Routes.changePin,
        builder: (_, _) => const CreatePinScreen(change: true),
      ),
      GoRoute(path: Routes.unlock, builder: (_, _) => const QuickPinScreen()),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: Routes.locked, builder: (_, _) => const LockedScreen()),
      GoRoute(path: Routes.help, builder: (_, _) => const HelpScreen()),
      GoRoute(
        path: Routes.tickets,
        builder: (_, _) => const SupportTicketsScreen(),
      ),
      GoRoute(
        path: Routes.newTicket,
        builder: (_, state) =>
            NewTicketScreen(link: state.extra as TicketLink?),
      ),
      GoRoute(
        path: '/help/tickets/:id',
        builder: (_, state) =>
            TicketScreen(ticketId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.catalog,
        builder: (_, _) => FpCatalogPage(
          demoPanel: ref.read(appConfigProvider).demo
              ? const DemoPanel()
              : null,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: Routes.discover,
            builder: (_, _) => const DiscoverScreen(),
          ),
          GoRoute(
            path: Routes.history,
            builder: (_, _) => const HistoryScreen(),
          ),
          GoRoute(
            path: Routes.profile,
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/home/credit/:type',
        builder: (_, state) => CreditScreen(
          type: CreditType.values.byName(state.pathParameters['type']!),
        ),
      ),
      GoRoute(path: Routes.pay, builder: (_, _) => const PayScreen()),
      GoRoute(path: Routes.payScan, builder: (_, _) => const ScanScreen()),
      GoRoute(path: Routes.payCode, builder: (_, _) => const CodeScreen()),
      GoRoute(
        path: '${Routes.stickerPrefix}:publicId',
        builder: (_, state) => StickerLinkScreen(
          link: StickerLink(
            publicId: state.pathParameters['publicId']!,
            signature: state.uri.queryParameters['s'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: Routes.payConfirm,
        builder: (_, state) =>
            ConfirmPinScreen(checkout: state.extra! as PendingCheckout),
      ),
      GoRoute(
        path: Routes.payApproved,
        builder: (_, state) =>
            ApprovedScreen(receipt: state.extra! as PaymentReceipt),
      ),
      GoRoute(
        path: Routes.payRefused,
        builder: (_, state) =>
            RefusedScreen(refusal: state.extra! as PaymentRefusal),
      ),
      GoRoute(
        path: '/receipt/:id',
        builder: (_, state) =>
            ReceiptScreen(operationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(path: Routes.family, builder: (_, _) => const FamilyScreen()),
      GoRoute(
        path: Routes.familyAdd,
        builder: (_, _) => const FamilyAddScreen(),
      ),
      GoRoute(
        path: '/family/member/:id',
        builder: (_, state) =>
            FamilyMemberScreen(memberId: state.pathParameters['id']!),
      ),
    ],
  );
});

/// Onglets Accueil, Découvrir, Historique, Profil avec le bouton Payer au centre.
class _TabShell extends StatelessWidget {
  const _TabShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
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
          tab(FpIcons.home, l10n.navHome, Routes.home),
          tab(FpIcons.store, l10n.navDiscover, Routes.discover),
        ],
        trailing: [
          tab(FpIcons.clock, l10n.navHistory, Routes.history),
          tab(FpIcons.user, l10n.navProfile, Routes.profile),
        ],
        centerIcon: FpIcons.nfc,
        centerLabel: l10n.navPay,
        onCenter: () => context.push(Routes.pay),
      ),
    );
  }
}
