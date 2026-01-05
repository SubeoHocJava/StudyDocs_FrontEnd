import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';

import 'app_icon_button.dart';

class DocItemHorizontal extends StatelessWidget {
  final String title;
  final String author;
  final VoidCallback? onTap;

  const DocItemHorizontal({
    super.key,
    required this.title,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.docTitleBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.headerBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Image.asset(AppAssets.folder, width: 26, height: 26, color: AppColors.headerForeground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onTap ?? () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.docTitleBorder,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.docSmallText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              AppIconButton(assetPath: AppAssets.like,     onPressed: null, size: 20),
              // AppIconButton(assetPath: AppAssets.cmt,      onPressed: null, size: 20),
              AppIconButton(assetPath: AppAssets.download, onPressed: null, size: 20),
              AppIconButton(assetPath: AppAssets.saved,    onPressed: null, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
