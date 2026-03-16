import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/presentation/folder_list_item.dart';

class FolderListVertical extends StatelessWidget {
  final List<FolderItem> items;
  final String? selectedId;
  final EdgeInsets padding;
  final double separatorHeight;
  final void Function(String id)? onTap;

  const FolderListVertical({
    super.key,
    required this.items,
    required this.selectedId,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.separatorHeight = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) {
        final item = items[index];
        return FolderListItem(
          item: item,
          selected: selectedId == item.id,
          onTap: onTap != null ? () => onTap!(item.id) : null,
        );
      },
    );
  }
}

