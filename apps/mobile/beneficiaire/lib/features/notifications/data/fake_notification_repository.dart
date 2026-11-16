import '../../../demo/demo_backend.dart';
import '../domain/app_notification.dart';

class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository(this._backend);

  final DemoBackend _backend;

  @override
  Future<List<AppNotification>> list() async =>
      [..._backend.notifications]..sort((a, b) => b.date.compareTo(a.date));

  @override
  Future<void> markAllRead() async {
    _backend.notifications = [
      for (final n in _backend.notifications)
        AppNotification(
          id: n.id,
          kind: n.kind,
          date: n.date,
          unread: false,
          amount: n.amount,
          merchant: n.merchant,
          type: n.type,
          person: n.person,
          leftToday: n.leftToday,
          breakdown: n.breakdown,
        ),
    ];
  }
}
