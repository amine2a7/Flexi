// Écrans de connexion branchés sur l'API (faux serveur) : jetons, PIN, blocages, 401.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';

import 'api_helpers.dart';
import 'helpers.dart';

void main() {
  testWidgets(
    'API · Connexion : jeton d’accès en mémoire, renouvellement dans le Keystore',
    (tester) async {
      final server = beneficiaryServer();
      final (_, store) = await launchApi(tester, server);

      await signIn(tester);

      tester.seeText('SOLDE DISPONIBLE');
      final login = server.calls('POST', '/v1/mobile/auth/login').single;
      expect(login.json['identifier'], 'yasmine@biat.test');
      expect(login.json['deviceId'], isA<String>());
      // Le jeton d'accès n'est jamais écrit sur le téléphone ; le mot de passe non plus.
      expect(await store.read(SecureKey.accessToken), isNull);
      expect(await store.read(SecureKey.refreshToken), refreshToken);
      expect(
        server.calls('GET', '/v1/employee/wallet').first.authorization,
        'Bearer acc-1',
      );
    },
  );

  testWidgets(
    'API · Première connexion : nouveau mot de passe puis création du PIN',
    (tester) async {
      final server = beneficiaryServer()
        ..on(
          'POST',
          '/v1/mobile/auth/login',
          (_) => FakeResponse.ok(mobileSession(step: 'PASSWORD_CHANGE')),
        )
        ..on(
          'POST',
          '/v1/mobile/auth/password/change',
          (_) => FakeResponse.ok(mobileSession(access: 'acc-3')),
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
            'pinSet': false,
          }),
        )
        ..on('POST', '/v1/employee/pin', (_) => FakeResponse.noContent);
      await launchApi(tester, server);

      await signIn(tester);
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

      tester.seeText('Créez votre PIN');
      await typePin(tester, '2580');
      await tapText(tester, 'Continuer');

      tester.seeText('SOLDE DISPONIBLE');
      expect(
        server.calls('POST', '/v1/mobile/auth/password/change').single.json,
        {'newPassword': 'Yasmine2026'},
      );
      final pin = server.calls('POST', '/v1/employee/pin').single;
      expect(pin.json, {'newPin': '2580'});
      expect(pin.authorization, 'Bearer acc-3');
    },
  );

  testWidgets('API · PIN vérifié par le serveur : faux, puis bloqué 15 min', (
    tester,
  ) async {
    var attempts = 0;
    final server = beneficiaryServer()
      ..on('POST', '/v1/employee/pin/verify', (_) {
        attempts++;
        return attempts < 3
            ? FakeResponse.problem(403, 'PIN_INVALID')
            : FakeResponse.problem(
                403,
                'PIN_INVALID',
                details: {'retryAfterSeconds': 900},
              );
      });
    await launchApi(tester, server, known: true);

    tester.seeText('Bon retour, Yasmine');
    await typePin(tester, '1357');
    await tapText(tester, 'Entrer');
    tester.seeText('PIN incorrect. Encore 2 essais.');
    await typePin(tester, '1357');
    await tapText(tester, 'Entrer');
    tester.seeText('PIN incorrect. Encore 1 essai.');
    await typePin(tester, '1357');
    await tapText(tester, 'Entrer');

    tester.seeText('Compte bloqué pour un moment');
    tester.seeText('14:59');
    // Après un redémarrage, le jeton d'accès est obtenu par renouvellement (rotation).
    expect(server.calls('POST', '/v1/mobile/auth/refresh'), hasLength(1));
    expect(
      server.calls('POST', '/v1/employee/pin/verify').first.authorization,
      'Bearer acc-2',
    );
  });

  testWidgets('API · 4e blocage : retour à la connexion complète', (
    tester,
  ) async {
    final server = beneficiaryServer()
      ..on(
        'POST',
        '/v1/employee/pin/verify',
        (_) => FakeResponse.problem(
          403,
          'PIN_INVALID',
          details: {'reauthenticationRequired': true},
        ),
      );
    final (_, store) = await launchApi(tester, server, known: true);

    await typePin(tester, '1357');
    await tapText(tester, 'Entrer');

    tester.seeText('Valider mon ticket');
    expect(await store.read(SecureKey.refreshToken), isNull);
  });

  testWidgets('API · Session refusée (401) : retour à la connexion', (
    tester,
  ) async {
    final server = beneficiaryServer()
      ..on(
        'POST',
        '/v1/mobile/auth/refresh',
        (_) => FakeResponse.problem(401, 'SESSION_EXPIRED'),
      );
    final (_, store) = await launchApi(tester, server, known: true);

    await typePin(tester, '2580');
    await tapText(tester, 'Entrer');

    tester.seeText('Valider mon ticket');
    expect(await store.read(SecureKey.refreshToken), isNull);
    expect(
      server.calls('POST', '/v1/employee/pin/verify').single.authorization,
      isNull,
    );
  });

  testWidgets('API · Déconnexion : jeton révoqué côté serveur, puis oublié', (
    tester,
  ) async {
    final server = beneficiaryServer();
    final (_, store) = await launchApiHome(tester, server);

    await goTab(tester, 'Profil');
    await tapText(tester, 'Se déconnecter');

    final logout = server.calls('POST', '/v1/mobile/auth/logout').single;
    expect(logout.authorization, 'Bearer acc-2');
    expect(await store.read(SecureKey.refreshToken), isNull);
    expect(await store.read(SecureKey.sessionProfile), isNull);
  });

  testWidgets(
    'API · Renouvellement après expiration du jeton d’accès (rotation)',
    (tester) async {
      final server = beneficiaryServer();
      final wallet = server.handlerFor('GET', '/v1/employee/wallet');
      // Le jeton d'accès a expiré : 401, renouvellement, puis la requête est rejouée.
      server.on(
        'GET',
        '/v1/employee/wallet',
        (request) => request.authorization == 'Bearer acc-1'
            ? FakeResponse.problem(401, 'UNAUTHENTICATED')
            : wallet(request),
      );
      await launchApi(tester, server);
      await signIn(tester);

      tester.seeText('SOLDE DISPONIBLE');
      final refresh = server.calls('POST', '/v1/mobile/auth/refresh').single;
      expect(refresh.json['refreshToken'], refreshToken);
      expect(
        server.calls('GET', '/v1/employee/wallet').last.authorization,
        'Bearer acc-2',
      );
    },
  );
}
