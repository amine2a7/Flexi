import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:intl/intl.dart';

import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../domain/team.dart';

/// Mon équipe (propriétaire) : caissiers et ajout d'un caissier.
class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final team = ref.watch(teamProvider).value ?? const <TeamMember>[];
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(overline: l10n.ownerOnly, title: l10n.myTeam),
        ListGroup(
          children: [
            for (final m in team)
              m.isOwner
                  ? ListRow(
                      leading: IconTile(
                        tint: FpColors.navy,
                        color: FpColors.surface,
                        text: m.name[0],
                      ),
                      title: l10n.youOwner,
                      subtitle: m.email,
                    )
                  : ListRow(
                      leading: IconTile(
                        tint: FpColors.foodTint,
                        color: FpColors.food,
                        text: m.name[0],
                      ),
                      title: l10n.cashierRole(m.name),
                      subtitle: m.lastAccess == null
                          ? m.email
                          : l10n.activeLastAccess(
                              DateFormat.Hm(locale).format(m.lastAccess!),
                            ),
                      chevron: true,
                    ),
          ],
        ),
        FpCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconTile(
                tint: FpColors.clothingTint,
                color: FpColors.clothing,
                icon: FpIcons.key,
                size: 40,
              ),
              const SizedBox(width: FpSpace.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cashierActions,
                      style: FpText.body(weight: FontWeight.w700),
                    ),
                    const SizedBox(height: FpSpace.x4),
                    Text(
                      l10n.cashierActionsText,
                      style: FpText.body(
                        size: 13,
                        color: FpColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        FpButton(
          label: l10n.addCashier,
          icon: FpIcons.plus,
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            backgroundColor: FpColors.surface,
            barrierColor: FpColors.scrim,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(FpRadius.ticket),
              ),
            ),
            builder: (_) => const _NewCashierSheet(),
          ),
        ),
      ],
    );
  }
}

/// Création d'un caissier ; le mot de passe temporaire renvoyé par le serveur
/// s'affiche une seule fois, avec Copier, et n'est jamais stocké.
class _NewCashierSheet extends ConsumerStatefulWidget {
  const _NewCashierSheet();

  @override
  ConsumerState<_NewCashierSheet> createState() => _NewCashierSheetState();
}

class _NewCashierSheetState extends ConsumerState<_NewCashierSheet> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  String? _password;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      final created = await ref
          .read(teamRepositoryProvider)
          .createCashier(
            fullName: _name.text.trim(),
            email: _email.text.trim(),
          );
      ref.invalidate(teamProvider);
      if (mounted) setState(() => _password = created.temporaryPassword);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final valid = _name.text.trim().isNotEmpty && _email.text.contains('@');
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: FpColors.dash,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: FpSpace.x14),
              Semantics(
                header: true,
                child: Text(
                  l10n.newCashier,
                  style: FpText.body(size: 22, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: FpSpace.x14),
              FpTextField(
                fieldKey: const Key('cashier-name'),
                label: l10n.fullNameLabel,
                controller: _name,
                icon: FpIcons.user,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: FpSpace.x14),
              FpTextField(
                fieldKey: const Key('cashier-email'),
                label: l10n.emailLabel,
                controller: _email,
                icon: FpIcons.mail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: FpSpace.x14),
              if (_password != null) ...[
                Text(l10n.tempPassword, style: FpText.label),
                const SizedBox(height: FpSpace.x8),
                OneTimePasswordBox(password: _password!),
                const SizedBox(height: FpSpace.x14),
                FpButton(
                  label: l10n.passwordNoted,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ] else
                FpButton(
                  label: l10n.createCashier,
                  onPressed: valid && !_busy ? _create : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
