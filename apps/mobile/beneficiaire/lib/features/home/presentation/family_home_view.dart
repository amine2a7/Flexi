import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../../shared/operation_row.dart';
import 'home_parts.dart';

/// Accueil d'un membre famille (Adam) : son seul crédit et son plafond du jour.
class FamilyHomeView extends ConsumerWidget {
  const FamilyHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final session = ref.watch(authControllerProvider).session;
    final member = ref.watch(myFamilyAccountProvider).value;
    final ops =
        ref.watch(operationsProvider((now.year, now.month))).value ?? const [];
    if (member == null) return const HomeLoading();
    final cap = Tnd.format(
      member.dailyCap,
      currency: l10n.currency,
      compact: true,
    );
    final spent = Tnd.format(member.spentToday, currency: null, compact: true);
    final quarter = member.dailyCap ~/ 4;
    return FpTabScroll(
      gap: FpSpace.x18,
      children: [
        HomeGreeting(
          initial: member.firstName[0],
          color: FpColors.gifts,
          overline: l10n.familyAccountOf(session?.organization ?? ''),
          name: l10n.helloName(member.firstName),
          nameFirst: true,
        ),
        FpRise(
          child: BalanceHero(
            label: l10n.myCreditOf(member.type.label(l10n)),
            amount: member.balance,
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MarkupText(
                        l10n.leftToday(
                          Tnd.format(
                            member.leftToday,
                            currency: l10n.currency,
                            compact: true,
                          ),
                        ),
                        style: FpText.body(
                          size: 13,
                          color: FpColors.onNavyMuted,
                        ),
                        boldColor: FpColors.surface,
                      ),
                    ),
                    Text(
                      l10n.untilDate(dates.shortDate(member.endDate)),
                      style: FpText.body(size: 13, color: FpColors.onNavyMuted),
                    ),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                FpProgressBar(
                  value: member.spentToday / member.dailyCap,
                  color: FpColors.green,
                  track: FpColors.onNavyTrack,
                  height: 8,
                ),
                const SizedBox(height: FpSpace.x16),
                FpButton(
                  label: l10n.navPay,
                  icon: FpIcons.qr,
                  compact: true,
                  onPressed: () => context.push(Routes.pay),
                ),
              ],
            ),
          ),
        ),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: CapsLabel(l10n.dailyCapTitle)),
                  Text(
                    '$spent / $cap',
                    style: FpText.body(size: 13, weight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: FpSpace.x12),
              Row(
                children: [
                  for (var i = 0; i < 4; i++) ...[
                    if (i > 0) const SizedBox(width: FpSpace.x6),
                    Expanded(
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: member.spentToday >= quarter * (i + 1)
                              ? FpColors.gifts
                              : FpColors.track,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: FpSpace.x12),
              Text(l10n.capResets(cap), style: FpText.small),
            ],
          ),
        ),
        SectionHeader(title: l10n.myPayments),
        ListGroup(
          children: [
            for (final op in ops)
              OperationRow(op: op, dates: dates, mode: OperationRowMode.credit),
          ],
        ),
      ],
    );
  }
}
