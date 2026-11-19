import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fp_core/fp_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../components/basics.dart';
import '../components/credit_card.dart';
import '../components/list_row.dart';
import '../icons/fp_icons.dart';
import '../tokens/fp_tokens.dart';
import '../tokens/fp_typography.dart';

/// Pièce choisie, ou le message à afficher quand elle est refusée (taille, format).
typedef PieceChoice = ({PickedPiece? piece, String? error});

/// Choisit une pièce jointe (W-SUP) ; `null` quand l'utilisateur renonce.
typedef PiecePicker = Future<PieceChoice?> Function(BuildContext context);

/// Ouvre une pièce jointe reçue (image affichée, PDF remis au téléphone).
typedef PieceOpener = Future<void> Function(
  BuildContext context,
  String ticketId,
  TicketAttachment attachment,
);

enum _Source { camera, gallery, pdf }

/// Photo (caméra), image ou capture d'écran (galerie) ou PDF (fichiers). Le type est lu dans
/// les octets (JPG, PNG, PDF) et la taille limitée à 5 Mo, comme le serveur le vérifie.
Future<PieceChoice?> pickTicketPiece(BuildContext context) async {
  final l10n = FpL10n.of(context);
  final source = await showModalBottomSheet<_Source>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: ListGroup(
        children: [
          ListRow(
            leading: const IconTile(
              tint: FpColors.greenTint,
              color: FpColors.greenDark,
              icon: FpIcons.scan,
            ),
            title: l10n.supportAttachCamera,
            onTap: () => Navigator.pop(sheet, _Source.camera),
          ),
          ListRow(
            leading: const IconTile(
              tint: FpColors.clothingTint,
              color: FpColors.clothing,
              icon: FpIcons.copy,
            ),
            title: l10n.supportAttachGallery,
            onTap: () => Navigator.pop(sheet, _Source.gallery),
          ),
          ListRow(
            leading: const IconTile(
              tint: FpColors.giftsTint,
              color: FpColors.gifts,
              icon: FpIcons.list,
            ),
            title: l10n.supportAttachPdf,
            onTap: () => Navigator.pop(sheet, _Source.pdf),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;
  String name;
  Uint8List bytes;
  if (source == _Source.pdf) {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (file == null) return null;
    name = file.name;
    bytes = await file.readAsBytes();
  } else {
    // Une qualité donnée ré-encode en JPEG (les photos HEIC de l'iPhone aussi).
    final image = await ImagePicker().pickImage(
      source: source == _Source.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2400,
    );
    if (image == null) return null;
    name = image.name;
    bytes = await image.readAsBytes();
  }
  return checkPiece(name, bytes, l10n);
}

/// Contrôle d'une pièce avant l'envoi : 5 Mo au plus, JPG, PNG ou PDF (lu dans les octets).
PieceChoice checkPiece(String name, Uint8List bytes, FpL10n l10n) {
  if (bytes.length > PickedPiece.maxBytes) {
    return (piece: null, error: l10n.supportAttachTooLarge);
  }
  final type = PickedPiece.sniff(bytes);
  if (type == null) return (piece: null, error: l10n.supportAttachType);
  return (
    piece: PickedPiece(name: name, bytes: bytes, contentType: type),
    error: null,
  );
}

/// Ouvre une pièce par son lien signé : une image s'affiche (zoom), un PDF part dans la feuille
/// de partage du téléphone (Fichiers, lecteur PDF, impression).
PieceOpener ticketPieceOpener(SupportRepository repository) =>
    (context, ticketId, attachment) async {
      final l10n = FpL10n.of(context);
      final messenger = ScaffoldMessenger.of(context);
      try {
        final bytes = await repository.attachment(ticketId, attachment.id);
        if (!context.mounted) return;
        if (attachment.isImage) {
          await showDialog<void>(
            context: context,
            builder: (dialog) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(FpSpace.x12),
                    child: Text(attachment.fileName, style: FpText.label),
                  ),
                  Flexible(
                    child: InteractiveViewer(
                      child: Image.memory(
                        bytes,
                        semanticLabel: attachment.fileName,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialog),
                    child: Text(l10n.done),
                  ),
                ],
              ),
            ),
          );
          return;
        }
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                bytes,
                mimeType: attachment.contentType,
                name: attachment.fileName,
              ),
            ],
            fileNameOverrides: [attachment.fileName],
          ),
        );
      } on AppFailure {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.supportAttachError)),
        );
      }
    };

/// Pièces d'un message : une puce par fichier, ouverte au toucher.
class TicketPieces extends StatelessWidget {
  const TicketPieces({
    super.key,
    required this.ticketId,
    required this.attachments,
    required this.onOpen,
  });

  final String ticketId;
  final List<TicketAttachment> attachments;
  final PieceOpener onOpen;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();
    final l10n = FpL10n.of(context);
    return Wrap(
      spacing: FpSpace.x8,
      runSpacing: FpSpace.x6,
      children: [
        for (final a in attachments)
          FpLink(
            label: a.fileName,
            icon: FpIcons.copy,
            size: 13,
            onTap: () => onOpen(context, ticketId, a),
            key: ValueKey('piece-${a.id}'),
          ),
      ],
    ).withSemantics(l10n.supportAttachOpen(attachments.first.fileName));
  }
}

extension on Widget {
  Widget withSemantics(String hint) => Semantics(hint: hint, child: this);
}

/// Pièce choisie avant l'envoi, avec son bouton pour la retirer.
class PickedPieceRow extends StatelessWidget {
  const PickedPieceRow({
    super.key,
    required this.piece,
    required this.onRemove,
  });

  final PickedPiece piece;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = FpL10n.of(context);
    return Row(
      children: [
        const FpIcon(FpIcons.copy, size: 18, color: FpColors.muted),
        const SizedBox(width: FpSpace.x8),
        Expanded(
          child: Text(
            '${piece.name} · ${(piece.bytes.length / 1024).ceil()} Ko',
            style: FpText.small,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          tooltip: l10n.supportAttachRemove,
          onPressed: onRemove,
          icon: const FpIcon(FpIcons.close, size: 18, color: FpColors.muted),
        ),
      ],
    );
  }
}
