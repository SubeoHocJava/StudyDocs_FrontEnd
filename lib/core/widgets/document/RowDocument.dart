import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../features/library/data/model/Document.dart';

class RowDocument extends StatelessWidget {
  final List<Document> documents;
  final int crossAxisCount;
  final double cardWidth;

  const RowDocument(
      this.documents, {
        required this.crossAxisCount,
        required this.cardWidth,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Tính cardHeight dựa trên tỷ lệ 2:3 (width:height = 2:3)
    final cardHeight = cardWidth*55/45 ;

    return SizedBox(
      height: cardHeight + responsive.heightPercent(10), // thêm khoảng trống cho title
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return MonoDocumentInRow(
            document: document,
            cardWidth: cardWidth, cardHeight: cardHeight,
          );
        },
      ),
    );
  }
}

class MonoDocumentInRow extends StatelessWidget {
  final Document document;
  final double cardWidth;
  final double cardHeight;

  const MonoDocumentInRow({
    super.key,
    required this.document,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Column(
      children: [
        Container(
          width: cardWidth,
          height: cardHeight,
          margin: EdgeInsets.symmetric(
            horizontal: responsive.widthPercent(1),
            vertical: responsive.heightPercent(1),
          ),
          padding: EdgeInsets.all(responsive.isMobile ? 4 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black87),
          ),
          child: Image.asset(
            "assets/icons/search-icon.png",
            width: cardWidth * 0.9,
            height: cardHeight * 0.9,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),
        SizedBox(
          width: cardWidth,
          child: Text(
            document.title,
            style: TextStyle(
              fontSize: responsive.fontSize(14),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
