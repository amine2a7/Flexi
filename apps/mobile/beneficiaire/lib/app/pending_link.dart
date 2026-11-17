import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lien d'autocollant ouvert alors que l'app était verrouillée : rouvert après le PIN.
class PendingLink extends Notifier<String?> {
  @override
  String? build() => null;

  void keep(String location) => state = location;

  String? take() {
    final location = state;
    state = null;
    return location;
  }
}

final pendingLinkProvider = NotifierProvider<PendingLink, String?>(
  PendingLink.new,
);
