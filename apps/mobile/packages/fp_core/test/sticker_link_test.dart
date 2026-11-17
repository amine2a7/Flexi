import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';

void main() {
  const link = StickerLink(
    publicId: 'demo-register-r-1',
    signature: 'demo-signature-demo',
  );

  test(
    'lien d’autocollant : aller-retour NDEF et refus des liens étrangers',
    () {
      final url = link.uri.toString();
      expect(
        url,
        'https://pay.flexipay.tn/c/demo-register-r-1?s=demo-signature-demo',
      );
      final payload = ndefUriPayload(url);
      expect(payload.first, 0x04);
      expect(uriFromNdefPayload(payload), url);
      expect(StickerLink.parse(url)?.publicId, 'demo-register-r-1');

      expect(
        StickerLink.parse(
          'https://evil.tn/c/demo-register-r-1?s=demo-signature-demo',
        ),
        isNull,
      );
      expect(
        StickerLink.parse(
          'http://pay.flexipay.tn/c/demo-register-r-1?s=demo-signature-demo',
        ),
        isNull,
      );
      expect(
        StickerLink.parse(
          'https://pay.flexipay.tn/c/court?s=demo-signature-demo',
        ),
        isNull,
      );
      expect(
        StickerLink.parse('https://pay.flexipay.tn/c/demo-register-r-1'),
        isNull,
      );
    },
  );
}
