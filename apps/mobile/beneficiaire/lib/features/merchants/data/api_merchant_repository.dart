import 'package:fp_core/fp_core.dart';

import '../domain/merchant.dart';

/// L'API n'expose pas encore la liste des commerces partenaires (Découvrir) : liste vide.
class ApiMerchantRepository implements MerchantRepository {
  const ApiMerchantRepository();

  @override
  Future<List<Merchant>> nearby() async => const [];

  @override
  Future<Merchant> byId(String id) async => throw const UnknownFailure();
}
