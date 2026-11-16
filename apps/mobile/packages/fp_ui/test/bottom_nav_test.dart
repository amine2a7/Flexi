import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('FpBottomNav : 4 onglets et le bouton central Payer', (
    tester,
  ) async {
    final taps = <String>[];
    FpNavItem item(FpIcons i, String l, {bool selected = false}) => FpNavItem(
      icon: i,
      label: l,
      selected: selected,
      onTap: () => taps.add(l),
    );
    await pumpUi(
      tester,
      FpBottomNav(
        leading: [
          item(FpIcons.home, 'Accueil', selected: true),
          item(FpIcons.store, 'Découvrir'),
        ],
        trailing: [
          item(FpIcons.clock, 'Historique'),
          item(FpIcons.user, 'Profil'),
        ],
        centerIcon: FpIcons.qr,
        centerLabel: 'Payer',
        onCenter: () => taps.add('Payer'),
      ),
    );

    await tester.tap(find.text('Découvrir'));
    await tester.tap(find.bySemanticsLabel('Payer'));
    await tester.tap(find.text('Profil'));
    expect(taps, ['Découvrir', 'Payer', 'Profil']);
  });

  testWidgets('FpBottomNav caissier : un seul onglet et le bouton central', (
    tester,
  ) async {
    await pumpUi(
      tester,
      FpBottomNav(
        leading: [
          FpNavItem(
            icon: FpIcons.list,
            label: 'Aujourd’hui',
            selected: true,
            onTap: () {},
          ),
        ],
        trailing: const [],
        centerIcon: FpIcons.scan,
        centerLabel: 'Encaisser',
        onCenter: () {},
      ),
    );
    expect(find.text('Aujourd’hui'), findsOneWidget);
    expect(find.bySemanticsLabel('Encaisser'), findsOneWidget);
    expect(find.text('Profil'), findsNothing);
  });
}
