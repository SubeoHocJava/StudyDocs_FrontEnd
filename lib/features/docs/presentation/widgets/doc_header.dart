import 'package:flutter/material.dart';

// Header hiển thị tiêu đề tài liệu và icon mở rộng/thu gọn
class DocHeader extends StatelessWidget {
  final String title;
  final bool isDetail;       // true = đang ở chế độ xem chi tiết
  final VoidCallback? onTapArrow;

  const DocHeader({
    super.key,
    required this.title,
    this.isDetail = true,
    this.onTapArrow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề tài liệu
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        // Icon thu gọn / mở rộng
        IconButton(
          tooltip: isDetail
              ? 'Thu gọn về tài liệu sơ bộ'
              : 'Xem chi tiết',
          icon: Icon(
            isDetail
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down_circle_outlined,
          ),
          onPressed: onTapArrow,
        ),
      ],
    );
  }
}
