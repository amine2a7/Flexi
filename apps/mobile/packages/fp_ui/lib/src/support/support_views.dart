import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';
import 'package:intl/intl.dart';

import '../components/basics.dart';
import '../components/chips.dart';
import '../components/credit_card.dart';
import '../components/layout.dart';
import '../components/list_row.dart';
import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Libellé d'une catégorie de demande.
String ticketCategoryLabel(FpL10n l10n, TicketCategory c) => switch (c) {
  TicketCategory.paymentDeclined => l10n.supportCategoryPaymentDeclined,
  TicketCategory.disputedTransaction => l10n.supportCategoryDisputed,
  TicketCategory.accountAccess => l10n.supportCategoryAccount,
  TicketCategory.orderTransfer => l10n.supportCategoryOrder,
  TicketCategory.payout => l10n.supportCategoryPayout,
  TicketCategory.kyc => l10n.supportCategoryKyc,
  TicketCategory.other => l10n.supportCategoryOther,
};

/// Libellé d'un statut de demande, vu par le client.
String ticketStatusLabel(FpL10n l10n, TicketStatus s) => switch (s) {
  TicketStatus.open => l10n.supportStatusOpen,
  TicketStatus.inProgress => l10n.supportStatusInProgress,
  TicketStatus.waitingCustomer => l10n.supportStatusWaiting,
  TicketStatus.resolved => l10n.supportStatusResolved,
  TicketStatus.closed => l10n.supportStatusClosed,
};

(Color, Color) _statusColors(TicketStatus s) => switch (s) {
  TicketStatus.waitingCustomer => (FpColors.warningTint, FpColors.warningInk),
  TicketStatus.resolved => (FpColors.greenTint, FpColors.greenDark),
  TicketStatus.closed => (FpColors.divider, FpColors.muted),
  _ => (FpColors.clothingTint, FpColors.clothing),
};

/// Pastille de statut (couleur + texte, jamais la couleur seule).
class TicketStatusPill extends StatelessWidget {
  const TicketStatusPill(this.status, {super.key});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final (tint, ink) = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.x8,
        vertical: FpSpace.x4,
      ),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(FpRadius.sm),
      ),
      child: Text(
        ticketStatusLabel(FpL10n.of(context), status),
        style: FpText.body(size: 12, weight: FontWeight.w600, color: ink),
      ),
    );
  }
}

/// « Mes demandes » (W-SUP) : recherche pendant la frappe (300 ms), puis la liste.
class SupportTicketsView extends StatefulWidget {
  const SupportTicketsView({
    super.key,
    required this.repository,
    required this.onOpen,
    required this.onNew,
    required this.onBack,
  });

  final SupportRepository repository;
  final ValueChanged<String> onOpen;
  final VoidCallback onNew;
  final VoidCallback onBack;

  @override
  State<SupportTicketsView> createState() => _SupportTicketsViewState();
}

class _SupportTicketsViewState extends State<SupportTicketsView> {
  final _search = TextEditingController();
  Timer? _debounce;
  List<TicketSummary>? _tickets;
  AppFailure? _failure;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final request = ++_request;
    try {
      final tickets = await widget.repository.tickets(query: _search.text);
      if (!mounted || request != _request) return;
      setState(() {
        _tickets = tickets;
        _failure = null;
      });
    } on AppFailure catch (e) {
      if (!mounted || request != _request) return;
      setState(() => _failure = e);
    }
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _load);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final tickets = _tickets;
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.supportTickets, onBack: widget.onBack),
        Text(l10n.supportTicketsHint, style: FpText.muted14),
        FpButton(
          label: l10n.supportNew,
          icon: FpIcons.plus,
          onPressed: widget.onNew,
        ),
        FpTextField(
          label: l10n.supportSearch,
          controller: _search,
          icon: FpIcons.search,
          onChanged: _onSearch,
          fieldKey: const Key('support-search'),
        ),
        if (_failure != null)
          Text(l10n.searchNoResult, style: FpText.muted14)
        else if (tickets == null)
          const Center(child: CircularProgressIndicator())
        else if (tickets.isEmpty)
          Text(
            _search.text.trim().isEmpty
                ? l10n.supportEmpty
                : l10n.searchNoResult,
            style: FpText.muted14,
          )
        else
          ListGroup(
            children: [
              for (final t in tickets)
                ListRow(
                  leading: const IconTile(
                    tint: FpColors.clothingTint,
                    color: FpColors.clothing,
                    icon: FpIcons.mail,
                  ),
                  title: t.subject,
                  subtitle:
                      '${t.reference} · ${ticketStatusLabel(l10n, t.status)} · ${dateFormat.format(t.updatedAt.toLocal())}',
                  chevron: true,
                  onTap: () => widget.onOpen(t.id),
                ),
            ],
          ),
      ],
    );
  }
}

/// Nouvelle demande : catégorie, sujet, description ; l'opération liée (« Signaler un
/// problème » sur un reçu) est pré-remplie.
class NewTicketView extends StatefulWidget {
  const NewTicketView({
    super.key,
    required this.repository,
    required this.onCreated,
    required this.onBack,
    this.link,
  });

  final SupportRepository repository;
  final TicketLink? link;
  final ValueChanged<TicketDetail> onCreated;
  final VoidCallback onBack;

  @override
  State<NewTicketView> createState() => _NewTicketViewState();
}

class _NewTicketViewState extends State<NewTicketView> {
  final _subject = TextEditingController();
  final _description = TextEditingController();
  late TicketCategory _category = widget.link == null
      ? TicketCategory.other
      : TicketCategory.paymentDeclined;
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _send(FpL10n l10n) async {
    if (_subject.text.trim().length < 3 ||
        _description.text.trim().length < 10) {
      setState(() => _error = l10n.supportInvalid);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final ticket = await widget.repository.open(
        category: _category,
        subject: _subject.text,
        description: _description.text,
        link: widget.link,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.supportSent(ticket.reference))),
      );
      widget.onCreated(ticket);
    } on AppFailure catch (e) {
      if (!mounted) return;
      setState(
        () => _error = e is ApiProblemFailure && e.code == 'RATE_LIMITED'
            ? l10n.supportRateLimited
            : l10n.supportInvalid,
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final link = widget.link;
    return FpScreen(
      children: [
        ScreenHeader(title: l10n.supportNew, onBack: widget.onBack),
        if (link != null)
          FpCard(
            child: Text(
              l10n.supportLinked(link.reference ?? ''),
              style: FpText.rowTitle,
            ),
          ),
        Text(l10n.supportCategory, style: FpText.label),
        Wrap(
          spacing: FpSpace.x8,
          runSpacing: FpSpace.x8,
          children: [
            for (final c in TicketCategory.values)
              FpChip(
                label: ticketCategoryLabel(l10n, c),
                selected: _category == c,
                onTap: () => setState(() => _category = c),
              ),
          ],
        ),
        FpTextField(
          label: l10n.supportSubject,
          controller: _subject,
          fieldKey: const Key('support-subject'),
        ),
        _MultilineField(
          label: l10n.supportDescription,
          controller: _description,
          fieldKey: const Key('support-description'),
        ),
        Text(l10n.supportPinWarning, style: FpText.small),
        if (_error != null)
          Text(_error!, style: FpText.body(size: 13, color: FpColors.danger)),
        FpButton(
          label: l10n.supportSend,
          icon: FpIcons.mail,
          onPressed: _sending ? null : () => _send(l10n),
        ),
      ],
    );
  }
}

/// Une demande et sa conversation ; réponse, ou réouverture quand elle est résolue.
class TicketView extends StatefulWidget {
  const TicketView({
    super.key,
    required this.repository,
    required this.ticketId,
    required this.onBack,
  });

  final SupportRepository repository;
  final String ticketId;
  final VoidCallback onBack;

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  final _reply = TextEditingController();
  TicketDetail? _ticket;
  bool _busy = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _run(() => widget.repository.ticket(widget.ticketId));
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _run(Future<TicketDetail> Function() action) async {
    setState(() => _busy = true);
    try {
      final ticket = await action();
      if (mounted) {
        setState(() {
          _ticket = ticket;
          _failed = false;
        });
      }
    } on AppFailure {
      // La demande reste affichée telle qu'elle était ; un message propose de réessayer.
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    final ticket = _ticket;
    final time = DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm();
    if (ticket == null) {
      return FpScreen(
        children: [
          ScreenHeader(title: l10n.supportTickets, onBack: widget.onBack),
          if (_failed) ...[
            Text(l10n.genericError, style: FpText.muted14),
            FpButton(
              label: l10n.retry,
              icon: FpIcons.refresh,
              variant: FpButtonVariant.secondary,
              onPressed: () =>
                  _run(() => widget.repository.ticket(widget.ticketId)),
            ),
          ] else
            const Center(child: CircularProgressIndicator()),
        ],
      );
    }
    return FpScreen(
      children: [
        ScreenHeader(title: ticket.reference, onBack: widget.onBack),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(ticket.subject, style: FpText.title),
              ),
            ),
            TicketStatusPill(ticket.status),
          ],
        ),
        Text(ticketCategoryLabel(l10n, ticket.category), style: FpText.small),
        if (ticket.link != null)
          Text(
            l10n.supportLinked(ticket.link!.reference ?? ''),
            style: FpText.small,
          ),
        _Bubble(
          author: l10n.supportYou,
          time: time.format(ticket.createdAt.toLocal()),
          body: ticket.description,
          redacted: ticket.redacted,
          mine: true,
        ),
        if (ticket.messages.isEmpty)
          Text(l10n.supportNoAnswer, style: FpText.muted14)
        else
          for (final m in ticket.messages)
            _Bubble(
              author: m.fromAgent ? l10n.supportFlexipay : l10n.supportYou,
              time: time.format(m.createdAt.toLocal()),
              body: m.body,
              redacted: m.redacted,
              mine: !m.fromAgent,
            ),
        if (ticket.canReopen) ...[
          Text(l10n.supportResolvedHint, style: FpText.muted14),
          FpButton(
            label: l10n.supportReopen,
            icon: FpIcons.refresh,
            variant: FpButtonVariant.secondary,
            onPressed: _busy
                ? null
                : () => _run(() => widget.repository.reopen(ticket.id)),
          ),
        ],
        if (ticket.canReply) ...[
          _MultilineField(
            label: l10n.supportReply,
            controller: _reply,
            fieldKey: const Key('support-reply'),
          ),
          FpButton(
            label: l10n.supportReplySend,
            icon: FpIcons.mail,
            onPressed: _busy
                ? null
                : () {
                    final body = _reply.text.trim();
                    if (body.isEmpty) return;
                    _run(() async {
                      final updated = await widget.repository.reply(
                        ticket.id,
                        body,
                      );
                      _reply.clear();
                      return updated;
                    });
                  },
          ),
        ] else
          Text(l10n.supportClosedHint, style: FpText.muted14),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.author,
    required this.time,
    required this.body,
    required this.redacted,
    required this.mine,
  });

  final String author;
  final String time;
  final String body;
  final bool redacted;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: FpCard(
        color: mine ? FpColors.greenTint : FpColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$author · $time', style: FpText.small),
            const SizedBox(height: FpSpace.x6),
            Text(body, style: FpText.body(size: 14, height: 1.5)),
            if (redacted) ...[
              const SizedBox(height: FpSpace.x6),
              Text(
                FpL10n.of(context).supportRedacted,
                style: FpText.body(size: 12, color: FpColors.warningInk),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Zone de texte de plusieurs lignes, au style des champs.
class _MultilineField extends StatelessWidget {
  const _MultilineField({
    required this.label,
    required this.controller,
    required this.fieldKey,
  });

  final String label;
  final TextEditingController controller;
  final Key fieldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: FpText.label),
        const SizedBox(height: FpSpace.x6),
        Container(
          padding: const EdgeInsets.all(FpSpace.x14),
          decoration: BoxDecoration(
            color: FpColors.surface,
            borderRadius: BorderRadius.circular(FpRadius.field),
            border: Border.all(color: FpColors.border),
          ),
          child: Semantics(
            label: label,
            child: TextField(
              key: fieldKey,
              controller: controller,
              minLines: 4,
              maxLines: 8,
              maxLength: 4000,
              style: FpText.body(size: 15),
              cursorColor: FpColors.navy,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
