import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import 'demo_backend.dart';

/// Réglages de démonstration du catalogue caché : réseau et prochaine réponse du faux serveur.
/// Les libellés des réponses reprennent les titres d'écran déjà traduits.
class DemoPanel extends ConsumerStatefulWidget {
  const DemoPanel({super.key});

  @override
  ConsumerState<DemoPanel> createState() => _DemoPanelState();
}

class _DemoPanelState extends ConsumerState<DemoPanel> {
  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final backend = ref.watch(demoBackendProvider);
    final online = ref.watch(connectivityProvider);
    final outcomes = {
      DemoPaymentOutcome.auto: l10n.paymentApproved,
      DemoPaymentOutcome.typeNotAccepted: l10n.refusedTypeTitle,
      DemoPaymentOutcome.insufficientFunds: l10n.refusedFundsTitle,
      DemoPaymentOutcome.merchantInactive: l10n.refusedMerchantTitle,
      DemoPaymentOutcome.codeExpired: l10n.refusedExpiredTitle,
      DemoPaymentOutcome.alreadyPaid: l10n.refusedPaidTitle,
      DemoPaymentOutcome.stickerInvalid: l10n.refusedStickerTitle,
    };
    return FpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.catalogOffline,
                  style: FpText.body(weight: FontWeight.w600),
                ),
              ),
              FpSwitch(
                value: !online,
                label: l10n.catalogOffline,
                onChanged: (offline) =>
                    ref.read(connectivityProvider.notifier).setOnline(!offline),
              ),
            ],
          ),
          const SizedBox(height: FpSpace.x16),
          Text(
            l10n.payStickerRead,
            style: FpText.body(weight: FontWeight.w600),
          ),
          const SizedBox(height: FpSpace.x10),
          Wrap(
            spacing: FpSpace.x8,
            runSpacing: FpSpace.x8,
            children: [
              for (final e in outcomes.entries)
                FpChip(
                  label: e.value,
                  selected: backend.nextOutcome == e.key,
                  onTap: () => setState(() => backend.nextOutcome = e.key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
