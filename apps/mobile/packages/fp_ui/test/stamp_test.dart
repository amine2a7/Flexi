import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('Stamp APPROUVÉ s’anime puis se pose', (tester) async {
    await pumpUi(
      tester,
      const Stamp(kind: StampKind.approved),
      reduceMotion: false,
    );

    final opacity = find.descendant(
      of: find.byType(Stamp),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(opacity).opacity, 0);
    await tester.pumpAndSettle();
    expect(tester.widget<Opacity>(opacity).opacity, 1);
    expect(find.text('APPROUVÉ'), findsOneWidget);
  });

  testWidgets(
    'Stamp REFUSÉ, posé immédiatement si les animations sont réduites',
    (tester) async {
      await pumpUi(tester, const Stamp(kind: StampKind.refused));
      expect(find.text('REFUSÉ'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    },
  );
}
