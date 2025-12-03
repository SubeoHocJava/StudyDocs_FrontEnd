import 'package:flutter/material.dart';
import '../../domain/entity/document_entity.dart';
import '../../../../core/constants/app_icons.dart';

// Widget hiển thị danh sách bình luận kèm phân trang.
class CommentsSection extends StatelessWidget {
  final List<CommentEntity> comments;     // Danh sách bình luận đầy đủ
  final int currentPage;                  // Trang hiện tại
  final int commentsPerPage;              // Số bình luận mỗi trang
  final Function(int) onPageChange;       // Callback đổi trang

  const CommentsSection({
    super.key,
    this.comments = const [],
    this.currentPage = 0,
    this.commentsPerPage = 5,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      // Nếu không có comment → hiển thị text thông báo
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text("Chưa có bình luận nào", style: TextStyle(color: Colors.grey)),
      );
    }

    // Tính tổng số trang
    final totalPages = (comments.length / commentsPerPage).ceil();

    // Xác định index bắt đầu & kết thúc trong list
    final start = currentPage * commentsPerPage;
    final end = (start + commentsPerPage).clamp(0, comments.length);

    // Lấy danh sách comment cho trang hiện tại
    final pageComments = comments.sublist(start, end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Bình luận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),

        // Hiển thị từng comment
        ...pageComments.map(
              (c) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(AppAssets.avt), // Ảnh avatar mặc định
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên tác giả
                      Text(c.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),

                      // Nội dung bình luận
                      Text(c.text, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Phân trang
        if (totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                // Trang trước — disable nếu đang ở trang đầu
                onPressed: currentPage > 0
                    ? () => onPageChange(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                "${currentPage + 1} / $totalPages",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                // Trang sau — disable nếu đang trang cuối
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChange(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
      ],
    );
  }
}
