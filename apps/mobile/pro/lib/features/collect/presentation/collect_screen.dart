import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/routes.dart';
import '../../../shared/pro_header.dart';
import '../../../shared/pro_providers.dart';
import '../domain/collect.dart';

/// `false` dans les tests : pas de caméra.
final cameraEnabledProvider = Provider<bool>((ref) => true);

/// Encaisser : scanner le QR ou saisir le code, puis montant et type de crédit.
class CollectScreen extends ConsumerStatefulWidget {
  const CollectScreen({super.key});

  @override
  ConsumerState<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends ConsumerState<CollectScreen> {
  int _mode = 0;
  CreditType? _type;
  final _code = TextEditingController();
  final _amount = TextEditingController();
  String? _customerCode;
  Customer? _customer;
  String? _idempotencyKey;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    final code = raw.replaceAll(RegExp(r'\D'), '');
    if (code.length != 6 || code == _customerCode) return;
    try {
      final c = await ref
          .read(collectRepositoryProvider)
          .lookup(code, _type ?? CreditType.food);
      if (mounted) {
        setState(() {
          _customerCode = code;
          _customer = c;
          _type = c.availableType;
        });
      }
    } on AppFailure {
      if (mounted) setState(() => _customer = null);
    }
  }

  Future<void> _collect() async {
    final code = _customerCode;
    final amount = Tnd.parse(_amount.text);
    final type = _type;
    if (code == null || amount == null || type == null) return;
    // Une clé par encaissement : un nouvel essai réutilise la même clé.
    _idempotencyKey ??= newIdempotencyKey();
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(collectRepositoryProvider)
          .collect(
            code: code,
            amount: amount,
            type: type,
            idempotencyKey: _idempotencyKey!,
          );
      refreshMerchant(ref);
      _idempotencyKey = null;
      if (mounted) context.push(ProRoutes.result, extra: result);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final session = ref.watch(authControllerProvider).session;
    final types =
        ref.watch(acceptedTypesProvider).value ?? const <CreditType>[];
    _type ??= types.isEmpty ? null : types.first;
    final amount = Tnd.parse(_amount.text);
    final canCollect =
        _customer != null && amount != null && amount > 0 && !_busy;
    return FpTabScroll(
      gap: FpSpace.x16,
      children: [
        ProHeader(
          overline: l10n.cashRegisterOf(session?.firstName ?? ''),
          title: l10n.collectTitle,
        ),
        Semantics(
          label: l10n.modeLabel,
          container: true,
          child: ToggleTabs(
            options: [l10n.scanQr, l10n.enterCode],
            selected: _mode,
            onSelected: (i) => setState(() => _mode = i),
          ),
        ),
        if (_mode == 0)
          _Viewfinder(
            label: l10n.cameraViewfinder,
            caption: l10n.aimQr,
            camera: ref.watch(cameraEnabledProvider),
            onCode: _lookup,
            onSimulate: ref.watch(appConfigProvider).useFakeData
                ? () => _lookup('482913')
                : null,
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.customerCode, style: FpText.label),
              const SizedBox(height: FpSpace.x8),
              Semantics(
                label: l10n.customerCode,
                child: TextField(
                  key: const Key('customer-code'),
                  controller: _code,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: _lookup,
                  textAlign: TextAlign.center,
                  style: FpText.display(
                    size: 44,
                    color: FpColors.navy,
                    letterSpacing: 0.14,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: FpColors.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FpRadius.key),
                      borderSide: const BorderSide(
                        color: FpColors.navy,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FpRadius.key),
                      borderSide: const BorderSide(
                        color: FpColors.navy,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (_customer != null)
          Semantics(
            liveRegion: true,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FpSpace.x14,
                vertical: FpSpace.x12,
              ),
              decoration: BoxDecoration(
                color: FpColors.greenTint,
                borderRadius: BorderRadius.circular(FpRadius.button),
              ),
              child: Row(
                children: [
                  IconTile(
                    tint: _customer!.availableType.color,
                    color: FpColors.surface,
                    text: _customer!.initial,
                    size: 40,
                  ),
                  const SizedBox(width: FpSpace.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_customer!.displayName} · ${_customer!.organization}',
                          style: FpText.body(weight: FontWeight.w700),
                        ),
                        Text(
                          l10n.customerRecognized(
                            _customer!.availableType.label(l10n),
                            Tnd.format(_customer!.available, currency: null),
                          ),
                          style: FpText.body(
                            size: 12.5,
                            color: FpColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.amountLabel, style: FpText.label),
            const SizedBox(height: FpSpace.x8),
            Container(
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: FpColors.surface,
                borderRadius: BorderRadius.circular(FpRadius.key),
                border: Border.all(color: FpColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: l10n.amountLabel,
                      child: TextField(
                        key: const Key('collect-amount'),
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        style: FpText.display(size: 48, color: FpColors.navy),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    l10n.currency,
                    style: FpText.display(size: 22, color: FpColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        Semantics(
          label: l10n.creditTypeLabel,
          container: true,
          child: Row(
            children: [
              for (final (i, t) in types.indexed) ...[
                if (i > 0) const SizedBox(width: FpSpace.x8),
                Expanded(
                  child: TypeOption(
                    label: t.label(l10n),
                    color: t.color,
                    selected: t == _type,
                    height: 46,
                    onTap: () => setState(() => _type = t),
                  ),
                ),
              ],
            ],
          ),
        ),
        FpButton(
          label: l10n.collectAmount(
            Tnd.format(amount ?? 0, currency: l10n.currency),
          ),
          onPressed: canCollect ? _collect : null,
        ),
      ],
    );
  }
}

/// Viseur de la caméra : coins verts et ligne de scan animée.
class _Viewfinder extends StatefulWidget {
  const _Viewfinder({
    required this.label,
    required this.caption,
    required this.camera,
    required this.onCode,
    this.onSimulate,
  });

  final String label;
  final String caption;
  final bool camera;
  final ValueChanged<String> onCode;

  /// Démonstration : un appui simule le scan du QR de Yasmine.
  final VoidCallback? onSimulate;

  @override
  State<_Viewfinder> createState() => _ViewfinderState();
}

class _ViewfinderState extends State<_Viewfinder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (FpMotion.reduced(context)) {
      _c
        ..stop()
        ..value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget corner({required bool top, required bool left}) {
      const side = BorderSide(color: FpColors.green, width: 4);
      const r = Radius.circular(10);
      return Positioned(
        top: top ? 30 : null,
        bottom: top ? null : 30,
        left: left ? 70 : null,
        right: left ? null : 70,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border(
              top: top ? side : BorderSide.none,
              bottom: top ? BorderSide.none : side,
              left: left ? side : BorderSide.none,
              right: left ? BorderSide.none : side,
            ),
            borderRadius: BorderRadius.only(
              topLeft: top && left ? r : Radius.zero,
              topRight: top && !left ? r : Radius.zero,
              bottomLeft: !top && left ? r : Radius.zero,
              bottomRight: !top && !left ? r : Radius.zero,
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: widget.label,
      button: widget.onSimulate != null,
      child: GestureDetector(
        onTap: widget.onSimulate,
        child: Container(
          height: 240,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: FpColors.navy,
            borderRadius: BorderRadius.circular(FpRadius.ticket),
          ),
          child: LayoutBuilder(
            builder: (context, box) => Stack(
              children: [
                if (widget.camera)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.6,
                      child: MobileScanner(
                        onDetect: (capture) {
                          final value = capture.barcodes.firstOrNull?.rawValue;
                          if (value != null) widget.onCode(value);
                        },
                      ),
                    ),
                  ),
                corner(top: true, left: true),
                corner(top: true, left: false),
                corner(top: false, left: true),
                corner(top: false, left: false),
                AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) {
                    final t = Curves.easeInOut.transform(
                      _c.value < 0.5 ? _c.value * 2 : 2 - _c.value * 2,
                    );
                    return Positioned(
                      left: 76,
                      right: 76,
                      top: box.maxHeight * (0.12 + 0.72 * t),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: FpColors.green,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [
                            BoxShadow(color: FpColors.green, blurRadius: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child: Text(
                    widget.caption,
                    textAlign: TextAlign.center,
                    style: FpText.body(size: 12, color: FpColors.onNavyMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
