import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/usecase/get_school_list_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/usecase/get_subject_list_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/logic/document_upload_event.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/logic/document_upload_state.dart';

class DocumentUploadBloc
    extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  final GetSchoolListUseCase _getSchoolListUseCase;
  final GetSubjectListUseCase _getSubjectListUseCase;

  DocumentUploadBloc({
    required GetSchoolListUseCase getSchoolListUseCase,
    required GetSubjectListUseCase getSubjectListUseCase,
  })  : _getSchoolListUseCase = getSchoolListUseCase,
        _getSubjectListUseCase = getSubjectListUseCase,
        super(const DocumentUploadState(isLoading: true)) {
    on<UploadInitialized>(_onInitialized);
    on<UploadSchoolChanged>(_onSchoolChanged);
    on<UploadSubjectChanged>(_onSubjectChanged);
    on<UploadFilePicked>(_onFilePicked);
    on<UploadErrorCleared>(_onErrorCleared);
  }

  Future<void> _onInitialized(
    UploadInitialized event,
    Emitter<DocumentUploadState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        fileName: event.initialFileName,
        file: event.initialFile,
      ),
    );
    try {
      final schools = await _getSchoolListUseCase();
      final School? firstSchool = schools.isNotEmpty ? schools.first : null;
      List<Subject> subjects = const [];
      Subject? firstSubject;
      if (firstSchool != null) {
        subjects = await _getSubjectListUseCase(firstSchool.id);
        firstSubject = subjects.isNotEmpty ? subjects.first : null;
      }
      emit(
        state.copyWith(
          schools: schools,
          selectedSchool: firstSchool,
          subjects: subjects,
          selectedSubject: firstSubject,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không tải được danh sách trường/môn',
        ),
      );
    }
  }

  Future<void> _onSchoolChanged(
    UploadSchoolChanged event,
    Emitter<DocumentUploadState> emit,
  ) async {
    final selectedSchool =
        state.schools.firstWhere((s) => s.id == event.schoolId);
    emit(
      state.copyWith(
        selectedSchool: selectedSchool,
        subjects: const [],
        selectedSubject: null,
        isLoading: true,
        errorMessage: null,
      ),
    );
    try {
      final subjects = await _getSubjectListUseCase(event.schoolId);
      final Subject? firstSubject = subjects.isNotEmpty ? subjects.first : null;
      emit(
        state.copyWith(
          subjects: subjects,
          selectedSubject: firstSubject,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không tải được danh sách môn học',
        ),
      );
    }
  }

  void _onSubjectChanged(
    UploadSubjectChanged event,
    Emitter<DocumentUploadState> emit,
  ) {
    final selectedSubject =
        state.subjects.firstWhere((s) => s.id == event.subjectId);
    emit(
      state.copyWith(
        selectedSubject: selectedSubject,
        errorMessage: null,
      ),
    );
  }

  void _onFilePicked(
    UploadFilePicked event,
    Emitter<DocumentUploadState> emit,
  ) {
    emit(
      state.copyWith(
        fileName: event.fileName,
        file: event.file,
        errorMessage: null,
      ),
    );
  }

  void _onErrorCleared(
    UploadErrorCleared event,
    Emitter<DocumentUploadState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}

