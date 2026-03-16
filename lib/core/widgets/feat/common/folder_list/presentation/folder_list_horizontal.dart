import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/presentation/folder_list_item.dart';

class FolderListHorizontal extends StatelessWidget {
  final List<FolderItem> items;
  final String? selectedId;
  final EdgeInsets padding;
  final double separatorWidth;
  final void Function(String id)? onTap;

  const FolderListHorizontal({
    super.key,
    required this.items,
    required this.selectedId,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.separatorWidth = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 320,
            child: FolderListItem(
              item: item,
              selected: selectedId == item.id,
              onTap: onTap != null ? () => onTap!(item.id) : null,
            ),
          );
        },
      ),
    );
  }
}

