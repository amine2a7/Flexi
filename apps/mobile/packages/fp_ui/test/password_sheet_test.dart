import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('OneTimePasswordSheet : mot de passe affiché, Copier → Copié', (
    tester,
  ) async {
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    var noted = false;
    await pumpUi(
      tester,
      Builder(
        builder: (context) => FpButton(
          label: 'Créer',
          onPressed: () => OneTimePasswordSheet.show(
            context,
            OneTimePasswordSheet(
              title: 'Compte d’Adam créé',
              message: 'Il ne sera **plus jamais affiché**.',
              password: 'K7m-42Qa',
              actionLabel: 'J’ai noté le mot de passe',
              onAction: () {
                noted = true;
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();
    expect(find.text('Compte d’Adam créé'), findsOneWidget);
    expect(find.text('K7m-42Qa'), findsOneWidget);

    await tester.tap(find.text('Copier'));
    await tester.pump();
    expect(clipboard, 'K7m-42Qa');
    expect(find.text('Copié'), findsOneWidget);

    await tester.tap(find.text('J’ai noté le mot de passe'));
    await tester.pumpAndSettle();
    expect(noted, isTrue);
    expect(find.text('K7m-42Qa'), findsNothing);
  });
}
