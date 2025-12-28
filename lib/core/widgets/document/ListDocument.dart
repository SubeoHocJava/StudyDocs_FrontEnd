import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'model/list_document_ui.dart';

class ListDocument extends StatelessWidget {
  final List<DocumentUiList> documents;

  final void Function(DocumentUiList)? onDownload;
  final void Function(DocumentUiList)? onSave;
  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;

  const ListDocument(
      this.documents, {
        super.key,
        this.onDownload,
        this.onSave,
        this.onLike,
        this.onComment,
      });
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.heightPercent(1),
            horizontal: responsive.isMobile ? 12 : 16,
          ),
          child: MonoDocumentInList(
            document: document,
            onDownload: onDownload,
            onSave: onSave,
          ),
        );
      },
    );
  }
}

/// =======================
/// CARD DOCUMENT
/// =======================
class MonoDocumentInList extends StatelessWidget {
  final DocumentUiList document;

  final void Function(DocumentUiList)? onDownload;
  final void Function(DocumentUiList)? onSave;
  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;
  const MonoDocumentInList({
    super.key,
    required this.document,
    this.onDownload,
    this.onSave,
    this.onLike,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double containerWidth =
    responsive.isMobile ? responsive.widthPercent(90) : 520;

    return Container(
      width: containerWidth,
      height: responsive.isMobile ? responsive.heightPercent(25) : 210,
      margin: EdgeInsets.symmetric(
        vertical: responsive.heightPercent(0.5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(responsive.isMobile ? 8 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DocumentImage(responsive: responsive),
                SizedBox(width: responsive.widthPercent(2)),
                Expanded(
                  child:_DocumentInfo(
                    document: document,
                    responsive: responsive,
                    onLike: onLike,
                    onComment: onComment,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: responsive.isMobile ? 8 : 12,
            bottom: responsive.isMobile ? 8 : 12,
            child: DownloadSaveGroup(
              responsive: responsive,
              onDownload: () => onDownload?.call(document),
              onSave: () => onSave?.call(document),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// IMAGE
/// =======================
class DocumentImage extends StatelessWidget {
  final ResponsiveHelper responsive;

  const DocumentImage({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final double size =
    responsive.isMobile ? responsive.widthPercent(30) : 180;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.navy, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/icons/temp_image.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// =======================
/// DOCUMENT INFO
/// =======================
class _DocumentInfo extends StatelessWidget {
  final DocumentUiList document;
  final ResponsiveHelper responsive;

  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;

  const _DocumentInfo({
    required this.document,
    required this.responsive,
    this.onLike,
    this.onComment,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: document.title, responsive: responsive),
        SizedBox(height: responsive.heightPercent(0.5)),
        SubjectWidget(subject: document.category, responsive: responsive),
        SizedBox(height: responsive.heightPercent(0.5)),
        SchoolWidget(school: document.institution, responsive: responsive),
        SizedBox(height: responsive.heightPercent(0.5)),
        PageDateWidget(
          pages: 5,
          date: document.createdAt,
          responsive: responsive,
        ),
        SizedBox(height: responsive.heightPercent(1.5)),
        LikeCommentWidget(
          likes: document.likesCount,
          comments: document.commentsCount,
          responsive: responsive,
          onLikeTap: () => onLike?.call(document),
          onCommentTap: () => onComment?.call(document),
        ),
      ],
    );
  }
}

/// =======================
/// TEXT COMPONENTS
/// =======================
class TitleWidget extends StatelessWidget {
  final String title;
  final ResponsiveHelper responsive;

  const TitleWidget({
    super.key,
    required this.title,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: responsive.fontSize(14),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SubjectWidget extends StatelessWidget {
  final String? subject;
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
        Icon(Icons.folder,
            size: responsive.fontSize(14), color: Colors.blue),
        SizedBox(width: responsive.widthPercent(1)),
        Expanded(
          child: Text(
            subject!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: responsive.fontSize(12)),
          ),
        ),
      ],
    );
  }
}

class SchoolWidget extends StatelessWidget {
  final String? school;
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
        Expanded(
          child: Text(
            school!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: responsive.fontSize(12)),
          ),
        ),
      ],
    );
  }
}

class PageDateWidget extends StatelessWidget {
  final int pages;
  final String? date;
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
      spacing: responsive.widthPercent(2),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.file_open_rounded,
            size: responsive.fontSize(14)),
        Text("$pages trang",
            style: TextStyle(fontSize: responsive.fontSize(12))),
        Icon(Icons.calendar_today,
            size: responsive.fontSize(14)),
        Text(date!,
            style: TextStyle(fontSize: responsive.fontSize(12))),
      ],
    );
  }
}
// LikeComment
class LikeCommentWidget extends StatelessWidget {
  final int? likes;
  final int? comments;
  final ResponsiveHelper responsive;

  /// CALLBACK EVENTS
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;

  const LikeCommentWidget({
    super.key,
    required this.likes,
    required this.comments,
    required this.responsive,
    this.onLikeTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = responsive.fontSize(16);

    return Row(
      children: [
        // ===== LIKE =====
        GestureDetector(
          onTap: onLikeTap,
          child: Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: iconSize),
              SizedBox(width: responsive.widthPercent(1)),
              Text(
                "$likes",
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ],
          ),
        ),

        SizedBox(width: responsive.widthPercent(3)),

        // ===== COMMENT =====
        GestureDetector(
          onTap: onCommentTap,
          child: Row(
            children: [
              Icon(Icons.comment,
                  size: iconSize, color: Colors.grey),
              SizedBox(width: responsive.widthPercent(1)),
              Text(
                "$comments",
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


/// =======================
/// DOWNLOAD + SAVE
/// =======================
class DownloadSaveGroup extends StatelessWidget {
  final ResponsiveHelper responsive;
  final VoidCallback? onDownload;
  final VoidCallback? onSave;

  const DownloadSaveGroup({
    super.key,
    required this.responsive,
    this.onDownload,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = responsive.fontSize(26);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDownload,
          child: Icon(Icons.download_rounded, size: iconSize),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onSave,
          child: Icon(Icons.bookmark_rounded,
              size: iconSize + 2, color: Colors.amber),
        ),
      ],
    );
  }
}
