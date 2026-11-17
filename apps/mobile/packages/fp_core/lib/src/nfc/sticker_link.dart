import 'dart:convert';
import 'dart:typed_data';

/// Lien d'un autocollant de caisse : `https://pay.flexipay.tn/c/<publicId>?s=<signature>`.
///
/// Écrit en NDEF sur l'autocollant NFC et imprimé en QR. La signature est vérifiée par le
/// serveur ; l'app ne fait que lire le lien.
class StickerLink {
  const StickerLink({required this.publicId, required this.signature});

  static const host = 'pay.flexipay.tn';
  static final _publicId = RegExp(r'^[A-Za-z0-9_-]{16,32}$');
  static final _signature = RegExp(r'^[A-Za-z0-9_-]{16,64}$');

  final String publicId;
  final String signature;

  Uri get uri => Uri(
    scheme: 'https',
    host: host,
    pathSegments: ['c', publicId],
    queryParameters: {'s': signature},
  );

  /// Lit un lien d'autocollant ; `null` pour tout autre lien (jamais une erreur affichée brute).
  static StickerLink? parse(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != 'https' || uri.host != host) return null;
    final segments = uri.pathSegments;
    if (segments.length != 2 || segments.first != 'c') return null;
    final publicId = segments[1];
    final signature = uri.queryParameters['s'] ?? '';
    if (!_publicId.hasMatch(publicId) || !_signature.hasMatch(signature)) {
      return null;
    }
    return StickerLink(publicId: publicId, signature: signature);
  }
}

/// Préfixes d'URI d'un enregistrement NDEF « U » (NFC Forum, extrait utile).
const _uriPrefixes = <int, String>{
  0x00: '',
  0x01: 'http://www.',
  0x02: 'https://www.',
  0x03: 'http://',
  0x04: 'https://',
};

/// Charge utile d'un enregistrement NDEF URI (type « U ») pour [url].
Uint8List ndefUriPayload(String url) {
  for (final entry in _uriPrefixes.entries.toList().reversed) {
    if (entry.key != 0 && url.startsWith(entry.value)) {
      return Uint8List.fromList([
        entry.key,
        ...utf8.encode(url.substring(entry.value.length)),
      ]);
    }
  }
  return Uint8List.fromList([0x00, ...utf8.encode(url)]);
}

/// URI d'une charge utile NDEF « U » ; `null` si elle est invalide.
String? uriFromNdefPayload(Uint8List payload) {
  if (payload.isEmpty) return null;
  final prefix = _uriPrefixes[payload.first];
  if (prefix == null) return null;
  try {
    return prefix + utf8.decode(payload.sublist(1));
  } on FormatException {
    return null;
  }
}
