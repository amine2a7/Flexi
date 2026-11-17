import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

/// Écriture du lien de la caisse sur un autocollant NFC (Android et iPhone).
abstract interface class StickerWriter {
  Future<bool> isAvailable();

  /// Attend un autocollant puis y écrit [url] ; `false` si l'écriture échoue.
  Future<bool> write(String url, {required String iosMessage});

  Future<void> stop();
}

class NfcStickerWriter implements StickerWriter {
  @override
  Future<bool> isAvailable() async {
    try {
      return await NfcManager.instance.checkAvailability() ==
          NfcAvailability.enabled;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> write(String url, {required String iosMessage}) async {
    final done = Completer<bool>();
    final message = NdefMessage(
      records: [
        NdefRecord(
          typeNameFormat: TypeNameFormat.wellKnown,
          type: Uint8List.fromList([0x55]),
          identifier: Uint8List(0),
          payload: ndefUriPayload(url),
        ),
      ],
    );
    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      alertMessageIos: iosMessage,
      onDiscovered: (tag) async {
        final ndef = Ndef.from(tag);
        var ok = false;
        if (ndef != null && ndef.isWritable) {
          try {
            await ndef.write(message: message);
            ok = true;
          } on PlatformException {
            ok = false;
          }
        }
        await stop();
        if (!done.isCompleted) done.complete(ok);
      },
    );
    return done.future;
  }

  @override
  Future<void> stop() async {
    try {
      await NfcManager.instance.stopSession();
    } on PlatformException {
      // Pas de session ouverte.
    }
  }
}

final stickerWriterProvider = Provider<StickerWriter>(
  (ref) => NfcStickerWriter(),
);
