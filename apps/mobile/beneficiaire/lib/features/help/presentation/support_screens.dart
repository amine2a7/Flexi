import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Choix d'une pièce jointe (photo, capture ou PDF) ; remplacé dans les tests.
final piecePickerProvider = Provider<PiecePicker>((ref) => pickTicketPiece);

/// Aide › Mes demandes (W-SUP).
class SupportTicketsScreen extends ConsumerWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SupportTicketsView(
    repository: ref.watch(supportRepositoryProvider),
    onOpen: (id) => context.push(Routes.ticket(id)),
    onNew: () => context.push(Routes.newTicket),
    onBack: () => context.canPop() ? context.pop() : context.go(Routes.help),
  );
}

/// Nouvelle demande ; depuis un reçu, la transaction est pré-remplie.
class NewTicketScreen extends ConsumerWidget {
  const NewTicketScreen({super.key, this.link});

  final TicketLink? link;

  @override
  Widget build(BuildContext context, WidgetRef ref) => NewTicketView(
    repository: ref.watch(supportRepositoryProvider),
    link: link,
    pickPiece: ref.watch(piecePickerProvider),
    onCreated: (ticket) => context.pushReplacement(Routes.ticket(ticket.id)),
    onBack: () => context.pop(),
  );
}

class TicketScreen extends ConsumerWidget {
  const TicketScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TicketView(
    repository: ref.watch(supportRepositoryProvider),
    ticketId: ticketId,
    pickPiece: ref.watch(piecePickerProvider),
    onBack: () => context.canPop() ? context.pop() : context.go(Routes.tickets),
  );
}
