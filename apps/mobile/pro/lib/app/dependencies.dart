import 'package:flutter_riverpod/misc.dart';
import 'package:fp_core/fp_core.dart';

import '../demo/pro_demo_backend.dart';
import '../features/auth/data/fake_pro_auth_repository.dart';
import '../features/collect/data/fake_collect_repository.dart';
import '../features/collect/domain/collect.dart';
import '../features/day/data/fake_day_repository.dart';
import '../features/day/domain/day.dart';
import '../features/payouts/data/fake_payout_repository.dart';
import '../features/payouts/domain/payout.dart';
import '../features/team/data/fake_team_repository.dart';
import '../features/team/domain/team.dart';

/// Branche les Repository de démonstration ; les écrans ne voient que les interfaces `domain`.
List<Override> fakeDataOverrides({SecureStore? store}) => [
  if (store != null) secureStoreProvider.overrideWithValue(store),
  clockProvider.overrideWithValue(() => demoNow),
  authRepositoryProvider.overrideWith(
    (ref) => FakeProAuthRepository(
      ref.watch(proDemoBackendProvider),
      ref.watch(secureStoreProvider),
    ),
  ),
  collectRepositoryProvider.overrideWith(
    (ref) => FakeCollectRepository(
      ref.watch(proDemoBackendProvider),
      ref.watch(clockProvider),
    ),
  ),
  dayRepositoryProvider.overrideWith(
    (ref) => FakeDayRepository(
      ref.watch(proDemoBackendProvider),
      ref.watch(clockProvider),
    ),
  ),
  payoutRepositoryProvider.overrideWith(
    (ref) => FakePayoutRepository(ref.watch(proDemoBackendProvider)),
  ),
  teamRepositoryProvider.overrideWith(
    (ref) => FakeTeamRepository(ref.watch(proDemoBackendProvider)),
  ),
];
