// W-SUP dans l'app Pro (faux serveur) : recherche dans Aujourd'hui par référence ou montant,
// « Signaler un problème » sur un encaissement avec la transaction pré-remplie.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_helpers.dart';
import 'helpers.dart';

void main() {
  testWidgets(
    'API Pro · Aujourd’hui : recherche par montant puis par référence',
    (tester) async {
      await launchProApi(tester, proServer());
      await goTab(tester, 'Aujourd’hui');
      await reveal(tester, find.byKey(const Key('day-search')));

      await tester.enterText(find.byKey(const Key('day-search')), '57,5');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.textContaining('Yasmine'), findsWidgets);

      await tester.enterText(find.byKey(const Key('day-search')), '12,000');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.textContaining('Yasmine'), findsNothing);
      tester.seeText('Aucun résultat.');

      await tester.enterText(find.byKey(const Key('day-search')), 'pay-7f3a');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.textContaining('Yasmine'), findsWidgets);
    },
  );

  testWidgets('API Pro · Signaler un problème sur un encaissement', (
    tester,
  ) async {
    final server = proServer()
      ..on(
        'POST',
        '/v1/support/tickets',
        (_) => FakeResponse(
          201,
          json: {
            'id': '0193b000-0000-7000-8000-0000000000t1',
            'reference': 'TK-2026-000007',
            'category': 'PAYMENT_DECLINED',
            'priority': 'NORMAL',
            'status': 'OPEN',
            'subject': 'Client débité sans ticket',
            'requesterName': 'Sami',
            'link': {
              'type': 'PAYMENT',
              'id': '0193b000-0000-7000-8000-0000000000p1',
              'reference': 'PAY-7F3A21',
            },
            'createdAt': '2026-11-19T10:00:00.000Z',
            'updatedAt': '2026-11-19T10:00:00.000Z',
            'resolvedAt': null,
            'closedAt': null,
            'description':
                'Le client a été débité mais la caisse indique un refus.',
            'redacted': false,
            'canReopen': false,
            'canReply': true,
            'attachments': <Object>[],
            'messages': <Object>[],
          },
        ),
      );
    await launchProApi(tester, server);
    await goTab(tester, 'Aujourd’hui');
    await tap(tester, find.textContaining('Yasmine').first);
    await reveal(tester, find.text('Signaler un problème sur ce paiement'));
    await tapText(tester, 'Signaler un problème sur ce paiement');
    tester.seeText('Opération concernée : PAY-7F3A21');
    await tester.enterText(
      find.byKey(const Key('support-subject')),
      'Client débité sans ticket',
    );
    await reveal(tester, find.byKey(const Key('support-description')));
    await tester.enterText(
      find.byKey(const Key('support-description')),
      'Le client a été débité mais la caisse indique un refus.',
    );
    await tapText(tester, 'Envoyer la demande');
    final sent = server.calls('POST', '/v1/support/tickets').single.json;
    expect(sent['linkType'], 'PAYMENT');
    expect(sent['linkId'], '0193b000-0000-7000-8000-0000000000p1');
  });
}
