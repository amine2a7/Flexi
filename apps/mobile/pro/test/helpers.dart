import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_pro/app/app.dart';
import 'package:fp_pro/app/dependencies.dart';

import 'dart:typed_data';

import 'package:fp_pro/features/registers/data/pdf_sharer.dart';
import 'package:fp_pro/features/registers/data/sticker_writer.dart';

/// Feuille de partage simulée : garde les PDF remis au téléphone.
class RecordingSharer implements PdfSharer {
  final shared = <String, Uint8List>{};

  @override
  Future<void> share(Uint8List bytes, {required String fileName}) async =>
      shared[fileName] = bytes;
}

final sharer = RecordingSharer();

/// Téléphone sans NFC : l'écriture de l'autocollant est simulée par un appui (démo).
class NoNfcWriter implements StickerWriter {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> write(String url, {required String iosMessage}) async => false;

  @override
  Future<void> stop() async {}
}

/// Lance l'app Pro (390 × 844, animations réduites, sans NFC) et se connecte.
Future<ProviderContainer> launchPro(
  WidgetTester tester, {
  String email = 'sami@flexipay.test',
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  final container = ProviderContainer(
    overrides: [
      ...fakeDataOverrides(store: MemorySecureStore()),
      appConfigProvider.overrideWithValue(
        const AppConfig(apiBaseUrl: '', demo: true),
      ),
      stickerWriterProvider.overrideWithValue(NoNfcWriter()),
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
  await tester.enterText(find.byKey(const Key('pro-email')), email);
  await tester.enterText(find.byKey(const Key('pro-password')), 'Flexi2026');
  await tap(tester, find.text('Valider mon ticket'));
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

Future<void> tap(WidgetTester tester, Finder finder) async {
  await reveal(tester, finder);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) =>
    tap(tester, find.text(text));

Future<void> goTab(WidgetTester tester, String label) => tap(
  tester,
  find.descendant(of: find.byType(Scaffold).first, matching: find.text(label)),
);

/// Saisit le montant puis envoie la demande à la caisse.
Future<void> request(WidgetTester tester, {required String amount}) async {
  await tester.enterText(find.byKey(const Key('collect-amount')), amount);
  await tester.pumpAndSettle();
  await tapText(tester, 'Demander $amount TND');
}

/// Laisse le client de démonstration approcher son téléphone et taper son PIN.
Future<void> customerPays(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

extension Expectations on WidgetTester {
  void seeText(String text) => expect(find.text(text), findsWidgets);
}
