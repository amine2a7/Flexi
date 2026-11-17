import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../domain/collect.dart';

/// Encaisser : le caissier saisit le montant et le type, puis le client paie avec
/// l'autocollant de la caisse (NFC, QR ou code court).
class CollectScreen extends ConsumerStatefulWidget {
  const CollectScreen({super.key});

  @override
  ConsumerState<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends ConsumerState<CollectScreen> {
  CreditType? _type;
  final _amount = TextEditingController();
  String? _idempotencyKey;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _request() async {
    final amount = Tnd.parse(_amount.text);
    final type = _type;
    if (amount == null || amount <= 0 || type == null) return;
    // Une clé par demande : un nouvel essai après une coupure réutilise la même clé.
    final key = _idempotencyKey ??= newIdempotencyKey();
    setState(() => _busy = true);
    try {
      final checkout = await ref
          .read(collectRepositoryProvider)
          .request(amount: amount, type: type, idempotencyKey: key);
      _idempotencyKey = null;
      if (!mounted) return;
      _amount.clear();
      // Sans attendre : l'écran d'attente peut être remplacé (résultat, nouvelle demande).
      unawaited(context.push(ProRoutes.waiting, extra: checkout));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final session = ref.watch(authControllerProvider).session;
    final register = ref.watch(myRegisterProvider).value;
    final types =
        ref.watch(acceptedTypesProvider).value ?? const <CreditType>[];
    _type ??= types.isEmpty ? null : types.first;
    final amount = Tnd.parse(_amount.text);
    final canRequest =
        register != null && amount != null && amount > 0 && !_busy;
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(
          overline: l10n.cashRegisterOf(session?.firstName ?? ''),
          title: l10n.collectTitle,
        ),
        if (register != null)
          Row(
            children: [
              TagChip(
                label: '${l10n.myRegister} · ${register.name}',
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                dot: FpColors.green,
              ),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.amountLabel, style: FpText.label),
            const SizedBox(height: FpSpace.x8),
            Container(
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.x18),
              decoration: BoxDecoration(
                color: FpColors.surface,
                borderRadius: BorderRadius.circular(FpRadius.key),
                border: Border.all(color: FpColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: l10n.amountLabel,
                      child: TextField(
                        key: const Key('collect-amount'),
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        style: FpText.display(size: 48, color: FpColors.navy),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    l10n.currency,
                    style: FpText.display(size: 22, color: FpColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        Semantics(
          label: l10n.creditTypeLabel,
          container: true,
          child: Row(
            children: [
              for (final (i, t) in types.indexed) ...[
                if (i > 0) const SizedBox(width: FpSpace.x8),
                Expanded(
                  child: TypeOption(
                    label: t.label(l10n),
                    color: t.color,
                    selected: t == _type,
                    height: 46,
                    onTap: () => setState(() => _type = t),
                  ),
                ),
              ],
            ],
          ),
        ),
        FpButton(
          label: l10n.requestPayment(
            Tnd.format(amount ?? 0, currency: l10n.currency),
          ),
          icon: FpIcons.nfc,
          onPressed: canRequest ? _request : null,
        ),
      ],
    );
  }
}
