import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/app/app.dart';
import 'package:fp_beneficiaire/app/dependencies.dart';
import 'package:fp_beneficiaire/features/payment/data/nfc_reader.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_core/testing.dart';

import 'helpers.dart';

export 'package:fp_core/testing.dart';

const refreshToken =
    'ref-0123456789abcdefghij'; // gitleaks:allow (test-only value)
const checkoutId = '0193a000-0000-7000-8000-00000000c001';

/// Session mobile du contrat (`MobileSession`).
Map<String, Object?> mobileSession({
  String step = 'NONE',
  String access = 'acc-1',
  String refresh = refreshToken,
}) => {
  'nextStep': step,
  'accessToken': access,
  'refreshToken': refresh,
  'accessExpiresAt': DateTime.now()
      .add(const Duration(minutes: 15))
      .toUtc()
      .toIso8601String(),
  'refreshExpiresAt': DateTime.now()
      .add(const Duration(days: 30))
      .toUtc()
      .toIso8601String(),
};

String iso(DateTime d) => d.toUtc().toIso8601String();

Map<String, Object?> receipt({int amount = 57500, int after = 85000}) => {
  'id': '0193a000-0000-7000-8000-0000000000a1',
  'reference': 'PAY-7F3A21',
  'type': 'PAYMENT',
  'direction': 'DEBIT',
  'amountMillimes': amount,
  'creditType': 'RESTAURATION',
  'counterpartyName': 'Carrefour La Marsa',
  'counterpartyCity': 'La Marsa',
  'status': 'COMPLETED',
  'occurredAt': iso(DateTime.now()),
  'balanceAfterMillimes': after,
};

Map<String, Object?> customerCheckout() => {
  'id': checkoutId,
  'merchantName': 'Carrefour La Marsa',
  'registerName': 'Caisse 1',
  'city': 'La Marsa',
  'amountMillimes': 57500,
  'creditType': 'RESTAURATION',
  'expiresAt': iso(DateTime.now().add(const Duration(seconds: 120))),
};

/// Faux serveur avec un compte bénéficiaire complet : Yasmine, 142,500 TND en Restauration.
FakeApiServer beneficiaryServer({String role = 'EMPLOYEE'}) {
  final now = DateTime.now();
  final server = FakeApiServer()
    ..on(
      'POST',
      '/v1/mobile/auth/login',
      (_) => FakeResponse.ok(mobileSession()),
    )
    ..on(
      'POST',
      '/v1/mobile/auth/refresh',
      (_) => FakeResponse.ok(mobileSession(access: 'acc-2')),
    )
    ..on('POST', '/v1/mobile/auth/logout', (_) => FakeResponse.noContent)
    ..on(
      'GET',
      '/v1/me',
      (_) => FakeResponse.ok({
        'id': '0193a000-0000-7000-8000-0000000000u1',
        'displayName': role == 'EMPLOYEE' ? 'Yasmine J.' : 'Adam J.',
        'role': role,
        'subRole': null,
        'permissions': <String>[],
        'tenant': {
          'id': '0193a000-0000-7000-8000-0000000000t1',
          'label': 'BIAT',
        },
        'mfa': {
          'required': false,
          'enrolled': false,
          'recoveryCodesRemaining': 0,
        },
        'onboardingTourDone': true,
      }),
    )
    ..on(
      'GET',
      '/v1/employee/profile',
      (_) => FakeResponse.ok({
        'firstName': 'Yasmine',
        'lastName': 'Jaziri',
        'employeeNumber': 'BIAT-0042',
        'email': 'yasmine@biat.test',
        'phone': '+21622123456',
        'companyName': 'BIAT',
        'pinSet': true,
      }),
    )
    ..on(
      'GET',
      '/v1/employee/wallet',
      (_) => FakeResponse.ok({
        'companyName': 'BIAT',
        'totalBalanceMillimes': 142500,
        'balances': [
          {
            'creditType': 'RESTAURATION',
            'balanceMillimes': 142500,
            'expiringMillimes': 0,
            'nextExpiryDate': '${now.year}-12-31',
            'dailyLimitMillimes': 20000,
            'todaySpentMillimes': 5000,
            'enabled': true,
          },
        ],
      }),
    )
    ..on(
      'GET',
      '/v1/employee/operations',
      (_) => FakeResponse.ok({
        'data': [
          {
            'id': '0193a000-0000-7000-8000-0000000000a1',
            'reference': 'PAY-7F3A21',
            'type': 'PAYMENT',
            'direction': 'DEBIT',
            'amountMillimes': 57500,
            'creditType': 'RESTAURATION',
            'counterpartyName': 'Carrefour La Marsa',
            'status': 'COMPLETED',
            'occurredAt': iso(now),
          },
          {
            'id': '0193a000-0000-7000-8000-0000000000a2',
            'reference': 'ALC-0001',
            'type': 'ALLOCATION',
            'direction': 'CREDIT',
            'amountMillimes': 200000,
            'creditType': 'RESTAURATION',
            'counterpartyName': 'BIAT',
            'status': 'COMPLETED',
            'occurredAt': iso(now.subtract(const Duration(minutes: 5))),
          },
        ],
        'page': {'limit': 100, 'hasMore': false, 'nextCursor': null},
      }),
    )
    ..on(
      'GET',
      '/v1/employee/operations/{id}',
      (_) => FakeResponse.ok(receipt()),
    )
    ..on(
      'GET',
      '/v1/employee/notifications',
      (_) => FakeResponse.ok({
        'data': [
          {
            'id': 'n1',
            'kind': 'CREDIT_RECEIVED',
            'occurredAt': iso(now),
            'unread': true,
            'amountMillimes': 200000,
            'creditType': 'RESTAURATION',
            'counterpartyName': 'BIAT',
          },
        ],
        'page': {'limit': 50, 'hasMore': false, 'nextCursor': null},
      }),
    )
    ..on(
      'POST',
      '/v1/employee/notifications/read',
      (_) => FakeResponse.noContent,
    )
    ..on(
      'GET',
      '/v1/employee/family',
      (_) => FakeResponse.ok({
        'enabled': true,
        'maxMembers': 5,
        'data': [
          {
            'id': '0193a000-0000-7000-8000-0000000000f1',
            'firstName': 'Adam',
            'lastName': 'Jaziri',
            'relationship': 'CHILD',
            'login': 'adam@biat.test',
            'status': 'ACTIVE',
            'balances': [
              {
                'creditType': 'RESTAURATION',
                'amountMillimes': 35000,
                'dailyLimitMillimes': 20000,
                'endsOn': '${now.year}-12-31',
              },
            ],
          },
        ],
      }),
    )
    ..on('POST', '/v1/employee/pin/verify', (_) => FakeResponse.noContent)
    ..on(
      'GET',
      '/v1/employee/checkouts/code/{code}',
      (_) => FakeResponse.ok(customerCheckout()),
    )
    ..on(
      'GET',
      '/v1/employee/checkouts/sticker/{publicId}',
      (_) => FakeResponse.ok(customerCheckout()),
    )
    ..on(
      'POST',
      '/v1/employee/checkouts/{id}/confirm',
      (_) => FakeResponse.ok(receipt()),
    );
  return server;
}

/// Lance l'app branchée sur le faux serveur (build normal, sans fausses données).
/// [known] : session déjà ouverte sur l'appareil (jeton de renouvellement et prénom gardés).
Future<(ProviderContainer, MemorySecureStore)> launchApi(
  WidgetTester tester,
  FakeApiServer server, {
  bool known = false,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  final store = MemorySecureStore({
    SecureKey.onboardingDone: '1',
    if (known) SecureKey.refreshToken: refreshToken,
    if (known) SecureKey.sessionProfile: '{"userId":"u1","firstName":"Yasmine","role":"employee","organization":"BIAT"}',
  });
  final container = ProviderContainer(
    overrides: [
      ...apiOverrides(store: store),
      appConfigProvider.overrideWithValue(
        const AppConfig(apiBaseUrl: 'http://api.test', demo: false),
      ),
      httpAdapterProvider.overrideWithValue(server),
      biometricServiceProvider.overrideWithValue(FakeBiometrics()),
      stickerReaderProvider.overrideWithValue(NoNfc()),
      qrCameraEnabledProvider.overrideWithValue(false),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const FlexiPayApp()),
  );
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  return (container, store);
}

/// Connexion par e-mail et mot de passe sur l'écran de connexion.
Future<void> signIn(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'yasmine@biat.test',
  );
  await tester.enterText(find.byKey(const Key('login-password')), 'Flexi2026!');
  await tapText(tester, 'Valider mon ticket');
}

/// Démarre connecté (session connue + PIN) sur l'accueil.
Future<(ProviderContainer, MemorySecureStore)> launchApiHome(
  WidgetTester tester,
  FakeApiServer server, {
  List<Override> overrides = const [],
}) async {
  final launched = await launchApi(
    tester,
    server,
    known: true,
    overrides: overrides,
  );
  await unlock(tester);
  return launched;
}
