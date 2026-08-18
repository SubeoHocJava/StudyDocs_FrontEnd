import 'package:flutter_bloc/flutter_bloc.dart';
import 'document_upload_event.dart';
import 'document_upload_state.dart';

class DocumentUploadBloc extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  DocumentUploadBloc() : super(const DocumentUploadState()) {
    on<FileSelected>(_onFileSelected);
    on<FileRemoved>(_onFileRemoved);
    on<SchoolSelected>(_onSchoolSelected);
    on<SubjectSelected>(_onSubjectSelected);
    on<DocumentNameChanged>(_onDocumentNameChanged);
    on<SchoolYearChanged>(_onSchoolYearChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<UploadSubmitted>(_onUploadSubmitted);
  }

  void _onDocumentNameChanged(DocumentNameChanged event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(documentName: event.documentName));
  }

  void _onSchoolYearChanged(SchoolYearChanged event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(schoolYear: event.schoolYear));
  }

  void _onDescriptionChanged(DescriptionChanged event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onFileSelected(FileSelected event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(selectedFileName: event.fileName));
  }

  void _onFileRemoved(FileRemoved event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWithClearFile());
  }

  void _onSchoolSelected(SchoolSelected event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(selectedSchoolName: event.schoolName));
  }

  void _onSubjectSelected(SubjectSelected event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(selectedSubjectName: event.subjectName));
  }

  void _onUploadSubmitted(UploadSubmitted event, Emitter<DocumentUploadState> emit) async {
    if (state.selectedFileName == null) return;
    
    emit(state.copyWith(isSubmitting: true));
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isSubmitting: false));
    // Here we can trigger a success state or navigation event if needed
  }
}
