import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/core/utils/image_utils.dart';
import 'package:studydocs/core/utils/auth_helper.dart';

class DocumentCardHorizontal extends StatelessWidget {
  final DocumentSummaryModel doc;
  final VoidCallback? onLike;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  const DocumentCardHorizontal({
    super.key,
    required this.doc,
    this.onLike,
    this.onBookmark,
    this.onDownload,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => context.push('/document/${doc.id}'),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildThumbnail(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildRightSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.docTitleBorder, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildThumbnailImage(),
    );
  }

  Widget _buildThumbnailImage() {
    String? processedThumb = ImageUtils.getPagePreview(doc.thumbnail, 1);
    final thumb = processedThumb;
    if (thumb == null || thumb.isEmpty) {
      return _fallbackThumbnail();
    }
    if (thumb.startsWith('assets/')) {
      return Image.asset(
        thumb,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackThumbnail(),
      );
    }
    
    String imageUrl = thumb;
    if (thumb.startsWith('/')) {
      final baseUrl = ApiConstants.baseUrl.replaceAll(RegExp(r'/+$'), '');
      imageUrl = '$baseUrl$thumb';
    } else if (!thumb.startsWith('http')) {
      imageUrl = '${ApiConstants.baseUrl}$thumb';
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackThumbnail(),
    );
  }

  Widget _fallbackThumbnail() {
    return const Icon(Icons.picture_as_pdf, size: 36, color: AppColors.gray);
  }

  Widget _buildRightSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRect(
            child: _buildInfoCluster(),
          ),
        ),
        _buildActionRow(context),
      ],
    );
  }

  Widget _buildInfoCluster() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: AppColors.profileName,
          ),
        ),
        const SizedBox(height: 3),
        _infoRow(AppAssets.folder, doc.category),
        const SizedBox(height: 1),
        _infoRow(AppAssets.school, doc.school),
        const SizedBox(height: 1),
        Row(
          children: [
            _infoRowIcon(Icons.description_outlined, '${doc.pageCount} trang'),
            const SizedBox(width: 8),
            _infoRowIcon(Icons.calendar_today_outlined, doc.year),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(String iconPath, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 12,
          height: 12,
          color: AppColors.docSmallText,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.docSmallText),
          ),
        ),
      ],
    );
  }

  Widget _infoRowIcon(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.docSmallText),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.docSmallText),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final likeColor = doc.isLiked ? AppColors.primary : AppColors.docSmallText;
    final bookmarkAsset = doc.isBookmarked ? AppAssets.saved : AppAssets.unsaved;

    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (AuthHelper.checkLogin(context) && onLike != null) {
              onLike!();
            }
          },
          child: Image.asset(
            doc.isLiked ? AppAssets.fullLike : AppAssets.outlineLike,
            width: 15,
            height: 15,
            color: likeColor,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '${doc.likeCount}',
          style: const TextStyle(fontSize: 11, color: AppColors.docSmallText),
        ),
        const SizedBox(width: 8),
        Image.asset(
          AppAssets.cmt,
          width: 15,
          height: 15,
        ),
        const SizedBox(width: 3),
        Text(
          '${doc.commentCount}',
          style: const TextStyle(fontSize: 11, color: AppColors.docSmallText),
        ),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (AuthHelper.checkLogin(context) && onDownload != null) {
              onDownload!();
            }
          },
          child: Image.asset(
            AppAssets.download,
            width: 22,
            height: 22,
            ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (AuthHelper.checkLogin(context) && onBookmark != null) {
              onBookmark!();
            }
          },
          child: Image.asset(
            bookmarkAsset,
            width: 22,
            height: 22,
            color: doc.isBookmarked ? AppColors.warning : Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
