import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('TicketCard affiche le haut, la perforation et deux encoches', (
    tester,
  ) async {
    await pumpUi(
      tester,
      const TicketCard(top: Text('Connexion'), bottom: Text('E-mail')),
    );

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.byType(DashedLine), findsOneWidget);
    final notches = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.constraints?.maxWidth == FpSize.notch &&
          (w.decoration as BoxDecoration?)?.shape == BoxShape.circle,
    );
    expect(notches, findsNWidgets(2));
  });

  testWidgets('TicketCard marine : fond navy et encoches sans bordure', (
    tester,
  ) async {
    await pumpUi(tester, const TicketCard(dark: true, top: Text('Solde')));

    final card = tester.widget<Container>(
      find
          .ancestor(of: find.text('Solde'), matching: find.byType(Container))
          .last,
    );
    expect((card.decoration! as BoxDecoration).color, FpColors.navy);
  });
}
