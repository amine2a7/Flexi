import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'BalanceHero affiche le libellé, la pastille et le montant en TND',
    (tester) async {
      await pumpUi(
        tester,
        const BalanceHero(
          label: 'Solde disponible',
          badge: 'Offert par BIAT',
          amount: 182500,
          bottom: Text('actions'),
        ),
      );

      expect(find.text('SOLDE DISPONIBLE'), findsOneWidget);
      expect(find.text('Offert par BIAT'), findsOneWidget);
      expect(find.bySemanticsLabel('182,500 TND'), findsOneWidget);
      expect(find.text('actions'), findsOneWidget);
    },
  );

  testWidgets('BalanceHero en arabe : devise د.ت', (tester) async {
    await pumpUi(
      tester,
      const BalanceHero(label: 'x', amount: 182500),
      locale: const Locale('ar'),
    );

    expect(find.bySemanticsLabel('182,500 د.ت'), findsOneWidget);
  });
}
