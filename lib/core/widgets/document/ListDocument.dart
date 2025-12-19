import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../../features/library/data/model/Document.dart';

class ListDocument extends StatelessWidget {
  final List<Document> documents;
  final int crossAxisCount;

  const ListDocument(this.documents, {required this.crossAxisCount, super.key});

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
          child: MonoDocumentInList(document: documents[index]),
        );
      },
    );
  }
}

// mỗi document
class MonoDocumentInList extends StatelessWidget {
  final Document document;

  const MonoDocumentInList({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    double with_container =
        responsive.isMobile ? responsive.widthPercent(90) : 500;

    return Container(
      width: with_container,
      height: responsive.isMobile ? responsive.heightPercent(25) : 200,
      padding: EdgeInsets.all(responsive.isMobile ? 8 : 12),
      margin: EdgeInsets.symmetric(vertical: responsive.heightPercent(0.5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image left
          Container(
            width: responsive.isMobile ? responsive.widthPercent(30) : 200,
            height: responsive.isMobile ? responsive.widthPercent(30) : 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.navy, // màu viền
                width: 1, // độ dày viền
              ),
              borderRadius: BorderRadius.circular(8), // nếu muốn bo góc
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // để ảnh bo theo container
              child: Image.asset(
                "assets/icons/temp_image.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: responsive.widthPercent(2)),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: document.title, responsive: responsive),
                SizedBox(height: responsive.heightPercent(0.5)),

                SubjectWidget(
                  subject: document.subject,
                  responsive: responsive,
                ),
                SizedBox(height: responsive.heightPercent(0.5)),

                SchoolWidget(school: document.school, responsive: responsive),
                SizedBox(height: responsive.heightPercent(0.5)),

                PageDateWidget(
                  pages: document.pages,
                  date: document.date,
                  responsive: responsive,
                ),
                SizedBox(height: responsive.heightPercent(2)),

                LikeCommentWidget(
                  likes: document.likes,
                  comments: document.comments,
                  responsive: responsive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  Các thành phần trong document
class TitleWidget extends StatelessWidget {
  final String title;
  final ResponsiveHelper responsive;

  const TitleWidget({super.key, required this.title, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.fontSize(14),
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class SubjectWidget extends StatelessWidget {
  final String subject;
  final ResponsiveHelper responsive;

  const SubjectWidget({
    super.key,
    required this.subject,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.folder, size: responsive.fontSize(14), color: Colors.blue),
        SizedBox(width: responsive.widthPercent(1)),
        Flexible(
          child: Text(
            subject,
            style: TextStyle(fontSize: responsive.fontSize(12)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class SchoolWidget extends StatelessWidget {
  final String school;
  final ResponsiveHelper responsive;

  const SchoolWidget({
    super.key,
    required this.school,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/icons/school.png",
          width: responsive.fontSize(14),
          height: responsive.fontSize(14),
        ),
        SizedBox(width: responsive.widthPercent(1)),
        Flexible(
          child: Text(
            school,
            style: TextStyle(fontSize: responsive.fontSize(12)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class PageDateWidget extends StatelessWidget {
  final int pages;
  final String date;
  final ResponsiveHelper responsive;

  const PageDateWidget({
    super.key,
    required this.pages,
    required this.date,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: responsive.widthPercent(2),
      runSpacing: responsive.heightPercent(1),
      children: [
        Icon(Icons.file_open_rounded, size: responsive.fontSize(14)),
        Text(
          "$pages trang",
          style: TextStyle(fontSize: responsive.fontSize(12)),
        ),

        Icon(Icons.calendar_today, size: responsive.fontSize(14)),
        Text(date, style: TextStyle(fontSize: responsive.fontSize(12))),
      ],
    );
  }
}

//
class LikeCommentWidget extends StatelessWidget {
  final int likes;
  final int comments;
  final ResponsiveHelper responsive;

  const LikeCommentWidget({
    super.key,
    required this.likes,
    required this.comments,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.thumb_up_outlined,
          size: responsive.fontSize(17),
          color: Colors.black,
        ),
        SizedBox(width: responsive.widthPercent(1)),
        Text("$likes", style: TextStyle(fontSize: responsive.fontSize(15))),

        SizedBox(width: responsive.widthPercent(2)),
        Icon(Icons.comment, size: responsive.fontSize(17), color: Colors.grey),
        SizedBox(width: responsive.widthPercent(1)),
        Text("$comments", style: TextStyle(fontSize: responsive.fontSize(15))),

        SizedBox(width: responsive.widthPercent(4)),
        IconButton(
          icon: Icon(Icons.download),
          iconSize: responsive.fontSize(30),
          color: Colors.black,
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),

        IconButton(
          icon: Icon(Icons.bookmark),
          iconSize: responsive.fontSize(30),
          color: Colors.yellowAccent,
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }
}
