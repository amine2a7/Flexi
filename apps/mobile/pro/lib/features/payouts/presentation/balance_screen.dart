import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../domain/payout.dart';

/// Mon solde (propriétaire) : montant à reverser et calcul au millime du net.
/// Les montants viennent du serveur ; l'app ne fait que les afficher.
class BalanceScreen extends ConsumerStatefulWidget {
  const BalanceScreen({super.key});

  @override
  ConsumerState<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends ConsumerState<BalanceScreen> {
  String? _idempotencyKey;
  bool _busy = false;

  Future<void> _request() async {
    // Même clé si la personne réessaie : pas de double virement.
    _idempotencyKey ??= newIdempotencyKey();
    setState(() => _busy = true);
    try {
      await ref
          .read(payoutRepositoryProvider)
          .request(idempotencyKey: _idempotencyKey!);
      refreshMerchant(ref);
      if (mounted) context.go(ProRoutes.payouts);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final session = ref.watch(authControllerProvider).session;
    final q = ref.watch(payoutQuoteProvider).value;
    final email =
        ref
            .watch(teamProvider)
            .value
            ?.where((m) => m.isOwner)
            .firstOrNull
            ?.email ??
        '';
    if (q == null) return const SizedBox.expand();
    String rate(int bps) =>
        NumberFormat.percentPattern(locale).format(bps / 10000);
    String minus(int m) => Tnd.format(-m, currency: null);
    final byType = q.byType.entries
        .map(
          (e) => '${e.key.label(l10n)} ${Tnd.format(e.value, currency: null)}',
        )
        .join(' · ');
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(overline: l10n.ownerEmail(email), title: l10n.myBalance),
        FpRise(
          child: BalanceHero(
            label: l10n.toPayOut,
            amount: q.gross,
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentBar(
                  track: FpColors.onNavyFill,
                  segments: [
                    for (final e in q.byType.entries) (e.value, e.key.color),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                Text(
                  '$byType · ${l10n.availableTodayJ0}',
                  style: FpText.body(size: 13, color: FpColors.onNavyMuted),
                ),
              ],
            ),
          ),
        ),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CapsLabel(l10n.ifRequestNow),
              const SizedBox(height: FpSpace.x10),
              DetailLine(
                label: l10n.amountLabel,
                value: Tnd.format(q.gross, currency: null),
              ),
              const SizedBox(height: FpSpace.x10),
              DetailLine(
                label: l10n.commissionRate(rate(q.commissionBps)),
                value: minus(q.commission),
              ),
              const SizedBox(height: FpSpace.x10),
              DetailLine(
                label: l10n.vatRate(rate(q.vatBps)),
                value: minus(q.vat),
              ),
              const SizedBox(height: FpSpace.x10),
              DetailLine(
                label: l10n.feesInclTax,
                value: minus(q.feesInclTax),
                bold: true,
              ),
              const SizedBox(height: FpSpace.x10),
              DetailLine(
                label: l10n.withholding,
                value: q.withholding == 0
                    ? l10n.withholdingNone(
                        Tnd.format(0, currency: null),
                        Tnd.format(
                          q.withholdingThreshold,
                          currency: null,
                          compact: true,
                        ),
                      )
                    : minus(q.withholding),
              ),
              const SizedBox(height: FpSpace.x10),
              DetailLine(label: l10n.stampDuty, value: minus(q.stampDuty)),
              const SizedBox(height: FpSpace.x10),
              DetailLine(label: l10n.transferFee, value: minus(q.transferFee)),
              const SizedBox(height: FpSpace.x10),
              Container(height: 1, color: FpColors.divider),
              const SizedBox(height: FpSpace.x10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      l10n.youWillReceive,
                      style: FpText.body(weight: FontWeight.w700),
                    ),
                  ),
                  AmountText(
                    q.net,
                    size: 34,
                    currencySize: 14,
                    color: FpColors.greenDark,
                  ),
                ],
              ),
            ],
          ),
        ),
        FpButton(
          label: l10n.requestPayout,
          onPressed: _busy || q.net <= 0 || !(session?.isOwner ?? false)
              ? null
              : _request,
        ),
        Text(
          l10n.payoutInfo,
          textAlign: TextAlign.center,
          style: FpText.body(size: 13, color: FpColors.muted),
        ),
      ],
    );
  }
}
