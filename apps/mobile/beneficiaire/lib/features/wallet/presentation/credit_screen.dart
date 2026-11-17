import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../../shared/operation_row.dart';

/// Détail d'un crédit : solde, utilisé, partagé, expiration, où l'utiliser, mouvements.
class CreditScreen extends ConsumerWidget {
  const CreditScreen({super.key, required this.type});

  final CreditType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final credit = ref.watch(walletProvider).value?.credit(type);
    final merchants = ref.watch(merchantsProvider).value ?? const [];
    final ops =
        (ref.watch(operationsProvider((now.year, now.month))).value ?? const [])
            .where((o) => o.type == type || o.breakdown.containsKey(type))
            .toList();
    final typeLabel = type.label(l10n);
    if (credit == null) {
      return FpScreen(
        children: [ScreenHeader(title: typeLabel, onBack: () => context.pop())],
      );
    }
    Widget statCard(String value, String label) => Expanded(
      child: FpCard(
        padding: const EdgeInsets.all(FpSpace.x14),
        child: MergeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: FpText.display(size: 28)),
              const SizedBox(height: FpSpace.x4),
              Text(label, style: FpText.small),
            ],
          ),
        ),
      ),
    );
    return FpScreen(
      gap: FpSpace.x20,
      children: [
        ScreenHeader(title: typeLabel, onBack: () => context.pop()),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconTile(
                    tint: type.tint,
                    color: type.color,
                    icon: type.icon,
                    size: 48,
                  ),
                  const SizedBox(width: FpSpace.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CapsLabel(l10n.creditBalanceOf(typeLabel)),
                        const SizedBox(height: FpSpace.x2),
                        AmountText(credit.balance, size: 48, currencySize: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FpSpace.x16),
              FpProgressBar(
                value: credit.balance / credit.received,
                color: type.color,
                height: 12,
              ),
              const SizedBox(height: FpSpace.x16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.usedAmount(Tnd.format(credit.used, currency: null)),
                      style: FpText.body(size: 13, color: FpColors.muted),
                    ),
                  ),
                  const SizedBox(width: FpSpace.x12),
                  Flexible(
                    child: Text(
                      l10n.receivedAmount(
                        Tnd.format(credit.received, currency: null),
                      ),
                      textAlign: TextAlign.end,
                      style: FpText.body(size: 13, color: FpColors.muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            statCard(
              '${credit.paymentCount}',
              l10n.statPayments(credit.paymentCount),
            ),
            const SizedBox(width: FpSpace.x10),
            statCard(
              Tnd.format(credit.shared, currency: null, compact: true),
              l10n.statShared,
            ),
            const SizedBox(width: FpSpace.x10),
            statCard(dates.dayMonth(credit.expiresOn), l10n.expiresOn),
          ],
        ),
        SectionHeader(title: l10n.whereToUse),
        Row(
          children: [
            for (final (i, m)
                in merchants
                    .where((m) => m.acceptedTypes.contains(type))
                    .take(2)
                    .indexed) ...[
              if (i > 0) const SizedBox(width: FpSpace.x10),
              Expanded(
                child: FpPressable(
                  onTap: () => context.go(Routes.discover),
                  semanticLabel: m.shortName,
                  child: Container(
                    padding: const EdgeInsets.all(FpSpace.x12),
                    decoration: BoxDecoration(
                      color: FpColors.surface,
                      borderRadius: BorderRadius.circular(FpRadius.button),
                      border: Border.all(color: FpColors.border),
                    ),
                    child: Row(
                      children: [
                        IconTile(
                          tint: type.tint,
                          color: type.color,
                          text: tileInitials(m.shortName),
                          size: 36,
                        ),
                        const SizedBox(width: FpSpace.x10),
                        Flexible(
                          child: Text(
                            m.shortName,
                            overflow: TextOverflow.ellipsis,
                            style: FpText.body(
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        SectionHeader(title: l10n.movements),
        ListGroup(
          children: [
            for (final op in ops)
              OperationRow(
                op: op,
                dates: dates,
                mode: OperationRowMode.credit,
                forType: type,
              ),
          ],
        ),
        FpButton(
          label: l10n.payWith(typeLabel),
          icon: FpIcons.qr,
          onPressed: () => context.push(Routes.pay),
        ),
      ],
    );
  }
}
