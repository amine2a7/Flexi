import 'package:flutter_riverpod/misc.dart';
import 'package:fp_core/fp_core.dart';

import '../demo/demo_backend.dart';
import '../features/auth/data/fake_auth_repository.dart';
import '../features/family/data/fake_family_repository.dart';
import '../features/family/domain/family.dart';
import '../features/merchants/data/fake_merchant_repository.dart';
import '../features/merchants/domain/merchant.dart';
import '../features/notifications/data/fake_notification_repository.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/payment/data/fake_payment_repository.dart';
import '../features/payment/domain/payment.dart';
import '../features/profile/data/fake_profile_repository.dart';
import '../features/profile/domain/profile.dart';
import '../features/wallet/data/fake_wallet_repository.dart';
import '../features/wallet/domain/wallet.dart';

/// Branche les Repository de démonstration. Pour l'API réelle, seules ces lignes changeront :
/// les écrans ne dépendent que des interfaces du dossier `domain`.
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
