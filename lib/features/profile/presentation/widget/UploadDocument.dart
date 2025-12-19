import 'package:flutter/cupertino.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../../core/widgets/document/RowDocument.dart';
import '../../../library/data/model/Document.dart';
import '../../logic/profile_state.dart';

class UpLoadDocument extends StatelessWidget {
  final ProfileLoaded state;

  const UpLoadDocument({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final List<Document> documents = [
      Document(
        title: "Tài liệu Flutter",
        subject: "Lập trình di động",
        school: "ĐH Công nghệ",
        pages: 120,
        date: "2025-08-01",
        likes: 45,
        comments: 10,
      ),
      Document(
        title: "Tài liệu Java",
        subject: "Lập trình hướng đối tượng",
        school: "ĐH Bách Khoa",
        pages: 200,
        date: "2025-08-10",
        likes: 60,
        comments: 15,
      ),
      Document(
        title: "Tài liệu Kotlin",
        subject: "Lập trình Android",
        school: "ĐH Khoa Học Tự Nhiên",
        pages: 150,
        date: "2025-08-20",
        likes: 35,
        comments: 8,
      ),
    ];
    // Số cột theo thiết bị
    final crossAxisCount = responsive.getGridColumnCount(
      mobile: 3,
      tablet: 4,
      desktop: 5,
    );

    // Card width theo số cột
    final cardWidth = responsive.getCardWidth(
      columns: crossAxisCount,
      spacing: 12,
      padding: 16,
    );

    return Padding(
      padding: responsive.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tài liệu bạn tải lên",
            style: TextStyle(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          /// 🔥 RowDocument đã scale theo ResponsiveHelper
          RowDocument(
            documents,
            cardWidth: cardWidth,
          ),
        ],
      ),
    );
  }
}
