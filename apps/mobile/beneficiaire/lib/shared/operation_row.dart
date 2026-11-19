import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../app/routes.dart';
import '../features/wallet/domain/wallet.dart';
import 'formatters.dart';

/// Où la ligne est affichée : change le sous-titre et l'action.
enum OperationRowMode { home, credit, history }

/// Ligne d'opération (paiement, crédit reçu, partage famille).
class OperationRow extends StatelessWidget {
  const OperationRow({
    super.key,
    required this.op,
    required this.dates,
    this.withType = false,
    this.mode = OperationRowMode.home,
    this.forType,
  });

  final Operation op;
  final Dates dates;
  final bool withType;
  final OperationRowMode mode;

  /// Écran d'un crédit : montant du crédit reçu pour ce type seulement.
  final CreditType? forType;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final typeLabel = op.type?.label(l10n);
    String when() => switch (mode) {
      OperationRowMode.home => [
        ?typeLabel,
        dates.relative(op.date),
      ].join(' · '),
      OperationRowMode.credit => dates.relative(op.date),
      OperationRowMode.history => [?typeLabel, dates.time(op.date)].join(' · '),
    };
    switch (op.kind) {
      case OperationKind.payment:
        final name = op.merchantName ?? '';
        return ListRow(
          leading: IconTile(
            tint: op.type?.tint ?? FpColors.track,
            color: op.type?.color ?? FpColors.ink,
            text: name.isEmpty ? '' : name[0],
          ),
          title: name,
          subtitle: when(),
          trailing: ListRow.amount(Tnd.format(op.amount, currency: null)),
          onTap: () => context.push(Routes.receipt(op.id)),
        );
      case OperationKind.creditReceived:
        final types = op.breakdown.keys.toList();
        final amount = forType == null
            ? op.amount
            : (op.breakdown[forType] ?? 0);
        final subtitle = switch (mode) {
          OperationRowMode.home =>
            '${types.map((t) => t.label(l10n)).join(' + ')} · ${dates.relative(op.date, withTime: false)}',
          OperationRowMode.credit => dates.relative(op.date),
          OperationRowMode.history => [
            for (final t in types)
              '${t.label(l10n)} ${Tnd.format(op.breakdown[t]!, currency: null, compact: true)}',
          ].join(' + '),
        };
        return ListRow(
          leading: const IconTile(
            tint: FpColors.greenTint,
            color: FpColors.greenDark,
            icon: FpIcons.arrowDown,
          ),
          title: l10n.creditReceivedFrom(op.counterpart ?? ''),
          subtitle: subtitle,
          trailing: ListRow.amount(
            Tnd.format(amount, currency: null, signed: true),
            color: FpColors.greenDark,
          ),
          onTap: mode == OperationRowMode.home
              ? () => context.push(Routes.notifications)
              : null,
        );
      case OperationKind.expiry:
        return ListRow(
          leading: const IconTile(
            tint: FpColors.track,
            color: FpColors.muted,
            icon: FpIcons.clock,
          ),
          title: l10n.creditsExpired,
          subtitle: when(),
          trailing: ListRow.amount(
            Tnd.format(op.amount, currency: null, signed: true),
            color: FpColors.muted,
          ),
        );
      case OperationKind.familyShare:
      case OperationKind.familyReclaim:
        return ListRow(
          leading: IconTile(
            tint: FpColors.giftsTint,
            color: FpColors.gifts,
            icon: op.kind == OperationKind.familyShare
                ? FpIcons.family
                : FpIcons.undo,
          ),
          title: l10n.sharedWith(op.counterpart ?? ''),
          subtitle: when(),
          trailing: ListRow.amount(
            Tnd.format(op.amount, currency: null, signed: true),
          ),
          onTap: () => context.push(Routes.family),
        );
    }
  }
}
