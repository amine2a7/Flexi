// Paiement à la caisse branché sur l'API (faux serveur) : Idempotency-Key du client, statut
// par clé après une coupure réseau (jamais de second paiement), écran Refusé par motif.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/app/app_router.dart';
import 'package:fp_core/fp_core.dart';

import 'api_helpers.dart';
import 'helpers.dart';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

/// Payer > Taper le code de la caisse > 4827 > PIN > Payer 57,500 TND.
Future<void> payByCode(WidgetTester tester) async {
  await tapText(tester, 'Payer');
  await tapText(tester, 'Taper le code de la caisse');
  await typePin(tester, '4827');
  tester.seeText('Carrefour La Marsa');
  tester.seeText('Caisse 1 · La Marsa');
  await typePin(tester, '2580');
  await tapText(tester, 'Payer 57,500 TND');
}

void main() {
  final l10n = lookupFpL10n(const Locale('fr'));

  testWidgets('API · Payer par le code de la caisse : PIN et Idempotency-Key', (
    tester,
  ) async {
    final server = beneficiaryServer();
    await launchApiHome(tester, server);

    await payByCode(tester);

    tester.seeText('APPROUVÉ');
    tester.seeText('85,000 TND');
    expect(
      server.calls('GET', '/v1/employee/checkouts/code/4827'),
      hasLength(1),
    );
    final confirm = server
        .calls('POST', '/v1/employee/checkouts/$checkoutId/confirm')
        .single;
    expect(confirm.json, {'pin': '2580'});
    expect(confirm.idempotencyKey, matches(_uuidV4));
  });

  testWidgets(
    'API · Coupure après l’envoi : statut par clé, aucun second paiement',
    (tester) async {
      final server = beneficiaryServer();
      String? sentKey;
      server
        ..on('POST', '/v1/employee/checkouts/{id}/confirm', (request) {
          sentKey = request.idempotencyKey;
          // Le serveur a payé, mais la réponse se perd.
          throw const NetworkCut();
        })
        ..on(
          'GET',
          '/v1/employee/checkouts/by-idempotency-key/{key}',
          (request) => request.path.endsWith('/$sentKey')
              ? FakeResponse.ok(receipt())
              : FakeResponse.problem(404, 'NOT_FOUND'),
        );
      await launchApiHome(tester, server);

      await payByCode(tester);

      tester.seeText('APPROUVÉ');
      expect(server.callsTo('POST', '/v1/employee/checkouts/'), hasLength(1));
      expect(
        server
            .callsTo('GET', '/v1/employee/checkouts/by-idempotency-key/')
            .single
            .path,
        endsWith('/$sentKey'),
      );
    },
  );

  testWidgets(
    'API · Coupure avant le serveur : même clé pour le nouvel essai',
    (tester) async {
      final server = beneficiaryServer();
      var attempt = 0;
      server
        ..on('POST', '/v1/employee/checkouts/{id}/confirm', (_) {
          attempt++;
          if (attempt == 1) throw const NetworkCut();
          return FakeResponse.ok(receipt());
        })
        ..on(
          'GET',
          '/v1/employee/checkouts/by-idempotency-key/{key}',
          (_) => FakeResponse.problem(404, 'NOT_FOUND'),
        );
      await launchApiHome(tester, server);

      await payByCode(tester);

      tester.seeText('APPROUVÉ');
      final posts = server.callsTo('POST', '/v1/employee/checkouts/');
      expect(posts, hasLength(2));
      expect(posts.first.idempotencyKey, posts.last.idempotencyKey);
      expect(
        server.callsTo('GET', '/v1/employee/checkouts/by-idempotency-key/'),
        hasLength(1),
      );
    },
  );

  // Chaque motif de refus de l'API mène au bon écran Refusé (rien n'est débité).
  final refusals = <String, (FakeResponse, String)>{
    'solde insuffisant': (
      FakeResponse.problem(
        422,
        'INSUFFICIENT_FUNDS',
        details: {'missingMillimes': 15000},
      ),
      l10n.refusedFundsTitle,
    ),
    'plafond du jour': (
      FakeResponse.problem(
        422,
        'LIMIT_EXCEEDED',
        details: {'limitType': 'FAMILY_MEMBER', 'remainingMillimes': 5000},
      ),
      l10n.refusedFamilyTitle,
    ),
    'type non accepté': (
      FakeResponse.problem(
        422,
        'CHECKOUT_REFUSED',
        details: {'reason': 'CREDIT_TYPE_NOT_ACCEPTED'},
      ),
      l10n.refusedTypeTitle,
    ),
    'commerce inactif': (
      FakeResponse.problem(
        422,
        'CHECKOUT_REFUSED',
        details: {'reason': 'MERCHANT_NOT_ACTIVE'},
      ),
      l10n.refusedMerchantTitle,
    ),
    'demande expirée': (
      FakeResponse.problem(
        422,
        'CHECKOUT_REFUSED',
        details: {'reason': 'CHECKOUT_EXPIRED'},
      ),
      l10n.refusedExpiredTitle,
    ),
    'déjà payée': (
      FakeResponse.problem(
        422,
        'CHECKOUT_REFUSED',
        details: {'reason': 'ALREADY_PAID'},
      ),
      l10n.refusedPaidTitle,
    ),
    'paiement refusé': (
      FakeResponse.problem(422, 'PAYMENT_DECLINED'),
      l10n.refusedDeclinedTitle,
    ),
  };
  for (final MapEntry(key: name, value: (answer, title)) in refusals.entries) {
    testWidgets('API · Refus « $name » : écran $title', (tester) async {
      final server = beneficiaryServer()
        ..on('POST', '/v1/employee/checkouts/{id}/confirm', (_) => answer);
      await launchApiHome(tester, server);

      await payByCode(tester);

      tester.seeText('REFUSÉ');
      tester.seeText(title);
      if (name == 'solde insuffisant') {
        tester.seeContaining('15,000');
        tester.seeText('Restauration 142,500 TND');
      }
    });
  }

  testWidgets('API · Code inconnu : aucune demande en caisse', (tester) async {
    final server = beneficiaryServer()
      ..on(
        'GET',
        '/v1/employee/checkouts/code/{code}',
        (_) => FakeResponse.problem(
          422,
          'CHECKOUT_REFUSED',
          details: {'reason': 'NO_PENDING_CHECKOUT'},
        ),
      );
    await launchApiHome(tester, server);

    await tapText(tester, 'Payer');
    await tapText(tester, 'Taper le code de la caisse');
    await typePin(tester, '1111');

    tester.seeText(l10n.refusedNoPendingTitle);
  });

  testWidgets(
    'API · Lien d’autocollant : demande lue, ou autocollant invalide',
    (tester) async {
      const publicId = 'AbCdEfGhIjKlMnOp';
      const signature = 'sig_0123456789abcdef';
      final server = beneficiaryServer();
      final (container, _) = await launchApiHome(tester, server);

      container.read(routerProvider).go('/c/$publicId?s=$signature');
      await tester.pumpAndSettle();
      tester.seeText('Carrefour La Marsa');
      final read = server
          .calls('GET', '/v1/employee/checkouts/sticker/$publicId')
          .single;
      expect(read.query['s'], signature);

      server.on(
        'GET',
        '/v1/employee/checkouts/sticker/{publicId}',
        (_) => FakeResponse.problem(
          422,
          'CHECKOUT_REFUSED',
          details: {'reason': 'STICKER_INVALID'},
        ),
      );
      container.read(routerProvider).go('/c/$publicId?s=$signature');
      await tester.pumpAndSettle();
      tester.seeText(l10n.refusedStickerTitle);
    },
  );
}
