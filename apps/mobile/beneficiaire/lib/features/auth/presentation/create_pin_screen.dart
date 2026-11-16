import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';

/// Création (ou changement) du PIN à 4 chiffres. Le PIN part au serveur, rien n'est stocké.
class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key, this.change = false});

  /// Depuis Profil › Changer mon PIN.
  final bool change;

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _pin = '';
  bool _biometric = true;
  bool _busy = false;

  Future<void> _continue() async {
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).createPin(_pin);
      _pin = '';
      ref
          .read(profilePrefsProvider.notifier)
          .update(
            ref.read(profilePrefsProvider).copyWith(biometric: _biometric),
          );
      if (!mounted) return;
      if (widget.change) {
        context.pop();
      } else {
        context.go(Routes.home);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final full = _pin.length == 4;
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        ScreenHeader(
          title: widget.change ? l10n.changePin : l10n.createPinStep,
          onBack: () =>
              widget.change ? context.pop() : context.go(Routes.newPassword),
        ),
        Column(
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.createPinTitle,
                style: FpText.display(size: 36, color: FpColors.navy),
              ),
            ),
            const SizedBox(height: FpSpace.x8),
            Text(
              l10n.createPinSubtitle,
              style: FpText.body(size: 14, color: FpColors.muted),
            ),
          ],
        ),
        PinDots(filled: _pin.length),
        PinPad(
          onDigit: (d) {
            if (_pin.length < 4) setState(() => _pin += d);
          },
          onDelete: () {
            if (_pin.isNotEmpty) {
              setState(() => _pin = _pin.substring(0, _pin.length - 1));
            }
          },
        ),
        FpButton(
          label: l10n.continueAction,
          onPressed: full && !_busy ? _continue : null,
        ),
        if (!widget.change)
          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _biometric,
                  activeColor: FpColors.greenDark,
                  onChanged: (v) => setState(() => _biometric = v ?? false),
                ),
                Flexible(
                  child: Text(
                    l10n.enableBiometric,
                    style: FpText.body(size: 14, weight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
