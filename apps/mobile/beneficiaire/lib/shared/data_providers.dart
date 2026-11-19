import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../features/family/domain/family.dart';
import '../features/merchants/domain/merchant.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/profile/domain/profile.dart';
import '../features/wallet/domain/wallet.dart';

/// Dernier portefeuille chargé, affiché hors ligne (« Dernier solde connu »).
class LastKnownWallet extends Notifier<(Wallet, DateTime)?> {
  @override
  (Wallet, DateTime)? build() => null;

  void remember(Wallet w, DateTime at) => state = (w, at);
}

final lastKnownWalletProvider =
    NotifierProvider<LastKnownWallet, (Wallet, DateTime)?>(LastKnownWallet.new);

final walletProvider = FutureProvider<Wallet>((ref) async {
  ref.watch(connectivityProvider);
  try {
    final wallet = await ref.watch(walletRepositoryProvider).wallet();
    ref
        .read(lastKnownWalletProvider.notifier)
        .remember(wallet, ref.read(clockProvider)());
    return wallet;
  } on NetworkFailure {
    ref.read(connectivityProvider.notifier).setOnline(false);
    rethrow;
  }
});

/// Opérations d'un mois (année, mois).
final operationsProvider = FutureProvider.family<List<Operation>, (int, int)>((
  ref,
  ym,
) async {
  ref.watch(connectivityProvider);
  return ref
      .watch(walletRepositoryProvider)
      .operations(year: ym.$1, month: ym.$2);
});

/// Recherche dans l'historique (W-SUP).
final operationSearchProvider = FutureProvider.family<List<Operation>, String>(
  (ref, query) => ref.watch(walletRepositoryProvider).search(query),
);

final operationProvider = FutureProvider.family<Operation, String>(
  (ref, id) => ref.watch(walletRepositoryProvider).operation(id),
);

final merchantsProvider = FutureProvider<List<Merchant>>(
  (ref) => ref.watch(merchantRepositoryProvider).nearby(),
);

final familyMembersProvider = FutureProvider<List<FamilyMember>>(
  (ref) => ref.watch(familyRepositoryProvider).members(),
);

final familyMemberProvider = FutureProvider.family<FamilyMember, String>(
  (ref, id) => ref.watch(familyRepositoryProvider).member(id),
);

final memberOperationsProvider = FutureProvider.family<List<Operation>, String>(
  (ref, id) => ref.watch(familyRepositoryProvider).memberOperations(id),
);

final myFamilyAccountProvider = FutureProvider<FamilyMember?>(
  (ref) => ref.watch(familyRepositoryProvider).myAccount(),
);

final notificationsProvider = FutureProvider<List<AppNotification>>(
  (ref) => ref.watch(notificationRepositoryProvider).list(),
);

final profileProvider = FutureProvider<Profile>(
  (ref) => ref.watch(profileRepositoryProvider).profile(),
);

/// Recharge tout ce qui dépend des soldes après une opération.
void refreshMoney(WidgetRef ref) {
  ref
    ..invalidate(walletProvider)
    ..invalidate(operationsProvider)
    ..invalidate(familyMembersProvider)
    ..invalidate(familyMemberProvider)
    ..invalidate(profileProvider);
}

/// Préférences de l'écran Profil (non sensibles, gardées en mémoire).
class ProfilePrefs {
  const ProfilePrefs({
    this.theme = 0,
    this.biometric = true,
    this.notifications = true,
  });
  final int theme;
  final bool biometric;
  final bool notifications;

  ProfilePrefs copyWith({int? theme, bool? biometric, bool? notifications}) =>
      ProfilePrefs(
        theme: theme ?? this.theme,
        biometric: biometric ?? this.biometric,
        notifications: notifications ?? this.notifications,
      );
}

class ProfilePrefsController extends Notifier<ProfilePrefs> {
  @override
  ProfilePrefs build() => const ProfilePrefs();

  void update(ProfilePrefs p) => state = p;
}

final profilePrefsProvider =
    NotifierProvider<ProfilePrefsController, ProfilePrefs>(
      ProfilePrefsController.new,
    );
