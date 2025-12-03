import 'package:flutter/material.dart';

// Thumbnail preview PDF (chưa phải render PDF thật ─ icon + text)
class PdfPreviewThumbnail extends StatelessWidget {
  final VoidCallback? onTap; // Event khi nhấn vào
  final bool isFullSize;     // Mode full-screen preview
  final double? height;      // Tùy chọn override chiều cao

  const PdfPreviewThumbnail({
    super.key,
    this.onTap,
    this.isFullSize = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Chiều cao tự động khi không truyền height
    final double effectiveHeight =
        height ?? (isFullSize ? size.height * 0.65 : 240.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: effectiveHeight,
        width: double.infinity,

        // Box preview
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        // Nội dung hiển thị giả lập (không phải PDF thật)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: isFullSize ? 100 : 60,
              color: Colors.red.shade700,
            ),
            const SizedBox(height: 16),

            Text(
              isFullSize ? "Xem trước PDF" : "Nhấn để xem trước PDF",
              style: TextStyle(
                fontSize: isFullSize ? 22 : 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // ⚠️ Text tĩnh (hardcode), sau này cần lấy từ API: số trang + size file
            Text(
              "80 trang • 2.4 MB",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
