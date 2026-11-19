import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../../shared/formatters.dart';
import '../domain/family.dart';

/// Ajouter un membre : type, montant, plafond par jour, date de fin.
/// À la création, le mot de passe temporaire s'affiche une seule fois.
class FamilyAddScreen extends ConsumerStatefulWidget {
  const FamilyAddScreen({super.key});

  @override
  ConsumerState<FamilyAddScreen> createState() => _FamilyAddScreenState();
}

class _FamilyAddScreenState extends ConsumerState<FamilyAddScreen> {
  final _name = TextEditingController();
  final _lastName = TextEditingController();
  FamilyRelationship? _relationship;
  final _contact = TextEditingController();
  final _amount = TextEditingController();
  final _end = TextEditingController();
  CreditType? _type;
  int _capDinars = 20;
  late DateTime _endDate = ref
      .read(clockProvider)()
      .add(const Duration(days: 30));
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _contact.dispose();
    _amount.dispose();
    _end.dispose();
    super.dispose();
  }

  /// Numéro du membre au format international (+216 par défaut pour 8 chiffres).
  static String _phone(String text) {
    final digits = text.replaceAll(RegExp(r'[\s.-]'), '');
    return RegExp(r'^\d{8}$').hasMatch(digits) ? '+216$digits' : digits;
  }

  static bool _validPhone(String text) =>
      RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(_phone(text));

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: now,
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _create() async {
    final l10n = FpL10n.of(context);
    final amount = Tnd.parse(_amount.text);
    final type = _type;
    final relationship = _relationship;
    if (amount == null || type == null || relationship == null) {
      setState(() => _error = l10n.genericError);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await ref
          .read(familyRepositoryProvider)
          .create(
            firstName: _name.text.trim(),
            lastName: _lastName.text.trim(),
            relationship: relationship,
            contact: _phone(_contact.text),
            type: type,
            amount: amount,
            dailyCap: Tnd.dinars(_capDinars),
            endDate: _endDate,
          );
      refreshMoney(ref);
      ref.invalidate(familyMembersProvider);
      if (!mounted) return;
      final name = created.member.firstName;
      await OneTimePasswordSheet.show(
        context,
        OneTimePasswordSheet(
          title: l10n.memberCreatedTitle(elide(name), name),
          message: l10n.memberCreatedText(name),
          password: created.temporaryPassword,
          actionLabel: l10n.passwordNoted,
          onAction: () => Navigator.of(context).pop(),
        ),
      );
      if (mounted) {
        context.pushReplacement(Routes.familyMember(created.member.id));
      }
    } on ValidationFailure {
      if (mounted) setState(() => _error = l10n.genericError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final dates = Dates(context, ref.watch(clockProvider)());
    final credits = ref.watch(walletProvider).value?.credits ?? const [];
    _type ??= credits.isEmpty ? null : credits.first.type;
    final credit = credits.where((c) => c.type == _type).firstOrNull;
    _end.text = dates.numeric(_endDate);
    final name = _name.text.trim();
    final amount = Tnd.parse(_amount.text);
    final valid =
        name.isNotEmpty &&
        _lastName.text.trim().isNotEmpty &&
        _relationship != null &&
        _validPhone(_contact.text) &&
        amount != null &&
        amount > 0 &&
        credit != null &&
        amount <= credit.balance;
    final cap = Tnd.format(Tnd.dinars(_capDinars), currency: l10n.currency);
    return FpScreen(
      gap: FpSpace.x18,
      children: [
        ScreenHeader(title: l10n.addMember, onBack: () => context.pop()),
        FpTextField(
          fieldKey: const Key('member-name'),
          label: l10n.firstNameLabel,
          controller: _name,
          icon: FpIcons.user,
          onChanged: (_) => setState(() {}),
        ),
        FpTextField(
          fieldKey: const Key('member-last-name'),
          label: l10n.lastNameLabel,
          controller: _lastName,
          icon: FpIcons.user,
          onChanged: (_) => setState(() {}),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.relationshipLabel, style: FpText.label),
            const SizedBox(height: FpSpace.x8),
            Wrap(
              spacing: FpSpace.x8,
              runSpacing: FpSpace.x8,
              children: [
                for (final r in FamilyRelationship.values)
                  FpChip(
                    label: switch (r) {
                      FamilyRelationship.spouse => l10n.relationshipSpouse,
                      FamilyRelationship.child => l10n.relationshipChild,
                      FamilyRelationship.parent => l10n.relationshipParent,
                    },
                    selected: _relationship == r,
                    onTap: () => setState(() => _relationship = r),
                  ),
              ],
            ),
          ],
        ),
        FpTextField(
          fieldKey: const Key('member-contact'),
          label: l10n.memberPhoneLabel,
          controller: _contact,
          icon: FpIcons.mail,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.creditTypeToShare, style: FpText.label),
            const SizedBox(height: FpSpace.x8),
            Row(
              children: [
                for (final (i, c) in credits.indexed) ...[
                  if (i > 0) const SizedBox(width: FpSpace.x10),
                  Expanded(
                    child: TypeOption(
                      label: c.type.label(l10n),
                      color: c.type.color,
                      selected: c.type == _type,
                      onTap: () => setState(() => _type = c.type),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FpTextField(
              fieldKey: const Key('member-amount'),
              label: l10n.amountToShare,
              controller: _amount,
              icon: FpIcons.wallet,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: FpSpace.x6),
            Text(
              l10n.availableAmount(
                Tnd.format(credit?.balance ?? 0, currency: l10n.currency),
              ),
              style: FpText.small,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.dailyCap, style: FpText.label),
            const SizedBox(height: FpSpace.x8),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.x6),
              decoration: BoxDecoration(
                color: FpColors.surface,
                borderRadius: BorderRadius.circular(FpRadius.field),
                border: Border.all(color: FpColors.border),
              ),
              child: Row(
                children: [
                  _StepButton(
                    label: l10n.decrease,
                    text: '−',
                    onTap: () => setState(
                      () => _capDinars = (_capDinars - 5).clamp(5, 50),
                    ),
                  ),
                  Expanded(
                    child: Semantics(
                      label: l10n.dailyCap,
                      value: cap,
                      child: Text(
                        Tnd.format(
                          Tnd.dinars(_capDinars),
                          currency: l10n.currency,
                        ),
                        textAlign: TextAlign.center,
                        style: FpText.display(size: 28),
                      ),
                    ),
                  ),
                  _StepButton(
                    label: l10n.increase,
                    text: '+',
                    onTap: () => setState(
                      () => _capDinars = (_capDinars + 5).clamp(5, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: FpTextField(
              label: l10n.endDate,
              controller: _end,
              icon: FpIcons.calendar,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FpSpace.x16,
            vertical: FpSpace.x14,
          ),
          decoration: BoxDecoration(
            color: FpColors.giftsTint,
            borderRadius: BorderRadius.circular(FpRadius.button),
          ),
          child: MarkupText(
            l10n.memberSummary(
              name.isEmpty ? '…' : name,
              cap,
              (_type ?? CreditType.food).label(l10n),
              dates.shortDate(_endDate),
              amount == null
                  ? '…'
                  : Tnd.format(amount, currency: l10n.currency, compact: true),
            ),
            style: FpText.body(size: 14, color: FpColors.navy, height: 1.5),
          ),
        ),
        if (_error != null)
          Text(_error!, style: FpText.body(size: 13, color: FpColors.danger)),
        FpButton(
          label: name.isEmpty
              ? l10n.addMember
              : l10n.createMemberAccount(elide(name), name),
          onPressed: valid && !_busy ? _create : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.text,
    required this.onTap,
  });

  final String label;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FpPressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: FpColors.divider,
          borderRadius: BorderRadius.circular(FpRadius.md),
        ),
        child: Text(
          text,
          style: FpText.body(size: 22, weight: FontWeight.w700),
        ),
      ),
    );
  }
}
