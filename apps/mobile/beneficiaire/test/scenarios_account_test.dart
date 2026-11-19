import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/demo/demo_backend.dart';
import 'package:fp_core/fp_core.dart';

import 'helpers.dart';
import 'scenarios_payment_test.dart' show nfcTitle;

void main() {
  testWidgets('S9 · Voir un crédit et où l’utiliser', (tester) async {
    await launchHome(tester);

    await tap(tester, semantics('Restauration, 142,500 TND'));
    tester.seeText('SOLDE RESTAURATION');
    tester.seeText('Utilisé : 57,500');
    tester.seeText('Reçu : 200,000');
    tester.seeText('31/12');
    tester.seeText('Partagé avec Adam');

    await tapText(tester, 'El Medina');
    tester.seeText('3 commerces');
    await tapText(tester, 'Carburant');
    tester.seeText('1 commerce');
    tester.seeText('Station Ennour');
  });

  testWidgets('S10 · Historique du mois et reçu', (tester) async {
    await launchHome(tester);

    await goTab(tester, 'Historique');
    tester.seeText('DÉPENSÉ EN NOVEMBRE');
    expect(semantics('117,500 TND'), findsOneWidget);
    await tester.see('JEUDI 12 NOVEMBRE');
    await tester.see('Restauration 200 + Carburant 100');

    await tapText(tester, 'Station Ennour');
    tester.seeText('Reçu');
    tester.seeText('TX-5C1B09');
  });

  testWidgets('S11 · Créer un compte famille', (tester) async {
    await launchHome(tester);

    await goTab(tester, 'Profil');
    await tapText(tester, 'Comptes famille');
    tester.seeText('1 sur 5');
    await tapText(tester, 'Ajouter un membre');

    await tester.enterText(find.byKey(const Key('member-name')), 'Lina');
    await tester.enterText(find.byKey(const Key('member-last-name')), 'Jaziri');
    await tapText(tester, 'Enfant');
    await tester.enterText(
      find.byKey(const Key('member-contact')),
      '22 123 456',
    );
    await tester.enterText(find.byKey(const Key('member-amount')), '30');
    await tester.pumpAndSettle();
    await tap(tester, semantics('Augmenter'));
    tester.seeText('25,000 TND');
    await tapText(tester, 'Créer le compte de Lina');

    // Mot de passe affiché une seule fois.
    tester.seeText('Compte de Lina créé');
    tester.seeText('K7m-42Qa');
    await tapText(tester, 'Copier');
    tester.seeText('Copié');
    await tapText(tester, 'J’ai noté le mot de passe');

    tester.seeText('SOLDE DE LINA');
    expect(find.text('K7m-42Qa'), findsNothing);
  });

  testWidgets('S12 · Adam paie avec son compte famille', (tester) async {
    await launchHome(tester, account: DemoAccount.adam);

    tester.seeText('Bonjour, Adam');
    tester.seeText('Compte famille de Yasmine');
    tester.seeText('Encore 5 TND aujourd’hui');
    tester.seeText('15 / 20 TND');

    await tapText(tester, 'Payer');
    await tapText(tester, nfcTitle);
    tester.seeText('Caisse 1 · La Marsa');
    await typePin(tester, '1234');
    await tapText(tester, 'Payer 15,000 TND');

    tester.seeText('APPROUVÉ');
    tester.seeText('35,000 TND');
  });

  testWidgets('S13 · Reprendre le crédit d’Adam', (tester) async {
    await launchHome(tester);

    await tapText(tester, 'Famille');
    await tapText(tester, 'Adam');
    tester.seeText('SOLDE D’ADAM');
    tester.seeText('35,000 TND reviennent sur votre solde');
    await tapText(tester, 'Reprendre le crédit');

    tester.seeText('SOLDE RESTAURATION');
    expect(semantics('177,500 TND'), findsOneWidget);
  });

  testWidgets('S14 · Recevoir un crédit (notification)', (tester) async {
    await launchHome(tester);

    await tap(tester, semantics('Notifications, 2 non lues'));
    tester.seeText('Crédit reçu de BIAT');
    tester.seeText('+300,000 TND : Restauration 200 et Carburant 100.');
    tester.seeText('Adam a payé');
    tester.seeText('Nouvelle connexion');

    await tapText(tester, 'Tout lire');
    await tap(tester, semantics('Retour'));
    await tester.pumpAndSettle();
    expect(semantics('Notifications'), findsOneWidget);
  });

  testWidgets('S15 · Passer l’app en arabe', (tester) async {
    await launchHome(tester);

    await goTab(tester, 'Profil');
    await tapText(tester, 'العربية');

    tester.seeText('الرصيد المتاح');
    tester.seeText('أرصدتي');
    expect(semantics('182,500 د.ت'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.text('أرصدتي')));
    expect(dir, TextDirection.rtl);
  });

  testWidgets('S16 · Nouveau salarié sans crédit', (tester) async {
    await launchHome(tester, account: DemoAccount.omar);

    tester.seeText('Votre assiette est encore vide');
    tester.seeText(
      'Dès que BIAT vous attribue un crédit, il apparaît ici et vous recevez une notification.',
    );
    await tapText(tester, 'Découvrir les commerces');

    tester.seeText('3 commerces');
  });

  testWidgets('S17 · Pas de connexion Internet', (tester) async {
    final c = await launchHome(tester);

    c.read(connectivityProvider.notifier).setOnline(false);
    await tester.pumpAndSettle();
    tester.seeText('Vous êtes hors ligne');
    tester.seeText('DERNIER SOLDE CONNU');
    expect(semantics('182,500 TND'), findsOneWidget);
    tester.seeText('Le paiement a besoin d’Internet');

    await tapText(tester, 'Réessayer');
    tester.seeText('SOLDE DISPONIBLE');
  });

  testWidgets('S18 · Trouver de l’aide', (tester) async {
    await launchHome(tester);

    await goTab(tester, 'Profil');
    await tapText(tester, 'Besoin d’aide ?');
    tester.seeText('On vous aide');
    tester.seeContaining('Touchez le bouton vert Payer');

    await tapText(tester, 'Pourquoi mon paiement est refusé ?');
    tester.seeContaining('Le motif exact s’affiche à l’écran.');
    tester.seeText('support@flexipay.test');
  });
}
