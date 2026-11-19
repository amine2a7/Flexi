import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../features/collect/domain/collect.dart';
import '../features/day/domain/day.dart';
import '../features/payouts/domain/payout.dart';
import '../features/team/domain/team.dart';

final acceptedTypesProvider = FutureProvider<List<CreditType>>(
  (ref) => ref.watch(collectRepositoryProvider).acceptedTypes(),
);

final myRegisterProvider = FutureProvider<TillRegister?>(
  (ref) => ref.watch(collectRepositoryProvider).myRegister(),
);

final registersProvider = FutureProvider<List<TillRegister>>(
  (ref) => ref.watch(collectRepositoryProvider).registers(),
);

final daySummaryProvider = FutureProvider<DaySummary>(
  (ref) => ref.watch(dayRepositoryProvider).today(),
);

final cashiersProvider = FutureProvider<List<({String id, String name})>>(
  (ref) => ref.watch(dayRepositoryProvider).cashiers(),
);

/// Devis du type choisi (`null` : le type qui a le plus à reverser).
final payoutQuoteProvider = FutureProvider.family<PayoutQuote, CreditType?>(
  (ref, type) => ref.watch(payoutRepositoryProvider).quote(type: type),
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
