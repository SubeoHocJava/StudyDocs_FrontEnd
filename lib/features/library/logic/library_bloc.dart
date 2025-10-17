import "package:file_picker/file_picker.dart";
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
            emit(LibraryLoaded(documents,categories,null));
          } catch (e) {
            emit(LibraryError(e.toString()));
          }
        });
    //   Xử lý sự kiện SearchDocument
    on<SearchDocument>((event,emit)async{
    emit(LibraryLoading());
    try {
      final documents = await repository.searchDocument(event.keyword);
      final categories= await repository.getCategorieDemo();
      emit(LibraryLoaded(documents,categories,null));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
    });
  //   Xử lý sự kiện pick file
  //   on<UpLoadDocument>((event,emit)async{
  //     emit(LibraryLoading());
  //     try {
  //       final documents = await repository.searchDocument(event.keyword);
  //       final categories= await repository.getCategorieDemo();
  //       emit(LibraryLoaded(documents,categories));
  //     } catch (e) {
  //       emit(LibraryError(e.toString()));
  //     }
  //   });

  //     Xử lý sự kiện pick file
    on<PickDocument>((event,emit)async{

      emit(LibraryLoading());
      try {
        final documents = await repository.getDocdemo();
        final categories= await repository.getCategorieDemo();
        final result = await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null && result.files.isNotEmpty) {
          final pickedFile = result.files.single;
          // emit state kèm file đã chọn
          emit(LibraryLoaded(documents, categories, pickedFile));}
        else{emit(LibraryLoaded(documents,categories,null));}
      } catch (e) {
        emit(LibraryError(e.toString()));
      }
    });
  }

}
