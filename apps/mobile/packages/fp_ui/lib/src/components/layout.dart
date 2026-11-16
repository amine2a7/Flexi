import 'package:flutter/material.dart';

import '../tokens/fp_tokens.dart';

/// Gabarit d'écran du prototype : fond clair, marges 20 px, colonne espacée,
/// défilement si nécessaire et `Spacer` possible pour pousser les boutons en bas.
class FpScreen extends StatelessWidget {
  const FpScreen({
    super.key,
    required this.children,
    this.gap = FpSpace.x16,
    this.top = FpSpace.x12,
    this.bottom = FpSpace.x32,
    this.background = FpColors.background,
  });

  final List<Widget> children;
  final double gap;
  final double top;
  final double bottom;
  final Color background;

  List<Widget> _spaced(List<Widget> items) => [
    for (var i = 0; i < items.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      items[i],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    // Avant le premier Spacer : contenu qui défile. Après : actions poussées en bas.
    final split = children.indexWhere((c) => c is Spacer);
    final head = split < 0 ? children : children.sublist(0, split);
    final tail = split < 0
        ? const <Widget>[]
        : children.sublist(split + 1).where((c) => c is! Spacer).toList();
    final insets = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                FpSpace.screen,
                top,
                FpSpace.screen,
                tail.isEmpty ? bottom + insets : 0,
              ),
              sliver: SliverList.list(children: _spaced(head)),
            ),
            if (tail.isNotEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    FpSpace.screen,
                    gap,
                    FpSpace.screen,
                    bottom + insets,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _spaced(tail),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Contenu défilant d'un onglet ; la barre du bas se superpose en bas.
/// [top] : bandeau fixe au-dessus (hors ligne).
class FpTabScroll extends StatelessWidget {
  const FpTabScroll({
    super.key,
    required this.children,
    this.gap = FpSpace.x24,
    this.top,
  });

  final List<Widget> children;
  final double gap;
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final list = ListView.separated(
      padding: EdgeInsets.fromLTRB(
        FpSpace.screen,
        top == null ? padding.top + FpSpace.x12 : FpSpace.x24,
        FpSpace.screen,
        padding.bottom + FpSpace.x28,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => SizedBox(height: gap),
      itemBuilder: (_, i) => children[i],
    );
    if (top == null) return list;
    return Column(
      children: [
        top!,
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: list,
          ),
        ),
      ],
    );
  }
}
