import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../../shared/operation_row.dart';
import '../domain/family.dart';

/// Détail d'un membre : solde, plafond du jour, reprendre le crédit, actions.
class FamilyMemberScreen extends ConsumerWidget {
  const FamilyMemberScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final m = ref.watch(familyMemberProvider(memberId)).value;
    if (m == null) {
      return FpScreen(
        children: [ScreenHeader(title: '', onBack: () => context.pop())],
      );
    }
    final ops = ref.watch(memberOperationsProvider(m.id)).value ?? const [];
    final repo = ref.read(familyRepositoryProvider);
    final cap = Tnd.format(m.dailyCap, currency: l10n.currency, compact: true);

    Future<void> reclaim() async {
      await repo.reclaim(m.id);
      refreshMoney(ref);
      if (context.mounted) context.go(Routes.credit(m.type.name));
    }

    Future<void> newPassword() async {
      final password = await repo.resetPassword(m.id);
      if (!context.mounted) return;
      await OneTimePasswordSheet.show(
        context,
        OneTimePasswordSheet(
          title: l10n.newPasswordAction,
          message: l10n.memberCreatedText(m.firstName),
          password: password,
          actionLabel: l10n.passwordNoted,
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    Future<void> disable() async {
      await repo.disable(m.id);
      refreshMoney(ref);
      if (context.mounted) context.go(Routes.family);
    }

    return FpScreen(
      children: [
        ScreenHeader(title: m.firstName, onBack: () => context.pop()),
        FpRise(
          child: BalanceHero(
            label: l10n.memberBalance(elide(m.firstName), m.firstName),
            badge: m.type.label(l10n),
            amount: m.balance,
            amountSize: 56,
            suffix:
                '/ ${Tnd.format(m.limit, currency: l10n.currency, compact: true)}',
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MarkupText(
                        l10n.todaySpent(
                          Tnd.format(
                            m.spentToday,
                            currency: null,
                            compact: true,
                          ),
                          cap,
                        ),
                        style: FpText.body(
                          size: 13,
                          color: FpColors.onNavyMuted,
                        ),
                        boldColor: FpColors.surface,
                      ),
                    ),
                    Text(
                      l10n.endShort(dates.shortDate(m.endDate)),
                      style: FpText.body(size: 13, color: FpColors.onNavyMuted),
                    ),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                FpProgressBar(
                  value: m.spentToday / m.dailyCap,
                  color: FpColors.green,
                  track: FpColors.onNavyTrack,
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        ListGroup(
          children: [
            ListRow(
              leading: const IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                icon: FpIcons.undo,
              ),
              title: l10n.reclaimCredit,
              subtitle: l10n.reclaimDetail(
                Tnd.format(m.balance, currency: l10n.currency),
              ),
              chevron: true,
              onTap: reclaim,
            ),
            if (repo.canEditMember)
              ListRow(
                leading: const IconTile(
                  tint: FpColors.clothingTint,
                  color: FpColors.clothing,
                  icon: FpIcons.edit,
                ),
                title: l10n.editCapOrDate,
                subtitle: l10n.capPerDay(cap, dates.shortDate(m.endDate)),
                chevron: true,
                onTap: () => context.push(Routes.familyAdd),
              ),
            if (repo.canEditMember)
              ListRow(
                leading: const IconTile(
                  tint: FpColors.giftsTint,
                  color: FpColors.gifts,
                  icon: FpIcons.key,
                ),
                title: l10n.newPasswordAction,
                subtitle: l10n.shownOnce,
                chevron: true,
                onTap: newPassword,
              ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.dangerTint,
                color: FpColors.danger,
                icon: FpIcons.ban,
              ),
              title: l10n.disableAccount,
              titleColor: FpColors.danger,
              subtitle: l10n.disableDetail(m.firstName),
              chevron: true,
              onTap: disable,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x6),
          child: SectionHeader(
            title: l10n.memberSpending(elide(m.firstName), m.firstName),
          ),
        ),
        if (ops.isNotEmpty)
          ListGroup(
            children: [
              for (final op in ops)
                OperationRow(
                  op: op,
                  dates: dates,
                  mode: OperationRowMode.credit,
                ),
            ],
          ),
      ],
    );
  }
}
