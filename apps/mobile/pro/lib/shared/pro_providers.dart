import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../features/collect/domain/collect.dart';
import '../features/day/domain/day.dart';
import '../features/payouts/domain/payout.dart';
import '../features/team/domain/team.dart';

final acceptedTypesProvider = FutureProvider<List<CreditType>>(
  (ref) => ref.watch(collectRepositoryProvider).acceptedTypes(),
);

final daySummaryProvider = FutureProvider<DaySummary>(
  (ref) => ref.watch(dayRepositoryProvider).today(),
);

final cashiersProvider = FutureProvider<List<({String id, String name})>>(
  (ref) => ref.watch(dayRepositoryProvider).cashiers(),
);

final payoutQuoteProvider = FutureProvider<PayoutQuote>(
  (ref) => ref.watch(payoutRepositoryProvider).quote(),
);

final payoutsProvider = FutureProvider<List<Payout>>(
  (ref) => ref.watch(payoutRepositoryProvider).list(),
);

final teamProvider = FutureProvider<List<TeamMember>>(
  (ref) => ref.watch(teamRepositoryProvider).members(),
);

/// Recharge les chiffres du commerce après un encaissement ou une demande.
void refreshMerchant(WidgetRef ref) {
  ref
    ..invalidate(daySummaryProvider)
    ..invalidate(payoutQuoteProvider)
    ..invalidate(payoutsProvider)
    ..invalidate(teamProvider);
}
