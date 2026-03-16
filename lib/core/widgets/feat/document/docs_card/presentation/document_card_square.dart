import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_compact.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';

/// Card compact dạng vuông — dùng cho list trượt ngang:
/// thumbnail vuông + title bên dưới.
class DocumentCardSquare extends StatelessWidget {
  final DocumentCompactModel doc;
  final double size;
  final VoidCallback? onTap;

  const DocumentCardSquare({
    super.key,
    required this.doc,
    this.size = 110,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentCardCompact(
      doc: doc,
      width: size,
      thumbHeight: size,
      borderRadius: 8,
      onTap: onTap,
    );
  }
}

