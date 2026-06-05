import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_compact.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';

class DocumentCardSquareCarousel extends StatelessWidget {
  final List<DocumentCompactModel> docs;
  final double itemSize;
  final EdgeInsets padding;
  final double separatorWidth;
  final void Function(String docId)? onCardTap;

  const DocumentCardSquareCarousel({
    super.key,
    required this.docs,
    this.itemSize = 110,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.separatorWidth = 12,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemSize + 40,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: docs.length,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
        itemBuilder: (context, index) {
          final doc = docs[index];
          return DocumentCardCompact(
            doc: doc,
            width: itemSize,
            thumbHeight: itemSize,
            onTap: onCardTap != null ? () => onCardTap!(doc.id) : null,
          );
        },
      ),
    );
  }
}
