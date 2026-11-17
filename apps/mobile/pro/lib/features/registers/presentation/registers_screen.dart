import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_providers.dart';
import '../../collect/domain/collect.dart';
import '../data/pdf_sharer.dart';

/// Mes caisses (propriétaire) : chaque caisse active reçoit son autocollant NFC, et son
/// autocollant imprimable (PDF 8 × 8 cm) se télécharge d'ici.
class RegistersScreen extends ConsumerWidget {
  const RegistersScreen({super.key});

  Future<void> _download(WidgetRef ref, TillRegister register) async {
    final bytes = await ref
        .read(collectRepositoryProvider)
        .stickerPdf(register.id);
    await ref
        .read(pdfSharerProvider)
        .share(bytes, fileName: 'autocollant-${register.name}.pdf');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final registers =
        ref.watch(registersProvider).value ?? const <TillRegister>[];
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.registersTitle, onBack: () => context.pop()),
        ListGroup(
          children: [
            for (final r in registers)
              ListRow(
                leading: IconTile(
                  tint: r.active ? FpColors.greenTint : FpColors.track,
                  color: r.active ? FpColors.greenDark : FpColors.muted,
                  icon: FpIcons.nfc,
                ),
                title: r.name,
                subtitle: r.active
                    ? l10n.registerSticker
                    : l10n.registerDisabled,
                chevron: r.active,
                onTap: r.active
                    ? () => context.push(ProRoutes.sticker, extra: r)
                    : null,
              ),
          ],
        ),
        for (final r in registers.where((r) => r.active))
          FpButton(
            label: '${l10n.registerStickerPdf} · ${r.name}',
            icon: FpIcons.arrowDown,
            variant: FpButtonVariant.secondary,
            onPressed: () => _download(ref, r),
          ),
      ],
    );
  }
}
