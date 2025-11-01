import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:studydocs/features/upload_file/data/upload_file_repository.dart";
import "package:studydocs/features/upload_file/logic/upload_file_event.dart";


import "../../library/data/model/File.dart";
import "upload_file_state.dart";

/// UploadFileBloc quản lý logic load/update dữ liệu
class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileRepository repository;

  UploadFileBloc(this.repository) : super(UploadFileInitial()) {
    // Xử lý sự kiện LoadDocument theo keyword
    on<UploadFileLoadDocumentByKeyWord>((event, emit) async {
      emit(UploadFileLoading());
      try {
      MyFile file= new MyFile(fileName: "fileName", filePath: "filePath");
      String subject= "subject";
List<MyFile>files=[file];
        emit(UploadFileLoaded(
            files,subject
        ));
      } catch (e) {
        emit(UploadFileError(e.toString()));
      }
    });
  }
}
