import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../features/library/data/model/Document.dart';

class ListDocument extends StatelessWidget {
  final List<Document> documents;
  final int crossAxisCount;
  final double cardWidth;

  const ListDocument(
      this.documents, {
        required this.crossAxisCount,
        required this.cardWidth,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.heightPercent(1),
            horizontal: responsive.isMobile ? 12 : 16,
          ),
          child: MonoDocumentInList(
            document: documents[index],
            cardWidth: cardWidth,
            cardHeight: responsive.heightPercent(25),
          ),
        );
      },
    );
  }
}

class MonoDocumentInList extends StatelessWidget {
  final Document document;
  final double cardWidth;
  final double cardHeight;

  const MonoDocumentInList({
    super.key,
    required this.document,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(responsive.isMobile ? 8 : 12),
      margin: EdgeInsets.symmetric(vertical: responsive.heightPercent(0.5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(
            "assets/icons/temp_image.jpg",
            width: cardWidth * 0.35,
            height: cardHeight * 0.6,
            fit: BoxFit.cover,
          ),
          SizedBox(width: responsive.widthPercent(2)),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  document.title,
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.heightPercent(0.5)),

                // Subject
                Row(
                  children: [
                    Icon(Icons.folder, size: responsive.fontSize(14), color: Colors.blue),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text(
                      document.subject,
                      style: TextStyle(fontSize: responsive.fontSize(12)),
                    ),
                  ],
                ),
                SizedBox(height: responsive.heightPercent(0.5)),

                // School
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/school.png",
                      width: responsive.fontSize(14),
                      height: responsive.fontSize(14),
                    ),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text(
                      document.school,
                      style: TextStyle(fontSize: responsive.fontSize(12)),
                    ),
                  ],
                ),
                SizedBox(height: responsive.heightPercent(0.5)),

                // Page and Date
                Row(
                  children: [
                    Icon(Icons.file_open_rounded, size: responsive.fontSize(14)),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text("${document.pages} trang", style: TextStyle(fontSize: responsive.fontSize(12))),
                    SizedBox(width: responsive.widthPercent(2)),
                    Icon(Icons.calendar_today, size: responsive.fontSize(14)),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text(document.date, style: TextStyle(fontSize: responsive.fontSize(12))),
                  ],
                ),
                SizedBox(height: responsive.heightPercent(0.5)),

                // Likes and Comments
                Row(
                  children: [
                    Icon(Icons.favorite, size: responsive.fontSize(14), color: Colors.red),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text("${document.likes}", style: TextStyle(fontSize: responsive.fontSize(12))),
                    SizedBox(width: responsive.widthPercent(2)),
                    Icon(Icons.comment, size: responsive.fontSize(14), color: Colors.grey),
                    SizedBox(width: responsive.widthPercent(1)),
                    Text("${document.comments}", style: TextStyle(fontSize: responsive.fontSize(12))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
