import 'package:flutter/cupertino.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../domain/ui_model/doc_subject_lib_ui.dart';


class UploadDocument extends StatelessWidget {
  final List<DocumentSubjectLibUI> docs;

  // crossAxisCount và cardWidth sẽ nhận từ parent (responsive)
  final double? cardWidth;

  const UploadDocument(
    this.docs, {
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
          padding: EdgeInsets.only(
            left: responsive.isMobile ? 12 : 16,
            top: responsive.heightPercent(1),
          ),
          child: Text(
            "Tải lên gần đây",
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
          cardWidth:
              cardWidth ??
              responsive.getCardWidth(
                columns:
                    responsive.getGridColumnCount(
                      mobile: 3,
                      tablet: 4,
                      desktop: 5,
                    ),
              ),
        ),
      ],
    );
  }
}
