import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/demo/demo_backend.dart';

import 'helpers.dart';

Future<void> payWith(WidgetTester tester, String type) async {
  await tapText(tester, 'Payer');
  tester.seeText('482 913');
  if (type != 'Restauration') await tapText(tester, type);
  await tapText(tester, 'Le caissier a scanné');
}

void nextOutcome(ProviderContainer c, DemoPaymentOutcome o) =>
    c.read(demoBackendProvider).nextOutcome = o;

void main() {
  testWidgets('S4 · Payer 57,500 chez Carrefour (approuvé)', (tester) async {
    await launchHome(tester);

    await payWith(tester, 'Restauration');
    tester.seeText('Caisse de Sami · La Marsa');
    await typePin(tester, '1234');
    await tapText(tester, 'Payer 57,500 TND');

    tester.seeText('APPROUVÉ');
    tester.seeText('Ticket approuvé');
    tester.seeText('142,500 TND');
    await tapText(tester, 'Partager le reçu');

    tester.seeText('Reçu');
    tester.seeText('TX-7F3A21');
    tester.seeText('Avenue Habib Bourguiba, La Marsa');
  });

  testWidgets('S5 · Refus : type non accepté', (tester) async {
    await launchHome(tester);

    await payWith(tester, 'Carburant');

    tester.seeText('REFUSÉ');
    tester.seeText('Type non accepté');
    tester.seeText('Carrefour n’accepte pas le crédit Carburant.');
    tester.seeText('Payer avec Restauration');
  });

  testWidgets('S6 · Refus : solde insuffisant', (tester) async {
    final c = await launchHome(tester);
    nextOutcome(c, DemoPaymentOutcome.insufficientFunds);

    await payWith(tester, 'Carburant');

    tester.seeText('Solde insuffisant');
    tester.seeText('Il vous manque 10,000 TND sur votre crédit Carburant.');
    tester.seeText('Réessayer avec 40,000');
  });

  testWidgets('S7 · Refus : commerce pas encore validé', (tester) async {
    final c = await launchHome(tester);

    await goTab(tester, 'Découvrir');
    tester.seeText('3 commerces');
    expect(textContaining('Boutique Yasmina'), findsNothing);

    await goTab(tester, 'Accueil');
    nextOutcome(c, DemoPaymentOutcome.merchantInactive);
    await payWith(tester, 'Restauration');

    tester.seeText('Commerce pas encore actif');
    tester.seeContaining('Aucun montant n’a été débité.');
    await tapText(tester, 'Voir les commerces acceptés');
    tester.seeText('Découvrir');
  });

  testWidgets('S8 · Refus : code expiré', (tester) async {
    final c = await launchHome(tester);
    nextOutcome(c, DemoPaymentOutcome.codeExpired);

    await payWith(tester, 'Restauration');

    tester.seeText('Code expiré');
    await tapText(tester, 'Afficher un nouveau code');
    tester.seeText('482 913');
    tester.seeText('Le code change toutes les 60 secondes');
  });
}
