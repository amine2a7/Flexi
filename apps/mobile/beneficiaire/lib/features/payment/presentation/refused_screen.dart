import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/formatters.dart';
import '../domain/payment.dart';

/// Paiement refusé : motif, détail, conseil et action adaptée. Aucun montant débité.
class RefusedScreen extends ConsumerWidget {
  const RefusedScreen({super.key, required this.refusal});

  final PaymentRefusal refusal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final r = refusal;
    String money(int m) => Tnd.format(m, currency: l10n.currency);
    final accepted = r.acceptedTypes.map((t) => t.label(l10n)).toList();
    final firstAccepted = r.acceptedTypes.first;
    final (title, message, tip, action, onAction) = switch (r.reason) {
      RefusalReason.typeNotAccepted => (
        l10n.refusedTypeTitle,
        l10n.refusedTypeMessage(r.merchantName, r.balanceType.label(l10n)),
        l10n.refusedTypeTip(joinOr(l10n, accepted)),
        l10n.refusedTypeAction(firstAccepted.label(l10n)),
        () => context.go('${Routes.pay}?type=${firstAccepted.name}'),
      ),
      RefusalReason.insufficientFunds => (
        l10n.refusedFundsTitle,
        l10n.refusedFundsMessage(
          money(r.missing ?? 0),
          r.balanceType.label(l10n),
        ),
        l10n.refusedFundsTip(money(r.balance)),
        l10n.refusedFundsAction(Tnd.format(r.balance, currency: null)),
        () => context.go('${Routes.pay}?type=${r.balanceType.name}'),
      ),
      RefusalReason.merchantInactive => (
        l10n.refusedMerchantTitle,
        l10n.refusedMerchantMessage(r.merchantName),
        l10n.refusedMerchantTip(r.balanceType.label(l10n)),
        l10n.refusedMerchantAction,
        () => context.go(Routes.discover),
      ),
      RefusalReason.codeExpired => (
        l10n.refusedExpiredTitle,
        l10n.refusedExpiredMessage,
        l10n.refusedExpiredTip,
        l10n.refusedExpiredAction,
        () => context.go('${Routes.pay}?type=${r.balanceType.name}'),
      ),
    };
    return FpScreen(
      top: FpSpace.x20,
      gap: FpSpace.x22,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x20),
          child: Column(
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: const BoxDecoration(
                  color: FpColors.dangerTint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const FpIcon(
                  FpIcons.close,
                  size: 48,
                  color: FpColors.danger,
                  strokeWidth: 2.4,
                ),
              ),
              const SizedBox(height: FpSpace.x18),
              const Stamp(kind: StampKind.refused, size: 32),
            ],
          ),
        ),
        Column(
          children: [
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
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
                message,
                textAlign: TextAlign.center,
                style: FpText.body(color: FpColors.inkSoft, height: 1.5),
              ),
            ),
          ],
        ),
        Semantics(
          label: l10n.detail,
          container: true,
          child: FpCard(
            child: Column(
              children: [
                DetailLine(label: l10n.merchantLabel, value: r.merchantName),
                const SizedBox(height: FpSpace.x12),
                DetailLine(
                  label: l10n.requestedAmount,
                  value: money(r.requested),
                ),
                const SizedBox(height: FpSpace.x12),
                DetailLine(
                  label: l10n.yourBalance,
                  value: '${r.balanceType.label(l10n)} ${money(r.balance)}',
                ),
                const SizedBox(height: FpSpace.x12),
                Container(height: 1, color: FpColors.divider),
                const SizedBox(height: FpSpace.x12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FpIcon(
                      FpIcons.info,
                      size: 18,
                      color: FpColors.greenDark,
                    ),
                    const SizedBox(width: FpSpace.x10),
                    Expanded(
                      child: Text(
                        tip,
                        style: FpText.body(
                          size: 13,
                          color: FpColors.inkSoft,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        FpButton(label: action, onPressed: onAction),
        FpButton(
          label: l10n.backHome,
          variant: FpButtonVariant.secondary,
          onPressed: () => context.go(Routes.home),
        ),
      ],
    );
  }
}
