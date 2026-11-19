// W-SUP-bis : pièces jointes dans l'app (faux serveur) : une image jointe à une réponse part en
// multipart (type lu dans les octets), une pièce reçue s'ouvre par son lien signé, un fichier de
// plus de 5 Mo est refusé avant l'envoi.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_beneficiaire/app/app_router.dart';
import 'package:fp_beneficiaire/features/help/presentation/support_screens.dart';
import 'package:fp_core/fp_core.dart';

import 'api_helpers.dart';
import 'api_support_test.dart' show ticketId, ticketJson;
import 'helpers.dart';

/// Un PNG d'un pixel (signature PNG + IHDR, IDAT, IEND).
final png = Uint8List.fromList([
  0x89,
  0x50,
  0x4e,
  0x47,
  0x0d,
  0x0a,
  0x1a,
  0x0a,
  0x00,
  0x00,
  0x00,
  0x0d,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1f,
  0x15,
  0xc4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0d,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9c,
  0x63,
  0xf8,
  0xcf,
  0xc0,
  0xf0,
  0x1f,
  0x00,
  0x05,
  0x00,
  0x01,
  0xff,
  0x89,
  0x99,
  0x3d,
  0x1d,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4e,
  0x44,
  0xae,
  0x42,
  0x60,
  0x82,
]);

const pieceId = '0193a000-0000-7000-8000-0000000000e1';

void main() {
  testWidgets('API · Joindre une capture à une réponse, ouvrir une pièce reçue', (
    tester,
  ) async {
    final withPiece = ticketJson(
      messages: [
        {
          'id': '0193a000-0000-7000-8000-0000000000d1',
          'authorName': 'Sonia',
          'fromAgent': true,
          'body': 'Voici le relevé corrigé.',
          'redacted': false,
          'createdAt': '2026-11-19T11:00:00.000Z',
          'attachments': [
            {
              'id': pieceId,
              'fileName': 'releve.png',
              'contentType': 'image/png',
              'sizeBytes': png.length,
              'createdAt': '2026-11-19T11:00:00.000Z',
            },
          ],
        },
      ],
    );
    final server = beneficiaryServer()
      ..on('GET', '/v1/support/tickets/{id}', (_) => FakeResponse.ok(withPiece))
      ..on(
        'POST',
        '/v1/support/tickets/{id}/messages',
        (_) => FakeResponse(201, json: withPiece),
      )
      ..on(
        'GET',
        '/v1/support/tickets/{id}/attachments/{pid}/link',
        (_) => FakeResponse.ok({
          'reference': 'TK-2026-000042',
          'url':
              '/v1/support/tickets/$ticketId/attachments/$pieceId?expires=1&signature=s',
          'expires': 1,
          'signature': 's',
          'expiresAt': '2026-11-19T11:05:00.000Z',
        }),
      )
      ..on(
        'GET',
        '/v1/support/tickets/{id}/attachments/{pid}',
        (_) => FakeResponse(200, bytes: png),
      );
    final (container, _) = await launchApiHome(
      tester,
      server,
      overrides: [
        piecePickerProvider.overrideWithValue(
          (context) async => (
            piece: PickedPiece(
              name: 'capture.png',
              bytes: png,
              contentType: PickedPiece.sniff(png)!,
            ),
            error: null,
          ),
        ),
      ],
    );

    // Directement la demande (la liste est testée ailleurs).
    container.read(routerProvider).push('/help/tickets/$ticketId');
    await tester.pumpAndSettle();

    // La pièce reçue s'ouvre par son lien signé (image affichée).
    await tap(tester, find.byKey(const ValueKey('piece-$pieceId')));
    await tester.pumpAndSettle();
    expect(
      server.calls(
        'GET',
        '/v1/support/tickets/$ticketId/attachments/$pieceId/link',
      ),
      hasLength(1),
    );
    expect(
      server
          .calls('GET', '/v1/support/tickets/$ticketId/attachments/$pieceId')
          .single
          .query,
      containsPair('signature', 's'),
    );
    expect(find.bySemanticsLabel('releve.png'), findsWidgets);
    await tapText(tester, 'Terminé');

    // Une capture jointe à la réponse : multipart, fichier « attachment » en image/png.
    await reveal(tester, find.byKey(const Key('support-reply')));
    await tester.enterText(
      find.byKey(const Key('support-reply')),
      'Merci, voici ma capture.',
    );
    await tap(tester, find.byKey(const Key('support-attach')));
    tester.seeContaining('capture.png');
    await tapText(tester, 'Envoyer');
    final sent = server
        .calls('POST', '/v1/support/tickets/$ticketId/messages')
        .single
        .body;
    // Corps multipart (FormData de Dio), lu sans dépendre de Dio dans les tests.
    final form = sent! as dynamic;
    final fields = [for (final e in form.fields as List) '${e.key}=${e.value}'];
    expect(fields, contains('body=Merci, voici ma capture.'));
    final file = (form.files as List).single;
    expect(file.key, 'attachment');
    expect(file.value.filename, 'capture.png');
    expect(file.value.contentType.toString(), 'image/png');
  });

  testWidgets('API · Un fichier de plus de 5 Mo est refusé avant l’envoi', (
    tester,
  ) async {
    final server = beneficiaryServer()
      ..on(
        'GET',
        '/v1/support/tickets/{id}',
        (_) => FakeResponse.ok(ticketJson()),
      );
    final (container, _) = await launchApiHome(
      tester,
      server,
      overrides: [
        piecePickerProvider.overrideWithValue((context) async {
          final big = Uint8List(PickedPiece.maxBytes + 1)..setAll(0, png);
          if (big.length > PickedPiece.maxBytes) {
            return (piece: null, error: 'Le fichier dépasse 5 Mo.');
          }
          return null;
        }),
      ],
    );
    container.read(routerProvider).push('/help/tickets/new');
    await tester.pumpAndSettle();
    await reveal(tester, find.byKey(const Key('support-attach')));
    await tap(tester, find.byKey(const Key('support-attach')));
    tester.seeText('Le fichier dépasse 5 Mo.');
    expect(server.calls('POST', '/v1/support/tickets'), isEmpty);
  });
}
