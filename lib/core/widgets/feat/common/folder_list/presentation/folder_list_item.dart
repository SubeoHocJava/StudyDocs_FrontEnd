import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';

class FolderListItem extends StatelessWidget {
  final FolderItem item;
  final bool selected;
  final VoidCallback? onTap;

  const FolderListItem({
    super.key,
    required this.item,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primaryLight : const Color(0xFFEFF1F8);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Image.asset(
              AppAssets.folder,
              width: 22,
              height: 22,
              color: AppColors.backgroundNavy,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

