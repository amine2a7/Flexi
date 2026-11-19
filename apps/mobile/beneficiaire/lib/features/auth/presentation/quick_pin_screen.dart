import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/pending_link.dart';
import '../../../app/routes.dart';

/// Connexion de tous les jours : PIN ou empreinte.
class QuickPinScreen extends ConsumerStatefulWidget {
  const QuickPinScreen({super.key});

  @override
  ConsumerState<QuickPinScreen> createState() => _QuickPinScreenState();
}

class _QuickPinScreenState extends ConsumerState<QuickPinScreen> {
  String _pin = '';
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (ref.read(authControllerProvider).session == null) {
      ref.read(authControllerProvider.notifier).restore();
    }
  }

  /// Accueil, puis le lien d'autocollant ouvert pendant que l'app était verrouillée.
  void _enterApp() {
    context.go(Routes.home);
    final link = ref.read(pendingLinkProvider.notifier).take();
    if (link == null) return;
    final router = ref.read(routerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) => router.push(link));
  }

  Future<void> _enter() async {
    setState(() => _busy = true);
    final pin = _pin;
    _pin = '';
    final failure = await ref
        .read(authControllerProvider.notifier)
        .verifyPin(pin);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (failure) {
      case null:
        _enterApp();
      // Après le 4e blocage, seule une connexion complète débloque le PIN.
      case AccountLockedFailure(level: >= 4):
        await ref.read(authControllerProvider.notifier).logout();
        if (mounted) context.go(Routes.login);
      case AccountLockedFailure():
        context.go(Routes.locked);
      case PinRefusedFailure(:final remainingAttempts):
        setState(() => _error = FpL10n.of(context).pinWrong(remainingAttempts));
      default:
        setState(() => _error = FpL10n.of(context).genericError);
    }
  }

  Future<void> _biometric() async {
    final l10n = FpL10n.of(context);
    final ok = await ref
        .read(biometricServiceProvider)
        .authenticate(l10n.biometricReason);
    if (!ok || !mounted) return;
    if (await ref.read(authControllerProvider.notifier).unlockWithDevice() &&
        mounted) {
      _enterApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final session = ref.watch(authControllerProvider).session;
    final name = session?.firstName ?? '';
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x12),
          child: Column(
            children: [
              Avatar(
                initial: name.isEmpty ? '' : name[0],
                color: FpColors.food,
                size: 72,
              ),
              const SizedBox(height: FpSpace.x10),
              Semantics(
                header: true,
                child: Text(
                  l10n.welcomeBack(name),
                  textAlign: TextAlign.center,
                  style: FpText.display(size: 34, color: FpColors.navy),
                ),
              ),
              const SizedBox(height: FpSpace.x10),
              Text(
                l10n.quickLoginSubtitle,
                style: FpText.body(size: 14, color: FpColors.muted),
              ),
            ],
          ),
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
          onBiometric: _biometric,
        ),
        FpButton(
          label: l10n.enter,
          onPressed: _pin.length == 4 && !_busy ? _enter : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: FpLink(
                label: l10n.useEmail,
                onTap: () => context.go(Routes.login),
              ),
            ),
            const SizedBox(width: FpSpace.x12),
            Flexible(
              child: FpLink(
                label: l10n.forgotPin,
                onTap: () => context.go(Routes.login),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
