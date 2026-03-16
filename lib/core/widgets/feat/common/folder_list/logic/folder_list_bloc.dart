import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/logic/folder_list_event.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/logic/folder_list_state.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc({
    required FolderListState initialState,
  }) : super(initialState) {
    on<FolderListInitialized>((event, emit) {
      emit(
        state.copyWith(
          items: event.items,
          selectedId: event.selectedId ?? (event.items.isNotEmpty ? event.items.first.id : null),
        ),
      );
    });
    on<FolderItemSelected>((event, emit) {
      emit(state.copyWith(selectedId: event.id));
    });
  }
}

