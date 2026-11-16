import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';

import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';

/// Couleur, teinte et icône de chaque type de crédit.
extension CreditTypeStyle on CreditType {
  Color get color => switch (this) {
    CreditType.food => FpColors.food,
    CreditType.clothing => FpColors.clothing,
    CreditType.fuel => FpColors.fuel,
    CreditType.gifts => FpColors.gifts,
  };

  Color get tint => switch (this) {
    CreditType.food => FpColors.foodTint,
    CreditType.clothing => FpColors.clothingTint,
    CreditType.fuel => FpColors.fuelTint,
    CreditType.gifts => FpColors.giftsTint,
  };

  FpIcons get icon => switch (this) {
    CreditType.food => FpIcons.food,
    CreditType.clothing => FpIcons.clothing,
    CreditType.fuel => FpIcons.fuel,
    CreditType.gifts => FpIcons.gift,
  };
}
