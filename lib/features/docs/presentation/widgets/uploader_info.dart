import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../../../profile/presentation/screen/profile_screen.dart';
import '../../domain/entity/document_entity.dart';

class UploaderInfo extends StatelessWidget {
  final DocumentEntity doc;

  const UploaderInfo({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 380;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        context.go(
          '${AppRoutes.profile}/${doc.uploader}',
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: isSmall ? 18 : 22,
            backgroundImage: AssetImage(AppAssets.avt),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  doc.uploader,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 14 : 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Image.asset(AppAssets.school, width: 14, height: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doc.school,
                        style: TextStyle(
                          fontSize: isSmall ? 12 : 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
