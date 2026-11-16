import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../../shared/operation_row.dart';
import '../../wallet/domain/wallet.dart';
import 'family_home_view.dart';
import 'home_parts.dart';

/// Accueil. Selon la situation : soldes, état vide, hors ligne ou compte famille.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(connectivityProvider);
    final session = ref.watch(authControllerProvider).session;
    if (!online) return const OfflineHomeView();
    if (session?.role == UserRole.familyMember) return const FamilyHomeView();
    final wallet = ref.watch(walletProvider);
    return wallet.when(
      loading: () => const HomeLoading(),
      error: (e, _) =>
          e is NetworkFailure ? const OfflineHomeView() : const HomeLoading(),
      data: (w) => w.credits.isEmpty
          ? EmptyHomeView(wallet: w)
          : _HomeContent(wallet: w),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final session = ref.watch(authControllerProvider).session;
    final ops =
        ref.watch(operationsProvider((now.year, now.month))).value ?? const [];
    final unread =
        ref.watch(notificationsProvider).value?.where((n) => n.unread).length ??
        0;
    return FpTabScroll(
      children: [
        FpRise(
          child: HomeGreeting(
            initial: (session?.firstName ?? ' ')[0],
            color: FpColors.food,
            overline: l10n.hello,
            name: session?.firstName ?? '',
            trailing: FpSquareButton(
              icon: FpIcons.bell,
              label: l10n.notificationsUnread(unread),
              badge: unread > 0,
              onTap: () => context.push(Routes.notifications),
            ),
          ),
        ),
        FpRise(
          delay: const Duration(milliseconds: 60),
          child: BalanceHero(
            label: l10n.availableBalance,
            badge: l10n.offeredBy(wallet.company),
            amount: wallet.total,
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentBar(
                  track: FpColors.onNavyFill,
                  segments: [
                    for (final c in wallet.credits) (c.balance, c.type.color),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                Row(
                  children: [
                    Expanded(
                      child: FpButton(
                        label: l10n.navPay,
                        icon: FpIcons.qr,
                        compact: true,
                        onPressed: () => context.push(Routes.pay),
                      ),
                    ),
                    const SizedBox(width: FpSpace.x10),
                    Expanded(
                      child: FpButton(
                        label: l10n.familyAction,
                        icon: FpIcons.family,
                        compact: true,
                        onNavy: true,
                        variant: FpButtonVariant.secondary,
                        onPressed: () => context.push(Routes.family),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        FpRise(
          delay: const Duration(milliseconds: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: l10n.myCredits,
                trailing: Text(
                  Dates.capitalize(dates.month(now)),
                  style: FpText.body(size: 13, color: FpColors.muted),
                ),
              ),
              const SizedBox(height: FpSpace.x12),
              CreditGrid(
                wallet: wallet,
                onCredit: (c) => context.push(Routes.credit(c.name)),
                onEmpty: () => context.go(Routes.discover),
              ),
            ],
          ),
        ),
        WeekCard(operations: ops, now: now),
        SectionHeader(
          title: l10n.activity,
          trailing: TextAction(
            label: l10n.seeAll,
            onTap: () => context.go(Routes.history),
          ),
        ),
        ListGroup(
          children: [
            for (final op
                in ops
                    .where(
                      (o) =>
                          o.kind == OperationKind.payment ||
                          o.kind == OperationKind.creditReceived,
                    )
                    .take(3))
              OperationRow(op: op, dates: dates, withType: true),
          ],
        ),
      ],
    );
  }
}
