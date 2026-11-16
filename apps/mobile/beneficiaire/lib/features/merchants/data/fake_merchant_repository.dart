import '../../../demo/demo_backend.dart';
import '../domain/merchant.dart';

class FakeMerchantRepository implements MerchantRepository {
  const FakeMerchantRepository();

  @override
  Future<List<Merchant>> nearby() async =>
      DemoBackend.merchants.where((m) => m.active).toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

  @override
  Future<Merchant> byId(String id) async =>
      DemoBackend.merchants.firstWhere((m) => m.id == id);
}
