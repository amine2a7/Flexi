import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import 'checkout_opener.dart';

/// Taper le code à 4 chiffres affiché par la caisse (sans NFC ni caméra).
class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key});

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  static const _length = 4;
  String _code = '';
  bool _busy = false;

  Future<void> _submit() async {
    final code = _code;
    setState(() => _busy = true);
    await openCheckout(context, ref, (repo) => repo.byCode(code));
    if (mounted) {
      setState(() {
        _busy = false;
        _code = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        ScreenHeader(title: l10n.payCodeTitle, onBack: () => context.pop()),
        Text(
          l10n.payCodeHint,
          textAlign: TextAlign.center,
          style: FpText.body(size: 14, color: FpColors.muted),
        ),
        Semantics(
          label: l10n.payCodeTitle,
          value: _code,
          container: true,
          child: ExcludeSemantics(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _length; i++) ...[
                    if (i > 0) const SizedBox(width: FpSpace.x10),
                    Container(
                      width: 56,
                      height: 68,
                      decoration: BoxDecoration(
                        color: FpColors.surface,
                        borderRadius: BorderRadius.circular(FpRadius.field),
                        border: Border.all(
                          color: i == _code.length
                              ? FpColors.green
                              : FpColors.border,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        i < _code.length ? _code[i] : '',
                        style: FpText.display(size: 32, color: FpColors.navy),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        PinPad(
          onDigit: (d) {
            if (_busy || _code.length >= _length) return;
            setState(() => _code += d);
            if (_code.length == _length) _submit();
          },
          onDelete: () {
            if (_code.isNotEmpty && !_busy) {
              setState(() => _code = _code.substring(0, _code.length - 1));
            }
          },
        ),
      ],
    );
  }
}
