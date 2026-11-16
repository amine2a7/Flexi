import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('CreditCard avec crédit : solde, barre et « sur 200 TND »', (
    tester,
  ) async {
    var tapped = false;
    await pumpUi(
      tester,
      CreditCard(
        type: CreditType.food,
        balance: 142500,
        received: 200000,
        onTap: () => tapped = true,
      ),
    );

    expect(find.text('Restauration'), findsOneWidget);
    expect(find.text('142,500'), findsOneWidget);
    expect(find.text('sur 200 TND'), findsOneWidget);
    final bar = tester.widget<FpProgressBar>(find.byType(FpProgressBar));
    expect(bar.value, closeTo(0.7125, 0.0001));

    await tester.tap(find.byType(CreditCard));
    expect(tapped, isTrue);
  });

  testWidgets(
    'CreditCard sans crédit : « Pas encore de crédit » et bordure pointillée',
    (tester) async {
      await pumpUi(
        tester,
        const CreditCard(type: CreditType.gifts, balance: null, received: null),
      );

      expect(find.text('Cadeaux'), findsOneWidget);
      expect(find.text('Pas encore de crédit'), findsOneWidget);
      expect(find.byType(DashedBorderBox), findsOneWidget);
      expect(find.byType(FpProgressBar), findsNothing);
    },
  );
}
