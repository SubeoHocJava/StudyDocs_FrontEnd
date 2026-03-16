import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';

abstract class FolderListEvent extends Equatable {
  const FolderListEvent();

  @override
  List<Object?> get props => [];
}

class FolderListInitialized extends FolderListEvent {
  final List<FolderItem> items;
  final String? selectedId;

  const FolderListInitialized({
    required this.items,
    this.selectedId,
  });

  @override
  List<Object?> get props => [items, selectedId];
}

class FolderItemSelected extends FolderListEvent {
  final String id;

  const FolderItemSelected(this.id);

  @override
  List<Object?> get props => [id];
}

