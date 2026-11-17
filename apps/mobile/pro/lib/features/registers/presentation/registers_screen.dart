import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_providers.dart';
import '../../collect/domain/collect.dart';

/// Mes caisses (propriétaire) : chaque caisse active reçoit son autocollant NFC.
class RegistersScreen extends ConsumerWidget {
  const RegistersScreen({super.key});

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
      ],
    );
  }
}
