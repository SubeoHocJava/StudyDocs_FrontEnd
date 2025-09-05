import "package:flutter_bloc/flutter_bloc.dart";

import "../data/library_repository.dart";
import "LibraryEvent.dart";
import "LibraryState.dart";

/// ProfileBloc quản lý logic load/update dữ liệu
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository repository;

  LibraryBloc(this.repository) : super(LibraryInitial()) {
    // Xử lý sự kiện LoadDocument theo keyword
    on<LoadDocumentByKeyWord>((event, emit) async {
          emit(LibraryLoading());
          try {
            final documents = await repository.getDocdemo();
            final categories= await repository.getCategorieDemo();
            emit(LibraryLoaded(documents,categories));
          } catch (e) {
            emit(LibraryError(e.toString()));
          }
        });
  }
}
