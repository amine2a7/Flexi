import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('C1 · Sami encaisse un paiement', (tester) async {
    await launchPro(tester);

    // Caissier : seulement Aujourd'hui et Encaisser.
    tester.seeText('Caisse de Sami');
    expect(find.text('Solde'), findsNothing);
    expect(find.text('Équipe'), findsNothing);

    await collect(tester, code: '482 913', amount: '57,500');
    tester.seeText('Yasmine B. · BIAT');
    tester.seeText('Client reconnu · Restauration 142,500 dispo');
    await tapText(tester, 'Encaisser 57,500 TND');

    tester.seeText('APPROUVÉ');
    tester.seeText('Paiement approuvé');
    tester.seeText('Le client a confirmé avec son PIN.');
    tester.seeText('TX-7F3A21');
    await tapText(tester, 'Voir la journée');

    tester.seeText('ENCAISSÉ AUJOURD’HUI');
    expect(find.bySemanticsLabel('72,500 TND'), findsOneWidget);
    tester.seeText('36,250');
    tester.seeText('Adam (famille)');
  });

  testWidgets('C2 · Encaissement refusé', (tester) async {
    await launchPro(tester);

    await collect(tester, code: '731406', amount: '57,500');
    tester.seeText('Omar · BIAT');
    await tapText(tester, 'Encaisser 57,500 TND');

    tester.seeText('REFUSÉ');
    tester.seeText('Paiement refusé');
    tester.seeText(
      'Solde Restauration insuffisant : il manque 7,500 TND. Rien n’a été débité.',
    );
    await tapText(tester, 'Voir la journée');

    tester.seeText('Omar · refusé');
    tester.seeText('Solde insuffisant · 13:20');
  });

  testWidgets('C3 · Le propriétaire demande son reversement', (tester) async {
    await launchPro(tester, email: 'carrefour@flexipay.test');

    await goTab(tester, 'Aujourd’hui');
    expect(find.bySemanticsLabel('72,500 TND'), findsOneWidget);
    tester.seeText('Moi');

    await goTab(tester, 'Solde');
    tester.seeText('Commission 2 %');
    tester.seeText('−1,450');
    tester.seeText('−0,276');
    tester.seeText('−1,726');
    tester.seeText('0,000 (frais sous 1 000)');
    expect(find.bySemanticsLabel('65,774 TND'), findsOneWidget);
    await tapText(tester, 'Demander le reversement');

    tester.seeText('DEMANDE RV-0012');
    tester.seeText('Demandé');
    tester.seeText('Acceptation par FlexiPay');
    tester.seeText('Payé + référence bancaire');
    tester.seeText('RV-0011 · Payé');
  });

  testWidgets('C4 · Le propriétaire ajoute un caissier', (tester) async {
    await launchPro(tester, email: 'carrefour@flexipay.test');

    await goTab(tester, 'Équipe');
    tester.seeText('Sami · Caissier');
    await tapText(tester, 'Ajouter un caissier');
    await tester.enterText(
      find.byKey(const Key('cashier-name')),
      'Nadia Trabelsi',
    );
    await tester.enterText(
      find.byKey(const Key('cashier-email')),
      'nadia@flexipay.test',
    );
    await tester.pumpAndSettle();
    await tapText(tester, 'Créer le caissier');

    tester.seeText('Mot de passe temporaire (affiché une seule fois)');
    tester.seeText('Pq9-73Lm');
    await tapText(tester, 'Copier');
    tester.seeText('Copié');
    await tapText(tester, 'J’ai noté le mot de passe');

    expect(find.text('Pq9-73Lm'), findsNothing);
    tester.seeText('Nadia Trabelsi · Caissier');
  });
}
