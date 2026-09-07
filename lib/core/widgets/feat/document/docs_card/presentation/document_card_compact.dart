import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/core/utils/image_utils.dart';

class DocumentCardCompact extends StatelessWidget {
  final DocumentCompactModel doc;
  final double width;
  final double thumbHeight;
  final double borderRadius;
  final double borderWidth;
  final double borderOpacity;
  final VoidCallback? onTap;

  const DocumentCardCompact({
    super.key,
    required this.doc,
    required this.width,
    required this.thumbHeight,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.borderOpacity = 0.65,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => context.push('/document/${doc.id}'),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildThumbnail(),
            const SizedBox(height: 6),
            Text(
              doc.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final thumb = ImageUtils.getPagePreview(doc.thumbnail, 1);
    return Container(
      width: width,
      height: thumbHeight,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.docTitleBorder.withValues(alpha: borderOpacity),
          width: borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildThumbnailImage(thumb),
    );
  }

  Widget _buildThumbnailImage(String? thumb) {
    if (thumb == null || thumb.isEmpty) {
      return const Icon(Icons.picture_as_pdf, size: 36, color: Colors.grey);
    }
    if (thumb.startsWith('assets/')) {
      return Image.asset(
        thumb,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.picture_as_pdf, size: 36, color: Colors.grey),
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
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.picture_as_pdf, size: 36, color: Colors.grey),
    );
  }
}
