 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import '../../../features/docs/logic/docs_bloc.dart';
import '../../../features/docs/logic/docs_event.dart';
import 'package:studydocs/features/docs/domain/repository/docs_repository.dart';
import 'package:studydocs/features/docs/domain/usecase/get_document_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/toggle_save_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/toggle_like_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/post_comment_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/react_review_usecase.dart';
import '../../../features/docs/presentation/screen/docs_detail_screen.dart';
import 'model/list_document_ui.dart';

/// =======================
/// LIST DOCUMENT
/// =======================
class ListDocument extends StatelessWidget {
  final List<DocumentUiList> documents;

  final void Function(DocumentUiList)? onDownload;
  final void Function(DocumentUiList)? onSave;
  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;
  final void Function(DocumentUiList)? onTap;

  const ListDocument(
    this.documents, {
    super.key,
    this.onDownload,
    this.onSave,
    this.onLike,
    this.onComment,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.heightPercent(1),
            horizontal: responsive.isMobile ? 12 : 16,
          ),
          child: MonoDocumentInList(
            document: documents[index],
            onDownload: onDownload,
            onSave: onSave,
            onLike: onLike,
            onComment: onComment,
            onTap: onTap,
          ),
        );
      },
    );
  }
}

/// =======================
/// CARD DOCUMENT
/// =======================
class MonoDocumentInList extends StatefulWidget {
  final DocumentUiList document;

  final void Function(DocumentUiList)? onDownload;
  final void Function(DocumentUiList)? onSave;
  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;
  final void Function(DocumentUiList)? onTap;
  const MonoDocumentInList({
    super.key,
    required this.document,
    this.onDownload,
    this.onSave,
    this.onLike,
    this.onComment,
    this.onTap,
  });

  @override
  State<MonoDocumentInList> createState() => _MonoDocumentInListState();
}

class _MonoDocumentInListState extends State<MonoDocumentInList> {
  bool _downloadSelected = false;
  bool _saveSelected = false;

  void _openDetail(BuildContext context) {
    final docsRepository = context.read<DocsRepository>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => DocsBloc(
            documentId: widget.document.id!,
            getDocumentUseCase: GetDocumentUseCase(docsRepository),
            toggleSaveUseCase: ToggleSaveUseCase(docsRepository),
            toggleLikeUseCase: ToggleLikeUseCase(docsRepository),
            postCommentUseCase: PostCommentUseCase(docsRepository),
            reactReviewUseCase: ReactReviewUseCase(docsRepository),
          )..add(const LoadDocDetails()),
          child: const DocsDetailScreen(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    double width =
    responsive.isMobile ? responsive.widthPercent(92) : 720;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.document);
        } else {
          _openDetail(context);
        }
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(
          vertical: responsive.heightPercent(0.5),
        ),
        constraints: BoxConstraints(
          minHeight: responsive.isMobile ? 120 : 136,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD0D0D0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 8 : 10),
          child: Row(
            children: [
              DocumentImage(
                responsive: responsive,
                imageUrl: widget.document.thumbnailUrl,
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildInfo(responsive)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleWidget(
          title: widget.document.title,
          responsive: responsive,
        ),
        const SizedBox(height: 2),
        SubjectWidget(
          subject: widget.document.category,
          responsive: responsive,
        ),
        const SizedBox(height: 2),
        SchoolWidget(
          school: widget.document.institution,
          responsive: responsive,
        ),
        const SizedBox(height: 2),
        PageDateWidget(
          pages: widget.document.pageCount,
          date: widget.document.createdAt,
          responsive: responsive,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            LikeCommentWidget(
              likes: widget.document.likesCount,
              isLiked: widget.document.isLiked,
              comments: widget.document.commentsCount,
              responsive: responsive,
              onLikeTap: () => widget.onLike?.call(widget.document),
              onCommentTap: () => widget.onComment?.call(widget.document),
            ),
            const Spacer(),
            _ActionIcon(
              icon: Icons.download_outlined,
              selected: _downloadSelected,
              onTap: () {
                setState(() => _downloadSelected = !_downloadSelected);
                widget.onDownload?.call(widget.document);
              },
            ),
            const SizedBox(width: 6),
            _ActionIcon(
              icon: Icons.bookmark_border,
              selected: _saveSelected,
              onTap: () {
                setState(() => _saveSelected = !_saveSelected);
                widget.onSave?.call(widget.document);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// =======================
/// IMAGE
/// =======================
class DocumentImage extends StatelessWidget {
  final ResponsiveHelper responsive;
  final String? imageUrl;

  const DocumentImage({
    super.key,
    required this.responsive,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double size =
    responsive.isMobile ? responsive.widthPercent(30) : 150;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.navy, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) =>
              Image.asset("assets/icons/temp_image.jpg"),
        )
            : Image.asset("assets/icons/temp_image.jpg"),
      ),
    );
  }
}

/// =======================
/// ACTION ICON
/// =======================
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.amber : const Color(0xFFD0D0D0),
            width: 1.2,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: selected ? Colors.amber.shade800 : Colors.grey.shade700,
        ),
      ),
    );
  }
}

/// =======================
/// TEXT WIDGETS
/// =======================
class TitleWidget extends StatelessWidget {
  final String title;
  final ResponsiveHelper responsive;

  const TitleWidget({super.key, required this.title, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: responsive.fontSize(13),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SubjectWidget extends StatelessWidget {
  final String? subject;
  final ResponsiveHelper responsive;

  const SubjectWidget({super.key, this.subject, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Text(
      subject ?? 'Chưa phân loại',
      style: TextStyle(fontSize: responsive.fontSize(11)),
    );
  }
}

class SchoolWidget extends StatelessWidget {
  final String? school;
  final ResponsiveHelper responsive;

  const SchoolWidget({super.key, this.school, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Text(
      school ?? 'Chưa có trường',
      style: TextStyle(fontSize: responsive.fontSize(11)),
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
    final formatted =
    date != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(date!)) : 'N/A';

    return Text(
      "$pages trang • $formatted",
      style: TextStyle(fontSize: responsive.fontSize(11)),
    );
  }
}

/// =======================
/// LIKE + COMMENT
/// =======================
class LikeCommentWidget extends StatelessWidget {
  final int? likes;
  final int? comments;
  final bool isLiked;
  final ResponsiveHelper responsive;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;

  const LikeCommentWidget({
    super.key,
    required this.likes,
    required this.comments,
    required this.responsive,
    this.isLiked = false,
    this.onLikeTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onLikeTap,
          child: Row(
            children: [
               Icon(
                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16,
                color: isLiked ? Colors.blue : Colors.grey[700], 
              ),
              const SizedBox(width: 4),
              Text(
                "${likes ?? 0}",
                style: TextStyle(
                   color: isLiked ? Colors.blue : Colors.black,
                   fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onCommentTap,
          child: Text("💬 ${comments ?? 0}"),
        ),
      ],
    );
  }
}
