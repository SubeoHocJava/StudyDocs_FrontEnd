import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/presentation/document_card_horizontal_with_bloc.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

/// Carousel ngang cho card ngang.
/// Page tự quyết định kích thước item để phù hợp layout (giống card dọc).
class DocumentCardHorizontalCarousel extends StatelessWidget {
  final List<DocumentSummaryModel> docs;
  final DocumentRepository repository;
  final double itemWidth;
  final double itemHeight;
  final EdgeInsets padding;
  final double separatorWidth;
  final void Function(String docId)? onCardTap;

  const DocumentCardHorizontalCarousel({
    super.key,
    required this.docs,
    required this.repository,
    this.itemWidth = 320,
    this.itemHeight = 150,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.separatorWidth = 12,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: docs.length,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
        itemBuilder: (context, index) {
          final doc = docs[index];
          return SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: DocumentCardHorizontalWithBloc(
              doc: doc,
              repository: repository,
              onTap: onCardTap != null ? () => onCardTap!(doc.id) : null,
            ),
          );
        },
      ),
    );
  }
}

