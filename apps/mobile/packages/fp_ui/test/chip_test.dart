import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fp_ui/fp_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets('FpChip : sélection marine et tap', (tester) async {
    var selected = 'Tous';
    await pumpUi(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Wrap(
          children: [
            for (final l in ['Tous', 'Restauration'])
              FpChip(
                label: l,
                dot: FpColors.food,
                selected: selected == l,
                onTap: () => setState(() => selected = l),
              ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Restauration'));
    await tester.pump();
    expect(selected, 'Restauration');
    final text = tester.widget<Text>(find.text('Restauration'));
    expect(text.style?.color, FpColors.surface);
  });

  testWidgets('TagChip affiche son libellé teinté', (tester) async {
    await pumpUi(
      tester,
      const TagChip(
        label: 'En cours',
        tint: FpColors.warningTint,
        color: FpColors.warningInk,
      ),
    );
    expect(
      tester.widget<Text>(find.text('En cours')).style?.color,
      FpColors.warningInk,
    );
  });
}
