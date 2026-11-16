import 'package:fp_core/fp_core.dart';

import '../../../demo/demo_backend.dart';
import '../domain/payment.dart';

/// Paiement de démonstration : rejoue les transactions du prototype
/// (Carrefour 57,500 pour Yasmine, 15,000 pour Adam) et les 4 motifs de refus.
class FakePaymentRepository implements PaymentRepository {
  FakePaymentRepository(this._backend, this._online);

  final DemoBackend _backend;
  final bool Function() _online;

  static final _food5750 = Tnd.dinars(57) + 500;

  @override
  Future<PaymentCode> createCode(CreditType type) async {
    if (!_online()) throw const NetworkFailure();
    return PaymentCode(
      code: '482913',
      type: type,
      validity: const Duration(seconds: 60),
    );
  }

  @override
  Future<PaymentRequest> pendingRequest(PaymentCode code) async {
    if (!_online()) throw const NetworkFailure();
    final outcome = _backend.nextOutcome;
    _backend.nextOutcome = DemoPaymentOutcome.auto;
    switch (outcome) {
      case DemoPaymentOutcome.insufficientFunds:
        throw PaymentRefusedException(
          PaymentRefusal(
            reason: RefusalReason.insufficientFunds,
            merchantName: 'Station Ennour',
            requested: Tnd.dinars(50),
            balanceType: CreditType.fuel,
            balance: Tnd.dinars(40),
            missing: Tnd.dinars(10),
            acceptedTypes: const [CreditType.fuel],
          ),
        );
      case DemoPaymentOutcome.merchantInactive:
        throw PaymentRefusedException(
          PaymentRefusal(
            reason: RefusalReason.merchantInactive,
            merchantName: 'Boutique Yasmina',
            requested: Tnd.dinars(50),
            balanceType: CreditType.clothing,
            balance: Tnd.dinars(150),
            acceptedTypes: const [CreditType.clothing],
          ),
        );
      case DemoPaymentOutcome.codeExpired:
        throw PaymentRefusedException(
          PaymentRefusal(
            reason: RefusalReason.codeExpired,
            merchantName: 'Carrefour',
            requested: _food5750,
            balanceType: CreditType.food,
            balance: Tnd.dinars(200),
            acceptedTypes: _carrefour.acceptedTypes,
          ),
        );
      case DemoPaymentOutcome.auto:
        break;
    }
    if (!_carrefour.acceptedTypes.contains(code.type)) {
      throw PaymentRefusedException(
        PaymentRefusal(
          reason: RefusalReason.typeNotAccepted,
          merchantName: _carrefour.name,
          requested: Tnd.dinars(10),
          balanceType: code.type,
          balance: Tnd.dinars(40),
          acceptedTypes: _carrefour.acceptedTypes,
        ),
      );
    }
    final adam = _backend.account == DemoAccount.adam;
    return PaymentRequest(
      id: 'pr-1',
      merchantId: _carrefour.id,
      merchantName: _carrefour.name,
      cashier: 'Sami',
      city: _carrefour.city,
      amount: adam ? Tnd.dinars(15) : _food5750,
      type: code.type,
    );
  }

  @override
  Future<PaymentReceipt> confirm(PaymentRequest request, String pin) async {
    if (!_online()) throw const NetworkFailure();
    if (pin == DemoBackend.refusedDemoPin) throw const PinRefusedFailure(2);
    final adam = _backend.account == DemoAccount.adam;
    return PaymentReceipt(
      operationId: adam ? 'op-adam-carrefour' : 'op-carrefour',
      merchantId: request.merchantId,
      merchantName: request.merchantName,
      cashier: request.cashier,
      amount: request.amount,
      type: request.type,
      remaining: adam ? Tnd.dinars(35) : Tnd.dinars(142) + 500,
      reference: adam ? 'TX-7F3A44' : 'TX-7F3A21',
      paidBy: adam ? 'Adam' : 'Yasmine',
      date: adam
          ? DateTime(2026, 11, 14, 13, 5)
          : DateTime(2026, 11, 14, 12, 41),
    );
  }

  static final _carrefour = DemoBackend.merchants.first;
}
