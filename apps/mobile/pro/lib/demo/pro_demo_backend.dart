import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../features/collect/domain/collect.dart';
import '../features/day/domain/day.dart';
import '../features/payouts/domain/payout.dart';
import '../features/team/domain/team.dart';

enum ProDemoAccount { sami, carrefour }

/// Clients de démonstration : solde disponible du type Restauration, prénom affiché en caisse.
enum ProDemoCustomer {
  yasmine('Yasmine', 'Y', 142500),
  omar('Omar', 'O', 50000),
  adam('Adam', 'A', 5000, family: true),

  /// Personne ne paie : la demande expire au bout de 120 s.
  nobody('', '', 0);

  const ProDemoCustomer(
    this.firstName,
    this.initial,
    this.available, {
    this.family = false,
  });

  final String firstName;
  final String initial;

  /// Millimes ; pour Adam, le reste du plafond du jour.
  final int available;
  final bool family;
}

/// Faux serveur du commerce Carrefour (La Marsa). Aucun mot de passe n'y est conservé.
class ProDemoBackend {
  ProDemoBackend() {
    _seed();
  }

  static const merchantName = 'Carrefour';
  static const ownerEmail = 'carrefour@flexipay.test';
  static const acceptedTypes = [
    CreditType.food,
    CreditType.clothing,
    CreditType.gifts,
  ];

  /// Seuil sous lequel aucune retenue à la source n'est appliquée sur les frais.
  static final withholdingThreshold = Tnd.dinars(1000);

  ProDemoAccount? account;
  late List<DayCollection> collections;
  late List<Payout> payouts;
  late List<TeamMember> team;
  int _ids = 100;

  String nextId(String prefix) => '$prefix-${_ids++}';

  /// Client qui lira la prochaine demande de la caisse (réglable dans le catalogue).
  ProDemoCustomer nextCustomer = ProDemoCustomer.yasmine;

  /// Caisses du commerce ; Sami est rattaché à la Caisse 1.
  final registers = const [
    TillRegister(id: 'r-1', name: 'Caisse 1', active: true),
    TillRegister(id: 'r-2', name: 'Caisse 2', active: true),
    TillRegister(id: 'r-3', name: 'Drive', active: false),
  ];

  void _seed() {
    collections = [
      DayCollection(
        id: 'c-yasmine',
        customerName: 'Yasmine B.',
        initial: 'Y',
        customerKind: CustomerKind.employee,
        organization: 'BIAT',
        type: CreditType.food,
        amount: Tnd.dinars(57) + 500,
        time: DateTime(2026, 11, 14, 12, 41),
        cashierId: 'u-sami',
        cashierName: 'Sami',
        approved: true,
      ),
      DayCollection(
        id: 'c-adam',
        customerName: 'Adam',
        initial: 'A',
        customerKind: CustomerKind.familyMember,
        organization: null,
        type: CreditType.food,
        amount: Tnd.dinars(15),
        time: DateTime(2026, 11, 14, 13, 5),
        cashierId: 'u-sami',
        cashierName: 'Sami',
        approved: true,
      ),
      DayCollection(
        id: 'c-omar',
        customerName: 'Omar',
        initial: 'O',
        customerKind: CustomerKind.employee,
        organization: 'BIAT',
        type: CreditType.food,
        amount: 0,
        time: DateTime(2026, 11, 14, 13, 20),
        cashierId: 'u-sami',
        cashierName: 'Sami',
        approved: false,
        refusal: RefusalReason.insufficientFunds,
      ),
    ];
    payouts = [
      Payout(
        reference: 'RV-0011',
        net: Tnd.dinars(51) + 131,
        gross: Tnd.dinars(57),
        status: PayoutStatus.paid,
        requestedAt: DateTime(2026, 11, 12, 17, 0),
        bankReference: 'VIR-FP-100',
        paidAt: DateTime(2026, 11, 13),
      ),
      Payout(
        reference: 'RV-0010',
        net: Tnd.dinars(48) + 920,
        gross: Tnd.dinars(54),
        status: PayoutStatus.paid,
        requestedAt: DateTime(2026, 11, 5, 17, 0),
        bankReference: 'VIR-FP-087',
        paidAt: DateTime(2026, 11, 6),
      ),
    ];
    team = [
      const TeamMember(
        id: 'u-carrefour',
        name: 'Carrefour',
        email: ownerEmail,
        isOwner: true,
        active: true,
      ),
      TeamMember(
        id: 'u-sami',
        name: 'Sami',
        email: 'sami@flexipay.test',
        isOwner: false,
        active: true,
        lastAccess: DateTime(2026, 11, 14, 13, 20),
      ),
    ];
  }

  /// Calcul serveur du reversement, au millime : commission en points de base,
  /// TVA sur la commission arrondie au millime le plus proche (demi vers le haut).
  static PayoutQuote computeQuote(Map<CreditType, int> byType) {
    final gross = byType.values.fold(0, (s, v) => s + v);
    const commissionBps = 200;
    const vatBps = 1900;
    final commission = _roundBps(gross, commissionBps);
    final vat = _roundBps(commission, vatBps);
    // Retenue à la source : nulle sous le seuil (cas des données de démonstration).
    // Au-delà, le taux est fourni par le serveur réel ; il n'est pas simulé ici.
    return PayoutQuote(
      gross: gross,
      byType: byType,
      commissionBps: commissionBps,
      commission: commission,
      vatBps: vatBps,
      vat: vat,
      withholding: 0,
      withholdingThreshold: withholdingThreshold,
      stampDuty: Tnd.dinars(1),
      transferFee: Tnd.dinars(4),
    );
  }

  static int _roundBps(int millimes, int bps) =>
      (millimes * bps + 5000) ~/ 10000;
}

final proDemoBackendProvider = Provider<ProDemoBackend>(
  (ref) => ProDemoBackend(),
);
