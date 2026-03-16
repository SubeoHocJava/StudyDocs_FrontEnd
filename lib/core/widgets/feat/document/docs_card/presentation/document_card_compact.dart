import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';

/// Card compact: thumbnail ở trên + title ở dưới.
/// Page có thể truyền kích thước thumbnail (vuông hoặc chữ nhật).
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
      onTap: onTap,
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final thumb = doc.thumbnail;
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
      child: (thumb != null && thumb.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: thumb.startsWith('assets/')
                  ? Image.asset(thumb, fit: BoxFit.cover)
                  : Image.network(thumb, fit: BoxFit.cover),
            )
          : const Icon(Icons.picture_as_pdf, size: 36, color: Colors.grey),
    );
  }
}

