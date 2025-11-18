import 'package:flutter/cupertino.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../../library/data/model/Document.dart';


class UploadDocument extends StatelessWidget {
  final List<Document> docs;

  // crossAxisCount và cardWidth sẽ nhận từ parent (responsive)
  final int? crossAxisCount;
  final double? cardWidth;

  const UploadDocument(
      this.docs, {
        this.crossAxisCount,
        this.cardWidth,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: responsive.isMobile ? 12 : 16, top: responsive.heightPercent(1)),
          child: Text(
            "Tài liệu bạn tải lên",
            style: TextStyle(
              fontSize: responsive.fontSize(18), // responsive font
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),

        // RowDocument: có thể truyền crossAxisCount, cardWidth để responsive
        RowDocument(
          docs,
          crossAxisCount: crossAxisCount ?? responsive.getGridColumnCount(mobile: 2, tablet: 3, desktop: 4),
          cardWidth: cardWidth ?? responsive.getCardWidth(
            columns: crossAxisCount ?? responsive.getGridColumnCount(mobile: 2, tablet: 3, desktop: 4),
          ),
        ),
      ],
    );
  }
}
