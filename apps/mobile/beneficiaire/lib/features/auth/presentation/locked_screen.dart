import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Compte bloqué après 3 PIN faux : compte à rebours et paliers suivants.
class LockedScreen extends ConsumerStatefulWidget {
  const LockedScreen({super.key});

  @override
  ConsumerState<LockedScreen> createState() => _LockedScreenState();
}

class _LockedScreenState extends ConsumerState<LockedScreen> {
  late final Duration _total =
      ref.read(authControllerProvider).lockedFor ?? const Duration(minutes: 15);
  late int _left = _total.inSeconds - 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_left > 0) setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final mm = (_left ~/ 60).toString().padLeft(2, '0');
    final ss = (_left % 60).toString().padLeft(2, '0');
    final level = switch (_total.inMinutes) {
      30 => 2,
      60 => 3,
      _ => 1,
    };
    final steps = [
      l10n.lockLevel1,
      l10n.lockLevel2,
      l10n.lockLevel3,
      l10n.lockLevel4,
    ];
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x16),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: FpColors.dangerTint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const FpIcon(
                  FpIcons.lock,
                  size: 44,
                  color: FpColors.danger,
                ),
              ),
              const SizedBox(height: FpSpace.x16),
              Semantics(
                header: true,
                child: Text(
                  l10n.lockedTitle,
                  textAlign: TextAlign.center,
                  style: FpText.display(size: 34, color: FpColors.navy),
                ),
              ),
              const SizedBox(height: FpSpace.x16),
              Text(
                l10n.lockedText,
                textAlign: TextAlign.center,
                style: FpText.body(color: FpColors.muted),
              ),
              const SizedBox(height: FpSpace.x16),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '$mm:$ss',
                  style: FpText.display(size: 84, color: FpColors.navy),
                ),
              ),
              const SizedBox(height: FpSpace.x16),
              SizedBox(
                width: 220,
                child: FpProgressBar(
                  value: _left / _total.inSeconds,
                  color: FpColors.danger,
                  height: 8,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CapsLabel(l10n.lockedNext),
              for (var i = 0; i < steps.length; i++) ...[
                const SizedBox(height: FpSpace.x12),
                MergeSemantics(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i + 1 == level
                              ? FpColors.navy
                              : FpColors.surface,
                          border: Border.all(
                            color: i + 1 == level
                                ? FpColors.navy
                                : FpColors.border,
                          ),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: FpText.body(
                            size: 13,
                            weight: FontWeight.w700,
                            color: i + 1 == level
                                ? FpColors.surface
                                : FpColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: FpSpace.x12),
                      Expanded(
                        child: Text(
                          steps[i],
                          style: FpText.body(
                            size: 14,
                            weight: i + 1 == level
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: i + 1 == level
                                ? FpColors.ink
                                : FpColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        FpButton(
          label: l10n.loginWithEmail,
          variant: FpButtonVariant.secondary,
          onPressed: () => context.go(Routes.login),
        ),
        Center(
          child: FpLink(
            label: l10n.contactSupport,
            onTap: () => context.push(Routes.help),
          ),
        ),
      ],
    );
  }
}
