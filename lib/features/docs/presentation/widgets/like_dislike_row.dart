import 'package:flutter/material.dart';
import '../../domain/entity/document_entity.dart';
import '../../../../core/constants/app_icons.dart';

class LikeDislikeRow extends StatelessWidget {
  final DocumentEntity doc;

  const LikeDislikeRow({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 380;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(doc.likes, false, isSmallScreen),
            const SizedBox(width: 16),
            _buildButton(doc.dislikes, true, isSmallScreen),
          ],
        );
      },
    );
  }

  Widget _buildButton(int count, bool isDislike, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 36,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
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
          Text("$count", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}