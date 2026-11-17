import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/demo/demo_backend.dart';

import 'helpers.dart';

const nfcTitle = "Approchez votre téléphone de l'autocollant FlexiPay";

/// Ouvre Payer puis « approche » l'autocollant de la caisse (simulé en démo).
Future<void> tapSticker(WidgetTester tester) async {
  await tapText(tester, 'Payer');
  tester.seeText('Scanner le QR');
  tester.seeText('Taper le code de la caisse');
  await tapText(tester, nfcTitle);
}

Future<void> confirmWithPin(WidgetTester tester, String amount) async {
  await typePin(tester, '1234');
  await tapText(tester, 'Payer $amount TND');
}

void nextOutcome(ProviderContainer c, DemoPaymentOutcome o) =>
    c.read(demoBackendProvider).nextOutcome = o;

void main() {
  testWidgets('S4 · Payer 57,500 chez Carrefour par l’autocollant (approuvé)', (
    tester,
  ) async {
    await launchHome(tester);

    await tapSticker(tester);
    tester.seeText('Carrefour');
    tester.seeText('Caisse 1 · La Marsa');
    tester.seeText('Restauration');
    await confirmWithPin(tester, '57,500');

    tester.seeText('APPROUVÉ');
    tester.seeText('Ticket approuvé');
    tester.seeText('142,500 TND');
    await tapText(tester, 'Partager le reçu');

    tester.seeText('Reçu');
    tester.seeText('TX-7F3A21');
    tester.seeText('Avenue Habib Bourguiba, La Marsa');
  });

  testWidgets('S5 · Refus : type non accepté', (tester) async {
    final c = await launchHome(tester);
    nextOutcome(c, DemoPaymentOutcome.typeNotAccepted);

    await tapSticker(tester);
    tester.seeText('Carburant');
    await confirmWithPin(tester, '10,000');

    tester.seeText('REFUSÉ');
    tester.seeText('Type non accepté');
    tester.seeText('Carrefour n’accepte pas le crédit Carburant.');
    await tapText(tester, 'Réessayer');
    tester.seeText(nfcTitle);
  });

  testWidgets('S6 · Refus : solde insuffisant', (tester) async {
    final c = await launchHome(tester);
    nextOutcome(c, DemoPaymentOutcome.insufficientFunds);

    await tapSticker(tester);
    tester.seeText('Station Ennour');
    await confirmWithPin(tester, '50,000');

    tester.seeText('Solde insuffisant');
    tester.seeText('Il vous manque 10,000 TND sur votre crédit Carburant.');
  });

  testWidgets('S7 · Refus : commerce pas encore validé', (tester) async {
    final c = await launchHome(tester);

    await goTab(tester, 'Découvrir');
    tester.seeText('3 commerces');
    expect(textContaining('Boutique Yasmina'), findsNothing);

    await goTab(tester, 'Accueil');
    nextOutcome(c, DemoPaymentOutcome.merchantInactive);
    await tapSticker(tester);

    tester.seeText('Commerce pas encore actif');
    tester.seeContaining('Aucun montant n’a été débité.');
    await tapText(tester, 'Voir les commerces acceptés');
    tester.seeText('Découvrir');
  });

  testWidgets('S8 · Refus : demande expirée, puis déjà payée', (tester) async {
    final c = await launchHome(tester);
    nextOutcome(c, DemoPaymentOutcome.codeExpired);

    await tapSticker(tester);
    await confirmWithPin(tester, '57,500');
    tester.seeText('Demande expirée');
    await tapText(tester, 'Réessayer');

    nextOutcome(c, DemoPaymentOutcome.alreadyPaid);
    await tapText(tester, nfcTitle);
    tester.seeText('Déjà payée');
    tester.seeText('Un autre client a déjà payé cette demande.');
  });

  testWidgets('S8b · Code de la caisse tapé à la main', (tester) async {
    await launchHome(tester);

    await tapText(tester, 'Payer');
    await tapText(tester, 'Taper le code de la caisse');
    tester.seeText('4 chiffres affichés à la caisse');
    await typePin(tester, '1111');
    tester.seeText('Aucune demande en caisse');
    await tapText(tester, 'Réessayer');
    await tapText(tester, 'Taper le code de la caisse');

    await typePin(tester, '4827');
    tester.seeText('Caisse 1 · La Marsa');
    await confirmWithPin(tester, '57,500');
    tester.seeText('APPROUVÉ');
  });

  testWidgets('S8c · Autocollant inconnu et scanner du QR', (tester) async {
    final c = await launchHome(tester);

    await tapText(tester, 'Payer');
    await tapText(tester, 'Scanner le QR');
    tester.seeText("Scannez le QR de l'autocollant");
    await tap(tester, find.bySemanticsLabel('Retour'));

    nextOutcome(c, DemoPaymentOutcome.stickerInvalid);
    await tapText(tester, nfcTitle);
    tester.seeText('Autocollant invalide');
  });
}
