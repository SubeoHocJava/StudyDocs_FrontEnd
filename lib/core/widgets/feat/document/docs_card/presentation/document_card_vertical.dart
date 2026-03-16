import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_compact.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';

/// Card DỌC — hiển thị gọn: chỉ thumbnail + tiêu đề
/// Dùng trong carousel/grid, payload nhỏ → load nhanh
/// Page chỉ cần truyền [doc] (DocumentCompactModel) + callback [onTap]
class DocumentCardVertical extends StatelessWidget {
  final DocumentCompactModel doc;
  final double width;
  final double thumbHeight;
  final VoidCallback? onTap;

  const DocumentCardVertical({
    super.key,
    required this.doc,
    this.width = 110,
    this.thumbHeight = 148,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentCardCompact(
      doc: doc,
      width: width,
      thumbHeight: thumbHeight,
      borderRadius: 6,
      onTap: onTap,
    );
  }
}
