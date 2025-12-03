import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entity/document_entity.dart';

// Hiển thị số lượt thích & không thích
class LikeDislikeRow extends StatelessWidget {
  final DocumentEntity doc;

  const LikeDislikeRow({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Dùng Flexible để tránh bị tràn hàng (overflow)
        Flexible(child: _buildLikeDislikeItem(doc.likes, false)),
        const SizedBox(width: 20),
        Flexible(child: _buildLikeDislikeItem(doc.dislikes, true)),
      ],
    );
  }

  // Tạo widget Like/Dislike
  Widget _buildLikeDislikeItem(int count, bool isDislike) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Co lại đúng size cần thiết
        children: [
          // Nếu là dislike → xoay icon 180 độ
          if (isDislike)
            Transform.scale(
              scaleY: -1, // Lật icon theo chiều dọc
              child: Image.asset(AppAssets.like, width: 18, height: 18),
            )
          else
            Image.asset(AppAssets.like, width: 18, height: 18),

          const SizedBox(width: 6),

          // Hiển thị count
          Text("$count"),
        ],
      ),
    );
  }
}
