import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fp_pro/demo/pro_demo_backend.dart';

import 'helpers.dart';

void main() {
  testWidgets('C1 · Sami encaisse un paiement par l’autocollant', (
    tester,
  ) async {
    await launchPro(tester);

    // Caissier : seulement Aujourd'hui et Encaisser.
    tester.seeText('Caisse de Sami');
    tester.seeText('Ma caisse · Caisse 1');
    expect(find.text('Solde'), findsNothing);
    expect(find.text('Équipe'), findsNothing);

    await request(tester, amount: '57,500');
    tester.seeText('En attente du client…');
    tester.seeText('4 8 2 7');
    tester.seeText('2:00');
    await tester.pump(const Duration(seconds: 1));
    tester.seeText('1:59');

    await customerPays(tester);
    tester.seeText('APPROUVÉ');
    tester.seeText('Paiement approuvé');
    tester.seeText('Payé par Yasmine');
    tester.seeText('Le client a confirmé avec son PIN.');
    tester.seeText('TX-7F3A21');
    await tapText(tester, 'Voir la journée');

    tester.seeText('ENCAISSÉ AUJOURD’HUI');
    expect(find.bySemanticsLabel('72,500 TND'), findsOneWidget);
    tester.seeText('36,250');
    tester.seeText('Adam (famille)');
  });

  testWidgets('C2 · Paiement refusé, prénom du client affiché', (tester) async {
    final c = await launchPro(tester);
    c.read(proDemoBackendProvider).nextCustomer = ProDemoCustomer.omar;

    await request(tester, amount: '57,500');
    await customerPays(tester);

    tester.seeText('REFUSÉ');
    tester.seeText('Paiement refusé');
    tester.seeText('Refusé pour Omar');
    tester.seeText(
      'Solde Restauration insuffisant : il manque 7,500 TND. Rien n’a été débité.',
    );
    await tapText(tester, 'Voir la journée');

    tester.seeText('Omar · refusé');
    tester.seeText('Solde insuffisant · 13:20');
  });

  testWidgets('C2b · Demande annulée puis demande expirée', (tester) async {
    final c = await launchPro(tester);
    c.read(proDemoBackendProvider).nextCustomer = ProDemoCustomer.nobody;

    await request(tester, amount: '12,000');
    await tapText(tester, 'Annuler la demande');
    tester.seeText('Demande annulée');
    await tapText(tester, 'Nouvelle demande');

    await request(tester, amount: '12,000');
    await tester.pump(const Duration(seconds: 121));
    await tester.pumpAndSettle();
    tester.seeText('Demande expirée');
    tester.seeText('Nouvelle demande');
  });

  testWidgets('C2c · Plafond famille atteint', (tester) async {
    final c = await launchPro(tester);
    c.read(proDemoBackendProvider).nextCustomer = ProDemoCustomer.adam;

    await request(tester, amount: '15,000');
    await customerPays(tester);
    tester.seeText('Refusé pour Adam');
    tester.seeText("Plafond du jour atteint. Rien n'a été débité.");
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

  testWidgets('C5 · Le propriétaire associe un autocollant à une caisse', (
    tester,
  ) async {
    await launchPro(tester, email: 'carrefour@flexipay.test');

    await goTab(tester, 'Équipe');
    await tapText(tester, 'Mes caisses');
    tester.seeText('Drive');
    tester.seeText('Désactivée');
    await tapText(tester, 'Caisse 1');

    tester.seeText("Approchez l'autocollant NFC du téléphone");
    tester.seeText('Le lien de Caisse 1 y sera écrit.');
    await tapText(tester, "Approchez l'autocollant NFC du téléphone");
    tester.seeText('Autocollant associé à Caisse 1');
  });
}
