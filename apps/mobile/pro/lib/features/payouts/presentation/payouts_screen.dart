import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:intl/intl.dart';

import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../domain/payout.dart';

/// Reversements : demande en cours (Demandé → Accepté → Payé) et historique.
class PayoutsScreen extends ConsumerWidget {
  const PayoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final payouts = ref.watch(payoutsProvider).value ?? const <Payout>[];
    final current = payouts
        .where((p) => p.status != PayoutStatus.paid)
        .firstOrNull;
    final paid = payouts.where((p) => p.status == PayoutStatus.paid).toList();
    String date(DateTime d) => DateFormat('d MMM', locale).format(d);
    String dateTime(DateTime d) =>
        '${date(d)} ${DateFormat.Hm(locale).format(d)}';
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(overline: l10n.transferTracking, title: l10n.payoutsTitle),
        if (current != null)
          FpCard(
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
                          CapsLabel(l10n.requestRef(current.reference)),
                          const SizedBox(height: FpSpace.x4),
                          AmountText(
                            current.net,
                            size: 40,
                            currencySize: 15,
                            color: FpColors.navy,
                          ),
                          const SizedBox(height: FpSpace.x4),
                          Text(
                            l10n.netOf(
                              Tnd.format(current.gross, currency: null),
                            ),
                            style: FpText.body(size: 13, color: FpColors.muted),
                          ),
                        ],
                      ),
                    ),
                    TagChip(
                      label: l10n.inProgress,
                      tint: FpColors.warningTint,
                      color: FpColors.warningInk,
                      height: 28,
                    ),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                const DashedLine(),
                const SizedBox(height: FpSpace.x16),
                _Step(
                  title: l10n.stepRequested,
                  subtitle: dateTime(current.requestedAt),
                  state: _StepState.done,
                  line: true,
                ),
                _Step(
                  title: l10n.stepAcceptance,
                  subtitle: current.status == PayoutStatus.accepted
                      ? ''
                      : l10n.pending,
                  state: current.status == PayoutStatus.accepted
                      ? _StepState.done
                      : _StepState.current,
                  line: true,
                ),
                _Step(
                  title: l10n.stepPaid,
                  subtitle: l10n.upcoming,
                  state: _StepState.future,
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.x4),
          child: SectionHeader(title: l10n.historySection),
        ),
        ListGroup(
          children: [
            for (final p in paid)
              ListRow(
                leading: const IconTile(
                  tint: FpColors.greenTint,
                  color: FpColors.greenDark,
                  icon: FpIcons.check,
                ),
                title: l10n.payoutPaid(p.reference),
                subtitle:
                    '${p.bankReference} · ${date(p.paidAt ?? p.requestedAt)}',
                trailing: ListRow.amount(Tnd.format(p.net, currency: null)),
              ),
          ],
        ),
      ],
    );
  }
}

enum _StepState { done, current, future }

class _Step extends StatelessWidget {
  const _Step({
    required this.title,
    required this.subtitle,
    required this.state,
    this.line = false,
  });

  final String title;
  final String subtitle;
  final _StepState state;
  final bool line;

  @override
  Widget build(BuildContext context) {
    final done = state == _StepState.done;
    return MergeSemantics(
      child: Stack(
        children: [
          if (line)
            PositionedDirectional(
              start: 13,
              top: 30,
              bottom: 0,
              child: Container(
                width: 2,
                color: done ? FpColors.green : FpColors.border,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: FpSpace.x14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? FpColors.green : FpColors.surface,
                    border: Border.all(
                      width: 2,
                      color: switch (state) {
                        _StepState.done => FpColors.green,
                        _StepState.current => FpColors.navy,
                        _StepState.future => FpColors.dashStrong,
                      },
                    ),
                  ),
                  child: done
                      ? const FpIcon(
                          FpIcons.check,
                          size: 16,
                          color: FpColors.surface,
                          strokeWidth: 3,
                        )
                      : null,
                ),
                const SizedBox(width: FpSpace.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FpText.body(
                          weight: FontWeight.w700,
                          color: state == _StepState.future
                              ? FpColors.muted
                              : FpColors.ink,
                        ),
                      ),
                      const SizedBox(height: FpSpace.x2),
                      Text(
                        subtitle,
                        style: FpText.body(size: 13, color: FpColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
