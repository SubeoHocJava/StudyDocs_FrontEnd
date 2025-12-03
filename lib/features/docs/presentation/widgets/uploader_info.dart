import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entity/document_entity.dart';

// Thông tin người tải tài liệu: avatar + tên + trường
class UploaderInfo extends StatelessWidget {
  final DocumentEntity doc;

  const UploaderInfo({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Gọn hơn, tránh dư khoảng cách

      leading: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(AppAssets.avt), // Avatar mặc định
      ),

      // Tên uploader
      title: Text(
        doc.uploader,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      // Hiển thị trường đại học
      subtitle: Row(
        children: [
          Image.asset(AppAssets.school, width: 16, height: 16),
          const SizedBox(width: 6),

          Expanded(
            child: Text(
              doc.school,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
