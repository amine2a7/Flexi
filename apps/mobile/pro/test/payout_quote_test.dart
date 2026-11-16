import 'package:flutter_test/flutter_test.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_pro/demo/pro_demo_backend.dart';

void main() {
  test('Devis de reversement au millime (prototype : net 65,774)', () {
    final q = ProDemoBackend.computeQuote({CreditType.food: 72500});

    expect(q.gross, 72500);
    expect(q.commissionBps, 200);
    expect(q.commission, 1450);
    expect(q.vat, 276); // 275,5 arrondi au millime supérieur
    expect(q.feesInclTax, 1726);
    expect(q.withholding, 0);
    expect(q.stampDuty, 1000);
    expect(q.transferFee, 4000);
    expect(q.net, 65774);
  });

  test('Montants entiers uniquement, même sur de petites sommes', () {
    final q = ProDemoBackend.computeQuote({CreditType.food: 1});
    expect(q.commission, 0);
    expect(q.vat, 0);
    expect(q.net, 1 - 1000 - 4000);
  });
}
