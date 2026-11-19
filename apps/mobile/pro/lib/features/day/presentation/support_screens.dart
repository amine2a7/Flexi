import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

/// Choix d'une pièce jointe (photo, capture ou PDF) ; remplacé dans les tests.
final piecePickerProvider = Provider<PiecePicker>((ref) => pickTicketPiece);

/// Aide › Mes demandes de l'app Pro (W-SUP) : le caissier voit les siennes, le propriétaire
/// celles du commerce.
class ProTicketsScreen extends ConsumerWidget {
  const ProTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SupportTicketsView(
    repository: ref.watch(supportRepositoryProvider),
    onOpen: (id) => context.push(ProRoutes.ticket(id)),
    onNew: () => context.push(ProRoutes.newTicket),
    onBack: () => context.canPop() ? context.pop() : context.go(ProRoutes.day),
  );
}

/// Nouvelle demande ; depuis un encaissement, la transaction est pré-remplie.
class ProNewTicketScreen extends ConsumerWidget {
  const ProNewTicketScreen({super.key, this.link});

  final TicketLink? link;

  @override
  Widget build(BuildContext context, WidgetRef ref) => NewTicketView(
    repository: ref.watch(supportRepositoryProvider),
    link: link,
    pickPiece: ref.watch(piecePickerProvider),
    onCreated: (ticket) => context.pushReplacement(ProRoutes.ticket(ticket.id)),
    onBack: () => context.pop(),
  );
}

class ProTicketScreen extends ConsumerWidget {
  const ProTicketScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TicketView(
    repository: ref.watch(supportRepositoryProvider),
    ticketId: ticketId,
    pickPiece: ref.watch(piecePickerProvider),
    onBack: () =>
        context.canPop() ? context.pop() : context.go(ProRoutes.tickets),
  );
}
