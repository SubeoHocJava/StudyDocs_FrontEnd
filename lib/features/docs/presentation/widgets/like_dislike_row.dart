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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildButton(context, doc.likes, true)),
            const SizedBox(width: 16),
            Expanded(child: _buildButton(context, doc.dislikes, false)),
          ],
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, int count, bool isLike) {
    return GestureDetector(
      onTap: () {
        context.read<DocsBloc>().add(ToggleDocumentLike(isLike: isLike));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLike)
              Transform.scale(
                scaleY: -1,
                child: Image.asset(AppAssets.like, width: 20, height: 20, color: Colors.redAccent),
              )
            else
              Image.asset(AppAssets.like, width: 20, height: 20, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              "$count",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}