import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entity/document_entity.dart';

class PdfSinglePagePreview extends StatelessWidget {
  final DocumentEntity doc;
  final bool isFullSize;

  const PdfSinglePagePreview({
    super.key,
    required this.doc,
    required this.isFullSize,
  });

  @override
  Widget build(BuildContext context) {
    final previewUrl = doc.previewUrls.isNotEmpty ? doc.previewUrls[0] : null;

    return Container(
      height: isFullSize ? MediaQuery.of(context).size.height * 0.65 : 240,
      width: double.infinity,
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
        child: previewUrl != null
            ? CachedNetworkImage(
          imageUrl: previewUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
          ),
        )
            : const Center(
          child: Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
        ),
      ),
    );
  }
}