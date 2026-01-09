import 'package:flutter/material.dart';
import '../../domain/entity/document_entity.dart';
import '../screen/docs_detail_screen.dart';

class PdfPreviewThumbnail extends StatelessWidget {
  final DocumentEntity doc;
  final bool isFullSize;
  final double? height;

  const PdfPreviewThumbnail({
    super.key,
    required this.doc,
    this.isFullSize = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double effectiveHeight = height ?? (isFullSize ? size.height * 0.65 : 240.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DocsDetailScreen(),

          ),
        );
      },
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
              "Nhấn để xem PDF",
              style: TextStyle(fontSize: isFullSize ? 22 : 17, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "${doc.pages} trang • ${doc.fileSize}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}