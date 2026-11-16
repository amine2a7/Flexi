import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('Mascot flotte quand les animations sont permises', (
    tester,
  ) async {
    await pumpUi(tester, const Mascot(size: 120), reduceMotion: false);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.getSize(find.byType(SvgPicture)), const Size(120, 120));
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('Mascot reste immobile si « réduire les animations » est actif', (
    tester,
  ) async {
    await pumpUi(tester, const Mascot());
    expect(tester.hasRunningAnimations, isFalse);
  });
}
