import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../domain/payment.dart';

/// Charge la demande de la caisse (autocollant, QR ou code) puis ouvre la confirmation ou le
/// refus. Se termine quand l'écran ouvert est refermé. [replace] : remplace l'écran courant.
Future<void> openCheckout(
  BuildContext context,
  WidgetRef ref,
  Future<PendingCheckout> Function(PaymentRepository repo) load, {
  bool replace = false,
}) async {
  Future<void> open(String route, Object extra) async {
    if (!context.mounted) return;
    if (replace) {
      context.pushReplacement(route, extra: extra);
    } else {
      await context.push(route, extra: extra);
    }
  }

  try {
    final checkout = await load(ref.read(paymentRepositoryProvider));
    await open(Routes.payConfirm, checkout);
  } on PaymentRefusedException catch (e) {
    await open(Routes.payRefused, e.refusal);
  } on NetworkFailure {
    ref.read(connectivityProvider.notifier).setOnline(false);
    if (context.mounted) context.go(Routes.home);
  }
}
