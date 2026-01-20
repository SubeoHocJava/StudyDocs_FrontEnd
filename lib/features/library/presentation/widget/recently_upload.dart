import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../domain/model/document_library.dart';

class RecentlyUpload extends StatelessWidget {
  final List<DocumentLibraryUI> documents;
  final void Function(RowDocumentItem)? onTap;

  const RecentlyUpload(
    this.documents, {
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.widthPercent(4),
            vertical: responsive.heightPercent(1),
          ),
          child: Text(
            "Tải lên gần đây",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: responsive.isMobile ? 200 : 250, // chiều cao của list
          child: RowDocument(
            documents,
            cardWidth: responsive.isMobile ? 100 : 150, // responsive width card
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
