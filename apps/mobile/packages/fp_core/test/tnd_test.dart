import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';

void main() {
  group('Tnd.format', () {
    test('formate des millimes entiers au format du prototype', () {
      expect(Tnd.format(57500), '57,500 TND');
      expect(Tnd.format(0), '0,000 TND');
      expect(Tnd.format(5), '0,005 TND');
      expect(Tnd.format(1250000), '1 250,000 TND');
    });

    test('signe, devise et forme compacte', () {
      expect(Tnd.format(-57500, currency: null), '−57,500');
      expect(Tnd.format(300000, currency: null, signed: true), '+300,000');
      expect(Tnd.format(200000, compact: true), '200 TND');
      expect(Tnd.format(142500, compact: true), '142,500 TND');
      expect(Tnd.format(182500, currency: 'د.ت'), '182,500 د.ت');
    });
  });

  group('Tnd.parse', () {
    test('lit une saisie en millimes, sans flottant', () {
      expect(Tnd.parse('57,500'), 57500);
      expect(Tnd.parse('57.5'), 57500);
      expect(Tnd.parse('57'), 57000);
      expect(Tnd.parse('0,001'), 1);
    });

    test('refuse les saisies invalides', () {
      expect(Tnd.parse('57,5001'), isNull);
      expect(Tnd.parse('abc'), isNull);
      expect(Tnd.parse(''), isNull);
    });
  });
}
