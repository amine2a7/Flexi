import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/app/app.dart';
import 'package:fp_beneficiaire/app/dependencies.dart';
import 'package:fp_beneficiaire/demo/demo_backend.dart';
import 'package:fp_core/fp_core.dart';

class FakeBiometrics implements BiometricService {
  @override
  Future<bool> authenticate(String reason) async => true;

  @override
  Future<bool> isAvailable() async => true;
}

/// Lance l'app sur un écran 390 × 844 (comme le prototype), animations réduites.
/// [known] : compte déjà connecté sur l'appareil (jeton de démonstration).
Future<ProviderContainer> launchApp(
  WidgetTester tester, {
  DemoAccount? known,
  bool onboarded = true,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  final store = MemorySecureStore({
    if (onboarded) SecureKey.onboardingDone: '1',
    if (known != null) SecureKey.refreshToken: 'demo-refresh-${known.name}',
  });
  final container = ProviderContainer(
    overrides: [
      ...fakeDataOverrides(store: store),
      biometricServiceProvider.overrideWithValue(FakeBiometrics()),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const FlexiPayApp()),
  );
  await tester.pump();
  await tap(tester, find.text('Continuer'));
  return container;
}

/// Fait défiler l'écran vers le bas jusqu'à construire l'élément (listes paresseuses).
Future<void> reveal(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isNotEmpty) return;
  final vertical = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  if (vertical.evaluate().isEmpty) return;
  await tester.scrollUntilVisible(finder, 200, scrollable: vertical.first);
  await tester.pumpAndSettle();
}

/// Fait défiler jusqu'à l'élément puis le touche.
Future<void> tap(WidgetTester tester, Finder finder) async {
  await reveal(tester, finder);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) =>
    tap(tester, find.text(text));

/// Saisit un PIN sur le clavier.
Future<void> typePin(WidgetTester tester, String pin) async {
  for (final d in pin.split('')) {
    await tester.tap(find.text(d).last);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// Déverrouille avec un PIN accepté et arrive sur l'accueil.
Future<void> unlock(WidgetTester tester) async {
  await typePin(tester, '1234');
  await tapText(tester, 'Entrer');
}

/// Démarre connecté sur l'accueil de Yasmine.
Future<ProviderContainer> launchHome(
  WidgetTester tester, {
  DemoAccount account = DemoAccount.yasmine,
}) async {
  final c = await launchApp(tester, known: account);
  await unlock(tester);
  return c;
}

/// Va sur un onglet de la barre du bas.
Future<void> goTab(WidgetTester tester, String label) => tap(
  tester,
  find.descendant(of: find.byType(Scaffold).last, matching: find.text(label)),
);

Finder semantics(String label) => find.bySemanticsLabel(label);

Finder textContaining(String text) =>
    find.textContaining(text, findRichText: true);

extension Expectations on WidgetTester {
  Future<void> see(String text) async {
    await reveal(this, find.text(text));
    expect(find.text(text), findsWidgets);
  }

  void seeText(String text) => expect(find.text(text), findsWidgets);
  void seeContaining(String text) => expect(textContaining(text), findsWidgets);
}
