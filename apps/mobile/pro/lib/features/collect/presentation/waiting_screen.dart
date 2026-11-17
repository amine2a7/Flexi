import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_providers.dart';
import '../domain/collect.dart';

/// « En attente du client… » : code court, compte à rebours de 120 s, puis le résultat
/// reçu en temps réel (approuvé ou refusé, avec le prénom du client).
class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key, required this.checkout});

  final TillCheckout checkout;

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  late int _left = widget.checkout.validity.inSeconds;
  CheckoutStatus _status = CheckoutStatus.pending;
  Timer? _timer;
  StreamSubscription<TillCheckout>? _events;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _events = ref
        .read(collectRepositoryProvider)
        .watch(widget.checkout.id)
        .listen(_update);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _events?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted || _status != CheckoutStatus.pending) return;
    setState(() => _left = _left > 0 ? _left - 1 : 0);
    if (_left == 0) _stop(CheckoutStatus.expired);
  }

  void _stop(CheckoutStatus status) {
    _timer?.cancel();
    _events?.cancel();
    setState(() => _status = status);
  }

  void _update(TillCheckout c) {
    if (!mounted) return;
    switch (c.status) {
      case CheckoutStatus.paid || CheckoutStatus.refused:
        _timer?.cancel();
        refreshMerchant(ref);
        context.pushReplacement(ProRoutes.result, extra: c);
      case CheckoutStatus.expired || CheckoutStatus.cancelled:
        _stop(c.status);
      case CheckoutStatus.pending:
        break;
    }
  }

  Future<void> _cancel() async {
    await ref.read(collectRepositoryProvider).cancel(widget.checkout.id);
    if (mounted) _stop(CheckoutStatus.cancelled);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final c = widget.checkout;
    final pending = _status == CheckoutStatus.pending;
    final total = c.validity.inSeconds;
    final clock = '${_left ~/ 60}:${(_left % 60).toString().padLeft(2, '0')}';
    return PopScope(
      canPop: !pending,
      child: FpScreen(
        top: FpSpace.x24,
        gap: FpSpace.x18,
        children: [
          Column(
            children: [
              CapsLabel(c.registerName),
              const SizedBox(height: FpSpace.x10),
              AmountText(c.amount, size: 52, currencySize: 20),
              const SizedBox(height: FpSpace.x10),
              TagChip(
                label: c.type.label(l10n),
                tint: c.type.tint,
                color: c.type.color,
                height: 28,
              ),
            ],
          ),
          FpCard(
            child: Column(
              children: [
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    switch (_status) {
                      CheckoutStatus.expired => l10n.requestExpiredTitle,
                      CheckoutStatus.cancelled => l10n.requestCancelledTitle,
                      _ => l10n.waitingCustomer,
                    },
                    textAlign: TextAlign.center,
                    style: FpText.body(
                      size: 20,
                      weight: FontWeight.w700,
                      color: pending ? FpColors.navy : FpColors.danger,
                    ),
                  ),
                ),
                if (pending) ...[
                  const SizedBox(height: FpSpace.x8),
                  Text(
                    l10n.waitingHint,
                    textAlign: TextAlign.center,
                    style: FpText.body(
                      size: 14,
                      color: FpColors.muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: FpSpace.x18),
                  CapsLabel(l10n.shortCodeLabel),
                  const SizedBox(height: FpSpace.x6),
                  Semantics(
                    label: l10n.shortCodeLabel,
                    value: c.shortCode.split('').join(' '),
                    container: true,
                    child: ExcludeSemantics(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          c.shortCode.split('').join(' '),
                          style: FpText.display(
                            size: 48,
                            color: FpColors.navy,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FpSpace.x16),
                  Row(
                    children: [
                      Expanded(
                        child: FpProgressBar(
                          value: total == 0 ? 0 : _left / total,
                          color: _left <= 20 ? FpColors.danger : FpColors.green,
                          height: 8,
                          animate: true,
                        ),
                      ),
                      const SizedBox(width: FpSpace.x12),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(clock, style: FpText.display(size: 20)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          if (pending)
            FpButton(
              label: l10n.cancelRequest,
              variant: FpButtonVariant.secondary,
              onPressed: _cancel,
            )
          else
            FpButton(
              label: l10n.newRequest,
              onPressed: () => context.go(ProRoutes.collect),
            ),
        ],
      ),
    );
  }
}
