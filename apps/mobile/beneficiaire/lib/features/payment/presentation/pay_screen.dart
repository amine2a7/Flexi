import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../domain/payment.dart';

/// Payer : choix du crédit, QR et code à 6 chiffres renouvelés toutes les 60 s.
class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key, this.initialType});

  final CreditType? initialType;

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  CreditType? _type;
  CreditType? _requestedFor;
  PaymentCode? _code;
  int _left = 60;
  Timer? _timer;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted || _code == null) return;
    if (_left <= 1) {
      _renew();
    } else {
      setState(() => _left--);
    }
  }

  Future<void> _renew() async {
    final type = _type;
    if (type == null) return;
    try {
      final code = await ref.read(paymentRepositoryProvider).createCode(type);
      if (mounted) {
        setState(() {
          _code = code;
          _left = code.validity.inSeconds;
        });
      }
    } on NetworkFailure {
      _offline();
    }
  }

  void _offline() {
    ref.read(connectivityProvider.notifier).setOnline(false);
    if (mounted) context.go(Routes.home);
  }

  Future<void> _scanned() async {
    final code = _code;
    if (code == null) return;
    setState(() => _busy = true);
    try {
      final request = await ref
          .read(paymentRepositoryProvider)
          .pendingRequest(code);
      if (mounted) context.push(Routes.payConfirm, extra: request);
    } on PaymentRefusedException catch (e) {
      if (mounted) context.push(Routes.payRefused, extra: e.refusal);
    } on NetworkFailure {
      _offline();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final credits = ref.watch(walletProvider).value?.credits ?? const [];
    if (_type == null && credits.isNotEmpty) _type = credits.first.type;
    if (_type != null && _requestedFor != _type) {
      _requestedFor = _type;
      Future.microtask(_renew);
    }
    final type = _type;
    final code = _code?.type == type ? (_code?.code ?? '') : '';
    final shown = code.length == 6
        ? '${code.substring(0, 3)} ${code.substring(3)}'
        : code;
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.payTitle, onBack: () => context.pop()),
        Semantics(
          label: l10n.creditTypeLabel,
          container: true,
          child: Row(
            children: [
              for (final (i, c) in credits.indexed) ...[
                if (i > 0) const SizedBox(width: FpSpace.x10),
                Expanded(
                  child: TypeOption(
                    label: c.type.label(l10n),
                    color: c.type.color,
                    selected: c.type == type,
                    onTap: () => setState(() => _type = c.type),
                    amount: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        Tnd.format(c.balance, currency: l10n.currency),
                        style: FpText.display(size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (type != null)
          FpRise(
            child: Semantics(
              label: l10n.myPaymentCode,
              container: true,
              child: TicketCard(
                padding: FpSpace.x22,
                top: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: type.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: FpSpace.x8),
                        Text(
                          l10n.ticketOf(type.label(l10n)).toUpperCase(),
                          style: FpText.caps().copyWith(letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: FpSpace.x16),
                    if (code.isNotEmpty)
                      PaymentQr(
                        data: 'flexipay:$code',
                        semanticLabel: l10n.qrLabel,
                      ),
                    const SizedBox(height: FpSpace.x16),
                    Text(l10n.orGiveCode, style: FpText.small),
                    const SizedBox(height: FpSpace.x2),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        shown,
                        style: FpText.display(
                          size: 44,
                          color: FpColors.navy,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
                bottom: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FpProgressBar(
                            value: _left / 60,
                            color: _left <= 10
                                ? FpColors.danger
                                : FpColors.green,
                            height: 8,
                            animate: true,
                          ),
                        ),
                        const SizedBox(width: FpSpace.x12),
                        SizedBox(
                          width: 52,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '0:${_left.toString().padLeft(2, '0')}',
                              textAlign: TextAlign.right,
                              style: FpText.display(size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FpSpace.x16),
                    Text(l10n.codeRenews, style: FpText.small),
                  ],
                ),
              ),
            ),
          ),
        FpButton(
          label: l10n.cashierScanned,
          onPressed: code.isEmpty || _busy ? null : _scanned,
        ),
        Text(
          l10n.showTicketHint,
          textAlign: TextAlign.center,
          style: FpText.body(size: 13, color: FpColors.muted),
        ),
      ],
    );
  }
}
