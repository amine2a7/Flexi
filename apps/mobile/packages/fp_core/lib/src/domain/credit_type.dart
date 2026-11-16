import '../l10n/gen/fp_localizations.dart';

/// Les 4 types de crédit offerts par l'entreprise.
enum CreditType { food, clothing, fuel, gifts }

extension CreditTypeLabel on CreditType {
  String label(FpL10n l10n) => switch (this) {
    CreditType.food => l10n.creditTypeFood,
    CreditType.clothing => l10n.creditTypeClothing,
    CreditType.fuel => l10n.creditTypeFuel,
    CreditType.gifts => l10n.creditTypeGifts,
  };
}
