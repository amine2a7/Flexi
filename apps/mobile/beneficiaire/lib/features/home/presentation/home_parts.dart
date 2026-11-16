import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../wallet/domain/wallet.dart';

/// En-tête : avatar, « Bonjour, » et prénom, action à droite.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    super.key,
    required this.initial,
    required this.color,
    required this.overline,
    required this.name,
    this.trailing,
    this.nameFirst = false,
  });

  final String initial;
  final Color color;
  final String overline;
  final String name;
  final Widget? trailing;

  /// Compte famille : le nom en gros au-dessus de la mention.
  final bool nameFirst;

  @override
  Widget build(BuildContext context) {
    final small = Text(
      overline,
      style: FpText.body(size: 13, color: FpColors.muted),
    );
    final big = Text(
      name,
      style: FpText.body(size: 18, weight: FontWeight.w700),
    );
    return Row(
      children: [
        Avatar(initial: initial, color: color),
        const SizedBox(width: FpSpace.x12),
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nameFirst ? [big, small] : [small, big],
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Grille 2 × 2 des 4 types de crédit.
class CreditGrid extends StatelessWidget {
  const CreditGrid({
    super.key,
    required this.wallet,
    required this.onCredit,
    required this.onEmpty,
  });

  final Wallet wallet;
  final ValueChanged<CreditType> onCredit;
  final VoidCallback onEmpty;

  @override
  Widget build(BuildContext context) {
    final cards = [
      for (final t in CreditType.values)
        Builder(
          builder: (context) {
            final c = wallet.credit(t);
            return CreditCard(
              type: t,
              balance: c?.balance,
              received: c?.received,
              onTap: c == null ? onEmpty : () => onCredit(t),
            );
          },
        ),
    ];
    return Column(
      children: [
        for (var r = 0; r < 2; r++) ...[
          if (r > 0) const SizedBox(height: FpSpace.x12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cards[r * 2]),
                const SizedBox(width: FpSpace.x12),
                Expanded(child: cards[r * 2 + 1]),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// « Cette semaine » : total, nombre de paiements et de commerces, barres par jour.
class WeekCard extends StatelessWidget {
  const WeekCard({super.key, required this.operations, required this.now});

  final List<Operation> operations;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final dates = Dates(context, now);
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final days = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
    final payments = operations
        .where(
          (o) => o.kind == OperationKind.payment && !o.date.isBefore(monday),
        )
        .toList();
    final total = payments.fold(0, (s, o) => s - o.amount);
    final merchants = payments.map((o) => o.merchantId).toSet().length;
    final perDay = [
      for (final d in days)
        payments.where((o) => isSameDay(o.date, d)).toList(),
    ];
    final max = perDay
        .map((l) => l.fold(0, (s, o) => s - o.amount))
        .fold(0, (a, b) => a > b ? a : b);
    final described = [
      for (var i = 0; i < 7; i++)
        if (perDay[i].isNotEmpty)
          '${dates.weekdayName(days[i])} ${Tnd.format(perDay[i].fold(0, (s, o) => s - o.amount), currency: null)}',
    ].join(', ');
    Widget stat(int value, String label) => Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$value', style: FpText.display(size: 26)),
        Text(label, style: FpText.small),
      ],
    );
    return FpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CapsLabel(l10n.thisWeek),
                    const SizedBox(height: FpSpace.x4),
                    AmountText(total, size: 40, currencySize: 15),
                  ],
                ),
              ),
              stat(payments.length, l10n.statPayments(payments.length)),
              const SizedBox(width: FpSpace.x18),
              stat(merchants, l10n.statMerchants(merchants)),
            ],
          ),
          const SizedBox(height: FpSpace.x16),
          Semantics(
            label: '${l10n.weekChartLabel} : $described',
            excludeSemantics: true,
            child: SizedBox(
              height: 96,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < 7; i++) ...[
                    if (i > 0) const SizedBox(width: FpSpace.x10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: perDay[i].isEmpty || max == 0
                                ? 6
                                : (70 *
                                          perDay[i].fold(
                                            0,
                                            (s, o) => s - o.amount,
                                          ) /
                                          max)
                                      .clamp(6, 70)
                                      .toDouble(),
                            decoration: BoxDecoration(
                              color: perDay[i].isEmpty
                                  ? FpColors.track
                                  : perDay[i].first.type?.color ??
                                        FpColors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: FpSpace.x6),
                          Text(
                            dates.weekdayLetter(days[i]).toUpperCase(),
                            style: FpText.body(
                              size: 11,
                              weight: isSameDay(days[i], now)
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSameDay(days[i], now)
                                  ? FpColors.ink
                                  : FpColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chargement : fond clair, rien d'autre (les données de démonstration arrivent aussitôt).
class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

/// Nouveau salarié sans crédit (Omar).
class EmptyHomeView extends ConsumerWidget {
  const EmptyHomeView({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final session = ref.watch(authControllerProvider).session;
    final name = session?.firstName ?? '';
    return FpTabScroll(
      gap: FpSpace.x18,
      children: [
        HomeGreeting(
          initial: name.isEmpty ? '' : name[0],
          color: FpColors.clothing,
          overline: l10n.welcome,
          name: name,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: FpSpace.x24,
            horizontal: FpSpace.x8,
          ),
          child: Column(
            children: [
              const Mascot(size: 150),
              const SizedBox(height: FpSpace.x14),
              Semantics(
                header: true,
                child: Text(
                  l10n.emptyTitle,
                  textAlign: TextAlign.center,
                  style: FpText.display(size: 34, color: FpColors.navy),
                ),
              ),
              const SizedBox(height: FpSpace.x14),
              Text(
                l10n.emptyText(wallet.company),
                textAlign: TextAlign.center,
                style: FpText.body(
                  size: 15,
                  color: FpColors.muted,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        ListGroup(
          children: [
            ListRow(
              leading: const IconTile(
                tint: FpColors.fuelTint,
                color: FpColors.fuel,
                icon: FpIcons.bell,
              ),
              title: l10n.enableNotifications,
              subtitle: l10n.enableNotificationsDetail,
              chevron: true,
              onTap: () => context.go(Routes.profile),
            ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                icon: FpIcons.store,
              ),
              title: l10n.discoverMerchants,
              subtitle: l10n.discoverMerchantsDetail,
              chevron: true,
              onTap: () => context.go(Routes.discover),
            ),
          ],
        ),
      ],
    );
  }
}

/// Hors ligne : dernier solde connu, paiement impossible, Réessayer.
class OfflineHomeView extends ConsumerWidget {
  const OfflineHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final last = ref.watch(lastKnownWalletProvider);
    final dates = Dates(context, ref.watch(clockProvider)());
    final skeleton = FpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (w, h) in const [
            (0.4, 40.0),
            (0.7, 14.0),
            (0.9, 24.0),
          ]) ...[
            FractionallySizedBox(
              widthFactor: w,
              child: Container(
                height: h,
                decoration: BoxDecoration(
                  color: FpColors.track,
                  borderRadius: BorderRadius.circular(FpRadius.sm),
                ),
              ),
            ),
            const SizedBox(height: FpSpace.x10),
          ],
        ],
      ),
    );
    return FpTabScroll(
      gap: FpSpace.x18,
      top: Semantics(
        liveRegion: true,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.paddingOf(context).top + 8,
            20,
            14,
          ),
          color: FpColors.warningTint,
          child: Row(
            children: [
              const FpIcon(
                FpIcons.wifiOff,
                size: 20,
                color: FpColors.warningInk,
              ),
              const SizedBox(width: FpSpace.x10),
              Expanded(
                child: Text(
                  l10n.offlineBanner,
                  style: FpText.body(
                    size: 14,
                    weight: FontWeight.w600,
                    color: FpColors.warningInk,
                  ),
                ),
              ),
              if (last != null)
                Flexible(
                  child: Text(
                    l10n.updatedAt(dates.time(last.$2)),
                    textAlign: TextAlign.end,
                    style: FpText.body(
                      size: 14,
                      weight: FontWeight.w500,
                      color: FpColors.warningInk,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      children: [
        Opacity(
          opacity: 0.85,
          child: Column(
            children: [
              BalanceHero(
                label: l10n.lastKnownBalance,
                amount: last?.$1.total ?? 0,
                amountSize: 56,
              ),
              const SizedBox(height: FpSpace.x14),
              Row(
                children: [
                  Expanded(child: skeleton),
                  const SizedBox(width: FpSpace.x12),
                  Expanded(child: skeleton),
                ],
              ),
            ],
          ),
        ),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IconTile(
                    tint: FpColors.warningTint,
                    color: FpColors.warningIcon,
                    icon: FpIcons.wifiOff,
                  ),
                  const SizedBox(width: FpSpace.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.offlineTitle,
                          style: FpText.body(size: 16, weight: FontWeight.w700),
                        ),
                        const SizedBox(height: FpSpace.x4),
                        Text(l10n.offlineText, style: FpText.muted14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FpSpace.x16),
              FpButton(
                label: l10n.retry,
                icon: FpIcons.refresh,
                variant: FpButtonVariant.navy,
                onPressed: () {
                  ref.read(connectivityProvider.notifier).setOnline(true);
                  refreshMoney(ref);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
