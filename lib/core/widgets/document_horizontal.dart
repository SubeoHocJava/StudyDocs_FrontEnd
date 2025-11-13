import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

/// Widget card tài liệu dạng ngang - thumbnail bên trái, thông tin bên phải
class DocumentHorizontal extends StatefulWidget {
  final String title;
  final String? author;
  final String? thumbnailUrl;
  final String? category;
  final String? institution;
  final int? pageCount;
  final String? academicYear;
  final int? viewCount;
  final int? downloadCount;
  final int? likesCount;
  final int? commentsCount;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onDownloadTap;
  final VoidCallback? onBookmarkTap;
  final double width;
  final double height;

  const DocumentHorizontal({
    super.key,
    required this.title,
    this.author,
    this.thumbnailUrl,
    this.category,
    this.institution,
    this.pageCount,
    this.academicYear,
    this.viewCount,
    this.downloadCount,
    this.likesCount,
    this.commentsCount,
    this.rating = 0.0,
    this.onTap,
    this.onDownloadTap,
    this.onBookmarkTap,
    this.width = double.infinity,
    this.height = 160,
  });

  @override
  State<DocumentHorizontal> createState() => _DocumentHorizontalState();
}

class _DocumentHorizontalState extends State<DocumentHorizontal> {
  bool liked = false;
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final isDesktop = context.isDesktop;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail bên trái
            _buildThumbnail(context),

            // Thông tin chi tiết bên phải
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : isTablet ? 17 : 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.profileName,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildMetadata(context),
                      const SizedBox(height: 8),
                      _buildEngagementMetrics(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Thumbnail hình ảnh bên trái
  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Container(
        width: context.isMobile ? 110 : 130,
        height: widget.height,
        color: AppColors.primaryLight,
        child: widget.thumbnailUrl != null
            ? Image.network(
          widget.thumbnailUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderThumbnail(),
        )
            : _buildPlaceholderThumbnail(),
      ),
    );
  }

  // Placeholder cho thumbnail
  Widget _buildPlaceholderThumbnail() {
    return Container(
      width: 120,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.secondaryBlue.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.description, color: AppColors.primary, size: 48),
      ),
    );
  }

  // Metadata với icons (category, institution, pageCount, academicYear)
  Widget _buildMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category với folder icon
        if (widget.category != null) ...[
          _buildMetadataRow(icon: Icons.folder_outlined, text: widget.category!),
          const SizedBox(height: 6),
        ],

        // Institution với building icon
        if (widget.institution != null) ...[
          _buildMetadataRow(
              icon: Icons.business_outlined, text: widget.institution!),
          const SizedBox(height: 6),
        ],

        // Page count với document icon
        if (widget.pageCount != null) ...[
          _buildMetadataRow(
            icon: Icons.description_outlined,
            text: '${widget.pageCount} trang',
          ),
          const SizedBox(height: 6),
        ],

        // Academic year với calendar icon
        if (widget.academicYear != null)
          _buildMetadataRow(
            icon: Icons.calendar_today_outlined,
            text: widget.academicYear!,
          ),
      ],
    );
  }

  // Widget hiển thị một dòng metadata với icon
  Widget _buildMetadataRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
            const TextStyle(fontSize: 13, color: AppColors.docSmallText),
          ),
        ),
      ],
    );
  }

  // Engagement metrics (likes, comments, download, bookmark)
  Widget _buildEngagementMetrics(BuildContext context) {
    return Row(
      children: [
        // Likes với thumbs up icon
        if (widget.likesCount != null)
          _buildMetricIcon(
            icon: Icons.thumb_up_outlined,
            count: widget.likesCount,
            onTap: null,
          ),
        if (widget.likesCount != null) const SizedBox(width: 16),

        // Comments với comment icon
        if (widget.commentsCount != null)
          _buildMetricIcon(
            icon: Icons.comment_outlined,
            count: widget.commentsCount,
            onTap: null,
          ),
        if (widget.commentsCount != null) const SizedBox(width: 16),

        // Download icon
        _buildMetricIcon(
          icon: Icons.download_outlined,
          count: null,
          onTap: widget.onDownloadTap,
        ),
        const SizedBox(width: 16),

        // Bookmark icon
        _buildMetricIcon(
          icon: Icons.bookmark_border,
          count: null,
          onTap: widget.onBookmarkTap,
        ),
      ],
    );
  }

  // Widget hiển thị một icon metric
  Widget _buildMetricIcon({
    required IconData icon,
    int? count,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.black),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget danh sách ngang để hiển thị nhiều tài liệu
class DocumentHorizontalList extends StatelessWidget {
  final List<DocumentHorizontalItem> documents;
  final String? sectionTitle;
  final VoidCallback? onSeeAllTap;
  final double itemHeight;

  const DocumentHorizontalList({
    super.key,
    required this.documents,
    this.sectionTitle,
    this.onSeeAllTap,
    this.itemHeight = 140,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header của section
        if (sectionTitle != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive.responsiveValue(
                mobile: 16.0,
                tablet: 24.0,
                desktop: 32.0,
              ),
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionTitle!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.profileName,
                  ),
                ),
                if (onSeeAllTap != null)
                  TextButton(
                    onPressed: onSeeAllTap,
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Danh sách dọc (vertical list) cho layout ngang của từng item
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive.responsiveValue(
              mobile: 16.0,
              tablet: 24.0,
              desktop: 32.0,
            ),
          ),
          child: Column(
            children: documents.map((doc) {
              return DocumentHorizontal(
                title: doc.title,
                author: doc.author,
                thumbnailUrl: doc.thumbnailUrl,
                category: doc.category,
                institution: doc.institution,
                pageCount: doc.pageCount,
                academicYear: doc.academicYear,
                viewCount: doc.viewCount,
                downloadCount: doc.downloadCount,
                likesCount: doc.likesCount,
                commentsCount: doc.commentsCount,
                rating: doc.rating,
                onTap: doc.onTap,
                onDownloadTap: doc.onDownloadTap,
                onBookmarkTap: doc.onBookmarkTap,
                height: itemHeight,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Model dữ liệu cho các item tài liệu trong danh sách ngang
class DocumentHorizontalItem {
  final String title;
  final String? author;
  final String? thumbnailUrl;
  final String? category;
  final String? institution;
  final int? pageCount;
  final String? academicYear;
  final int? viewCount;
  final int? downloadCount;
  final int? likesCount;
  final int? commentsCount;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onDownloadTap;
  final VoidCallback? onBookmarkTap;

  DocumentHorizontalItem({
    required this.title,
    this.author,
    this.thumbnailUrl,
    this.category,
    this.institution,
    this.pageCount,
    this.academicYear,
    this.viewCount,
    this.downloadCount,
    this.likesCount,
    this.commentsCount,
    this.rating = 0.0,
    this.onTap,
    this.onDownloadTap,
    this.onBookmarkTap,
  });
}
