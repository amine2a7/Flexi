import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Ouverture : mascotte, logo, chargement, puis Bienvenue, Connexion ou PIN.
/// Un appui long sur le logo ouvre le catalogue caché.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), _next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _next() async {
    if (_leaving) return;
    _leaving = true;
    _timer?.cancel();
    final store = ref.read(secureStoreProvider);
    final onboarded = await store.read(SecureKey.onboardingDone) != null;
    final known = await ref.read(authControllerProvider.notifier).restore();
    if (!mounted) return;
    if (!onboarded) {
      context.go(Routes.onboarding);
    } else if (known != null) {
      context.go(Routes.unlock);
    } else {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return Scaffold(
      backgroundColor: FpColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
          child: Column(
            children: [
              const Spacer(),
              const Mascot(size: 140),
              const SizedBox(height: 22),
              GestureDetector(
                onLongPress: () {
                  _timer?.cancel();
                  context.push(Routes.catalog);
                },
                child: Semantics(
                  header: true,
                  label: l10n.appName,
                  excludeSemantics: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: l10n.brandFlexi),
                        TextSpan(
                          text: l10n.brandPay,
                          style: FpText.display(
                            size: 64,
                            color: FpColors.green,
                          ),
                        ),
                      ],
                    ),
                    style: FpText.display(size: 64, color: FpColors.surface),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: FpText.body(size: 16, color: FpColors.onNavyMuted),
              ),
              const Spacer(),
              _Loader(label: l10n.loading),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _next,
                child: Padding(
                  padding: const EdgeInsets.all(FpSpace.x12),
                  child: Text(
                    l10n.continueAction,
                    style: FpText.body(
                      size: 13,
                      color: FpColors.onNavyMuted,
                    ).copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Loader extends StatefulWidget {
  const _Loader({required this.label});

  final String label;

  @override
  State<_Loader> createState() => _LoaderState();
}

class _LoaderState extends State<_Loader> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (FpMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FpRadius.pill),
        child: Container(
          width: 140,
          height: 6,
          color: FpColors.onNavyTrack,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final t = FpMotion.curve.transform(_c.value);
              return Transform.translate(
                offset: Offset(-56 + t * 196, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 56,
                    decoration: BoxDecoration(
                      color: FpColors.green,
                      borderRadius: BorderRadius.circular(FpRadius.pill),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
