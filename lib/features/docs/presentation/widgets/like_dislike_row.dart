import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_event.dart';
import '../../domain/entity/document_entity.dart';
import '../../../../core/constants/app_icons.dart';

class LikeDislikeRow extends StatelessWidget {
  final DocumentEntity doc;

  const LikeDislikeRow({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    // Determine active state
    final bool isLiked = doc.currentUserReaction == 'LIKE';
    final bool isDisliked = doc.currentUserReaction == 'DISLIKE';

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildButton(context, doc.likes, true, isLiked)),
            const SizedBox(width: 16),
            Expanded(child: _buildButton(context, doc.dislikes, false, isDisliked)),
          ],
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, int count, bool isLikeButton, bool isActive) {
    // Colors based on active state
    final Color activeColor = isLikeButton ? Colors.green : Colors.redAccent;
    final Color iconColor = isActive ? Colors.white : (isLikeButton ? Colors.green : Colors.redAccent);
    final Color textColor = isActive ? Colors.white : Colors.black87;
    final Color backgroundColor = isActive ? activeColor : Colors.white;
    final Border border = isActive ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade300);

    return GestureDetector(
      onTap: () {
        context.read<DocsBloc>().add(ToggleDocumentLike(isLike: isLikeButton));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Smooth transition
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (isActive)
              BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
            else
              const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLikeButton)
              Transform.scale(
                scaleY: -1,
                child: Image.asset(AppAssets.like, width: 20, height: 20, color: iconColor),
              )
            else
              Image.asset(AppAssets.like, width: 20, height: 20, color: iconColor),
            const SizedBox(width: 8),
            Text(
              "$count",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}