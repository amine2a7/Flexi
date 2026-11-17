import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Remet un PDF au téléphone (feuille de partage : enregistrer dans Fichiers, imprimer, envoyer).
abstract interface class PdfSharer {
  Future<void> share(Uint8List bytes, {required String fileName});
}

class SystemPdfSharer implements PdfSharer {
  @override
  Future<void> share(Uint8List bytes, {required String fileName}) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(bytes, mimeType: 'application/pdf', name: fileName),
        ],
        fileNameOverrides: [fileName],
      ),
    );
  }
}

final pdfSharerProvider = Provider<PdfSharer>((ref) => SystemPdfSharer());
