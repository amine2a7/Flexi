import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../domain/family.dart';

/// Ma famille : jusqu'à 5 comptes, plafond du jour de chacun.
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final dates = Dates(context, ref.watch(clockProvider)());
    final members =
        ref.watch(familyMembersProvider).value ?? const <FamilyMember>[];
    final full = members.length >= maxFamilyMembers;
    void add() => context.push(Routes.familyAdd);
    return FpScreen(
      children: [
        ScreenHeader(
          title: l10n.familyTitle,
          onBack: () =>
              context.canPop() ? context.pop() : context.go(Routes.profile),
        ),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: CapsLabel(l10n.familyAccounts)),
                  Text(
                    l10n.familyUsage(members.length, maxFamilyMembers),
                    style: FpText.body(size: 13, weight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: FpSpace.x16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < maxFamilyMembers; i++)
                    if (i < members.length)
                      FpPressable(
                        semanticLabel: members[i].firstName,
                        onTap: () =>
                            context.push(Routes.familyMember(members[i].id)),
                        child: Avatar(
                          initial: members[i].firstName[0],
                          color: FpColors.gifts,
                          size: 52,
                        ),
                      )
                    else
                      FpPressable(
                        semanticLabel: l10n.addMember,
                        onTap: add,
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: DashedBorderBox(
                            radius: 26,
                            strokeWidth: 2,
                            child: Center(
                              child: FpIcon(
                                FpIcons.plus,
                                size: 20,
                                color: FpColors.muted,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
        for (final m in members)
          FpPressable(
            semanticLabel: m.firstName,
            onTap: () => context.push(Routes.familyMember(m.id)),
            child: FpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Avatar(
                        initial: m.firstName[0],
                        color: FpColors.gifts,
                        size: 48,
                      ),
                      const SizedBox(width: FpSpace.x12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.firstName,
                              style: FpText.body(
                                size: 16,
                                weight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l10n.familyUntil(
                                m.type.label(l10n),
                                dates.shortDate(m.endDate),
                              ),
                              style: FpText.body(
                                size: 13,
                                color: FpColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AmountText(m.balance, size: 26, showCurrency: false),
                    ],
                  ),
                  const SizedBox(height: FpSpace.x14),
                  Row(
                    children: [
                      Expanded(child: Text(l10n.today, style: FpText.small)),
                      MarkupText(
                        '**${Tnd.format(m.spentToday, currency: null, compact: true)}** / '
                        '${Tnd.format(m.dailyCap, currency: l10n.currency, compact: true)}',
                        style: FpText.small,
                        boldColor: FpColors.ink,
                      ),
                    ],
                  ),
                  const SizedBox(height: FpSpace.x6),
                  FpProgressBar(
                    value: m.spentToday / m.dailyCap,
                    color: FpColors.gifts,
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        InfoBanner(
          text: l10n.familyInfo,
          icon: FpIcons.info,
          tint: FpColors.clothingTint,
          iconColor: FpColors.clothing,
        ),
        const Spacer(),
        FpButton(
          label: l10n.addMember,
          icon: FpIcons.plus,
          onPressed: full ? null : add,
        ),
      ],
    );
  }
}
