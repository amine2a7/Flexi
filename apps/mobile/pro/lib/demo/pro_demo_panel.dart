import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import 'pro_demo_backend.dart';

/// Réglage de démonstration du catalogue : le client qui paiera la prochaine demande.
class ProDemoPanel extends ConsumerStatefulWidget {
  const ProDemoPanel({super.key});

  @override
  ConsumerState<ProDemoPanel> createState() => _ProDemoPanelState();
}

class _ProDemoPanelState extends ConsumerState<ProDemoPanel> {
  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final backend = ref.watch(proDemoBackendProvider);
    return FpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.catalogNextCustomer,
            style: FpText.body(weight: FontWeight.w600),
          ),
          const SizedBox(height: FpSpace.x10),
          Wrap(
            spacing: FpSpace.x8,
            runSpacing: FpSpace.x8,
            children: [
              for (final c in ProDemoCustomer.values)
                FpChip(
                  label: c == ProDemoCustomer.nobody
                      ? l10n.requestExpiredTitle
                      : c.firstName,
                  selected: backend.nextCustomer == c,
                  onTap: () => setState(() => backend.nextCustomer = c),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
