import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import 'checkout_opener.dart';

/// Lien de l'autocollant ouvert par le système (App Links Android, Universal Links iPhone).
class StickerLinkScreen extends ConsumerStatefulWidget {
  const StickerLinkScreen({super.key, required this.link});

  final StickerLink link;

  @override
  ConsumerState<StickerLinkScreen> createState() => _StickerLinkScreenState();
}

class _StickerLinkScreenState extends ConsumerState<StickerLinkScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await openCheckout(
        context,
        ref,
        (repo) => repo.bySticker(widget.link),
        replace: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return Scaffold(
      backgroundColor: FpColors.background,
      body: Center(
        child: Semantics(
          liveRegion: true,
          child: Text(
            l10n.payStickerRead,
            style: FpText.body(size: 16, weight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
