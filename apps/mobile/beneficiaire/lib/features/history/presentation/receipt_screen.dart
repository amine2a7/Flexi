import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../wallet/domain/wallet.dart';

/// Reçu détaillé d'un paiement, partageable.
class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key, required this.operationId});

  final String operationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final dates = Dates(context, ref.watch(clockProvider)());
    final op = ref.watch(operationProvider(operationId)).value;
    final merchant = op?.merchantId == null
        ? null
        : ref
              .watch(merchantsProvider)
              .value
              ?.where((m) => m.id == op!.merchantId)
              .firstOrNull;
    if (op == null) {
      return FpScreen(
        children: [
          ScreenHeader(title: l10n.receiptTitle, onBack: () => context.pop()),
        ],
      );
    }
    final type = op.type ?? CreditType.food;
    String money(int? m) => Tnd.format(m ?? 0, currency: l10n.currency);

    void share() {
      Clipboard.setData(ClipboardData(text: _summary(l10n, dates, op)));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.copied)));
    }

    Widget cell(String label, String value) => MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FpText.small),
          const SizedBox(height: FpSpace.x4),
          Text(value, style: FpText.body(weight: FontWeight.w700)),
        ],
      ),
    );
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: FpSpace.x16),
        Expanded(child: b),
      ],
    );
    return FpScreen(
      children: [
        ScreenHeader(
          title: l10n.receiptTitle,
          onBack: () =>
              context.canPop() ? context.pop() : context.go(Routes.history),
          trailing: FpSquareButton(
            icon: FpIcons.share,
            label: l10n.share,
            onTap: share,
          ),
        ),
        FpRise(
          child: Semantics(
            label: l10n.receiptDetailed,
            container: true,
            child: TicketCard(
              top: Column(
                children: [
                  IconTile(
                    tint: type.tint,
                    color: type.color,
                    text: (op.merchantName ?? ' ')[0],
                    size: 56,
                  ),
                  const SizedBox(height: FpSpace.x12),
                  Text(
                    op.merchantName ?? '',
                    style: FpText.body(size: 18, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: FpSpace.x6),
                  Text(
                    merchant?.address ?? '',
                    style: FpText.body(size: 13, color: FpColors.muted),
                  ),
                  const SizedBox(height: FpSpace.x16),
                  AmountText(
                    op.amount,
                    size: 56,
                    currencySize: 21,
                    color: FpColors.navy,
                  ),
                ],
              ),
              bottom: Column(
                children: [
                  pair(
                    cell(l10n.dateLabel, dates.longDateTime(op.date)),
                    cell(l10n.typeLabel, type.label(l10n)),
                  ),
                  const SizedBox(height: FpSpace.x16),
                  pair(
                    cell(l10n.cashierLabel, op.cashier ?? ''),
                    cell(l10n.reference, op.reference ?? ''),
                  ),
                  const SizedBox(height: FpSpace.x16),
                  pair(
                    cell(l10n.balanceBefore, money(op.balanceBefore)),
                    cell(l10n.balanceAfter, money(op.balanceAfter)),
                  ),
                  const SizedBox(height: FpSpace.x22),
                  const Stamp(
                    kind: StampKind.approved,
                    size: 24,
                    animate: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        FpButton(
          label: l10n.shareReceipt,
          icon: FpIcons.share,
          variant: FpButtonVariant.secondary,
          onPressed: share,
        ),
        Center(
          child: FpLink(
            label: l10n.reportProblem,
            onTap: () => context.push(Routes.help),
          ),
        ),
      ],
    );
  }

  static String _summary(FpL10n l10n, Dates dates, Operation op) => [
    op.merchantName,
    Tnd.format(op.amount, currency: l10n.currency),
    dates.longDateTime(op.date),
    '${l10n.reference} ${op.reference}',
  ].join(' · ');
}
