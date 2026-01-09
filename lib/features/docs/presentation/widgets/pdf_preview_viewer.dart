import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PdfPreviewViewer extends StatelessWidget {
  final List<String> previewUrls;
  final int pages;
  final String fileSize;
  final VoidCallback? onTap;

  const PdfPreviewViewer({
    super.key,
    required this.previewUrls,
    required this.pages,
    required this.fileSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: previewUrls.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: previewUrls[0],
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, size: 60, color: Colors.red),
            ),
          )
              : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
                SizedBox(height: 16),
                Text("Không có trang xem trước"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}// TODO Implement this library.