import 'package:flutter_riverpod/flutter_riverpod.dart';

/// État réseau vu par l'app : passe à hors ligne quand un appel lève `NetworkFailure`.
class ConnectivityController extends Notifier<bool> {
  @override
  bool build() => true;

  void setOnline(bool online) => state = online;
}

/// `true` si en ligne.
final connectivityProvider = NotifierProvider<ConnectivityController, bool>(
  ConnectivityController.new,
);
