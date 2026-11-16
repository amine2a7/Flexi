import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/formatters.dart';
import '../domain/payment.dart';

/// Paiement approuvé : reçu en forme de ticket et tampon APPROUVÉ animé.
class ApprovedScreen extends ConsumerWidget {
  const ApprovedScreen({super.key, required this.receipt});

  final PaymentReceipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final dates = Dates(context, ref.watch(clockProvider)());
    final r = receipt;
    Widget cell(String label, Widget value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FpText.small),
        const SizedBox(height: FpSpace.x4),
        value,
      ],
    );
    final bold = FpText.body(weight: FontWeight.w700);
    // Le tampon chevauche le bas du ticket de 32 px.
    const stampOverlap = 32.0;
    const stampHeight = 64.0;
    return FpScreen(
      top: FpSpace.x20,
      gap: FpSpace.x22,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: stampHeight - stampOverlap,
              ),
              child: FpRise(
                child: Semantics(
                  label: l10n.receiptLabel,
                  container: true,
                  child: TicketCard(
                    top: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconTile(
                              tint: r.type.tint,
                              color: r.type.color,
                              text: r.merchantName[0],
                              size: 48,
                            ),
                            const SizedBox(width: FpSpace.x12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.merchantName,
                                    style: FpText.body(
                                      size: 17,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    l10n.cashierAt(
                                      r.cashier,
                                      '${dates.shortDate(r.date)} ${dates.time(r.date)}',
                                    ),
                                    style: FpText.body(
                                      size: 13,
                                      color: FpColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: FpSpace.x16),
                        CapsLabel(l10n.paidAmount),
                        const SizedBox(height: FpSpace.x4),
                        AmountText(
                          r.amount,
                          size: 72,
                          currencySize: 27,
                          color: FpColors.navy,
                        ),
                      ],
                    ),
                    bottom: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: cell(
                                  l10n.typeLabel,
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: r.type.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: FpSpace.x6),
                                      Flexible(
                                        child: Text(
                                          r.type.label(l10n),
                                          style: bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: cell(
                                  l10n.remaining,
                                  Text(
                                    Tnd.format(
                                      r.remaining,
                                      currency: l10n.currency,
                                    ),
                                    style: bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: FpSpace.x14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: cell(
                                  l10n.reference,
                                  Text(r.reference, style: bold),
                                ),
                              ),
                              Expanded(
                                child: cell(
                                  l10n.paidBy,
                                  Text(r.paidBy, style: bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Stamp(
              kind: StampKind.approved,
              background: FpColors.background,
            ),
          ],
        ),
        FpRise(
          delay: const Duration(milliseconds: 240),
          child: Column(
            children: [
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(
                  l10n.approvedTitle,
                  style: FpText.body(
                    size: 24,
                    weight: FontWeight.w700,
                    color: FpColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: FpSpace.x6),
              Text(
                l10n.approvedText(r.paidBy),
                textAlign: TextAlign.center,
                style: FpText.muted14,
              ),
            ],
          ),
        ),
        const Spacer(),
        FpButton(label: l10n.done, onPressed: () => context.go(Routes.home)),
        FpButton(
          label: l10n.shareReceipt,
          icon: FpIcons.share,
          variant: FpButtonVariant.secondary,
          onPressed: () => context.push(Routes.receipt(r.operationId)),
        ),
      ],
    );
  }
}
