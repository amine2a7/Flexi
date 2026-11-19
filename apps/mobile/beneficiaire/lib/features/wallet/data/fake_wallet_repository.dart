import 'package:fp_core/fp_core.dart';

import '../../../demo/demo_backend.dart';
import '../domain/wallet.dart';

class FakeWalletRepository implements WalletRepository {
  FakeWalletRepository(this._backend, this._online);

  final DemoBackend _backend;
  final bool Function() _online;

  void _checkNetwork() {
    if (!_online()) throw const NetworkFailure();
  }

  @override
  Future<Wallet> wallet() async {
    _checkNetwork();
    return switch (_backend.account) {
      DemoAccount.omar => const Wallet(
        company: DemoBackend.company,
        credits: [],
      ),
      DemoAccount.adam => _adamWallet(),
      _ => Wallet(company: DemoBackend.company, credits: _backend.credits),
    };
  }

  Wallet _adamWallet() {
    final adam = _backend.family.firstWhere((m) => m.id == 'fm-adam');
    return Wallet(
      company: DemoBackend.company,
      credits: [
        Credit(
          type: adam.type,
          balance: adam.balance,
          received: adam.limit,
          used: adam.limit - adam.balance,
          shared: 0,
          expiresOn: adam.endDate,
          paymentCount: 1,
        ),
      ],
    );
  }

  @override
  Future<List<Operation>> operations({
    required int year,
    required int month,
  }) async {
    _checkNetwork();
    final all = switch (_backend.account) {
      DemoAccount.omar => const <Operation>[],
      DemoAccount.adam => _backend.adamOperations,
      _ => _backend.operations,
    };
    return all
        .where((o) => o.date.year == year && o.date.month == month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Operation>> search(String query) async {
    final q = query.trim().toLowerCase();
    final amount = int.tryParse(q.replaceAll(',', '').replaceAll('.', ''));
    return [
      for (final o in _backend.operations)
        if ((o.reference ?? '').toLowerCase().contains(q) ||
            (o.merchantName ?? '').toLowerCase().contains(q) ||
            (o.counterpart ?? '').toLowerCase().contains(q) ||
            (amount != null &&
                (o.amount.abs() == amount * 1000 || o.amount.abs() == amount)))
          o,
    ];
  }

  @override
  Future<Operation> operation(String id) async {
    final all = [..._backend.operations, ..._backend.adamOperations];
    return all.firstWhere((o) => o.id == id);
  }
}
