import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_json.dart';

/// Statut d'une demande de support (W-SUP).
enum TicketStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  waitingCustomer('WAITING_CUSTOMER'),
  resolved('RESOLVED'),
  closed('CLOSED');

  const TicketStatus(this.api);
  final String api;

  static TicketStatus fromApi(Object? value) =>
      values.firstWhere((s) => s.api == value, orElse: () => TicketStatus.open);
}

/// Catégorie d'une demande.
enum TicketCategory {
  paymentDeclined('PAYMENT_DECLINED'),
  disputedTransaction('DISPUTED_TRANSACTION'),
  accountAccess('ACCOUNT_ACCESS'),
  orderTransfer('ORDER_TRANSFER'),
  payout('PAYOUT'),
  kyc('KYC'),
  other('OTHER');

  const TicketCategory(this.api);
  final String api;

  static TicketCategory fromApi(Object? value) => values.firstWhere(
    (c) => c.api == value,
    orElse: () => TicketCategory.other,
  );
}

/// Opération liée à une demande (transaction, commande ou reversement).
class TicketLink {
  const TicketLink({required this.type, required this.id, this.reference});

  /// `PAYMENT`, `ORDER` ou `PAYOUT` (contrat).
  final String type;
  final String id;
  final String? reference;
}

class TicketSummary {
  const TicketSummary({
    required this.id,
    required this.reference,
    required this.category,
    required this.status,
    required this.subject,
    required this.updatedAt,
    this.link,
  });

  final String id;

  /// TK-AAAA-NNNNNN.
  final String reference;
  final TicketCategory category;
  final TicketStatus status;
  final String subject;
  final DateTime updatedAt;
  final TicketLink? link;
}

class TicketMessage {
  const TicketMessage({
    required this.id,
    required this.authorName,
    required this.fromAgent,
    required this.body,
    required this.redacted,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final bool fromAgent;
  final String body;

  /// Un code PIN, un mot de passe ou un numéro de carte a été masqué par le serveur.
  final bool redacted;
  final DateTime createdAt;
}

class TicketDetail extends TicketSummary {
  const TicketDetail({
    required super.id,
    required super.reference,
    required super.category,
    required super.status,
    required super.subject,
    required super.updatedAt,
    super.link,
    required this.description,
    required this.redacted,
    required this.canReply,
    required this.canReopen,
    required this.messages,
    required this.createdAt,
  });

  final String description;
  final bool redacted;
  final bool canReply;
  final bool canReopen;
  final List<TicketMessage> messages;
  final DateTime createdAt;
}

/// Demandes de support de l'utilisateur connecté (les siennes ; celles du commerce pour le
/// propriétaire). Les notes internes de FlexiPay ne sont jamais reçues.
abstract interface class SupportRepository {
  Future<List<TicketSummary>> tickets({String? query});

  Future<TicketDetail> ticket(String id);

  Future<TicketDetail> open({
    required TicketCategory category,
    required String subject,
    required String description,
    TicketLink? link,
  });

  Future<TicketDetail> reply(String id, String body);

  Future<TicketDetail> reopen(String id);
}

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => throw UnimplementedError('supportRepositoryProvider'),
);

/// Demandes de support sur l'API (`/v1/support/tickets`).
class ApiSupportRepository implements SupportRepository {
  ApiSupportRepository(this._api);

  final ApiJson _api;

  @override
  Future<List<TicketSummary>> tickets({String? query}) async {
    final body = await _api.get(
      '/v1/support/tickets',
      query: {
        'limit': 50,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
      },
    );
    return [for (final t in listOf(body['data'])) _summary(t)];
  }

  @override
  Future<TicketDetail> ticket(String id) async =>
      _detail(await _api.get('/v1/support/tickets/$id'));

  @override
  Future<TicketDetail> open({
    required TicketCategory category,
    required String subject,
    required String description,
    TicketLink? link,
  }) async => _detail(
    await _api.post(
      '/v1/support/tickets',
      body: {
        'category': category.api,
        'subject': subject.trim(),
        'description': description.trim(),
        if (link != null) 'linkType': link.type,
        if (link != null) 'linkId': link.id,
      },
    ),
  );

  @override
  Future<TicketDetail> reply(String id, String body) async => _detail(
    await _api.post(
      '/v1/support/tickets/$id/messages',
      body: {'body': body.trim()},
    ),
  );

  @override
  Future<TicketDetail> reopen(String id) async =>
      _detail(await _api.post('/v1/support/tickets/$id/reopen'));
}

TicketLink? _link(Object? value) {
  if (value is! Json) return null;
  return TicketLink(
    type: value['type'] as String? ?? 'PAYMENT',
    id: value['id'] as String? ?? '',
    reference: value['reference'] as String?,
  );
}

TicketSummary _summary(Json t) => TicketSummary(
  id: t['id'] as String,
  reference: t['reference'] as String? ?? '',
  category: TicketCategory.fromApi(t['category']),
  status: TicketStatus.fromApi(t['status']),
  subject: t['subject'] as String? ?? '',
  updatedAt: dateOf(t['updatedAt']),
  link: _link(t['link']),
);

TicketDetail _detail(Json t) => TicketDetail(
  id: t['id'] as String,
  reference: t['reference'] as String? ?? '',
  category: TicketCategory.fromApi(t['category']),
  status: TicketStatus.fromApi(t['status']),
  subject: t['subject'] as String? ?? '',
  updatedAt: dateOf(t['updatedAt']),
  createdAt: dateOf(t['createdAt']),
  link: _link(t['link']),
  description: t['description'] as String? ?? '',
  redacted: t['redacted'] == true,
  canReply: t['canReply'] == true,
  canReopen: t['canReopen'] == true,
  messages: [
    for (final m in listOf(t['messages']))
      TicketMessage(
        id: m['id'] as String,
        authorName: m['authorName'] as String? ?? '',
        fromAgent: m['fromAgent'] == true,
        body: m['body'] as String? ?? '',
        redacted: m['redacted'] == true,
        createdAt: dateOf(m['createdAt']),
      ),
  ],
);

/// Demandes de démonstration (build `FP_DEMO=true`), en mémoire.
class FakeSupportRepository implements SupportRepository {
  FakeSupportRepository(this._now);

  final DateTime Function() _now;
  final _tickets = <TicketDetail>[];

  @override
  Future<List<TicketSummary>> tickets({String? query}) async {
    final q = query?.trim().toLowerCase() ?? '';
    return [
      for (final t in _tickets.reversed)
        if (q.isEmpty ||
            t.reference.toLowerCase().contains(q) ||
            t.subject.toLowerCase().contains(q))
          t,
    ];
  }

  @override
  Future<TicketDetail> ticket(String id) async =>
      _tickets.firstWhere((t) => t.id == id);

  @override
  Future<TicketDetail> open({
    required TicketCategory category,
    required String subject,
    required String description,
    TicketLink? link,
  }) async {
    final now = _now();
    final n = _tickets.length + 1;
    final ticket = TicketDetail(
      id: 'demo-ticket-$n',
      reference: 'TK-${now.year}-${n.toString().padLeft(6, '0')}',
      category: category,
      status: TicketStatus.open,
      subject: subject.trim(),
      updatedAt: now,
      createdAt: now,
      link: link,
      description: description.trim(),
      redacted: false,
      canReply: true,
      canReopen: false,
      messages: const [],
    );
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<TicketDetail> reply(String id, String body) async {
    final i = _tickets.indexWhere((t) => t.id == id);
    final t = _tickets[i];
    final now = _now();
    final updated = TicketDetail(
      id: t.id,
      reference: t.reference,
      category: t.category,
      status: t.status,
      subject: t.subject,
      updatedAt: now,
      createdAt: t.createdAt,
      link: t.link,
      description: t.description,
      redacted: t.redacted,
      canReply: t.canReply,
      canReopen: t.canReopen,
      messages: [
        ...t.messages,
        TicketMessage(
          id: '${t.id}-${t.messages.length + 1}',
          authorName: '',
          fromAgent: false,
          body: body.trim(),
          redacted: false,
          createdAt: now,
        ),
      ],
    );
    _tickets[i] = updated;
    return updated;
  }

  @override
  Future<TicketDetail> reopen(String id) => ticket(id);
}
