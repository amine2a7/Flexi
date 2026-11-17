import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../domain/payment.dart';

/// Confirmation du paiement par PIN (vérifié par le serveur, jamais stocké).
class ConfirmPinScreen extends ConsumerStatefulWidget {
  const ConfirmPinScreen({super.key, required this.request});

  final PaymentRequest request;

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  String _pin = '';
  String? _error;
  bool _busy = false;

  Future<void> _pay() async {
    final pin = _pin;
    setState(() {
      _busy = true;
      _pin = '';
    });
    try {
      final receipt = await ref
          .read(paymentRepositoryProvider)
          .confirm(widget.request, pin);
      refreshMoney(ref);
      if (mounted) context.go(Routes.payApproved, extra: receipt);
    } on PaymentRefusedException catch (e) {
      if (mounted) context.go(Routes.payRefused, extra: e.refusal);
    } on PinRefusedFailure catch (e) {
      if (mounted) {
        setState(
          () => _error = FpL10n.of(context).pinWrong(e.remainingAttempts),
        );
      }
    } on NetworkFailure {
      ref.read(connectivityProvider.notifier).setOnline(false);
      if (mounted) context.go(Routes.home);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final r = widget.request;
    final amount = Tnd.format(r.amount, currency: l10n.currency);
    return FpScreen(
      gap: FpSpace.x14,
      children: [
        ScreenHeader(title: l10n.confirmTitle, onBack: () => context.pop()),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          style: FpText.body(size: 16, weight: FontWeight.w700),
                        ),
                        Text(
                          l10n.cashierOf(r.cashier, r.city),
                          style: FpText.body(size: 13, color: FpColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FpSpace.x14),
              const DashedLine(),
              const SizedBox(height: FpSpace.x14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CapsLabel(l10n.amountLabel),
                        const SizedBox(height: FpSpace.x4),
                        AmountText(r.amount, size: 48, currencySize: 18),
                      ],
                    ),
                  ),
                  TagChip(
                    label: r.type.label(l10n),
                    tint: r.type.tint,
                    color: r.type.color,
                    height: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          l10n.enterPinToPay,
          textAlign: TextAlign.center,
          style: FpText.body(size: 14, color: FpColors.muted),
        ),
        PinDots(filled: _pin.length),
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: FpText.body(size: 13, color: FpColors.danger),
            ),
          ),
        PinPad(
          onDigit: (d) {
            if (_pin.length < 4) {
              setState(() {
                _pin += d;
                _error = null;
              });
            }
          },
          onDelete: () {
            if (_pin.isNotEmpty) {
              setState(() => _pin = _pin.substring(0, _pin.length - 1));
            }
          },
        ),
        FpButton(
          label: l10n.payAmount(amount),
          onPressed: _pin.length == 4 && !_busy ? _pay : null,
        ),
        if (ref.watch(appConfigProvider).demo)
          Center(
            child: FpLink(
              label: l10n.seeRefusalExample,
              size: 13,
              onTap: () => context.push(
                Routes.payRefused,
                extra: PaymentRefusal(
                  reason: RefusalReason.typeNotAccepted,
                  merchantName: r.merchantName,
                  requested: r.amount,
                  balanceType: CreditType.fuel,
                  balance: 40000,
                  acceptedTypes: const [
                    CreditType.food,
                    CreditType.clothing,
                    CreditType.gifts,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
