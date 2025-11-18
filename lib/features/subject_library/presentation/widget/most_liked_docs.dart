import 'package:flutter/cupertino.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../../library/data/model/Document.dart';

class MostLikeDocs extends StatelessWidget {
  final List<Document> documents;
  final int? crossAxisCount;

  const MostLikeDocs(this.documents, {this.crossAxisCount, super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Số cột responsive
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
          padding: EdgeInsets.only(
            left: responsive.isMobile ? 12 : 16,
            top: responsive.heightPercent(1),
          ),
          child: Text(
            "Lượt thích cao nhất",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),

        // RowDocument responsive
        RowDocument(
          documents,
          crossAxisCount: columns,
          cardWidth: responsive.getCardWidth(columns: columns),
        ),
      ],
    );
  }
}
