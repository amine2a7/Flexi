import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../collect/domain/collect.dart';
import '../data/sticker_writer.dart';

/// Associer un autocollant : écrit le lien signé de la caisse sur la puce NFC.
class StickerScreen extends ConsumerStatefulWidget {
  const StickerScreen({super.key, required this.register});

  final TillRegister register;

  @override
  ConsumerState<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends ConsumerState<StickerScreen> {
  late final StickerWriter _writer = ref.read(stickerWriterProvider);

  /// `null` : en attente de l'autocollant.
  bool? _written;
  bool _nfc = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _writer.stop();
    super.dispose();
  }

  Future<void> _start() async {
    final available = await _writer.isAvailable();
    if (!mounted) return;
    setState(() {
      _nfc = available;
      _written = null;
    });
    if (!available) return;
    final url = await ref
        .read(collectRepositoryProvider)
        .stickerUrl(widget.register.id);
    if (!mounted) return;
    final ok = await _writer.write(
      url,
      iosMessage: FpL10n.of(context).stickerApproach,
    );
    if (mounted) setState(() => _written = ok);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final name = widget.register.name;
    final demo = ref.watch(appConfigProvider).demo;
    final failed = _written == false;
    final card = FpCard(
      padding: const EdgeInsets.all(FpSpace.x24),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: failed ? FpColors.dangerTint : FpColors.greenTint,
              shape: BoxShape.circle,
            ),
            child: FpIcon(
              switch (_written) {
                true => FpIcons.check,
                false => FpIcons.close,
                null => FpIcons.nfc,
              },
              size: 44,
              color: failed ? FpColors.danger : FpColors.greenDark,
            ),
          ),
          const SizedBox(height: FpSpace.x18),
          Semantics(
            liveRegion: true,
            child: Text(
              switch (_written) {
                true => l10n.stickerWritten(name),
                false => l10n.stickerWriteFailed,
                null => l10n.stickerApproach,
              },
              textAlign: TextAlign.center,
              style: FpText.body(
                size: 18,
                weight: FontWeight.w700,
                color: FpColors.navy,
              ),
            ),
          ),
          if (_written == null) ...[
            const SizedBox(height: FpSpace.x8),
            Text(
              l10n.stickerApproachHint(name),
              textAlign: TextAlign.center,
              style: FpText.body(size: 14, color: FpColors.muted),
            ),
          ],
        ],
      ),
    );
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.registerSticker, onBack: () => context.pop()),
        // Démonstration (émulateur sans NFC) : un appui simule l'écriture.
        if (demo && _written == null)
          FpPressable(
            semanticLabel: l10n.stickerApproach,
            onTap: () => setState(() => _written = true),
            child: card,
          )
        else
          card,
        if (!_nfc && !demo)
          InfoBanner(
            text: l10n.payNfcUnavailable,
            icon: FpIcons.info,
            tint: FpColors.warningTint,
            iconColor: FpColors.warningIcon,
          ),
        const Spacer(),
        if (_written ?? false)
          FpButton(label: l10n.registersTitle, onPressed: () => context.pop())
        else if (failed)
          FpButton(label: l10n.refusedTryAgain, onPressed: _start),
      ],
    );
  }
}
