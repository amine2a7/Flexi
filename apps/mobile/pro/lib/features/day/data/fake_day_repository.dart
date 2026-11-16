import '../../../demo/pro_demo_backend.dart';
import '../domain/day.dart';

class FakeDayRepository implements DayRepository {
  FakeDayRepository(this._backend, this._now);

  final ProDemoBackend _backend;
  final DateTime Function() _now;

  @override
  Future<DaySummary> today() async {
    final cashierOnly = _backend.account == ProDemoAccount.sami;
    final list =
        _backend.collections
            .where((c) => !cashierOnly || c.cashierId == 'u-sami')
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));
    return DaySummary(date: _now(), collections: list);
  }

  @override
  Future<List<({String id, String name})>> cashiers() async => [
    for (final m in _backend.team)
      if (!m.isOwner) (id: m.id, name: m.name),
  ];
}
