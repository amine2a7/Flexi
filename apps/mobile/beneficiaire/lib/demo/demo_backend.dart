import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../features/family/domain/family.dart';
import '../features/merchants/domain/merchant.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/wallet/domain/wallet.dart';

/// Comptes de démonstration (e-mail de connexion).
enum DemoAccount { yasmine, omar, adam }

/// Réponse que le faux serveur donnera au prochain scan du caissier.
enum DemoPaymentOutcome {
  auto,
  insufficientFunds,
  merchantInactive,
  codeExpired,
}

/// Faux serveur en mémoire : il remplace l'API tant qu'elle n'est pas branchée.
///
/// Il ne contient ni PIN ni mot de passe : la vérification est simulée par une règle.
class DemoBackend {
  DemoBackend() {
    _seed();
  }

  /// PIN que le faux serveur refuse, pour rejouer le scénario « PIN faux 3 fois ».
  static const refusedDemoPin = '0000';

  DemoAccount? account;
  DemoPaymentOutcome nextOutcome = DemoPaymentOutcome.auto;
  int failedPins = 0;

  late List<Credit> credits;
  late List<Operation> operations;
  late List<FamilyMember> family;
  late List<AppNotification> notifications;
  int _ids = 100;

  String nextId(String prefix) => '$prefix-${_ids++}';

  static const company = 'BIAT';

  static final merchants = <Merchant>[
    const Merchant(
      id: 'm-carrefour',
      name: 'Carrefour',
      shortName: 'Carrefour',
      kind: MerchantKind.supermarket,
      city: 'La Marsa',
      address: 'Avenue Habib Bourguiba, La Marsa',
      distanceMeters: 1200,
      acceptedTypes: [CreditType.food, CreditType.clothing, CreditType.gifts],
      active: true,
    ),
    const Merchant(
      id: 'm-ennour',
      name: 'Station Ennour',
      shortName: 'Station Ennour',
      kind: MerchantKind.fuelStation,
      city: 'Ariana',
      address: 'Route de Raoued, Ariana',
      distanceMeters: 2800,
      acceptedTypes: [CreditType.fuel],
      active: true,
    ),
    const Merchant(
      id: 'm-medina',
      name: 'Restaurant El Medina',
      shortName: 'El Medina',
      kind: MerchantKind.restaurant,
      city: 'Tunis',
      address: 'Rue Jamaa Zitouna, Tunis',
      distanceMeters: 4500,
      acceptedTypes: [CreditType.food],
      active: true,
    ),
    const Merchant(
      id: 'm-yasmina',
      name: 'Boutique Yasmina',
      shortName: 'Yasmina',
      kind: MerchantKind.shop,
      city: 'Tunis',
      address: 'Avenue de Paris, Tunis',
      distanceMeters: 3100,
      acceptedTypes: [CreditType.clothing],
      active: false,
    ),
  ];

  Merchant merchant(String id) => merchants.firstWhere((m) => m.id == id);

  void _seed() {
    final endOfYear = DateTime(2026, 12, 31);
    credits = [
      Credit(
        type: CreditType.food,
        balance: Tnd.dinars(142) + 500,
        received: Tnd.dinars(200),
        used: Tnd.dinars(57) + 500,
        shared: Tnd.dinars(50),
        expiresOn: endOfYear,
        paymentCount: 1,
      ),
      Credit(
        type: CreditType.fuel,
        balance: Tnd.dinars(40),
        received: Tnd.dinars(100),
        used: Tnd.dinars(60),
        shared: 0,
        expiresOn: endOfYear,
        paymentCount: 1,
      ),
    ];
    operations = [
      Operation(
        id: 'op-carrefour',
        kind: OperationKind.payment,
        amount: -(Tnd.dinars(57) + 500),
        date: DateTime(2026, 11, 14, 12, 41),
        type: CreditType.food,
        merchantId: 'm-carrefour',
        merchantName: 'Carrefour',
        cashier: 'Sami',
        reference: 'TX-7F3A21',
        balanceBefore: Tnd.dinars(200),
        balanceAfter: Tnd.dinars(142) + 500,
      ),
      Operation(
        id: 'op-share-adam',
        kind: OperationKind.familyShare,
        amount: -Tnd.dinars(50),
        date: DateTime(2026, 11, 13, 19, 20),
        type: CreditType.food,
        counterpart: 'Adam',
      ),
      Operation(
        id: 'op-ennour',
        kind: OperationKind.payment,
        amount: -Tnd.dinars(60),
        date: DateTime(2026, 11, 12, 18, 5),
        type: CreditType.fuel,
        merchantId: 'm-ennour',
        merchantName: 'Station Ennour',
        cashier: 'Karim',
        reference: 'TX-5C1B09',
        balanceBefore: Tnd.dinars(100),
        balanceAfter: Tnd.dinars(40),
      ),
      Operation(
        id: 'op-credit-biat',
        kind: OperationKind.creditReceived,
        amount: Tnd.dinars(300),
        date: DateTime(2026, 11, 9, 9, 0),
        counterpart: company,
        breakdown: {
          CreditType.food: Tnd.dinars(200),
          CreditType.fuel: Tnd.dinars(100),
        },
      ),
    ];
    family = [
      FamilyMember(
        id: 'fm-adam',
        firstName: 'Adam',
        contact: 'adam@flexipay.test',
        type: CreditType.food,
        balance: Tnd.dinars(35),
        limit: Tnd.dinars(50),
        dailyCap: Tnd.dinars(20),
        spentToday: Tnd.dinars(15),
        endDate: DateTime(2026, 12, 14),
        active: true,
      ),
    ];
    notifications = [
      AppNotification(
        id: 'n1',
        kind: NotificationKind.paymentApproved,
        date: DateTime(2026, 11, 14, 12, 41),
        unread: true,
        amount: Tnd.dinars(57) + 500,
        merchant: 'Carrefour',
        type: CreditType.food,
      ),
      AppNotification(
        id: 'n2',
        kind: NotificationKind.familyPaid,
        date: DateTime(2026, 11, 14, 13, 5),
        unread: true,
        amount: Tnd.dinars(15),
        merchant: 'Carrefour',
        person: 'Adam',
        leftToday: Tnd.dinars(5),
      ),
      AppNotification(
        id: 'n3',
        kind: NotificationKind.creditReceived,
        date: DateTime(2026, 11, 9, 9, 0),
        unread: false,
        amount: Tnd.dinars(300),
        person: company,
        breakdown: {
          CreditType.food: Tnd.dinars(200),
          CreditType.fuel: Tnd.dinars(100),
        },
      ),
      AppNotification(
        id: 'n4',
        kind: NotificationKind.paymentApproved,
        date: DateTime(2026, 11, 12, 18, 5),
        unread: false,
        amount: Tnd.dinars(60),
        merchant: 'Station Ennour',
        type: CreditType.fuel,
      ),
      AppNotification(
        id: 'n5',
        kind: NotificationKind.newLogin,
        date: DateTime(2026, 11, 9, 8, 52),
        unread: false,
      ),
    ];
  }

  /// Opérations du membre famille connecté (compte Adam).
  List<Operation> get adamOperations => [
    Operation(
      id: 'op-adam-carrefour',
      kind: OperationKind.payment,
      amount: -Tnd.dinars(15),
      date: DateTime(2026, 11, 14, 13, 5),
      type: CreditType.food,
      merchantId: 'm-carrefour',
      merchantName: 'Carrefour',
      cashier: 'Sami',
      reference: 'TX-7F3A44',
      balanceBefore: Tnd.dinars(50),
      balanceAfter: Tnd.dinars(35),
    ),
  ];

  void replaceCredit(Credit credit) {
    credits = [for (final c in credits) c.type == credit.type ? credit : c];
  }
}

final demoBackendProvider = Provider<DemoBackend>((ref) => DemoBackend());
