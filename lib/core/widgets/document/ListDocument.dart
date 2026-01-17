import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'model/list_document_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double containerWidth =
        responsive.isMobile ? responsive.widthPercent(92) : 720;

    return Container(
      width: containerWidth,
      margin: EdgeInsets.symmetric(vertical: responsive.heightPercent(0.5)),
      constraints: BoxConstraints(minHeight: responsive.isMobile ? 120 : 136),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D0D0), width: 1.2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onTap?.call(widget.document),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(responsive.isMobile ? 8 : 10),
            child: Row(
              // Avoid stretching children to an unbounded height when this card is
              // laid out inside scrollables (can trigger BoxConstraints(h=Infinity)).
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DocumentImage(
                  responsive: responsive,
                  widthOverride: responsive.isMobile ? 120 : 150,
                  heightOverride: responsive.isMobile ? 120 : 150,
                  imageUrl: widget.document.thumbnailUrl,
                  fileId: widget.document.fileId, // ✅ Pass fileId
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
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
                        pages: 5,
                        date: widget.document.createdAt,
                        responsive: responsive,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          LikeCommentWidget(
                            likes: widget.document.likesCount,
                            comments: widget.document.commentsCount,
                            responsive: responsive,
                            onLikeTap: () => widget.onLike?.call(widget.document),
                            onCommentTap:
                                () => widget.onComment?.call(widget.document),
                          ),
                          const Spacer(),
                          _ActionIcon(
                            icon: Icons.download_outlined,
                            selected: _downloadSelected,
                            onTap: () {
                              setState(
                                () => _downloadSelected = !_downloadSelected,
                              );
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================
/// IMAGE
/// =======================
class DocumentImage extends StatefulWidget {
  final ResponsiveHelper responsive;
  final double? widthOverride;
  final double? heightOverride;
  final String? imageUrl;
  final String? fileId;

  const DocumentImage({
    super.key,
    required this.responsive,
    this.widthOverride,
    this.heightOverride,
    this.imageUrl,
    this.fileId,
  });

  @override
  State<DocumentImage> createState() => _DocumentImageState();
}

class _DocumentImageState extends State<DocumentImage> {
  String? _fetchedUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Rely on the passed imageUrl or fallback logic handled by CachedNetworkImage/Image.asset
    // If we need to fetch Asset info, it should be done at Data Layer, not here to avoid performance issues.

    final double width =
        widget.widthOverride ??
        (widget.responsive.isMobile ? widget.responsive.widthPercent(35) : 200);

    final double height =
        widget.heightOverride ??
        (widget.responsive.isMobile ? widget.responsive.widthPercent(35) : 200);

    final displayUrl = widget.imageUrl;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.navy, width: 1.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child:
                displayUrl != null && displayUrl.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: displayUrl,
                      fit: BoxFit.fill,
                      placeholder:
                          (context, url) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.navy.withOpacity(0.5),
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Image.asset(
                            "assets/icons/temp_image.jpg",
                            fit: BoxFit.fill,
                          ),
                    )
                    : Image.asset(
                      "assets/icons/temp_image.jpg",
                      fit: BoxFit.fill,
                    ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Hover effect applies to both selected and unselected states
    final bool isSelected = widget.selected;
    final bool showHover = _hovered;

    Color borderColor;
    Color iconColor;
    Color? backgroundColor;

    if (isSelected) {
      // Selected state
      borderColor = showHover ? Colors.amber.shade800 : Colors.amber.shade700;
      iconColor = showHover ? Colors.amber.shade900 : Colors.amber.shade800;
      backgroundColor =
          showHover
              ? Colors.amber.withOpacity(0.15)
              : Colors.amber.withOpacity(0.1);
    } else {
      // Unselected state
      borderColor = showHover ? Colors.grey.shade500 : const Color(0xFFD0D0D0);
      iconColor = showHover ? Colors.grey.shade800 : Colors.grey.shade600;
      backgroundColor =
          showHover ? Colors.grey.withOpacity(0.08) : Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Icon(widget.icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}

/// =======================
/// TEXT COMPONENTS
/// =======================
class TitleWidget extends StatelessWidget {
  final String title;
  final ResponsiveHelper responsive;

  const TitleWidget({super.key, required this.title, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final String displayTitle =
        title.length > 50 ? '${title.substring(0, 50)}...' : title;

    return Text(
      displayTitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: responsive.fontSize(13),
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: Colors.black87,
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
    final display = (subject ?? '').trim();
    return Row(
      children: [
        Icon(
          Icons.folder_outlined,
          size: responsive.fontSize(11.5),
          color: Colors.blue.shade600,
        ),
        SizedBox(width: responsive.widthPercent(0.5)),
        Expanded(
          child: Text(
            display.isEmpty ? 'Chưa phân loại' : display,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.fontSize(11),
              color: Colors.black87,
            ),
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
    final display = (school ?? '').trim();
    return Row(
      children: [
        Image.asset(
          "assets/icons/school.png",
          width: responsive.fontSize(11.5),
          height: responsive.fontSize(11.5),
        ),
        SizedBox(width: responsive.widthPercent(0.5)),
        Expanded(
          child: Text(
            display.isEmpty ? 'Chưa có trường' : display,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.fontSize(11),
              color: Colors.black87,
            ),
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

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: responsive.widthPercent(1.2),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Icons.description_outlined,
          size: responsive.fontSize(11.5),
          color: Colors.grey.shade600,
        ),
        Text(
          "$pages trang",
          style: TextStyle(
            fontSize: responsive.fontSize(11),
            color: Colors.black87,
          ),
        ),
        Icon(
          Icons.calendar_today_outlined,
          size: responsive.fontSize(11.5),
          color: Colors.grey.shade600,
        ),
        Text(
          _formatDate(date),
          style: TextStyle(
            fontSize: responsive.fontSize(11),
            color: Colors.black87,
          ),
        ),
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
    final iconSize = responsive.fontSize(15); // Tăng +2 từ 13 lên 15

    return Row(
      children: [
        // ===== LIKE =====
        GestureDetector(
          onTap: onLikeTap,
          child: Row(
            children: [
              Icon(
                Icons.thumb_up_outlined,
                size: iconSize,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: responsive.widthPercent(0.5)),
              Text(
                "$likes",
                style: TextStyle(
                  fontSize: responsive.fontSize(11),
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: responsive.widthPercent(2)),

        // ===== COMMENT =====
        GestureDetector(
          onTap: onCommentTap,
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: iconSize,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: responsive.widthPercent(0.5)),
              Text(
                "$comments",
                style: TextStyle(
                  fontSize: responsive.fontSize(11),
                  color: Colors.black87,
                ),
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
  final bool showSave;

  const DownloadSaveGroup({
    super.key,
    required this.responsive,
    this.onDownload,
    this.onSave,
    this.showSave = true,
  });

  @override
  Widget build(BuildContext context) {
    // Enlarged icon size as requested (was 26)
    final iconSize = responsive.fontSize(32);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDownload,
          child: Icon(Icons.download_rounded, size: iconSize),
        ),
        const SizedBox(width: 6),
        // Save button visibility toggled by showSave
        if (showSave)
          GestureDetector(
            onTap: onSave,
            child: Icon(
              Icons.bookmark_rounded,
              size: iconSize + 2,
              color: Colors.amber,
            ),
          ),
      ],
    );
  }
}
