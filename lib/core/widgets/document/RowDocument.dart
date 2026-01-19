import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import 'model/row_document_ui.dart';

class RowDocument extends StatelessWidget {
  final List<RowDocumentItem> documents;
  final double cardWidth;
  final void Function(RowDocumentItem)? onTap;

  const RowDocument(this.documents, {required this.cardWidth, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final cardHeight = cardWidth;

    return SizedBox(
      height:
          cardHeight +
          responsive.heightPercent(10), // thêm khoảng trống cho title
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return MonoDocumentInRow(
            document: document,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            onTap: onTap,
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
  final void Function(RowDocumentItem)? onTap;

  const MonoDocumentInRow({
    super.key,
    required this.document,
    required this.cardWidth,
    required this.cardHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return GestureDetector(
      onTap: () => onTap?.call(document),
      child: Column(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: document.thumbnail != null && document.thumbnail!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: document.thumbnail!,
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/icons/temp_image.jpg",
                        width: cardWidth,
                        height: cardHeight,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      "assets/icons/temp_image.jpg",
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
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
      ),
    );
  }
}
