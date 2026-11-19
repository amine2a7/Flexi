// Écrans du compte branchés sur l'API (faux serveur) : soldes par type, historique, reçu,
// notifications, famille (mot de passe affiché une seule fois, plafond, reprise, désactivation).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';

import 'package:fp_beneficiaire/app/app_router.dart';
import 'package:fp_beneficiaire/app/routes.dart';

import 'api_helpers.dart';
import 'helpers.dart';

const adamId = '0193a000-0000-7000-8000-0000000000f1';

void main() {
  testWidgets('API · Accueil : soldes par type', (tester) async {
    final server = beneficiaryServer();
    await launchApiHome(tester, server);

    tester.seeText('SOLDE DISPONIBLE');
    expect(semantics('Restauration, 142,500 TND'), findsOneWidget);
    await tester.see('Carrefour La Marsa');
  });

  testWidgets('API · Crédit Restauration : solde, reçu, utilisé, échéance', (
    tester,
  ) async {
    await launchApiHome(tester, beneficiaryServer());

    await tap(tester, semantics('Restauration, 142,500 TND'));
    tester.seeText('SOLDE RESTAURATION');
    tester.seeText('Utilisé : 57,500');
    tester.seeText('Reçu : 200,000');
    tester.seeText('31/12');
  });

  testWidgets('API · Historique du mois puis reçu', (tester) async {
    final server = beneficiaryServer();
    await launchApiHome(tester, server);

    await goTab(tester, 'Historique');
    await tester.see('Carrefour La Marsa');
    final month = server.calls('GET', '/v1/employee/operations').last.query;
    expect(month['createdFrom'], isNotNull);
    expect(month['createdTo'], isNotNull);

    await tapText(tester, 'Carrefour La Marsa');
    tester.seeText('Reçu');
    tester.seeText('PAY-7F3A21');
    expect(
      server.calls(
        'GET',
        '/v1/employee/operations/0193a000-0000-7000-8000-0000000000a1',
      ),
      hasLength(1),
    );
  });

  testWidgets('API · Notifications : crédit reçu, tout lire', (tester) async {
    final server = beneficiaryServer();
    await launchApiHome(tester, server);

    await tap(tester, find.bySemanticsLabel(RegExp('^Notifications')));
    tester.seeText('Crédit reçu de BIAT');
    await tapText(tester, 'Tout lire');
    expect(
      server.calls('POST', '/v1/employee/notifications/read'),
      hasLength(1),
    );
  });

  testWidgets(
    'API · Famille : créer (mot de passe une fois), partager avec plafond',
    (tester) async {
      final server = beneficiaryServer()
        ..on(
          'POST',
          '/v1/employee/family/members',
          (_) => FakeResponse(
            201,
            json: {
              'id': '0193a000-0000-7000-8000-0000000000f2',
              'firstName': 'Lina',
              'lastName': 'Jaziri',
              'relationship': 'CHILD',
              'credentials': {
                'email': 'lina@biat.test',
                'temporaryPassword': 'Tmp-8hQ2xL',
              },
            },
          ),
        )
        ..on(
          'POST',
          '/v1/employee/family/transfers',
          (_) => FakeResponse(
            201,
            json: {
              'memberId': '0193a000-0000-7000-8000-0000000000f2',
              'creditType': 'RESTAURATION',
              'amountMillimes': 30000,
              'transactionId': '0193a000-0000-7000-8000-0000000000x1',
            },
          ),
        );
      await launchApiHome(tester, server);

      await goTab(tester, 'Profil');
      await tapText(tester, 'Comptes famille');
      tester.seeText('Adam');
      await tapText(tester, 'Ajouter un membre');
      await tester.enterText(find.byKey(const Key('member-name')), 'Lina');
      await tester.enterText(
        find.byKey(const Key('member-last-name')),
        'Jaziri',
      );
      await tapText(tester, 'Enfant');
      await tester.enterText(
        find.byKey(const Key('member-contact')),
        '22 123 456',
      );
      await tester.enterText(find.byKey(const Key('member-amount')), '30');
      await tester.pumpAndSettle();
      await tapText(tester, 'Créer le compte de Lina');

      tester.seeText('Compte de Lina créé');
      tester.seeText('Tmp-8hQ2xL');
      final member = server
          .calls('POST', '/v1/employee/family/members')
          .single
          .json;
      expect(member, {
        'firstName': 'Lina',
        'lastName': 'Jaziri',
        'relationship': 'CHILD',
        'phone': '+21622123456',
      });
      final transfer = server
          .calls('POST', '/v1/employee/family/transfers')
          .single;
      expect(transfer.idempotencyKey, isNotNull);
      expect(transfer.json['amountMillimes'], 30000);
      expect(transfer.json['creditType'], 'RESTAURATION');
      expect(transfer.json['dailyLimitMillimes'], isA<int>());

      await tapText(tester, 'J’ai noté le mot de passe');
      expect(find.text('Tmp-8hQ2xL'), findsNothing);
    },
  );

  testWidgets('API · Famille : reprendre le crédit puis désactiver le compte', (
    tester,
  ) async {
    final server = beneficiaryServer()
      ..on(
        'POST',
        '/v1/employee/family/members/{id}/reclaim',
        (_) =>
            FakeResponse.ok({'memberId': adamId, 'reclaimedMillimes': 35000}),
      )
      ..on(
        'DELETE',
        '/v1/employee/family/members/{id}',
        (_) => FakeResponse.ok({'memberId': adamId, 'reclaimedMillimes': 0}),
      );
    final (container, _) = await launchApiHome(tester, server);

    await goTab(tester, 'Profil');
    await tapText(tester, 'Comptes famille');
    await tapText(tester, 'Adam');
    tester.seeText('SOLDE D’ADAM');
    // Pas de route pour un nouveau mot de passe : l'action n'est pas proposée.
    expect(find.text('Nouveau mot de passe'), findsNothing);
    await tapText(tester, 'Reprendre le crédit');
    final reclaim = server
        .calls('POST', '/v1/employee/family/members/$adamId/reclaim')
        .single;
    expect(reclaim.json, {'creditType': null});
    expect(reclaim.idempotencyKey, isNotNull);

    // Après la reprise, l'app ouvre le crédit : retour sur la fiche d'Adam.
    container.read(routerProvider).go(Routes.familyMember(adamId));
    await tester.pumpAndSettle();
    await tapText(tester, 'Désactiver le compte');
    final disable = server
        .calls('DELETE', '/v1/employee/family/members/$adamId')
        .single;
    expect(disable.idempotencyKey, isNotNull);
  });

  testWidgets('API · Compte famille : accueil réduit avec le plafond du jour', (
    tester,
  ) async {
    final server = beneficiaryServer(role: 'FAMILY_MEMBER');
    final (_, store) = await launchApi(tester, server);
    await signIn(tester);

    tester.seeText('Bonjour, Adam');
    tester.seeText('5 / 20 TND');
    expect(await store.read(SecureKey.refreshToken), refreshToken);
  });

  testWidgets('API · Profil : identité et compteurs', (tester) async {
    await launchApiHome(tester, beneficiaryServer());

    await goTab(tester, 'Profil');
    tester.seeText('Yasmine Jaziri');
    tester.seeText('BIAT');
  });
}
