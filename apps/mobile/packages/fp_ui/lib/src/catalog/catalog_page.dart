import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';

import '../components/balance_hero.dart';
import '../components/basics.dart';
import '../components/bottom_nav.dart';
import '../components/chips.dart';
import '../components/credit_card.dart';
import '../components/credit_style.dart';
import '../components/list_row.dart';
import '../components/mascot.dart';
import '../components/password_sheet.dart';
import '../components/pin_pad.dart';
import '../components/stamp.dart';
import '../components/ticket_card.dart';
import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Page cachée qui montre tous les composants de fp_ui.
/// Les titres de section sont les noms techniques des composants.
class FpCatalogPage extends StatefulWidget {
  const FpCatalogPage({super.key, this.demoPanel, this.onClose});

  /// Réglages de démonstration propres à l'app (réseau, réponses du faux serveur).
  final Widget? demoPanel;
  final VoidCallback? onClose;

  @override
  State<FpCatalogPage> createState() => _FpCatalogPageState();
}

class _FpCatalogPageState extends State<FpCatalogPage> {
  int _pin = 0;
  int _chip = 0;
  int _seg = 0;
  int _tab = 0;
  int _type = 0;
  bool _switch = true;
  int _stampKey = 0;
  final _field = TextEditingController(text: 'yasmine@flexipay.test');

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Widget _section(String name, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: FpSpace.x24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(name, style: FpText.caps()),
        const SizedBox(height: FpSpace.x10),
        child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            ScreenHeader(
              title: l10n.catalogTitle,
              onBack: widget.onClose ?? () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: FpSpace.x20),
            if (widget.demoPanel != null)
              _section(l10n.catalogDemo, widget.demoPanel!),
            _section(
              'FpColors',
              Wrap(
                spacing: FpSpace.x8,
                runSpacing: FpSpace.x8,
                children: [
                  for (final c in const [
                    FpColors.background,
                    FpColors.navy,
                    FpColors.green,
                    FpColors.greenDark,
                    FpColors.ink,
                    FpColors.muted,
                    FpColors.border,
                    FpColors.food,
                    FpColors.clothing,
                    FpColors.fuel,
                    FpColors.gifts,
                    FpColors.danger,
                  ])
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(FpRadius.md),
                        border: Border.all(color: FpColors.border),
                      ),
                    ),
                ],
              ),
            ),
            _section(
              'FpText',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FlexiPay',
                    style: FpText.display(size: 40, color: FpColors.navy),
                  ),
                  Text('Inter 15', style: FpText.body()),
                  const AmountText(57500, size: 48),
                ],
              ),
            ),
            _section(
              'FpIcons',
              Wrap(
                spacing: FpSpace.x12,
                runSpacing: FpSpace.x12,
                children: [for (final i in FpIcons.values) FpIcon(i, size: 24)],
              ),
            ),
            _section(
              'FpButton',
              Column(
                children: [
                  FpButton(label: l10n.loginSubmit, onPressed: () {}),
                  const SizedBox(height: FpSpace.x10),
                  FpButton(
                    label: l10n.shareReceipt,
                    icon: FpIcons.share,
                    variant: FpButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SizedBox(height: FpSpace.x10),
                  FpButton(
                    label: l10n.retry,
                    icon: FpIcons.refresh,
                    variant: FpButtonVariant.navy,
                    onPressed: () {},
                  ),
                  const SizedBox(height: FpSpace.x10),
                  FpButton(
                    label: l10n.logout,
                    icon: FpIcons.logout,
                    variant: FpButtonVariant.danger,
                    onPressed: () {},
                  ),
                  const SizedBox(height: FpSpace.x10),
                  FpButton(label: l10n.enter),
                ],
              ),
            ),
            _section(
              'TicketCard',
              TicketCard(
                top: Text(
                  l10n.loginTitle,
                  style: FpText.display(size: 36, color: FpColors.navy),
                ),
                bottom: Text(l10n.loginSubtitle, style: FpText.muted14),
              ),
            ),
            _section(
              'BalanceHero',
              BalanceHero(
                label: l10n.availableBalance,
                badge: l10n.offeredBy('BIAT'),
                amount: 182500,
                bottom: Row(
                  children: [
                    Expanded(
                      child: FpButton(
                        label: l10n.navPay,
                        icon: FpIcons.qr,
                        compact: true,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: FpSpace.x10),
                    Expanded(
                      child: FpButton(
                        label: l10n.familyAction,
                        icon: FpIcons.family,
                        compact: true,
                        onNavy: true,
                        variant: FpButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _section(
              'CreditCard',
              const Row(
                children: [
                  Expanded(
                    child: CreditCard(
                      type: CreditType.food,
                      balance: 142500,
                      received: 200000,
                    ),
                  ),
                  SizedBox(width: FpSpace.x12),
                  Expanded(
                    child: CreditCard(
                      type: CreditType.gifts,
                      balance: null,
                      received: null,
                    ),
                  ),
                ],
              ),
            ),
            _section(
              'PinPad',
              Column(
                children: [
                  PinDots(filled: _pin),
                  const SizedBox(height: FpSpace.x18),
                  PinPad(
                    onDigit: (_) =>
                        setState(() => _pin = (_pin + 1).clamp(0, 4)),
                    onDelete: () =>
                        setState(() => _pin = (_pin - 1).clamp(0, 4)),
                    onBiometric: () => setState(() => _pin = 4),
                  ),
                ],
              ),
            ),
            _section(
              'Stamp',
              Column(
                children: [
                  Wrap(
                    key: ValueKey(_stampKey),
                    spacing: FpSpace.x24,
                    runSpacing: FpSpace.x24,
                    alignment: WrapAlignment.center,
                    children: const [
                      Stamp(kind: StampKind.approved),
                      Stamp(kind: StampKind.refused, size: 32),
                      Stamp(kind: StampKind.approved, size: 24, animate: false),
                    ],
                  ),
                  const SizedBox(height: FpSpace.x12),
                  FpButton(
                    label: l10n.retry,
                    variant: FpButtonVariant.secondary,
                    onPressed: () => setState(() => _stampKey++),
                  ),
                ],
              ),
            ),
            _section(
              'ListRow · ListGroup',
              ListGroup(
                children: [
                  ListRow(
                    leading: IconTile(
                      tint: CreditType.food.tint,
                      color: CreditType.food.color,
                      text: 'C',
                    ),
                    title: 'Carrefour',
                    subtitle: CreditType.food.label(l10n),
                    trailing: ListRow.amount(
                      Tnd.format(-57500, currency: null),
                    ),
                    onTap: () {},
                  ),
                  ListRow(
                    leading: const IconTile(
                      tint: FpColors.greenTint,
                      color: FpColors.greenDark,
                      icon: FpIcons.arrowDown,
                    ),
                    title: l10n.creditReceivedFrom('BIAT'),
                    trailing: ListRow.amount(
                      Tnd.format(300000, currency: null, signed: true),
                      color: FpColors.greenDark,
                    ),
                  ),
                  ListRow(
                    leading: const IconTile(
                      tint: FpColors.clothingTint,
                      color: FpColors.clothing,
                      icon: FpIcons.lock,
                    ),
                    title: l10n.changePin,
                    subtitle: l10n.pinDigits,
                    chevron: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            _section(
              'FpChip · TagChip',
              Wrap(
                spacing: FpSpace.x8,
                runSpacing: FpSpace.x8,
                children: [
                  for (var i = 0; i < CreditType.values.length; i++)
                    FpChip(
                      label: CreditType.values[i].label(l10n),
                      dot: CreditType.values[i].color,
                      selected: _chip == i,
                      onTap: () => setState(() => _chip = i),
                    ),
                  TagChip(
                    label: l10n.inProgress,
                    tint: FpColors.warningTint,
                    color: FpColors.warningInk,
                    height: 28,
                  ),
                ],
              ),
            ),
            _section(
              'SegmentedChoice · ToggleTabs · TypeOption · FpSwitch',
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedChoice(
                    options: [l10n.langFr, l10n.langAr, l10n.langEn],
                    selected: _seg,
                    onSelected: (i) => setState(() => _seg = i),
                  ),
                  const SizedBox(height: FpSpace.x12),
                  ToggleTabs(
                    options: [l10n.scanQr, l10n.enterCode],
                    selected: _tab,
                    onSelected: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: FpSpace.x12),
                  Row(
                    children: [
                      for (final (i, t) in const [
                        CreditType.food,
                        CreditType.fuel,
                      ].indexed) ...[
                        if (i > 0) const SizedBox(width: FpSpace.x10),
                        Expanded(
                          child: TypeOption(
                            label: t.label(l10n),
                            color: t.color,
                            selected: _type == i,
                            onTap: () => setState(() => _type = i),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: FpSpace.x12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FpSwitch(
                      value: _switch,
                      label: l10n.biometricLogin,
                      onChanged: (v) => setState(() => _switch = v),
                    ),
                  ),
                ],
              ),
            ),
            _section(
              'FpTextField · FpProgressBar · InfoBanner',
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FpTextField(
                    label: l10n.emailLabel,
                    controller: _field,
                    icon: FpIcons.mail,
                  ),
                  const SizedBox(height: FpSpace.x12),
                  const FpProgressBar(value: 0.71, color: FpColors.food),
                  const SizedBox(height: FpSpace.x12),
                  InfoBanner(
                    text: l10n.familyInfo,
                    icon: FpIcons.info,
                    tint: FpColors.clothingTint,
                    iconColor: FpColors.clothing,
                  ),
                ],
              ),
            ),
            _section(
              'OneTimePasswordSheet',
              FpButton(
                label: l10n.addCashier,
                icon: FpIcons.plus,
                onPressed: () => OneTimePasswordSheet.show(
                  context,
                  OneTimePasswordSheet(
                    title: l10n.memberCreatedTitle('yes', 'Adam'),
                    message: l10n.memberCreatedText('Adam'),
                    password: 'K7m-42Qa',
                    actionLabel: l10n.passwordNoted,
                    onAction: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            _section('Mascot', const Center(child: Mascot())),
            _section(
              'FpBottomNav',
              FpBottomNav(
                leading: [
                  FpNavItem(
                    icon: FpIcons.home,
                    label: l10n.navHome,
                    selected: true,
                    onTap: () {},
                  ),
                  FpNavItem(
                    icon: FpIcons.store,
                    label: l10n.navDiscover,
                    onTap: () {},
                  ),
                ],
                trailing: [
                  FpNavItem(
                    icon: FpIcons.clock,
                    label: l10n.navHistory,
                    onTap: () {},
                  ),
                  FpNavItem(
                    icon: FpIcons.user,
                    label: l10n.navProfile,
                    onTap: () {},
                  ),
                ],
                centerIcon: FpIcons.qr,
                centerLabel: l10n.navPay,
                onCenter: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
