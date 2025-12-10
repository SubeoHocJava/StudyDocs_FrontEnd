import 'package:flutter/material.dart';

class PdfPreviewThumbnail extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isFullSize;
  final double? height;
  final int? pages;         // ← MỚI
  final String? fileSize;   // ← MỚI

  const PdfPreviewThumbnail({
    super.key,
    this.onTap,
    this.isFullSize = false,
    this.height,
    this.pages,
    this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double effectiveHeight = height ?? (isFullSize ? size.height * 0.65 : 240.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: effectiveHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: isFullSize ? 100 : 60, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              isFullSize ? "Xem trước PDF" : "Nhấn để xem trước PDF",
              style: TextStyle(fontSize: isFullSize ? 22 : 17, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "${pages ?? 80} trang • ${fileSize ?? "2.4 MB"}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}