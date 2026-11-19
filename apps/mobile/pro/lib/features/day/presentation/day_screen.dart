import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../../collect/domain/collect.dart';
import '../domain/day.dart';

/// Aujourd'hui : total, panier moyen, refus, encaissements par heure et liste.
/// Le caissier ne voit que sa journée ; le propriétaire peut filtrer par caissier.
class DayScreen extends ConsumerStatefulWidget {
  const DayScreen({super.key});

  @override
  ConsumerState<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends ConsumerState<DayScreen> {
  /// `null` : tous ; sinon identifiant du caissier.
  String? _cashier;

  /// Recherche par référence ou montant (W-SUP), appliquée 300 ms après la dernière touche.
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  static const _slots = [
    (8, 2),
    (10, 2),
    (12, 1),
    (13, 1),
    (14, 2),
    (16, 2),
    (18, 2),
    (20, 2),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final session = ref.watch(authControllerProvider).session;
    final owner = session?.isOwner ?? false;
    final summary = ref.watch(daySummaryProvider).value;
    final cashiers = owner
        ? (ref.watch(cashiersProvider).value ?? const [])
        : const [];
    if (summary == null) return const SizedBox.expand();
    final all = summary.collections;
    final list = all
        .where((c) => _cashier == null || c.cashierId == _cashier)
        .where((c) => c.matches(_query))
        .toList();
    final max = _slots
        .map((s) => summary.totalBetween(s.$1, s.$2))
        .fold(0, (a, b) => a > b ? a : b);
    final hm = DateFormat.Hm(locale);
    String dateTitle(DateTime d) {
      final s = DateFormat('EEEE d MMMM', locale).format(d);
      return s[0].toUpperCase() + s.substring(1);
    }

    final chartLabel = [
      for (final s in _slots)
        if (summary.totalBetween(s.$1, s.$2) > 0)
          '${s.$1}h ${Tnd.format(summary.totalBetween(s.$1, s.$2), currency: null)}',
    ].join(', ');
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(overline: dateTitle(summary.date), title: l10n.proNavToday),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CapsLabel(l10n.collectedToday),
              const SizedBox(height: FpSpace.x4),
              AmountText(
                summary.total,
                size: 56,
                currencySize: 21,
                color: FpColors.navy,
              ),
              const SizedBox(height: FpSpace.x16),
              StatRow(
                stats: [
                  ('${summary.count}', l10n.statCollections(summary.count)),
                  (
                    Tnd.format(summary.average, currency: null),
                    l10n.averageBasket,
                  ),
                  ('${summary.refusals}', l10n.statRefusals),
                ],
              ),
              const SizedBox(height: FpSpace.x16),
              Semantics(
                label: '${l10n.hourlyChart} : $chartLabel',
                excludeSemantics: true,
                child: SizedBox(
                  height: 110,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final (i, s) in _slots.indexed) ...[
                        if (i > 0) const SizedBox(width: FpSpace.x8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // La barre la plus haute occupe toute la place laissée par le libellé.
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor:
                                        max == 0 ||
                                            summary.totalBetween(s.$1, s.$2) ==
                                                0
                                        ? 0.05
                                        : (summary.totalBetween(s.$1, s.$2) /
                                                  max)
                                              .clamp(0.05, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            summary.totalBetween(s.$1, s.$2) ==
                                                0
                                            ? FpColors.track
                                            : FpColors.food,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: FpSpace.x6),
                              Text(
                                '${s.$1}h',
                                style: FpText.body(
                                  size: 11,
                                  color: FpColors.muted,
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
        ),
        Row(
          children: [
            Expanded(child: Text(l10n.collections, style: FpText.title)),
            if (owner)
              Semantics(
                label: l10n.filterByCashier,
                container: true,
                child: Wrap(
                  spacing: FpSpace.x6,
                  children: [
                    FpChip(
                      label: l10n.filterAll,
                      selected: _cashier == null,
                      height: 34,
                      fontSize: 12.5,
                      onTap: () => setState(() => _cashier = null),
                    ),
                    for (final c in cashiers)
                      FpChip(
                        label: c.name,
                        selected: _cashier == c.id,
                        height: 34,
                        fontSize: 12.5,
                        onTap: () => setState(() => _cashier = c.id),
                      ),
                    FpChip(
                      label: l10n.filterMe,
                      selected: _cashier == session?.userId,
                      height: 34,
                      fontSize: 12.5,
                      onTap: () => setState(() => _cashier = session?.userId),
                    ),
                  ],
                ),
              ),
          ],
        ),
        FpTextField(
          label: l10n.daySearch,
          controller: _search,
          icon: FpIcons.search,
          fieldKey: const Key('day-search'),
          onChanged: (text) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () {
              if (mounted) setState(() => _query = text);
            });
          },
        ),
        if (list.isEmpty && _query.trim().isNotEmpty)
          Text(l10n.searchNoResult, style: FpText.muted14)
        else
          ListGroup(
            children: [
              for (final c in list)
                _CollectionRow(collection: c, time: hm.format(c.time)),
            ],
          ),
        ListGroup(
          children: [
            ListRow(
              leading: const IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                icon: FpIcons.help,
              ),
              title: l10n.helpAndTickets,
              subtitle: l10n.supportTicketsHint,
              chevron: true,
              onTap: () => context.push(ProRoutes.tickets),
            ),
          ],
        ),
        FpButton(
          label: l10n.logout,
          icon: FpIcons.logout,
          variant: FpButtonVariant.danger,
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) context.go(ProRoutes.login);
          },
        ),
      ],
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({required this.collection, required this.time});

  final DayCollection collection;
  final String time;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final c = collection;
    final name = c.customerKind == CustomerKind.familyMember
        ? l10n.familyTag(c.customerName)
        : [c.customerName, ?c.organization].join(' · ');
    void open() => context.push(
      ProRoutes.result,
      extra: TillCheckout(
        id: c.id,
        registerName: '',
        amount: c.amount,
        type: c.type,
        shortCode: '',
        validity: Duration.zero,
        status: c.approved ? CheckoutStatus.paid : CheckoutStatus.refused,
        customerFirstName: name,
        refusal: c.refusal,
        cashier: c.cashierName,
        time: c.time,
        reference: c.reference,
        paymentId: c.id,
      ),
    );
    if (!c.approved) {
      return ListRow(
        leading: const IconTile(
          tint: FpColors.dangerTint,
          color: FpColors.danger,
          icon: FpIcons.close,
        ),
        title: l10n.refusedTag(c.customerName),
        subtitle:
            '${c.refusal == RefusalReason.familyLimit ? l10n.refusedFamilyTitle : l10n.refusedFundsTitle} · $time',
        trailing: ListRow.amount(
          Tnd.format(0, currency: null),
          color: FpColors.muted,
        ),
        onTap: open,
      );
    }
    return ListRow(
      leading: IconTile(
        tint: c.type.tint,
        color: c.type.color,
        text: c.initial,
      ),
      title: name,
      subtitle: '${c.type.label(l10n)} · $time · ${c.cashierName}',
      trailing: ListRow.amount(
        Tnd.format(c.amount, currency: null, signed: true),
        color: FpColors.greenDark,
      ),
      onTap: open,
    );
  }
}
