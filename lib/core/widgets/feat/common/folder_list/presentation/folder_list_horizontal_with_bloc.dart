import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/logic/folder_list_bloc.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/logic/folder_list_event.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/logic/folder_list_state.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/presentation/folder_list_horizontal.dart';

/// Widget gom Bloc cho folder list ngang.
/// Page chỉ cần truyền [items] là hiển thị và có selected state.
class FolderListHorizontalWithBloc extends StatelessWidget {
  final List<FolderItem> items;
  final String? initialSelectedId;
  final void Function(String id)? onSelected;

  const FolderListHorizontalWithBloc({
    super.key,
    required this.items,
    this.initialSelectedId,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FolderListBloc(
        initialState: FolderListState(items: items, selectedId: initialSelectedId),
      )..add(
          FolderListInitialized(items: items, selectedId: initialSelectedId),
        ),
      child: _FolderListHorizontalBody(onSelected: onSelected),
    );
  }
}

class _FolderListHorizontalBody extends StatelessWidget {
  final void Function(String id)? onSelected;

  const _FolderListHorizontalBody({this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderListBloc, FolderListState>(
      builder: (context, state) {
        final bloc = context.read<FolderListBloc>();
        return FolderListHorizontal(
          items: state.items,
          selectedId: state.selectedId,
          onTap: (id) {
            bloc.add(FolderItemSelected(id));
            onSelected?.call(id);
          },
        );
      },
    );
  }
}

