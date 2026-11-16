import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../domain/merchant.dart';

/// Découvrir : commerces actifs près de chez soi, filtrés par type.
class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  CreditType? _filter;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  String _kind(FpL10n l10n, MerchantKind k) => switch (k) {
    MerchantKind.supermarket => l10n.kindSupermarket,
    MerchantKind.fuelStation => l10n.kindFuelStation,
    MerchantKind.restaurant => l10n.kindRestaurant,
    MerchantKind.shop => l10n.kindShop,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final q = _query.text.trim().toLowerCase();
    final shops = (ref.watch(merchantsProvider).value ?? const <Merchant>[])
        .where((m) => _filter == null || m.acceptedTypes.contains(_filter))
        .where((m) => q.isEmpty || m.name.toLowerCase().contains(q))
        .toList();
    return FpTabScroll(
      gap: FpSpace.x20,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.discoverTitle,
                style: FpText.display(size: 40, color: FpColors.navy),
              ),
            ),
            const SizedBox(height: FpSpace.x6),
            Text(l10n.discoverSubtitle, style: FpText.muted14),
          ],
        ),
        Container(
          height: FpSize.field,
          padding: const EdgeInsetsDirectional.only(start: 16, end: 6),
          decoration: BoxDecoration(
            color: FpColors.surface,
            borderRadius: BorderRadius.circular(FpRadius.button),
            border: Border.all(color: FpColors.border),
          ),
          child: Row(
            children: [
              const FpIcon(FpIcons.search, size: 20, color: FpColors.muted),
              const SizedBox(width: FpSpace.x10),
              Expanded(
                child: TextField(
                  controller: _query,
                  onChanged: (_) => setState(() {}),
                  style: FpText.body(),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: l10n.searchMerchant,
                    hintStyle: FpText.body(color: FpColors.muted),
                  ),
                ),
              ),
              Semantics(
                label: l10n.viewOnMap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FpColors.divider,
                    borderRadius: BorderRadius.circular(FpRadius.md),
                  ),
                  alignment: Alignment.center,
                  child: const FpIcon(
                    FpIcons.map,
                    size: 20,
                    color: FpColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
        Semantics(
          label: l10n.filterByType,
          container: true,
          child: Wrap(
            spacing: FpSpace.x8,
            runSpacing: FpSpace.x8,
            children: [
              FpChip(
                label: l10n.filterAll,
                dot: FpColors.navy,
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              for (final t in CreditType.values)
                FpChip(
                  label: t.label(l10n),
                  dot: t.color,
                  selected: _filter == t,
                  onTap: () => setState(() => _filter = t),
                ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.merchantCount(shops.length),
                style: FpText.title,
              ),
            ),
            Text(
              l10n.sortByDistance,
              style: FpText.body(size: 13, color: FpColors.muted),
            ),
          ],
        ),
        for (final m in shops)
          _ShopCard(
            merchant: m,
            kind: _kind(l10n, m.kind),
            distance:
                '${NumberFormat('0.0', locale).format(m.distanceMeters / 1000)} km',
            onTap: () => context.push(
              '${Routes.pay}?type=${m.acceptedTypes.first.name}',
            ),
          ),
      ],
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.merchant,
    required this.kind,
    required this.distance,
    required this.onTap,
  });

  final Merchant merchant;
  final String kind;
  final String distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final main = merchant.acceptedTypes.first;
    Widget pill(Widget child) => Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.x12),
      decoration: BoxDecoration(
        color: FpColors.surface,
        borderRadius: BorderRadius.circular(FpRadius.pill),
      ),
      alignment: Alignment.center,
      child: child,
    );
    return FpPressable(
      onTap: onTap,
      semanticLabel: '${merchant.name}, $kind, $distance',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: FpColors.surface,
          borderRadius: BorderRadius.circular(FpRadius.ticket),
          border: Border.all(color: FpColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              color: main.tint,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: pill(
                      Text(
                        kind,
                        style: FpText.body(size: 12, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: pill(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: FpColors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: FpSpace.x6),
                          Text(
                            l10n.openNow,
                            style: FpText.body(
                              size: 12,
                              weight: FontWeight.w700,
                              color: FpColors.greenDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: ExcludeSemantics(
                      child: Opacity(
                        opacity: 0.35,
                        child: Text(
                          bigInitials(merchant.name),
                          style: FpText.display(
                            size: 64,
                            color: main.color,
                            height: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          merchant.name,
                          style: FpText.body(size: 17, weight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        distance,
                        style: FpText.body(size: 13, color: FpColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: FpSpace.x8),
                  Text(
                    merchant.city,
                    style: FpText.body(size: 13, color: FpColors.muted),
                  ),
                  const SizedBox(height: FpSpace.x8),
                  Wrap(
                    spacing: FpSpace.x6,
                    runSpacing: FpSpace.x6,
                    children: [
                      for (final t in merchant.acceptedTypes)
                        TagChip(
                          label: t.label(l10n),
                          tint: t.tint,
                          color: t.color,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
