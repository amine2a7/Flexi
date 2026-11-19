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

  /// Type de crédit du virement (un virement porte sur un seul type).
  CreditType? _type;

  Future<void> _request(PayoutQuote quote) async {
    // Même clé si la personne réessaie : pas de double virement.
    _idempotencyKey ??= newIdempotencyKey();
    setState(() => _busy = true);
    try {
      await ref
          .read(payoutRepositoryProvider)
          .request(quote: quote, idempotencyKey: _idempotencyKey!);
      _idempotencyKey = null;
      refreshMerchant(ref);
      if (mounted) context.go(ProRoutes.payouts);
    } on ApiProblemFailure {
      // Devis expiré ou refusé : un nouveau devis, et une nouvelle clé pour la nouvelle demande.
      _idempotencyKey = null;
      ref.invalidate(payoutQuoteProvider);
      if (mounted) _snack(FpL10n.of(context).genericError);
    } on AppFailure {
      if (mounted) _snack(FpL10n.of(context).genericError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final session = ref.watch(authControllerProvider).session;
    final q = ref.watch(payoutQuoteProvider(_type)).value;
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
            amount: q.total,
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
        if (q.byType.length > 1)
          Wrap(
            spacing: FpSpace.x8,
            runSpacing: FpSpace.x8,
            children: [
              for (final t in q.byType.keys)
                FpChip(
                  label: t.label(l10n),
                  dot: t.color,
                  selected: (q.creditType ?? q.byType.keys.first) == t,
                  onTap: () => setState(() {
                    _type = t;
                    _idempotencyKey = null;
                  }),
                ),
            ],
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
                // Seuil connu (démonstration) : rappelé quand la retenue est nulle.
                value: q.withholding == 0 && q.withholdingThreshold > 0
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
              : () => _request(q),
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
