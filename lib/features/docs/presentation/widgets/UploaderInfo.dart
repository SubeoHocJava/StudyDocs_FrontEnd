import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';

class UploaderInfo extends StatelessWidget {
  final Map<String, dynamic> doc;

  const UploaderInfo({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(AppAssets.avt),
      ),
      title: Text(
        doc["uploader"],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Row(
        children: [
          Image.asset(AppAssets.school, width: 16, height: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              doc["school"],
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
