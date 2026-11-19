import 'dart:typed_data';

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

/// Pièce jointe d'une demande (PDF, JPG ou PNG, chiffrée côté serveur).
class TicketAttachment {
  const TicketAttachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
  });

  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;

  bool get isImage => contentType.startsWith('image/');
}

/// Fichier choisi par l'utilisateur, avant l'envoi (5 Mo au plus).
class PickedPiece {
  const PickedPiece({
    required this.name,
    required this.bytes,
    required this.contentType,
  });

  static const maxBytes = 5 * 1024 * 1024;

  final String name;
  final Uint8List bytes;
  final String contentType;

  /// Type lu dans les premiers octets (jamais le nom) : JPG, PNG ou PDF, sinon `null`.
  static String? sniff(Uint8List b) {
    if (b.length >= 3 && b[0] == 0xff && b[1] == 0xd8 && b[2] == 0xff) {
      return 'image/jpeg';
    }
    if (b.length >= 4 &&
        b[0] == 0x89 &&
        b[1] == 0x50 &&
        b[2] == 0x4e &&
        b[3] == 0x47) {
      return 'image/png';
    }
    if (b.length >= 4 &&
        b[0] == 0x25 &&
        b[1] == 0x50 &&
        b[2] == 0x44 &&
        b[3] == 0x46) {
      return 'application/pdf';
    }
    return null;
  }
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
    this.attachments = const [],
  });

  final String id;
  final String authorName;
  final bool fromAgent;
  final String body;

  /// Un code PIN, un mot de passe ou un numéro de carte a été masqué par le serveur.
  final bool redacted;
  final DateTime createdAt;
  final List<TicketAttachment> attachments;
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
    this.attachments = const [],
  });

  final String description;
  final bool redacted;
  final bool canReply;
  final bool canReopen;
  final List<TicketMessage> messages;
  final DateTime createdAt;

  /// Pièces jointes à l'ouverture de la demande.
  final List<TicketAttachment> attachments;
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
    PickedPiece? piece,
  });

  Future<TicketDetail> reply(String id, String body, {PickedPiece? piece});

  Future<TicketDetail> reopen(String id);

  /// Octets d'une pièce, lus par son lien signé (5 minutes, cet utilisateur).
  Future<Uint8List> attachment(String ticketId, String attachmentId);
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

  /// Avec une pièce : multipart ; sans : JSON (les deux sont acceptés par l'API).
  Future<Json> _send(
    String path,
    Map<String, String> fields,
    PickedPiece? piece,
  ) => piece == null
      ? _api.post(path, body: fields)
      : _api.postForm(
          path,
          fields: fields,
          fileField: 'attachment',
          fileBytes: piece.bytes,
          fileName: piece.name,
          fileType: piece.contentType,
        );

  @override
  Future<TicketDetail> open({
    required TicketCategory category,
    required String subject,
    required String description,
    TicketLink? link,
    PickedPiece? piece,
  }) async => _detail(
    await _send('/v1/support/tickets', {
      'category': category.api,
      'subject': subject.trim(),
      'description': description.trim(),
      if (link != null) 'linkType': link.type,
      if (link != null) 'linkId': link.id,
    }, piece),
  );

  @override
  Future<TicketDetail> reply(
    String id,
    String body, {
    PickedPiece? piece,
  }) async => _detail(
    await _send('/v1/support/tickets/$id/messages', {
      'body': body.trim(),
    }, piece),
  );

  @override
  Future<TicketDetail> reopen(String id) async =>
      _detail(await _api.post('/v1/support/tickets/$id/reopen'));

  @override
  Future<Uint8List> attachment(String ticketId, String attachmentId) async {
    final link = await _api.get(
      '/v1/support/tickets/$ticketId/attachments/$attachmentId/link',
    );
    return _api.bytes(link['url'] as String);
  }
}

TicketLink? _link(Object? value) {
  if (value is! Json) return null;
  return TicketLink(
    type: value['type'] as String? ?? 'PAYMENT',
    id: value['id'] as String? ?? '',
    reference: value['reference'] as String?,
  );
}

List<TicketAttachment> _attachments(Object? value) => [
  for (final a in listOf(value))
    TicketAttachment(
      id: a['id'] as String,
      fileName: a['fileName'] as String? ?? '',
      contentType: a['contentType'] as String? ?? '',
      sizeBytes: intOf(a['sizeBytes']),
    ),
];

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
  attachments: _attachments(t['attachments']),
  messages: [
    for (final m in listOf(t['messages']))
      TicketMessage(
        id: m['id'] as String,
        authorName: m['authorName'] as String? ?? '',
        fromAgent: m['fromAgent'] == true,
        body: m['body'] as String? ?? '',
        redacted: m['redacted'] == true,
        createdAt: dateOf(m['createdAt']),
        attachments: _attachments(m['attachments']),
      ),
  ],
);

/// Demandes de démonstration (build `FP_DEMO=true`), en mémoire.
class FakeSupportRepository implements SupportRepository {
  FakeSupportRepository(this._now);

  final DateTime Function() _now;
  final _tickets = <TicketDetail>[];
  final _pieces = <String, Uint8List>{};

  TicketAttachment _store(PickedPiece piece) {
    final id = 'demo-piece-${_pieces.length + 1}';
    _pieces[id] = piece.bytes;
    return TicketAttachment(
      id: id,
      fileName: piece.name,
      contentType: piece.contentType,
      sizeBytes: piece.bytes.length,
    );
  }

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
  Future<Uint8List> attachment(String ticketId, String attachmentId) async =>
      _pieces[attachmentId] ?? Uint8List(0);

  @override
  Future<TicketDetail> open({
    required TicketCategory category,
    required String subject,
    required String description,
    TicketLink? link,
    PickedPiece? piece,
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
      attachments: piece == null ? const [] : [_store(piece)],
    );
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<TicketDetail> reply(
    String id,
    String body, {
    PickedPiece? piece,
  }) async {
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
      attachments: t.attachments,
      messages: [
        ...t.messages,
        TicketMessage(
          id: '${t.id}-${t.messages.length + 1}',
          authorName: '',
          fromAgent: false,
          body: body.trim(),
          redacted: false,
          createdAt: now,
          attachments: piece == null ? const [] : [_store(piece)],
        ),
      ],
    );
    _tickets[i] = updated;
    return updated;
  }

  @override
  Future<TicketDetail> reopen(String id) => ticket(id);
}
