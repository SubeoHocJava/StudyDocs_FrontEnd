import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';

class CommentsSection extends StatelessWidget {
  final List<dynamic> comments;
  final int currentPage;
  final int commentsPerPage;
  final Function(int) onPageChange;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.currentPage,
    required this.commentsPerPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (comments.length / commentsPerPage).ceil();
    final startIndex = currentPage * commentsPerPage;
    final endIndex = (startIndex + commentsPerPage) > comments.length
        ? comments.length
        : startIndex + commentsPerPage;
    final paginatedComments = comments.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bình luận",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...List.generate(paginatedComments.length, (i) {
          final c = paginatedComments[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(AppAssets.avt),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c["author"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(c["text"]),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        if (comments.length > commentsPerPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 ? () => onPageChange(currentPage - 1) : null,
                child: const Text("Trước"),
              ),
              Text("Trang ${currentPage + 1}/$totalPages"),
              ElevatedButton(
                onPressed: currentPage < totalPages - 1 ? () => onPageChange(currentPage + 1) : null,
                child: const Text("Sau"),
              ),
            ],
          ),
      ],
    );
  }
}
