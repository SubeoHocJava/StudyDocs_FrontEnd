import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/data/model/document_model.dart';

import 'model/row_document_ui.dart';


class RowDocument extends StatelessWidget {
  final List<RowDocumentItem > documents;
  final double cardWidth;

  const RowDocument(
      this.documents, {
        required this.cardWidth,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;


    final cardHeight = cardWidth ;

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
  final RowDocumentItem document;
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
            border: Border.all(color: AppColors.navy),
          ),
          child: Image.asset(
            "assets/icons/search-icon.png",
            width: cardWidth * 0.8,
            height: cardHeight * 0.8,
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
              fontWeight: FontWeight.bold,
              color: AppColors.profileName,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
