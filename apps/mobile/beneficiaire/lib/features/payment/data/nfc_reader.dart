import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

/// Lecture de l'autocollant NFC de la caisse (Android et iPhone, paquet nfc_manager).
abstract interface class StickerReader {
  Future<bool> isAvailable();

  /// Démarre la lecture ; [onLink] reçoit le lien de l'autocollant lu (ignoré s'il n'en est pas un).
  Future<void> start({
    required String iosMessage,
    required void Function(StickerLink) onLink,
  });

  Future<void> stop();
}

class NfcStickerReader implements StickerReader {
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
  Future<void> start({
    required String iosMessage,
    required void Function(StickerLink) onLink,
  }) async {
    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      alertMessageIos: iosMessage,
      onDiscovered: (tag) async {
        final message =
            Ndef.from(tag)?.cachedMessage ?? await Ndef.from(tag)?.read();
        for (final record in message?.records ?? const <NdefRecord>[]) {
          final isUri =
              record.typeNameFormat == TypeNameFormat.wellKnown &&
              record.type.length == 1 &&
              record.type.first == 0x55;
          final uri = isUri ? uriFromNdefPayload(record.payload) : null;
          final link = uri == null ? null : StickerLink.parse(uri);
          if (link != null) {
            onLink(link);
            return;
          }
        }
      },
    );
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

final stickerReaderProvider = Provider<StickerReader>(
  (ref) => NfcStickerReader(),
);

/// `false` dans les tests : pas de caméra pour le scanner de QR.
final qrCameraEnabledProvider = Provider<bool>((ref) => true);
