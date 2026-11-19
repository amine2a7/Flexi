import 'package:fp_core/fp_core.dart';

import '../domain/app_notification.dart';

/// Notifications du bénéficiaire sur l'API (`/v1/employee/notifications`) ; le texte est
/// construit par l'app à partir de clés i18n.
class ApiNotificationRepository implements NotificationRepository {
  ApiNotificationRepository(this._api);

  final ApiJson _api;

  @override
  Future<List<AppNotification>> list() async {
    final body = await _api.get(
      '/v1/employee/notifications',
      query: {'limit': 50},
    );
    return [
      for (final n in listOf(body['data']))
        if (_kind(n['kind']) case final kind?)
          AppNotification(
            id: n['id'] as String,
            kind: kind,
            date: dateOf(n['occurredAt']),
            unread: n['unread'] == true,
            amount: n['amountMillimes'] == null
                ? null
                : intOf(n['amountMillimes']),
            type: CreditType.fromApi(n['creditType']),
            merchant: kind == NotificationKind.creditReceived
                ? null
                : n['counterpartyName'] as String?,
            person: kind == NotificationKind.creditReceived
                ? n['counterpartyName'] as String?
                : null,
            breakdown: {
              ?CreditType.fromApi(n['creditType']): intOf(n['amountMillimes']),
            },
          ),
    ];
  }

  static NotificationKind? _kind(Object? kind) => switch (kind) {
    'CREDIT_RECEIVED' => NotificationKind.creditReceived,
    'PAYMENT_APPROVED' => NotificationKind.paymentApproved,
    'FAMILY_PAYMENT' => NotificationKind.familyPaid,
    'CREDIT_EXPIRING' => NotificationKind.creditExpiring,
    _ => null,
  };

  @override
  Future<void> markAllRead() async {
    await _api.post('/v1/employee/notifications/read');
  }
}
