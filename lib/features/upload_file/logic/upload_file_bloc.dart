import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:studydocs/features/upload_file/data/upload_file_repository.dart";
import "package:studydocs/features/upload_file/logic/upload_file_event.dart";
import "upload_file_state.dart";

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileRepository repository;

  /// Lưu lại state Loaded gần nhất để revert khi cancel
  UploadFileLoaded? lastLoadedState;

  UploadFileBloc(this.repository) : super(UploadFileInitial()) {
    // ============================
    // Load Document By Keyword
    // ============================
    on<UploadFileLoadDocumentByKeyWord>((event, emit) async {
      emit(UploadFileLoading());
      try {
        // Tạm thời mock lại dữ liệu
        String subject = "subject";
        String school = "school";
        List<PlatformFile> files = [];

        final loaded = UploadFileLoaded(files, subject, school);
        lastLoadedState = loaded;

        emit(loaded);
      } catch (e) {
        emit(UploadFileError(e.toString()));
      }
    });

    // ============================
    // Pick Document
    // ============================
    on<PickDocument>((event, emit) async {
      try {
        emit(UploadFileLoading());

        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );

        // --- CANCEL => revert state ---
        if (result == null || result.files.isEmpty) {

          if (state is UploadFileLoaded) {
            emit(state);                        // revert về current state
          } else if (lastLoadedState != null) {
            emit(lastLoadedState!);             // revert về last state từ keyword
          } else {
            emit(UploadFileInitial());          // fallback
          }

          return;
        }

        // --- ADD NEW FILES ---
        List<PlatformFile> currentFiles = [];

        if (state is UploadFileLoaded) {
          currentFiles = List.from((state as UploadFileLoaded).file);
        } else if (lastLoadedState != null) {
          currentFiles = List.from(lastLoadedState!.file);
        }

        currentFiles.addAll(result.files);

        // Subject + school lấy từ current state hoặc gán mặc định
        final subject = (state is UploadFileLoaded)
            ? (state as UploadFileLoaded).subject
            : lastLoadedState?.subject ?? "subject";

        final school = (state is UploadFileLoaded)
            ? (state as UploadFileLoaded).school
            : lastLoadedState?.school ?? "school";

        final newState = UploadFileLoaded(currentFiles, subject, school);
        lastLoadedState = newState;

        emit(newState);

      } catch (e) {
        emit(UploadFileError(e.toString()));
      }
    });

    // ============================
    // Remove Picked File
    // ============================
    on<RemovePickDocument>((event, emit) {
      if (state is UploadFileLoaded) {
        final current = state as UploadFileLoaded;

        final updatedFiles = List<PlatformFile>.from(current.file);

        if (event.index >= 0 && event.index < updatedFiles.length) {
          updatedFiles.removeAt(event.index);
        }

        final newState = UploadFileLoaded(
          updatedFiles,
          current.subject,
          current.school,
        );

        lastLoadedState = newState;
        emit(newState);
      }
    });

    // ============================
    // Edit School Label
    // ============================
    on<EditSchoolLabel>((event, emit) {
      if (state is UploadFileLoaded) {
        final current = state as UploadFileLoaded;

        final newState = UploadFileLoaded(
          current.file,
          current.subject,
          event.school,
        );

        lastLoadedState = newState;
        emit(newState);
      }
    });

    // ============================
    // Edit Subject Label
    // ============================
    on<EditSubjectLabel>((event, emit) {
      if (state is UploadFileLoaded) {
        final current = state as UploadFileLoaded;

        final newState = UploadFileLoaded(
          current.file,
          event.subject,
          current.school,
        );

        lastLoadedState = newState;
        emit(newState);
      }
    });
    on<SendFormUpload>((event,emit){
      if (state is UploadFileLoaded) {
        final current = state as UploadFileLoaded;
        repository.upload(current.file,current.school,current.subject,event.fileName,event.year,event.description);
      }
    });
  }
}
