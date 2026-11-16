import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Bienvenue en 3 étapes.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  Future<void> _finish() async {
    await ref.read(secureStoreProvider).write(SecureKey.onboardingDone, '1');
    if (mounted) context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final steps = [
      (
        l10n.onboarding1Title,
        l10n.onboarding1Text,
        FpColors.greenTint,
        FpColors.greenDark,
        FpIcons.wallet,
      ),
      (
        l10n.onboarding2Title,
        l10n.onboarding2Text,
        FpColors.clothingTint,
        FpColors.clothing,
        FpIcons.qr,
      ),
      (
        l10n.onboarding3Title,
        l10n.onboarding3Text,
        FpColors.giftsTint,
        FpColors.gifts,
        FpIcons.family,
      ),
    ];
    final (title, text, tint, color, icon) = steps[_step];
    final duration = FpMotion.of(context, FpMotion.slow);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: l10n.brandFlexi),
                          TextSpan(
                            text: l10n.brandPay,
                            style: FpText.display(
                              size: 26,
                              color: FpColors.greenDark,
                            ),
                          ),
                        ],
                      ),
                      style: FpText.display(size: 26, color: FpColors.navy),
                    ),
                  ),
                  FpLink(label: l10n.onboardingSkip, onTap: _finish),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: duration,
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        color: tint,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Opacity(
                        opacity: 1,
                        child: DashedBorderBox(
                          radius: 98,
                          color: color.withValues(alpha: 0.4),
                          strokeWidth: 2,
                          child: Center(
                            child: FpIcon(
                              icon,
                              size: 96,
                              color: color,
                              strokeWidth: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: FpText.display(
                          size: 38,
                          color: FpColors.navy,
                          height: 1.02,
                        ),
                      ),
                    ),
                    const SizedBox(height: FpSpace.x10),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: FpText.body(
                        size: 15,
                        color: FpColors.muted,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(width: FpSpace.x8),
                    AnimatedContainer(
                      duration: duration,
                      height: 8,
                      width: i == _step ? 28 : 8,
                      decoration: BoxDecoration(
                        color: i == _step ? FpColors.navy : FpColors.dash,
                        borderRadius: BorderRadius.circular(FpRadius.pill),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: FpSpace.x24),
              if (_step < steps.length - 1)
                FpButton(
                  label: l10n.onboardingNext,
                  onPressed: () => setState(() => _step++),
                )
              else
                FpButton(label: l10n.onboardingLogin, onPressed: _finish),
            ],
          ),
        ),
      ),
    );
  }
}
