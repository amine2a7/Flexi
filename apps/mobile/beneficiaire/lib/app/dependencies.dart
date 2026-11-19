import 'package:flutter_riverpod/misc.dart';
import 'package:fp_core/fp_core.dart';

import '../demo/demo_backend.dart';
import '../features/auth/data/fake_auth_repository.dart';
import '../features/family/data/api_family_repository.dart';
import '../features/family/data/fake_family_repository.dart';
import '../features/family/domain/family.dart';
import '../features/merchants/data/api_merchant_repository.dart';
import '../features/merchants/data/fake_merchant_repository.dart';
import '../features/merchants/domain/merchant.dart';
import '../features/notifications/data/api_notification_repository.dart';
import '../features/notifications/data/fake_notification_repository.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/payment/data/api_payment_repository.dart';
import '../features/payment/data/fake_payment_repository.dart';
import '../features/payment/domain/payment.dart';
import '../features/profile/data/api_profile_repository.dart';
import '../features/profile/data/fake_profile_repository.dart';
import '../features/profile/domain/profile.dart';
import '../features/wallet/data/api_wallet_repository.dart';
import '../features/wallet/data/fake_wallet_repository.dart';
import '../features/wallet/domain/wallet.dart';
import 'app_router.dart';
import 'routes.dart';

/// Branche les Repository de démonstration (build `FP_DEMO=true`) : les écrans ne dépendent
/// que des interfaces du dossier `domain`.
List<Override> fakeDataOverrides({SecureStore? store}) => [
  if (store != null) secureStoreProvider.overrideWithValue(store),
  clockProvider.overrideWithValue(() => demoNow),
  authRepositoryProvider.overrideWith(
    (ref) => FakeAuthRepository(
      ref.watch(demoBackendProvider),
      ref.watch(secureStoreProvider),
    ),
  ),
  walletRepositoryProvider.overrideWith(
    (ref) => FakeWalletRepository(
      ref.watch(demoBackendProvider),
      () => ref.read(connectivityProvider),
    ),
  ),
  merchantRepositoryProvider.overrideWithValue(const FakeMerchantRepository()),
  paymentRepositoryProvider.overrideWith(
    (ref) => FakePaymentRepository(
      ref.watch(demoBackendProvider),
      () => ref.read(connectivityProvider),
      ref.watch(clockProvider),
    ),
  ),
  familyRepositoryProvider.overrideWith(
    (ref) => FakeFamilyRepository(ref.watch(demoBackendProvider)),
  ),
  notificationRepositoryProvider.overrideWith(
    (ref) => FakeNotificationRepository(ref.watch(demoBackendProvider)),
  ),
  profileRepositoryProvider.overrideWith(
    (ref) => FakeProfileRepository(ref.watch(demoBackendProvider)),
  ),
];

/// Branche les Repository de l'API (build normal, `--dart-define=API_URL=…`).
List<Override> apiOverrides({SecureStore? store}) => [
  if (store != null) secureStoreProvider.overrideWithValue(store),
  // Session refusée par le serveur (401 après renouvellement) : retour à la connexion.
  sessionExpiredProvider.overrideWith(
    (ref) => () {
      ref.read(authControllerProvider.notifier).expire();
      ref.read(routerProvider).go(Routes.login);
    },
  ),
  authRepositoryProvider.overrideWith(
    (ref) => ApiAuthRepository(
      FlexiApp.beneficiary,
      ref.watch(apiJsonProvider),
      ref.watch(tokenVaultProvider),
      ref.watch(secureStoreProvider),
    ),
  ),
  walletRepositoryProvider.overrideWith(
    (ref) => ApiWalletRepository(
      ref.watch(apiJsonProvider),
      ref.watch(clockProvider),
    ),
  ),
  merchantRepositoryProvider.overrideWithValue(const ApiMerchantRepository()),
  paymentRepositoryProvider.overrideWith(
    (ref) => ApiPaymentRepository(
      ref.watch(apiJsonProvider),
      payerName: () =>
          ref.read(authControllerProvider).session?.firstName ?? '',
    ),
  ),
  familyRepositoryProvider.overrideWith(
    (ref) => ApiFamilyRepository(
      ref.watch(apiJsonProvider),
      () => ref.read(authControllerProvider).session,
      ref.watch(clockProvider),
    ),
  ),
  notificationRepositoryProvider.overrideWith(
    (ref) => ApiNotificationRepository(ref.watch(apiJsonProvider)),
  ),
  profileRepositoryProvider.overrideWith(
    (ref) => ApiProfileRepository(ref.watch(apiJsonProvider)),
  ),
];
