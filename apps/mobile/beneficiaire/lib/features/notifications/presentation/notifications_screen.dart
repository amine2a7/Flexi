import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../domain/app_notification.dart';

/// Notifications : aujourd'hui puis cette semaine ; non lues sur fond vert pâle.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final all =
        ref.watch(notificationsProvider).value ?? const <AppNotification>[];
    final today = all.where((n) => isSameDay(n.date, now)).toList();
    final week = all.where((n) => !isSameDay(n.date, now)).toList();

    Widget row(AppNotification n) {
      String money(int? m) => Tnd.format(m ?? 0, currency: l10n.currency);
      final (icon, tint, color, title, body) = switch (n.kind) {
        NotificationKind.paymentApproved => (
          FpIcons.check,
          FpColors.greenTint,
          FpColors.greenDark,
          l10n.notifPaymentApproved,
          l10n.notifPaymentApprovedBody(
            money(n.amount),
            n.merchant ?? '',
            n.type?.label(l10n) ?? '',
          ),
        ),
        NotificationKind.familyPaid => (
          FpIcons.family,
          FpColors.giftsTint,
          FpColors.gifts,
          l10n.notifFamilyPaid(n.person ?? ''),
          l10n.notifFamilyPaidBody(
            money(n.amount),
            n.merchant ?? '',
            Tnd.format(
              n.leftToday ?? 0,
              currency: l10n.currency,
              compact: true,
            ),
          ),
        ),
        NotificationKind.creditReceived => (
          FpIcons.arrowDown,
          FpColors.greenTint,
          FpColors.greenDark,
          l10n.notifCreditReceived(n.person ?? ''),
          l10n.notifCreditReceivedBody(
            Tnd.format(n.amount ?? 0, currency: l10n.currency, signed: true),
            joinAnd(l10n, [
              for (final e in n.breakdown.entries)
                '${e.key.label(l10n)} ${Tnd.format(e.value, currency: null, compact: true)}',
            ]),
          ),
        ),
        NotificationKind.creditExpiring => (
          FpIcons.clock,
          FpColors.clothingTint,
          FpColors.clothing,
          l10n.notifCreditExpiring,
          l10n.notifCreditExpiringBody(
            money(n.amount),
            n.type?.label(l10n) ?? '',
          ),
        ),
        NotificationKind.newLogin => (
          FpIcons.lock,
          FpColors.clothingTint,
          FpColors.clothing,
          l10n.notifNewLogin,
          l10n.notifNewLoginBody,
        ),
      };
      return MergeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.go(Routes.home),
          child: Container(
            color: n.unread ? FpColors.unreadSurface : FpColors.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.x16,
              vertical: FpSpace.x14,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTile(tint: tint, color: color, icon: icon),
                const SizedBox(width: FpSpace.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: FpText.body(weight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(
                        body,
                        style: FpText.body(
                          size: 13,
                          color: FpColors.inkSoft,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isSameDay(n.date, now)
                            ? dates.time(n.date)
                            : dates.relative(n.date),
                        style: FpText.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: FpSpace.x12),
                Padding(
                  padding: const EdgeInsets.only(top: FpSpace.x6),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: n.unread ? FpColors.green : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FpScreen(
      gap: FpSpace.x12,
      children: [
        ScreenHeader(
          title: l10n.notificationsTitle,
          onBack: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
          sideWidth: 72,
          trailing: TextAction(
            label: l10n.markAllRead,
            onTap: () async {
              await ref.read(notificationRepositoryProvider).markAllRead();
              ref.invalidate(notificationsProvider);
            },
          ),
        ),
        if (today.isNotEmpty) ...[
          DayHeader(l10n.today),
          ListGroup(
            insetDividers: false,
            children: [for (final n in today) row(n)],
          ),
        ],
        if (week.isNotEmpty) ...[
          DayHeader(l10n.thisWeek),
          ListGroup(
            insetDividers: false,
            children: [for (final n in week) row(n)],
          ),
        ],
      ],
    );
  }
}
