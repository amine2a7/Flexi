import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('ListRow dans un ListGroup : titre, sous-titre, montant, tap', (
    tester,
  ) async {
    var tapped = 0;
    await pumpUi(
      tester,
      ListGroup(
        children: [
          ListRow(
            leading: const IconTile(
              tint: FpColors.foodTint,
              color: FpColors.food,
              text: 'C',
            ),
            title: 'Carrefour',
            subtitle: 'Restauration · Aujourd’hui 12:41',
            trailing: ListRow.amount('−57,500'),
            onTap: () => tapped++,
          ),
          const ListRow(
            leading: IconTile(
              tint: FpColors.greenTint,
              color: FpColors.greenDark,
              icon: FpIcons.lock,
            ),
            title: 'Changer mon PIN',
            chevron: true,
          ),
        ],
      ),
    );

    expect(find.text('Carrefour'), findsOneWidget);
    expect(find.text('Restauration · Aujourd’hui 12:41'), findsOneWidget);
    expect(find.text('−57,500'), findsOneWidget);
    await tester.tap(find.text('Carrefour'));
    expect(tapped, 1);
  });
}
