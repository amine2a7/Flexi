import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

/// En-tête des écrans Pro : sur-titre, grand titre et pastille du commerce.
class ProHeader extends ConsumerWidget {
  const ProHeader({super.key, required this.overline, required this.title});

  final String overline;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant =
        ref.watch(authControllerProvider).session?.organization ?? '';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overline,
                style: FpText.body(size: 13, color: FpColors.muted),
              ),
              const SizedBox(height: FpSpace.x2),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: FpText.display(size: 36, color: FpColors.navy),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: FpSpace.x12),
          decoration: BoxDecoration(
            color: FpColors.navy,
            borderRadius: BorderRadius.circular(FpRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: FpColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: FpSpace.x6),
              Text(
                merchant,
                style: FpText.body(
                  size: 12,
                  weight: FontWeight.w700,
                  color: FpColors.surface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
