import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../domain/collect.dart';

/// Résultat d'un encaissement : tampon APPROUVÉ ou REFUSÉ et détail.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final CollectResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final r = result;
    final ok = r.approved;
    return FpScreen(
      gap: FpSpace.x20,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x24),
          child: Column(
            children: [
              Container(
                width: 112,
                height: 112,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ok ? FpColors.greenTint : FpColors.dangerTint,
                  shape: BoxShape.circle,
                ),
                child: FpIcon(
                  ok ? FpIcons.check : FpIcons.close,
                  size: 52,
                  color: ok ? FpColors.greenDark : FpColors.danger,
                  strokeWidth: 2.6,
                ),
              ),
              const SizedBox(height: FpSpace.x18),
              Stamp(kind: ok ? StampKind.approved : StampKind.refused),
              const SizedBox(height: FpSpace.x18),
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(
                  ok ? l10n.paymentApproved : l10n.paymentRefused,
                  style: FpText.body(
                    size: 24,
                    weight: FontWeight.w700,
                    color: FpColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: FpSpace.x8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  ok
                      ? l10n.customerConfirmed
                      : l10n.refusedFundsPro(
                          r.type.label(l10n),
                          Tnd.format(r.missing ?? 0, currency: l10n.currency),
                        ),
                  textAlign: TextAlign.center,
                  style: FpText.body(color: FpColors.muted, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        FpCard(
          child: Column(
            children: [
              DetailLine(
                label: l10n.amountLabel,
                value: Tnd.format(r.amount, currency: l10n.currency),
                bold: true,
              ),
              const SizedBox(height: FpSpace.x12),
              DetailLine(label: l10n.customerLabel, value: r.customerName),
              const SizedBox(height: FpSpace.x12),
              DetailLine(label: l10n.typeLabel, value: r.type.label(l10n)),
              const SizedBox(height: FpSpace.x12),
              DetailLine(label: l10n.cashierLabel, value: r.cashier),
              if (r.reference != null) ...[
                const SizedBox(height: FpSpace.x12),
                DetailLine(label: l10n.reference, value: r.reference!),
              ],
              const SizedBox(height: FpSpace.x12),
              DetailLine(
                label: l10n.timeLabel,
                value: DateFormat.Hm(locale).format(r.time),
              ),
            ],
          ),
        ),
        const Spacer(),
        FpButton(
          label: l10n.newCollection,
          icon: FpIcons.scan,
          onPressed: () => context.go(ProRoutes.collect),
        ),
        FpButton(
          label: l10n.seeDay,
          variant: FpButtonVariant.secondary,
          onPressed: () => context.go(ProRoutes.day),
        ),
      ],
    );
  }
}
