import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../../core/widgets/document/ListDocument.dart';
import '../../../data/model/Document.dart';

class StoredDocument extends StatelessWidget {
  final List<Document> documents;
  final int? crossAxisCount;

  const StoredDocument(this.documents, {this.crossAxisCount, super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Tính số cột responsive
    final columns = crossAxisCount ??
        responsive.getGridColumnCount(
          mobile: 2,
          tablet: 3,
          desktop: 5,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
          child: Text(
            "Danh sách tài liệu",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),

        // ListDocument responsive
        ListDocument(
          documents,
          crossAxisCount: columns,
        ),
      ],
    );
  }
}
