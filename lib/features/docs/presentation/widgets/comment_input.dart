import 'package:flutter/material.dart';

// Widget nhập bình luận, hiện đang là Stateless nhưng không có controller.
// -> Không lấy được nội dung người dùng nhập (cần controller nếu muốn gửi comment).
class CommentInput extends StatelessWidget {
  final VoidCallback? onSend; // Callback nhấn nút "Gửi", nhưng KHÔNG nhận nội dung text.

  const CommentInput({super.key, this.onSend});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            // ⚠️ Thiếu controller => không thể lấy text khi nhấn nút Gửi.
            decoration: InputDecoration(
              hintText: "Bạn nghĩ gì về tài liệu này...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onSend, // ⚠️ Chỉ gọi callback, không gửi nội dung comment.
          child: const Text("Gửi"),
        ),
      ],
    );
  }
}
