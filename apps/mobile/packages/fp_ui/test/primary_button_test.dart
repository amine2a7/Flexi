import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('FpButton principal : vert, 54 px, appelle onPressed', (
    tester,
  ) async {
    var pressed = 0;
    await pumpUi(
      tester,
      FpButton(label: 'Valider mon ticket', onPressed: () => pressed++),
    );

    await tester.tap(find.text('Valider mon ticket'));
    expect(pressed, 1);
    expect(tester.getSize(find.byType(FpButton)).height, FpSize.button);
    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(FpButton),
        matching: find.byType(Container),
      ),
    );
    expect((box.decoration! as BoxDecoration).color, FpColors.green);
  });

  testWidgets('FpButton désactivé : gris et sans action', (tester) async {
    await pumpUi(tester, const FpButton(label: 'Entrer'));
    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(FpButton),
        matching: find.byType(Container),
      ),
    );
    expect((box.decoration! as BoxDecoration).color, FpColors.track);
  });
}
