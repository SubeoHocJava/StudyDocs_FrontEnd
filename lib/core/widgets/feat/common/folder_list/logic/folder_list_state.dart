import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';

class FolderListState extends Equatable {
  final List<FolderItem> items;
  final String? selectedId;

  const FolderListState({
    required this.items,
    this.selectedId,
  });

  FolderListState copyWith({
    List<FolderItem>? items,
    String? selectedId,
  }) {
    return FolderListState(
      items: items ?? this.items,
      selectedId: selectedId ?? this.selectedId,
    );
  }

  @override
  List<Object?> get props => [items, selectedId];
}

