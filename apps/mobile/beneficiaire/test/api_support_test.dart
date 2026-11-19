// W-SUP : demandes de support et recherche dans l'historique, branchées sur l'API (faux
// serveur) : « Signaler un problème » sur un reçu pré-remplit la transaction, la conversation
// s'affiche, la recherche envoie le texte au serveur.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_helpers.dart';
import 'helpers.dart';

const ticketId = '0193a000-0000-7000-8000-0000000000c1';

Map<String, Object?> ticketJson({
  List<Map<String, Object?>> messages = const [],
}) => {
  'id': ticketId,
  'reference': 'TK-2026-000042',
  'category': 'PAYMENT_DECLINED',
  'priority': 'NORMAL',
  'status': messages.isEmpty ? 'OPEN' : 'WAITING_CUSTOMER',
  'subject': 'Paiement débité deux fois',
  'requesterName': 'Yasmine J.',
  'link': {
    'type': 'PAYMENT',
    'id': '0193a000-0000-7000-8000-0000000000a1',
    'reference': 'PAY-7F3A21',
  },
  'createdAt': '2026-11-19T10:00:00.000Z',
  'updatedAt': '2026-11-19T10:00:00.000Z',
  'resolvedAt': null,
  'closedAt': null,
  'description': 'Le paiement apparaît deux fois sur mon solde.',
  'redacted': false,
  'canReopen': false,
  'canReply': true,
  'attachments': <Object>[],
  'messages': messages,
};

void main() {
  testWidgets(
    'API · Signaler un problème depuis un reçu : transaction pré-remplie',
    (tester) async {
      final server = beneficiaryServer()
        ..on(
          'POST',
          '/v1/support/tickets',
          (_) => FakeResponse(201, json: ticketJson()),
        )
        ..on(
          'GET',
          '/v1/support/tickets/{id}',
          (_) => FakeResponse.ok(ticketJson()),
        );
      await launchApiHome(tester, server);

      await goTab(tester, 'Historique');
      await tapText(tester, 'Carrefour La Marsa');
      await tapText(tester, 'Signaler un problème sur ce paiement');
      tester.seeText('Opération concernée : PAY-7F3A21');
      await reveal(tester, find.byKey(const Key('support-description')));
      await tester.enterText(
        find.byKey(const Key('support-subject')),
        'Paiement débité deux fois',
      );
      await tester.enterText(
        find.byKey(const Key('support-description')),
        'Le paiement apparaît deux fois sur mon solde.',
      );
      await tapText(tester, 'Envoyer la demande');

      final sent =
          server.calls('POST', '/v1/support/tickets').single.body! as Map;
      expect(sent['category'], 'PAYMENT_DECLINED');
      expect(sent['linkType'], 'PAYMENT');
      expect(sent['linkId'], '0193a000-0000-7000-8000-0000000000a1');
      await tester.see('TK-2026-000042');
      tester.seeText('Paiement débité deux fois');
    },
  );

  testWidgets('API · Aide › Mes demandes : liste, conversation, réponse', (
    tester,
  ) async {
    final answered = ticketJson(
      messages: [
        {
          'id': '0193a000-0000-7000-8000-0000000000d1',
          'authorName': 'Sonia',
          'fromAgent': true,
          'body': 'Pouvez-vous préciser l’heure du paiement ?',
          'redacted': false,
          'createdAt': '2026-11-19T11:00:00.000Z',
          'attachments': <Object>[],
        },
      ],
    );
    final server = beneficiaryServer()
      ..on(
        'GET',
        '/v1/support/tickets',
        (_) => FakeResponse.ok({
          'data': [answered],
          'page': {'limit': 50, 'hasMore': false, 'nextCursor': null},
        }),
      )
      ..on('GET', '/v1/support/tickets/{id}', (_) => FakeResponse.ok(answered))
      ..on(
        'POST',
        '/v1/support/tickets/{id}/messages',
        (_) => FakeResponse(201, json: answered),
      );
    await launchApiHome(tester, server);

    await goTab(tester, 'Profil');
    await tapText(tester, 'Besoin d’aide ?');
    await tapText(tester, 'Mes demandes');
    await tapText(tester, 'Paiement débité deux fois');
    await tester.see('Pouvez-vous préciser l’heure du paiement ?');
    await reveal(tester, find.byKey(const Key('support-reply')));
    await tester.enterText(
      find.byKey(const Key('support-reply')),
      'Vers midi.',
    );
    await tapText(tester, 'Envoyer');
    final reply = server
        .calls('POST', '/v1/support/tickets/$ticketId/messages')
        .single;
    expect((reply.body! as Map)['body'], 'Vers midi.');
  });

  testWidgets('API · Historique : la recherche envoie le texte au serveur', (
    tester,
  ) async {
    final server = beneficiaryServer();
    await launchApiHome(tester, server);

    await goTab(tester, 'Historique');
    await tester.enterText(find.byKey(const Key('history-search')), '57,5');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    final searched = server
        .calls('GET', '/v1/employee/operations')
        .where((call) => call.query['q'] != null)
        .toList();
    expect(searched.single.query['q'], '57,5');
    await tester.see('Carrefour La Marsa');
  });
}
