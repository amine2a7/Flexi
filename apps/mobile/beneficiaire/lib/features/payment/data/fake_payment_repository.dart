import 'package:fp_core/fp_core.dart';

import '../../../demo/demo_backend.dart';
import '../domain/payment.dart';

/// Paiement de démonstration (autocollant NFC de la caisse) : rejoue les transactions du
/// prototype (Carrefour 57,500 pour Yasmine, 15,000 pour Adam) et les motifs de refus.
class FakePaymentRepository implements PaymentRepository {
  FakePaymentRepository(this._backend, this._online, this._now);

  final DemoBackend _backend;
  final bool Function() _online;
  final DateTime Function() _now;

  static final _carrefour = DemoBackend.merchants.first;
  static final _ennour = DemoBackend.merchants[1];

  void _checkNetwork() {
    if (!_online()) throw const NetworkFailure();
  }

  /// Demande « en caisse » selon le compte et la réponse de démonstration choisie.
  PendingCheckout _pending() {
    final now = _now();
    if (_backend.nextOutcome == DemoPaymentOutcome.insufficientFunds) {
      return PendingCheckout(
        id: 'co-ennour',
        merchantId: _ennour.id,
        merchantName: _ennour.name,
        registerName: 'Caisse 1',
        city: _ennour.city,
        amount: Tnd.dinars(50),
        type: CreditType.fuel,
        expiresAt: now.add(const Duration(seconds: 120)),
      );
    }
    final adam = _backend.account == DemoAccount.adam;
    final fuel = _backend.nextOutcome == DemoPaymentOutcome.typeNotAccepted;
    return PendingCheckout(
      id: 'co-carrefour',
      merchantId: _carrefour.id,
      merchantName: _carrefour.name,
      registerName: 'Caisse 1',
      city: _carrefour.city,
      amount: adam
          ? Tnd.dinars(15)
          : fuel
          ? Tnd.dinars(10)
          : Tnd.dinars(57) + 500,
      type: fuel ? CreditType.fuel : CreditType.food,
      expiresAt: now.add(const Duration(seconds: 120)),
    );
  }

  Never _refuse(PaymentRefusal refusal) {
    _backend.nextOutcome = DemoPaymentOutcome.auto;
    throw PaymentRefusedException(refusal);
  }

  @override
  Future<PendingCheckout> bySticker(StickerLink link) async {
    _checkNetwork();
    switch (_backend.nextOutcome) {
      case DemoPaymentOutcome.stickerInvalid:
        _refuse(const PaymentRefusal(reason: RefusalReason.stickerInvalid));
      case DemoPaymentOutcome.merchantInactive:
        _refuse(
          PaymentRefusal(
            reason: RefusalReason.merchantInactive,
            merchantName: 'Boutique Yasmina',
            requested: Tnd.dinars(50),
            balanceType: CreditType.clothing,
            balance: Tnd.dinars(150),
            acceptedTypes: const [CreditType.clothing],
          ),
        );
      case DemoPaymentOutcome.alreadyPaid:
        _refuse(
          PaymentRefusal(
            reason: RefusalReason.alreadyPaid,
            merchantName: _carrefour.name,
          ),
        );
      default:
        return _pending();
    }
  }

  @override
  Future<PendingCheckout> byCode(String shortCode) async {
    _checkNetwork();
    if (shortCode != demoShortCode) {
      _refuse(const PaymentRefusal(reason: RefusalReason.noPendingCheckout));
    }
    return bySticker(
      const StickerLink(
        publicId: 'demo-register-r-1',
        signature: 'demo-signature-demo',
      ),
    );
  }

  @override
  Future<PaymentReceipt> confirm(PendingCheckout checkout, String pin) async {
    _checkNetwork();
    if (pin == DemoBackend.refusedDemoPin) throw const PinRefusedFailure(2);
    switch (_backend.nextOutcome) {
      case DemoPaymentOutcome.typeNotAccepted:
        _refuse(
          PaymentRefusal(
            reason: RefusalReason.typeNotAccepted,
            merchantName: checkout.merchantName,
            requested: checkout.amount,
            balanceType: checkout.type,
            balance: Tnd.dinars(40),
            acceptedTypes: _carrefour.acceptedTypes,
          ),
        );
      case DemoPaymentOutcome.codeExpired:
        _refuse(
          PaymentRefusal(
            reason: RefusalReason.codeExpired,
            merchantName: checkout.merchantName,
            requested: checkout.amount,
          ),
        );
      default:
        break;
    }
    // Vérification de démonstration : le solde du type couvre-t-il la demande ?
    final credit = _backend.credits
        .where((c) => c.type == checkout.type)
        .firstOrNull;
    final balance = credit?.balance ?? 0;
    if (_backend.account != DemoAccount.adam && checkout.amount > balance) {
      _refuse(
        PaymentRefusal(
          reason: RefusalReason.insufficientFunds,
          merchantName: checkout.merchantName,
          requested: checkout.amount,
          balanceType: checkout.type,
          balance: balance,
          missing: checkout.amount - balance,
        ),
      );
    }
    final adam = _backend.account == DemoAccount.adam;
    return PaymentReceipt(
      operationId: adam ? 'op-adam-carrefour' : 'op-carrefour',
      merchantId: checkout.merchantId,
      merchantName: checkout.merchantName,
      cashier: 'Sami',
      amount: checkout.amount,
      type: checkout.type,
      remaining: adam ? Tnd.dinars(35) : Tnd.dinars(142) + 500,
      reference: adam ? 'TX-7F3A44' : 'TX-7F3A21',
      paidBy: adam ? 'Adam' : 'Yasmine',
      date: adam
          ? DateTime(2026, 11, 14, 13, 5)
          : DateTime(2026, 11, 14, 12, 41),
    );
  }
}
