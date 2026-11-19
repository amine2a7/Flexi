import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_core/testing.dart';
import 'package:fp_pro/app/app.dart';
import 'package:fp_pro/app/dependencies.dart';
import 'package:fp_pro/features/registers/data/pdf_sharer.dart';
import 'package:fp_pro/features/registers/data/sticker_writer.dart';

import 'helpers.dart';

export 'package:fp_core/testing.dart';

const registerId = '0193b000-0000-7000-8000-0000000000r1';
const checkoutId = '0193b000-0000-7000-8000-0000000000c1';

String iso(DateTime d) => d.toUtc().toIso8601String();

Map<String, Object?> session({String step = 'NONE'}) => {
  'nextStep': step,
  'accessToken': 'acc-pro',
  'refreshToken': 'ref-pro-0123456789abcdefgh',
  'accessExpiresAt': iso(DateTime.now().add(const Duration(minutes: 15))),
  'refreshExpiresAt': iso(DateTime.now().add(const Duration(hours: 12))),
};

/// Demande de la caisse vue par le commerce (`Checkout`).
Map<String, Object?> checkout({
  String status = 'PENDING',
  Map<String, Object?>? extra,
}) {
  final now = DateTime.now();
  return {
    'id': checkoutId,
    'registerId': registerId,
    'shortCode': '4827',
    'amountMillimes': 57500,
    'creditType': 'RESTAURATION',
    'status': status,
    'createdAt': iso(now),
    'expiresAt': iso(now.add(const Duration(seconds: 120))),
    ...?extra,
  };
}

/// Écrit l'autocollant sans NFC réel et garde le lien écrit.
class RecordingWriter implements StickerWriter {
  final written = <String>[];

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> write(String url, {required String iosMessage}) async {
    written.add(url);
    return true;
  }

  @override
  Future<void> stop() async {}
}

/// Faux serveur d'un commerce : Carrefour, Caisse 1, Restauration.
/// [subRole] : `CASHIER` (Sami) ou `OWNER` (propriétaire).
FakeApiServer proServer({String subRole = 'CASHIER'}) {
  final now = DateTime.now();
  return FakeApiServer()
    ..on(
      'POST',
      '/v1/mobile/auth/login',
      (_) => FakeResponse.ok({
        'nextStep': 'MFA_CHALLENGE',
        'challengeId': '0193b000-0000-7000-8000-0000000000m1',
        'challengeExpiresAt': iso(now.add(const Duration(minutes: 5))),
      }),
    )
    ..on(
      'POST',
      '/v1/mobile/auth/mfa/verify',
      (_) => FakeResponse.ok(session()),
    )
    ..on('POST', '/v1/mobile/auth/logout', (_) => FakeResponse.noContent)
    ..on(
      'GET',
      '/v1/me',
      (_) => FakeResponse.ok({
        'id': '0193b000-0000-7000-8000-0000000000u1',
        'displayName': subRole == 'CASHIER' ? 'Sami C.' : 'Mehdi K.',
        'role': 'MERCHANT',
        'subRole': subRole,
        'permissions': <String>[],
        'tenant': {
          'id': '0193b000-0000-7000-8000-0000000000t1',
          'label': 'Carrefour',
        },
        'mfa': {
          'required': true,
          'enrolled': true,
          'recoveryCodesRemaining': 10,
        },
        'onboardingTourDone': true,
      }),
    )
    ..on(
      'GET',
      '/v1/merchant/profile',
      (_) => FakeResponse.ok({
        'name': 'Carrefour',
        'category': 'GROCERY',
        'city': 'La Marsa',
        'address': 'Avenue Habib Bourguiba',
        'phone': '+21671000001',
        'maskedIban': '••••0014',
        'paymentCode': '123456',
        'acceptedCreditTypes': ['RESTAURATION'],
        'commissionGrid': null,
        'pointsOfSale': <Object>[],
        'staff': <Object>[],
      }),
    )
    ..on(
      'GET',
      '/v1/merchant/registers',
      (_) => FakeResponse.ok({
        'data': [
          {
            'id': registerId,
            'name': 'Caisse 1',
            'status': 'ACTIVE',
            'publicId': 'AbCdEfGhIjKlMnOp',
            'createdAt': iso(now),
          },
        ],
      }),
    )
    ..on(
      'POST',
      '/v1/merchant/registers/{id}/checkouts',
      (_) => FakeResponse(201, json: checkout()),
    )
    ..on(
      'POST',
      '/v1/merchant/checkouts/{id}/cancel',
      (_) => FakeResponse.ok(checkout(status: 'CANCELLED')),
    )
    ..on(
      'GET',
      '/v1/merchant/payments',
      (_) => FakeResponse.ok({
        'data': [
          {
            'id': '0193b000-0000-7000-8000-0000000000p1',
            'creditType': 'RESTAURATION',
            'reference': 'PAY-7F3A21',
            'status': 'CONFIRMED',
            'amountMillimes': 57500,
            'customer': {
              'firstName': 'Yasmine',
              'lastInitial': 'J',
              'maskedEmployeeNumber': '0042',
            },
            'createdAt': iso(now),
            'expiresAt': null,
          },
        ],
        'page': {'limit': 100, 'hasMore': false, 'nextCursor': null},
      }),
    );
}

/// Lance l'app Pro branchée sur le faux serveur, puis se connecte (mot de passe + code).
Future<ProviderContainer> launchProApi(
  WidgetTester tester,
  FakeApiServer server, {
  StickerWriter? writer,
  bool signIn = true,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  final container = ProviderContainer(
    overrides: [
      ...apiOverrides(store: MemorySecureStore()),
      appConfigProvider.overrideWithValue(
        const AppConfig(apiBaseUrl: 'http://api.test', demo: false),
      ),
      httpAdapterProvider.overrideWithValue(server),
      stickerWriterProvider.overrideWithValue(writer ?? RecordingWriter()),
      pdfSharerProvider.overrideWithValue(sharer),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const FlexiPayProApp(),
    ),
  );
  await tester.pumpAndSettle();
  if (signIn) await signInPro(tester);
  return container;
}

/// Mot de passe, puis le code de l'application d'authentification.
Future<void> signInPro(WidgetTester tester, {String code = '123456'}) async {
  await tester.enterText(
    find.byKey(const Key('pro-email')),
    'sami@carrefour.test',
  );
  await tester.enterText(find.byKey(const Key('pro-password')), 'Flexi2026!');
  await tap(tester, find.text('Valider mon ticket'));
  if (find.byKey(const Key('mfa-code')).evaluate().isEmpty) return;
  await tester.enterText(find.byKey(const Key('mfa-code')), code);
  await tester.pumpAndSettle();
  await tapText(tester, 'Valider');
}

/// Flux Server-Sent Events de la caisse, piloté par le test.
class TillEvents {
  final _controller = StreamController<List<int>>();

  FakeResponse open(FakeRequest _) =>
      FakeResponse(200, stream: _controller.stream);

  void send(Map<String, Object?> checkout) =>
      _controller.add(sseEvent(checkout));

  /// Ferme le flux sans attendre (l'app a pu déjà s'en désabonner).
  void close() => unawaited(_controller.close());
}
