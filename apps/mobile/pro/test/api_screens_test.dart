// App Pro branchée sur l'API (faux serveur) : connexion avec code, encaissement avec
// Idempotency-Key et suivi SSE, annulation, journée, reversement, caisses, équipe.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';

import 'api_helpers.dart';
import 'helpers.dart';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  testWidgets(
    'API Pro · Connexion : mot de passe puis code, session de la caisse',
    (tester) async {
      final server = proServer();
      await launchProApi(tester, server);

      tester.seeText('Ma caisse · Caisse 1');
      final verify = server.calls('POST', '/v1/mobile/auth/mfa/verify').single;
      expect(verify.json['code'], '123456');
      expect(
        verify.json['challengeId'],
        '0193b000-0000-7000-8000-0000000000m1',
      );
      expect(
        server.calls('GET', '/v1/merchant/registers').first.authorization,
        'Bearer acc-pro',
      );
    },
  );

  testWidgets('API Pro · Première connexion : nouveau mot de passe', (
    tester,
  ) async {
    final server = proServer()
      ..on(
        'POST',
        '/v1/mobile/auth/mfa/verify',
        (_) => FakeResponse.ok(session(step: 'PASSWORD_CHANGE')),
      )
      ..on(
        'POST',
        '/v1/mobile/auth/password/change',
        (_) => FakeResponse.ok(session()),
      );
    await launchProApi(tester, server);

    await tester.enterText(find.byKey(const Key('new-password')), 'Caisse2026');
    await tester.enterText(
      find.byKey(const Key('confirm-password')),
      'Caisse2026',
    );
    await tester.pumpAndSettle();
    await tapText(tester, 'Enregistrer et continuer');

    tester.seeText('Ma caisse · Caisse 1');
    expect(
      server.calls('POST', '/v1/mobile/auth/password/change').single.json,
      {'newPassword': 'Caisse2026'},
    );
  });

  testWidgets(
    'API Pro · Double authentification à activer : message, pas de session',
    (tester) async {
      final server = proServer()
        ..on(
          'POST',
          '/v1/mobile/auth/mfa/verify',
          (_) => FakeResponse.ok(session(step: 'MFA_ENROLL')),
        );
      await launchProApi(tester, server);

      tester.seeText(lookupFpL10n(const Locale('fr')).mfaEnrollOnWeb);
      expect(server.calls('POST', '/v1/mobile/auth/logout'), hasLength(1));
    },
  );

  testWidgets(
    'API Pro · Encaisser : demande, attente SSE, payé avec le prénom',
    (tester) async {
      final events = TillEvents();
      final server = proServer()
        ..on(
          'GET',
          '/v1/merchant/registers/{id}/checkouts/events',
          events.open,
        );
      await launchProApi(tester, server);

      await request(tester, amount: '57,500');
      tester.seeText('En attente du client…');
      tester.seeText('4 8 2 7');
      tester.seeText('2:00');
      final created = server
          .calls('POST', '/v1/merchant/registers/$registerId/checkouts')
          .single;
      expect(created.json, {
        'amountMillimes': 57500,
        'creditType': 'RESTAURATION',
      });
      expect(created.idempotencyKey, matches(_uuidV4));

      // Le flux s'ouvre sur la demande en cours, puis « payé » arrive.
      events.send(checkout());
      events.send(
        checkout(
          status: 'PAID',
          extra: {
            'customerFirstName': 'Yasmine',
            'paymentReference': 'PAY-7F3A21',
            'paidAt': iso(DateTime.now()),
          },
        ),
      );
      await tester.pumpAndSettle();

      tester.seeText('APPROUVÉ');
      tester.seeText('Payé par Yasmine');
      tester.seeText('PAY-7F3A21');
      events.close();
    },
  );

  testWidgets(
    'API Pro · Refus du client en temps réel : prénom, aucun montant',
    (tester) async {
      final events = TillEvents();
      final server = proServer()
        ..on(
          'GET',
          '/v1/merchant/registers/{id}/checkouts/events',
          events.open,
        );
      await launchProApi(tester, server);

      await request(tester, amount: '57,500');
      events.send(
        checkout(
          extra: {
            'lastRefusal': {
              'code': 'INSUFFICIENT_FUNDS',
              'customerFirstName': 'Omar',
              'occurredAt': iso(DateTime.now()),
            },
          },
        ),
      );
      await tester.pumpAndSettle();

      tester.seeText('REFUSÉ');
      tester.seeText('Refusé pour Omar');
      tester.seeText("Solde insuffisant. Rien n'a été débité.");
      events.close();
    },
  );

  testWidgets(
    'API Pro · Coupure à la création : statut par clé, une seule demande',
    (tester) async {
      final events = TillEvents();
      String? key;
      final server = proServer()
        ..on('GET', '/v1/merchant/registers/{id}/checkouts/events', events.open)
        ..on('POST', '/v1/merchant/registers/{id}/checkouts', (request) {
          key = request.idempotencyKey;
          throw const NetworkCut();
        })
        ..on(
          'GET',
          '/v1/merchant/checkouts/by-idempotency-key/{key}',
          (request) => request.path.endsWith('/$key')
              ? FakeResponse.ok(checkout())
              : FakeResponse.problem(404, 'NOT_FOUND'),
        );
      await launchProApi(tester, server);

      await request(tester, amount: '57,500');

      tester.seeText('En attente du client…');
      expect(server.callsTo('POST', '/v1/merchant/registers/'), hasLength(1));
      expect(
        server.callsTo('GET', '/v1/merchant/checkouts/by-idempotency-key/'),
        hasLength(1),
      );
      events.close();
    },
  );

  testWidgets('API Pro · Annuler la demande', (tester) async {
    final events = TillEvents();
    final server = proServer()
      ..on('GET', '/v1/merchant/registers/{id}/checkouts/events', events.open);
    await launchProApi(tester, server);

    await request(tester, amount: '57,500');
    await tapText(tester, 'Annuler la demande');

    tester.seeText('Demande annulée');
    expect(
      server.calls('POST', '/v1/merchant/checkouts/$checkoutId/cancel'),
      hasLength(1),
    );
    events.close();
  });

  testWidgets('API Pro · Journée : encaissements depuis minuit', (
    tester,
  ) async {
    final server = proServer();
    await launchProApi(tester, server);

    await goTab(tester, 'Aujourd’hui');
    expect(find.bySemanticsLabel('57,500 TND'), findsOneWidget);
    tester.seeText('Yasmine J.');
    expect(
      server.calls('GET', '/v1/merchant/payments').last.query['createdFrom'],
      isNotNull,
    );
  });

  testWidgets(
    'API Pro · Solde à reverser, simulation du serveur puis demande',
    (tester) async {
      final server = proServer(subRole: 'OWNER')
        ..on(
          'GET',
          '/v1/merchant/receivables',
          (_) => FakeResponse.ok({
            'data': <Object>[],
            'page': {'limit': 1, 'hasMore': false, 'nextCursor': null},
            'totalMillimes': 72500,
          }),
        )
        ..on(
          'POST',
          '/v1/merchant/payout-quotes',
          (_) => FakeResponse.ok({
            'quoteId': '0193b000-0000-7000-8000-0000000000q1',
            'creditType': 'RESTAURATION',
            'grossMillimes': 72500,
            'commissionRateBps': 200,
            'commissionMillimes': 1450,
            'vatRateBps': 1900,
            'vatMillimes': 276,
            'stampDutyMillimes': 1000,
            'withholdingRateBps': 0,
            'withholdingMillimes': 0,
            'transferFeeMillimes': 4000,
            'netMillimes': 65774,
            'availableMillimes': 72500,
            'expiresAt': iso(DateTime.now().add(const Duration(minutes: 10))),
          }),
        )
        ..on(
          'POST',
          '/v1/merchant/payouts',
          (_) => FakeResponse(201, json: _payout('RV-0012', 'REQUESTED')),
        )
        ..on(
          'GET',
          '/v1/merchant/payouts',
          (_) => FakeResponse.ok({
            'data': [
              _payout('RV-0012', 'REQUESTED'),
              _payout('RV-0011', 'EXECUTED'),
            ],
            'page': {'limit': 50, 'hasMore': false, 'nextCursor': null},
          }),
        )
        ..on('GET', '/v1/team/users', (_) => FakeResponse.ok({'data': _team}));
      await launchProApi(tester, server);

      await goTab(tester, 'Solde');
      expect(find.textContaining('Commission 2'), findsOneWidget);
      tester.seeText('−1,450');
      tester.seeText('−0,276');
      expect(find.bySemanticsLabel('65,774 TND'), findsOneWidget);
      await tapText(tester, 'Demander le reversement');

      final created = server.calls('POST', '/v1/merchant/payouts').single;
      expect(created.json, {'quoteId': '0193b000-0000-7000-8000-0000000000q1'});
      expect(created.idempotencyKey, matches(_uuidV4));
      tester.seeText('DEMANDE RV-0012');
      tester.seeText('RV-0011 · Payé');
    },
  );

  testWidgets('API Pro · Mes caisses : PDF de l’autocollant et écriture NFC', (
    tester,
  ) async {
    final writer = RecordingWriter();
    const url =
        'https://pay.flexipay.tn/c/AbCdEfGhIjKlMnOp?s=sig_0123456789abcdef';
    final server = proServer(subRole: 'OWNER')
      ..on('GET', '/v1/team/users', (_) => FakeResponse.ok({'data': _team}))
      ..on(
        'GET',
        '/v1/merchant/registers/{id}/sticker/pdf',
        (_) => FakeResponse(200, bytes: '%PDF-1.4 test'.codeUnits),
      )
      ..on(
        'GET',
        '/v1/merchant/registers/{id}/sticker',
        (_) => FakeResponse.ok({'url': url}),
      );
    await launchProApi(tester, server, writer: writer);

    await goTab(tester, 'Équipe');
    await tapText(tester, 'Mes caisses');
    await tapText(tester, "Télécharger l'autocollant (PDF) · Caisse 1");
    expect(
      String.fromCharCodes(sharer.shared['autocollant-Caisse 1.pdf']!.take(8)),
      '%PDF-1.4',
    );

    await tapText(tester, 'Caisse 1');
    // NFC disponible : le lien signé par le serveur est écrit dès l'ouverture.
    tester.seeText('Autocollant associé à Caisse 1');
    expect(writer.written, [url]);
  });

  testWidgets(
    'API Pro · Équipe : créer un caissier, mot de passe affiché une fois',
    (tester) async {
      final team = [..._team];
      final server = proServer(subRole: 'OWNER')
        ..on('GET', '/v1/team/users', (_) => FakeResponse.ok({'data': team}))
        ..on('POST', '/v1/team/users', (request) {
          team.add({
            'id': '0193b000-0000-7000-8000-0000000000u3',
            'displayName': 'Nadia Trabelsi',
            'email': 'nadia@carrefour.test',
            'subRole': 'CASHIER',
            'status': 'INVITED',
            'createdAt': iso(DateTime.now()),
          });
          return FakeResponse(
            201,
            json: {
              'credentials': {
                'email': 'nadia@carrefour.test',
                'temporaryPassword': 'Tmp-Pq9x73Lm',
              },
            },
          );
        });
      await launchProApi(tester, server);

      await goTab(tester, 'Équipe');
      tester.seeText('Sami C. · Caissier');
      await tapText(tester, 'Ajouter un caissier');
      await tester.enterText(
        find.byKey(const Key('cashier-name')),
        'Nadia Trabelsi',
      );
      await tester.enterText(
        find.byKey(const Key('cashier-email')),
        'nadia@carrefour.test',
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Créer le caissier');

      tester.seeText('Tmp-Pq9x73Lm');
      expect(server.calls('POST', '/v1/team/users').single.json, {
        'displayName': 'Nadia Trabelsi',
        'email': 'nadia@carrefour.test',
        'subRole': 'CASHIER',
      });
      await tapText(tester, 'J’ai noté le mot de passe');
      expect(find.text('Tmp-Pq9x73Lm'), findsNothing);
      tester.seeText('Nadia Trabelsi · Caissier');
    },
  );
}

final _team = <Map<String, Object?>>[
  {
    'id': '0193b000-0000-7000-8000-0000000000u2',
    'displayName': 'Mehdi K.',
    'email': 'mehdi@carrefour.test',
    'subRole': 'OWNER',
    'status': 'ACTIVE',
    'createdAt': '2026-01-01T00:00:00.000Z',
  },
  {
    'id': '0193b000-0000-7000-8000-0000000000u1',
    'displayName': 'Sami C.',
    'email': 'sami@carrefour.test',
    'subRole': 'CASHIER',
    'status': 'ACTIVE',
    'createdAt': '2026-01-01T00:00:00.000Z',
  },
];

Map<String, Object?> _payout(String reference, String status) => {
  'id': '0193b000-0000-7000-8000-0000000000v${reference.substring(5)}',
  'creditType': 'RESTAURATION',
  'reference': reference,
  'status': status,
  'grossMillimes': 72500,
  'commissionRateBps': 200,
  'commissionMillimes': 1450,
  'vatRateBps': 1900,
  'vatMillimes': 276,
  'stampDutyMillimes': 1000,
  'withholdingRateBps': 0,
  'withholdingMillimes': 0,
  'transferFeeMillimes': 4000,
  'netMillimes': 65774,
  'requestedAt': iso(DateTime.now()),
  'maskedIban': '••••0014',
  if (status == 'EXECUTED')
    'payment': {
      'bankReference': 'VIR-889',
      'paidOn': '2026-11-10',
      'amountMillimes': 65774,
    },
};
