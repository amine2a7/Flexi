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
    String typeLabel(CreditType? t) => t?.label(l10n) ?? '';
    final merchant = r.merchantName ?? '';
    final accepted = r.acceptedTypes.map((t) => t.label(l10n)).toList();
    void retry() => context.go(Routes.pay);
    final (title, message, tip, action, onAction) = switch (r.reason) {
      RefusalReason.typeNotAccepted => (
        l10n.refusedTypeTitle,
        l10n.refusedTypeMessage(merchant, typeLabel(r.balanceType)),
        accepted.isEmpty
            ? l10n.refusedNothingDebited
            : l10n.refusedTypeTip(joinOr(l10n, accepted)),
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.insufficientFunds => (
        l10n.refusedFundsTitle,
        l10n.refusedFundsMessage(
          money(r.missing ?? 0),
          typeLabel(r.balanceType),
        ),
        l10n.refusedFundsTip(money(r.balance ?? 0)),
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.merchantInactive => (
        l10n.refusedMerchantTitle,
        l10n.refusedMerchantMessage(merchant),
        r.balanceType == null
            ? l10n.refusedNothingDebited
            : l10n.refusedMerchantTip(typeLabel(r.balanceType)),
        l10n.refusedMerchantAction,
        () => context.go(Routes.discover),
      ),
      RefusalReason.codeExpired => (
        l10n.refusedExpiredTitle,
        l10n.refusedExpiredMessage,
        l10n.refusedExpiredTip,
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.alreadyPaid => (
        l10n.refusedPaidTitle,
        l10n.refusedPaidMessage,
        l10n.refusedNothingDebited,
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.stickerInvalid => (
        l10n.refusedStickerTitle,
        l10n.refusedStickerMessage,
        l10n.refusedNothingDebited,
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.noPendingCheckout => (
        l10n.refusedNoPendingTitle,
        l10n.refusedNoPendingMessage,
        l10n.refusedNothingDebited,
        l10n.refusedTryAgain,
        retry,
      ),
      RefusalReason.familyLimit => (
        l10n.refusedFamilyTitle,
        l10n.refusedFamilyMessage(money(r.missing ?? 0)),
        l10n.refusedNothingDebited,
        l10n.refusedTryAgain,
        retry,
      ),
    };
    final details = <Widget>[
      if (r.merchantName != null)
        DetailLine(label: l10n.merchantLabel, value: merchant),
      if (r.requested case final requested?)
        DetailLine(label: l10n.requestedAmount, value: money(requested)),
      if ((r.balanceType, r.balance) case (final type?, final balance?))
        DetailLine(
          label: l10n.yourBalance,
          value: '${type.label(l10n)} ${money(balance)}',
        ),
    ];
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
                for (final d in details) ...[
                  d,
                  const SizedBox(height: FpSpace.x12),
                ],
                if (details.isNotEmpty) ...[
                  Container(height: 1, color: FpColors.divider),
                  const SizedBox(height: FpSpace.x12),
                ],
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
