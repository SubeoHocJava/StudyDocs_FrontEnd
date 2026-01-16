import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:studydocs/features/upload_file/logic/upload_file_event.dart";
import "../domain/usecase/upload_file_usecase.dart";
import "upload_file_state.dart";

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileUseCase uploadFileUseCase;

  /// Lưu lại state Loaded gần nhất để revert khi cancel
  UploadFileLoaded? lastLoadedState;

  UploadFileBloc({required this.uploadFileUseCase})
      : super(UploadFileInitial()) {
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
        emit(UploadFileError(e.toString(), [], "subject", "school"));
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
        // Helper to get current values safely
        final currentFiles = (state is UploadFileLoaded)
            ? (state as UploadFileLoaded).file
            : lastLoadedState?.file ?? [];
        final currentSubject = (state is UploadFileLoaded)
            ? (state as UploadFileLoaded).subject
            : lastLoadedState?.subject ?? "subject";
        final currentSchool = (state is UploadFileLoaded)
            ? (state as UploadFileLoaded).school
            : lastLoadedState?.school ?? "school";

        emit(UploadFileError(e.toString(), currentFiles, currentSubject, currentSchool));
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
    on<SendFormUpload>((event, emit) async {
      if (state is UploadFileLoaded) {
        final current = state as UploadFileLoaded;

        emit(UploadFileLoading());

        final success = await uploadFileUseCase(
          filePath: current.file.first.path ?? "",
          school: current.school,
          subject: current.subject,
          fileName: event.fileName ,
          year: event.year ,
          description: event.description ,
        );

        if (success) {
          emit(UploadFileSuccess());
        } else {
          emit(UploadFileError(
            "Upload failed",
            current.file,
            current.subject,
            current.school,
          ));
        }
      }
    });
  }
}
