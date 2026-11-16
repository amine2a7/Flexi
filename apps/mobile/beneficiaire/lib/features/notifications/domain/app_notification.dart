import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

enum NotificationKind { paymentApproved, familyPaid, creditReceived, newLogin }

/// Notification ; le texte est construit côté app à partir de clés i18n.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.date,
    required this.unread,
    this.amount,
    this.merchant,
    this.type,
    this.person,
    this.leftToday,
    this.breakdown = const {},
  });

  final String id;
  final NotificationKind kind;
  final DateTime date;
  final bool unread;
  final int? amount;
  final String? merchant;
  final CreditType? type;

  /// Membre famille ou entreprise.
  final String? person;
  final int? leftToday;
  final Map<CreditType, int> breakdown;
}

abstract interface class NotificationRepository {
  Future<List<AppNotification>> list();

  Future<void> markAllRead();
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => throw UnimplementedError('notificationRepositoryProvider'),
);
