import 'package:flutter/material.dart';

class PdfPreviewThumbnail extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isFullSize;

  const PdfPreviewThumbnail({super.key, this.onTap, this.isFullSize = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = isFullSize ? size.height * 0.6 : 220.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: isFullSize ? 100 : 60, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              isFullSize ? "Xem trước PDF" : "Nhấn để xem trước PDF",
              style: TextStyle(fontSize: isFullSize ? 20 : 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text("80 trang • 2.4 MB", style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}