import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';

class LikeDislikeRow extends StatelessWidget {
  final Map<String, dynamic> doc;

  const LikeDislikeRow({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLikeDislikeItem(doc["likes"], false),
        const SizedBox(width: 20),
        _buildLikeDislikeItem(doc["dislikes"], true),
      ],
    );
  }

  Widget _buildLikeDislikeItem(int count, bool isDislike) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDislike)
            Transform.scale(
              scaleY: -1,
              child: Image.asset(AppAssets.like, width: 18, height: 18),
            )
          else
            Image.asset(AppAssets.like, width: 18, height: 18),
          const SizedBox(width: 6),
          Text("$count"),
        ],
      ),
    );
  }
}
