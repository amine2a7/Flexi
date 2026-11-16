import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';

/// Mot de passe oublié : seul le RH ou le support peut en générer un.
class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final profile = ref.watch(profileProvider).value;
    return FpScreen(
      gap: FpSpace.x20,
      children: [
        ScreenHeader(
          title: l10n.forgotTitle,
          onBack: () => context.go(Routes.login),
        ),
        const Padding(
          padding: EdgeInsets.only(top: FpSpace.x8),
          child: Center(child: Mascot(size: 120)),
        ),
        Column(
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.forgotHeadline,
                style: FpText.display(size: 34, color: FpColors.navy),
              ),
            ),
            const SizedBox(height: FpSpace.x8),
            Text(
              l10n.forgotText,
              textAlign: TextAlign.center,
              style: FpText.body(size: 15, color: FpColors.muted, height: 1.55),
            ),
          ],
        ),
        ListGroup(
          children: [
            ListRow(
              leading: IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                text: l10n.hrBadge,
              ),
              title: l10n.yourHrAt(profile?.company ?? ''),
              subtitle: profile == null
                  ? null
                  : '${profile.hrName} · ${profile.hrEmail}',
              chevron: true,
              onTap: profile == null
                  ? null
                  : () =>
                        Clipboard.setData(ClipboardData(text: profile.hrEmail)),
            ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.clothingTint,
                color: FpColors.clothing,
                icon: FpIcons.help,
              ),
              title: l10n.supportTitle,
              subtitle: profile?.supportEmail,
              chevron: true,
              onTap: () => context.push(Routes.help),
            ),
          ],
        ),
        const Spacer(),
        FpButton(
          label: l10n.backToLogin,
          variant: FpButtonVariant.secondary,
          onPressed: () => context.go(Routes.login),
        ),
      ],
    );
  }
}
