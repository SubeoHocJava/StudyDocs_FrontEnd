import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../data/model/Document.dart';
import '../../../../../core/widgets/document/RowDocument.dart';

class RecentlyUpload extends StatelessWidget {
  final List<Document> documents;

  const RecentlyUpload(this.documents, {super.key});

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
          height: responsive.heightPercent(25), // chiều cao của list
          child: RowDocument(
            documents,
            crossAxisCount: responsive.getGridColumnCount(mobile: 2, tablet: 3, desktop: 4),
            cardWidth: responsive.widthPercent(responsive.isMobile ? 60 : 30), // responsive width card
          ),
        ),
      ],
    );
  }
}
