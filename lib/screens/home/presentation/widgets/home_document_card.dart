import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class HomeDocumentCard extends StatelessWidget {
  final DocumentSummaryModel doc;
  final VoidCallback? onLike;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  const HomeDocumentCard({
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
        margin: EdgeInsets.zero,
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 42,
                child: _Thumbnail(thumbnail: doc.thumbnail),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 58,
                child: _CardInfo(
                  doc: doc,
                  onLike: onLike,
                  onBookmark: onBookmark,
                  onDownload: onDownload,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String? thumbnail;

  const _Thumbnail({required this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.docTitleBorder, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    final image = thumbnail;
    if (image == null || image.isEmpty) {
      return _fallback();
    }
    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return const Center(
      child: Icon(Icons.picture_as_pdf, size: 42, color: AppColors.gray),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final DocumentSummaryModel doc;
  final VoidCallback? onLike;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;

  const _CardInfo({
    required this.doc,
    this.onLike,
    this.onBookmark,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.profileName,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 7),
        _InfoLine(asset: AppAssets.folder, text: doc.category),
        const SizedBox(height: 4),
        _InfoLine(asset: AppAssets.school, text: doc.school),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _MetaItem(
                icon: Icons.article_outlined,
                text: '${doc.pageCount} trang',
              ),
            ),
            Expanded(
              child: _MetaItem(
                icon: Icons.calendar_today_outlined,
                text: doc.year,
              ),
            ),
          ],
        ),
        const Spacer(),
        _ActionRow(
          doc: doc,
          onLike: onLike,
          onBookmark: onBookmark,
          onDownload: onDownload,
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String asset;
  final String text;

  const _InfoLine({
    required this.asset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(asset, width: 14, height: 14, ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.docSmallText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.docSmallText),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.docSmallText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final DocumentSummaryModel doc;
  final VoidCallback? onLike;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;

  const _ActionRow({
    required this.doc,
    this.onLike,
    this.onBookmark,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
        final bookmarkAsset = doc.isBookmarked ? AppAssets.saved : AppAssets.unsaved;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _IconTap(
          onTap: onLike,
          child: Image.asset(
            doc.isLiked ? AppAssets.fullLike : AppAssets.outlineLike,
            width: 20,
            height: 20,
            color: doc.isLiked ? AppColors.primary : AppColors.docSmallText,
          ),
        ),
        const SizedBox(width: 3),
        Text('${doc.likeCount}', style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 12),
        Image.asset(AppAssets.cmt, width: 20, height: 20),
        const SizedBox(width: 3),
        Text('${doc.commentCount}', style: const TextStyle(fontSize: 12)),
        const Spacer(),
        _IconTap(
          onTap: onDownload,
          child: Image.asset(
            AppAssets.download,
            width: 30,
            height: 30,
            ),
        ),
        const SizedBox(width: 12),
        _IconTap(
          onTap: onBookmark,
          child: Image.asset(
            bookmarkAsset,
            width: 30,
            height: 30,
            color: doc.isBookmarked ? AppColors.warning : Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}

class _IconTap extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _IconTap({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: child,
      ),
    );
  }
}
