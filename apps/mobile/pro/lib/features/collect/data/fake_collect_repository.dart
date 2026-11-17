import 'dart:async';

import 'package:fp_core/fp_core.dart';

import '../../../demo/pro_demo_backend.dart';
import '../../day/domain/day.dart';
import '../domain/collect.dart';

/// Caisse de démonstration : le « client » réglé dans le catalogue lit la demande et
/// confirme au bout de quelques secondes, comme le ferait l'événement SSE du serveur.
class FakeCollectRepository implements CollectRepository {
  FakeCollectRepository(this._backend, this._now);

  final ProDemoBackend _backend;
  final DateTime Function() _now;

  /// Temps que met le client de démonstration à approcher son téléphone et taper son PIN.
  static const customerDelay = Duration(seconds: 3);
  static const validity = Duration(seconds: 120);

  final _byKey = <String, TillCheckout>{};
  final _cancelled = <String>{};

  bool get _owner => _backend.account == ProDemoAccount.carrefour;
  String get _cashier => _owner ? 'Carrefour' : 'Sami';

  @override
  Future<List<CreditType>> acceptedTypes() async =>
      ProDemoBackend.acceptedTypes;

  @override
  Future<TillRegister?> myRegister() async =>
      _backend.registers.where((r) => r.active).firstOrNull;

  @override
  Future<TillCheckout> request({
    required int amount,
    required CreditType type,
    required String idempotencyKey,
  }) async {
    if (amount <= 0) throw const ValidationFailure('amount');
    final register = (await myRegister())!;
    // Même clé, même demande : jamais deux demandes pour un seul appui.
    return _byKey[idempotencyKey] ??= TillCheckout(
      id: _backend.nextId('co'),
      registerName: register.name,
      amount: amount,
      type: type,
      shortCode: '4827',
      validity: validity,
    );
  }

  @override
  Future<void> cancel(String checkoutId) async => _cancelled.add(checkoutId);

  @override
  Stream<TillCheckout> watch(String checkoutId) {
    final checkout = _byKey.values.firstWhere((c) => c.id == checkoutId);
    final customer = _backend.nextCustomer;
    Timer? timer;
    late final StreamController<TillCheckout> controller;
    controller = StreamController<TillCheckout>(
      onListen: () {
        final paying = customer != ProDemoCustomer.nobody;
        timer = Timer(paying ? customerDelay : checkout.validity, () {
          if (_cancelled.contains(checkoutId)) return;
          controller.add(
            paying
                ? _settle(checkout, customer)
                : checkout.copyWith(status: CheckoutStatus.expired),
          );
          controller.close();
        });
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
  }

  TillCheckout _settle(TillCheckout checkout, ProDemoCustomer customer) {
    final approved = checkout.amount <= customer.available;
    final refusal = approved
        ? null
        : customer.family
        ? RefusalReason.familyLimit
        : RefusalReason.insufficientFunds;
    final existing = _backend.collections.where(
      (c) =>
          c.initial == customer.initial &&
          c.approved == approved &&
          (!approved || c.amount == checkout.amount),
    );
    // Rejoue la transaction du prototype au lieu de la dupliquer.
    final time = existing.isNotEmpty ? existing.first.time : _now();
    if (existing.isEmpty) {
      _backend.collections = [
        ..._backend.collections,
        DayCollection(
          id: _backend.nextId('c'),
          customerName: customer.firstName,
          initial: customer.initial,
          customerKind: customer.family
              ? CustomerKind.familyMember
              : CustomerKind.employee,
          organization: customer.family ? null : 'BIAT',
          type: checkout.type,
          amount: approved ? checkout.amount : 0,
          time: time,
          cashierId: _owner ? 'u-carrefour' : 'u-sami',
          cashierName: _cashier,
          approved: approved,
          refusal: refusal,
        ),
      ];
    }
    return checkout.copyWith(
      status: approved ? CheckoutStatus.paid : CheckoutStatus.refused,
      customerFirstName: customer.firstName,
      refusal: refusal,
      missing: approved
          ? null
          : customer.family
          ? customer.available
          : checkout.amount - customer.available,
      reference: approved ? 'TX-7F3A21' : null,
      cashier: _cashier,
      time: time,
    );
  }

  @override
  Future<List<TillRegister>> registers() async => _backend.registers;

  @override
  Future<String> stickerUrl(String registerId) async => StickerLink(
    publicId: 'demo-register-$registerId',
    signature: 'demo-signature-demo',
  ).uri.toString();
}
