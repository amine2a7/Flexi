import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../data/nfc_reader.dart';
import 'checkout_opener.dart';

/// Payer : le client approche son téléphone de l'autocollant NFC de la caisse, ou scanne
/// le QR imprimé, ou tape le code à 4 chiffres affiché en caisse.
class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key});

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  /// `null` tant que la disponibilité du NFC n'est pas connue.
  bool? _nfc;
  bool _busy = false;
  late final StickerReader _reader = ref.read(stickerReaderProvider);

  /// Autocollant simulé des builds de démonstration (émulateur sans NFC).
  static const _demoLink = StickerLink(
    publicId: 'demo-register-r-1',
    signature: 'demo-signature-demo',
  );

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void dispose() {
    _reader.stop();
    super.dispose();
  }

  Future<void> _listen() async {
    final available = await _reader.isAvailable();
    if (!mounted) return;
    setState(() => _nfc = available);
    if (!available) return;
    await _reader.start(
      iosMessage: FpL10n.of(context).payNfcTitle,
      onLink: _read,
    );
  }

  Future<void> _read(StickerLink link) async {
    if (_busy || !mounted) return;
    setState(() => _busy = true);
    await _reader.stop();
    if (!mounted) return;
    await openCheckout(context, ref, (repo) => repo.bySticker(link));
    if (!mounted) return;
    setState(() => _busy = false);
    if (_nfc ?? false) _listen();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final demo = ref.watch(appConfigProvider).demo;
    final card = FpCard(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.x22,
        vertical: FpSpace.x28,
      ),
      child: Column(
        children: [
          _NfcPulse(active: !_busy),
          const SizedBox(height: FpSpace.x22),
          Text(
            _busy ? l10n.payStickerRead : l10n.payNfcTitle,
            textAlign: TextAlign.center,
            style: FpText.body(
              size: 18,
              weight: FontWeight.w700,
              color: FpColors.navy,
            ),
          ),
          const SizedBox(height: FpSpace.x8),
          Text(
            l10n.payNfcHint,
            textAlign: TextAlign.center,
            style: FpText.body(size: 14, color: FpColors.muted, height: 1.5),
          ),
        ],
      ),
    );
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.payTitle, onBack: () => context.pop()),
        FpRise(
          child: demo
              ? FpPressable(
                  semanticLabel: l10n.payNfcTitle,
                  onTap: () => _read(_demoLink),
                  child: card,
                )
              : Semantics(container: true, liveRegion: true, child: card),
        ),
        if (_nfc == false)
          InfoBanner(
            text: l10n.payNfcUnavailable,
            icon: FpIcons.info,
            tint: FpColors.warningTint,
            iconColor: FpColors.warningIcon,
          ),
        const Spacer(),
        FpButton(
          label: l10n.payScanQr,
          icon: FpIcons.scan,
          variant: FpButtonVariant.secondary,
          onPressed: _busy ? null : () => context.push(Routes.payScan),
        ),
        FpButton(
          label: l10n.payTypeCode,
          variant: FpButtonVariant.secondary,
          onPressed: _busy ? null : () => context.push(Routes.payCode),
        ),
      ],
    );
  }
}

/// Ondes qui invitent à approcher le téléphone (immobiles si les animations sont réduites).
class _NfcPulse extends StatefulWidget {
  const _NfcPulse({required this.active});

  final bool active;

  @override
  State<_NfcPulse> createState() => _NfcPulseState();
}

class _NfcPulseState extends State<_NfcPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_NfcPulse old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final animate = widget.active && !MediaQuery.disableAnimationsOf(context);
    if (animate && !_c.isAnimating) {
      _c.repeat();
    } else if (!animate && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 168.0;
    const core = 88.0;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              Builder(
                builder: (context) {
                  final t = (_c.value + i / 3) % 1;
                  final d = core + (size - core) * t;
                  return Container(
                    width: d,
                    height: d,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FpColors.green.withValues(
                          alpha: math.max(0, 0.45 * (1 - t)),
                        ),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            Container(
              width: core,
              height: core,
              decoration: const BoxDecoration(
                color: FpColors.greenTint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const FpIcon(
                FpIcons.nfc,
                size: 40,
                color: FpColors.greenDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
