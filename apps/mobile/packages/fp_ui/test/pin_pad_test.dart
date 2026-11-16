import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('PinPad envoie les chiffres, l’effacement et l’empreinte', (
    tester,
  ) async {
    final typed = <String>[];
    var deleted = 0;
    var bio = 0;
    await pumpUi(
      tester,
      PinPad(
        onDigit: typed.add,
        onDelete: () => deleted++,
        onBiometric: () => bio++,
      ),
    );

    for (final d in ['1', '9', '0']) {
      await tester.tap(find.text(d));
    }
    await tester.tap(find.bySemanticsLabel('Effacer'));
    await tester.tap(find.bySemanticsLabel('Utiliser mon empreinte'));

    expect(typed, ['1', '9', '0']);
    expect(deleted, 1);
    expect(bio, 1);
  });

  testWidgets('PinPad sans biométrie masque la touche empreinte', (
    tester,
  ) async {
    await pumpUi(tester, PinPad(onDigit: (_) {}, onDelete: () {}));
    expect(find.bySemanticsLabel('Utiliser mon empreinte'), findsNothing);
  });

  testWidgets('PinDots remplit autant de points que de chiffres saisis', (
    tester,
  ) async {
    await pumpUi(tester, const PinDots(filled: 3));
    final dots = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((c) => (c.decoration! as BoxDecoration).color)
        .toList();
    expect(dots.where((c) => c == FpColors.navy).length, 3);
    expect(dots.length, 4);
  });
}
