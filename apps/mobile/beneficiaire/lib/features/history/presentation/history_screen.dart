import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../../../shared/operation_row.dart';
import '../../wallet/domain/wallet.dart';

/// Historique : résumé du mois puis opérations groupées par jour.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _month = 0;
  final _search = TextEditingController();
  Timer? _debounce;

  /// Texte recherché (W-SUP), appliqué 300 ms après la dernière touche.
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final now = ref.watch(clockProvider)();
    final dates = Dates(context, now);
    final months = [
      for (var i = 0; i < 3; i++) DateTime(now.year, now.month - i),
    ];
    final selected = months[_month];
    final ops =
        ref.watch(operationsProvider((selected.year, selected.month))).value ??
        const <Operation>[];
    final payments = ops.where((o) => o.kind == OperationKind.payment).toList();
    final spent = payments.fold(0, (s, o) => s - o.amount);
    final byType = <CreditType, int>{};
    for (final p in payments) {
      if (p.type != null) byType[p.type!] = (byType[p.type!] ?? 0) - p.amount;
    }
    final received = ops
        .where((o) => o.kind == OperationKind.creditReceived)
        .fold(0, (s, o) => s + o.amount);
    final shared = ops
        .where((o) => o.kind == OperationKind.familyShare)
        .fold(0, (s, o) => s - o.amount);
    final days = <DateTime, List<Operation>>{};
    for (final o in ops) {
      days
          .putIfAbsent(
            DateTime(o.date.year, o.date.month, o.date.day),
            () => [],
          )
          .add(o);
    }
    final title = Semantics(
      header: true,
      child: Text(
        l10n.historyTitle,
        style: FpText.display(size: 40, color: FpColors.navy),
      ),
    );
    final searchField = FpTextField(
      label: l10n.historySearch,
      controller: _search,
      icon: FpIcons.search,
      onChanged: _onSearch,
      fieldKey: const Key('history-search'),
    );
    if (_query.isNotEmpty) {
      final found = ref.watch(operationSearchProvider(_query));
      final results = found.value;
      return FpTabScroll(
        gap: FpSpace.x14,
        children: [
          title,
          searchField,
          if (results == null)
            const Center(child: CircularProgressIndicator())
          else if (results.isEmpty)
            Text(l10n.searchNoResult, style: FpText.muted14)
          else
            ListGroup(
              children: [
                for (final op in results)
                  OperationRow(
                    op: op,
                    dates: dates,
                    mode: OperationRowMode.history,
                  ),
              ],
            ),
        ],
      );
    }
    return FpTabScroll(
      gap: FpSpace.x14,
      children: [
        title,
        searchField,
        Semantics(
          label: l10n.monthFilter,
          container: true,
          child: Wrap(
            spacing: FpSpace.x8,
            children: [
              for (var i = 0; i < months.length; i++)
                FpChip(
                  label: Dates.capitalize(dates.month(months[i])),
                  selected: _month == i,
                  onTap: () => setState(() => _month = i),
                ),
            ],
          ),
        ),
        Semantics(
          label: l10n.monthSummary,
          container: true,
          child: FpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CapsLabel(l10n.spentIn(dates.month(selected))),
                const SizedBox(height: FpSpace.x4),
                AmountText(
                  spent,
                  size: 48,
                  currencySize: 18,
                  color: FpColors.navy,
                ),
                if (byType.isNotEmpty) ...[
                  const SizedBox(height: FpSpace.x14),
                  SegmentBar(
                    height: 10,
                    segments: [
                      for (final e in byType.entries) (e.value, e.key.color),
                    ],
                  ),
                  const SizedBox(height: FpSpace.x14),
                  Wrap(
                    spacing: FpSpace.x16,
                    runSpacing: FpSpace.x6,
                    children: [
                      for (final e in byType.entries)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: e.key.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: FpSpace.x6),
                            Text(
                              '${e.key.label(l10n)} ${Tnd.format(e.value, currency: null)}',
                              style: FpText.small,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: FpSpace.x14),
                StatRow(
                  stats: [
                    ('${payments.length}', l10n.statPayments(payments.length)),
                    (
                      Tnd.format(received, currency: null, compact: true),
                      l10n.statReceivedTnd,
                    ),
                    (
                      Tnd.format(shared, currency: null, compact: true),
                      l10n.statSharedTnd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        for (final entry in days.entries) ...[
          DayHeader(dates.dayHeader(entry.key)),
          ListGroup(
            children: [
              for (final op in entry.value)
                OperationRow(
                  op: op,
                  dates: dates,
                  mode: OperationRowMode.history,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
