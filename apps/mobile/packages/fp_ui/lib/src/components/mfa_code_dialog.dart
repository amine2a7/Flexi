import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_core/fp_core.dart';

import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Code à 6 chiffres de l'application d'authentification (comptes commerçant), après le mot
/// de passe. Le code n'est ni stocké ni journalisé ; `null` si la personne annule.
Future<String?> showMfaCodeDialog(BuildContext context, {bool retry = false}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _MfaCodeDialog(retry: retry),
  );
}

class _MfaCodeDialog extends StatefulWidget {
  const _MfaCodeDialog({required this.retry});

  final bool retry;

  @override
  State<_MfaCodeDialog> createState() => _MfaCodeDialogState();
}

class _MfaCodeDialogState extends State<_MfaCodeDialog> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final ready = RegExp(r'^\d{6}$').hasMatch(_code.text);
    return AlertDialog(
      title: Text(l10n.mfaCodeTitle, style: FpText.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.retry ? l10n.mfaCodeInvalid : l10n.mfaCodeHint,
            style: FpText.body(
              size: 14,
              color: widget.retry ? FpColors.danger : FpColors.inkSoft,
            ),
          ),
          const SizedBox(height: FpSpace.x12),
          TextField(
            key: const Key('mfa-code'),
            controller: _code,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: FpText.display(size: 28, letterSpacing: 0.3),
            decoration: InputDecoration(
              counterText: '',
              hintText: l10n.mfaCodePlaceholder,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(
          onPressed: ready ? () => Navigator.of(context).pop(_code.text) : null,
          child: Text(l10n.mfaCodeAction),
        ),
      ],
    );
  }
}
