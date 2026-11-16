import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/demo/demo_backend.dart';

import 'helpers.dart';

void main() {
  testWidgets('S1 · Première connexion de Yasmine', (tester) async {
    await launchApp(tester, onboarded: false);

    // Bienvenue : 3 écrans.
    tester.seeText('Tous vos avantages au même endroit');
    await tapText(tester, 'Suivant');
    tester.seeText('Payez en montrant un ticket');
    await tapText(tester, 'Suivant');
    tester.seeText('Partagez avec votre famille');
    await tapText(tester, 'Se connecter');

    // Connexion avec l'e-mail et le mot de passe reçus du RH.
    tester.seeText('Connexion');
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'Flexi2026',
    );
    await tapText(tester, 'Valider mon ticket');

    // Nouveau mot de passe.
    tester.seeContaining('Première connexion.');
    await tester.enterText(
      find.byKey(const Key('new-password')),
      'Yasmine2026',
    );
    await tester.enterText(
      find.byKey(const Key('confirm-password')),
      'Yasmine2026',
    );
    await tester.pumpAndSettle();
    await tapText(tester, 'Enregistrer et continuer');

    // PIN à 4 chiffres.
    tester.seeText('Créez votre PIN');
    await typePin(tester, '2580');
    await tapText(tester, 'Continuer');

    // Accueil avec les soldes par type.
    tester.seeText('SOLDE DISPONIBLE');
    tester.seeText('Bonjour,');
    tester.seeText('Restauration');
    tester.seeText('Carburant');
  });

  testWidgets('S2 · Connexion de tous les jours (empreinte)', (tester) async {
    await launchApp(tester, known: DemoAccount.yasmine);

    tester.seeText('Bon retour, Yasmine');
    await tap(tester, semantics('Utiliser mon empreinte'));

    tester.seeText('SOLDE DISPONIBLE');
  });

  testWidgets('S3 · PIN faux 3 fois, compte bloqué', (tester) async {
    await launchApp(tester, known: DemoAccount.yasmine);

    await typePin(tester, '0000');
    await tapText(tester, 'Entrer');
    tester.seeText('PIN incorrect. Encore 2 essais.');
    await typePin(tester, '0000');
    await tapText(tester, 'Entrer');
    tester.seeText('PIN incorrect. Encore 1 essai.');
    await typePin(tester, '0000');
    await tapText(tester, 'Entrer');

    // Compte bloqué 15 min, compte à rebours et paliers.
    tester.seeText('Compte bloqué pour un moment');
    tester.seeText('14:59');
    tester.seeText('2e blocage : 30 minutes');

    // Mot de passe oublié : seul le RH ou le support.
    await tapText(tester, 'Se connecter avec l’e-mail');
    await tapText(tester, 'Mot de passe oublié ?');
    tester.seeText('Pas de panique');
    tester.seeText('Votre RH · BIAT');
    await tapText(tester, 'Retour à la connexion');

    tester.seeText('Valider mon ticket');
  });
}
