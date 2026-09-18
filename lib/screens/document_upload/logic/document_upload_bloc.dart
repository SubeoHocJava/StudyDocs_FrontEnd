import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../domain/repository/document_upload_repository.dart';
import '../domain/repository/impl/document_upload_repository_impl.dart';
import '../../../../data/datasource/impl/academic_remote_datasource_impl.dart';
import '../../../../data/datasource/academic_remote_datasource.dart';
import 'document_upload_event.dart';
import 'document_upload_state.dart';

class DocumentUploadBloc extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  final DocumentUploadRepository repository;
  final AcademicRemoteDataSource academicDataSource;

  DocumentUploadBloc({
    DocumentUploadRepository? repository,
    AcademicRemoteDataSource? academicDataSource,
  }) 
      : repository = repository ?? DocumentUploadRepositoryImpl(), 
        academicDataSource = academicDataSource ?? AcademicRemoteDataSourceImpl(),
        super(const DocumentUploadState()) {
    on<LoadUniversities>(_onLoadUniversities);
    on<SchoolSelected>(_onSchoolSelected);
    on<FacultySelected>(_onFacultySelected);
    on<DepartmentSelected>(_onDepartmentSelected);
    on<SubjectSelected>(_onSubjectSelected);
    on<FileSelected>(_onFileSelected);
    on<InitialFileSelected>(_onInitialFileSelected);
    on<FileRemoved>(_onFileRemoved);
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
    emit(state.copyWith(selectedFile: event.file, selectedFileName: event.file.name));
  }
  
  void _onInitialFileSelected(InitialFileSelected event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(selectedFileName: event.fileName));
  }

  void _onFileRemoved(FileRemoved event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWithClearFile());
  }

  void _onSchoolSelected(SchoolSelected event, Emitter<DocumentUploadState> emit) async {
    final clearedState = state.clearAfterUniversity().copyWith(
      universityId: event.universityId,
      selectedSchoolName: event.schoolName,
      isLoadingFaculties: true,
    );
    emit(clearedState);
    
    try {
      final response = await academicDataSource.getFacultiesByUniversity(event.universityId.toString());
      if (response is List) {
        emit(state.copyWith(isLoadingFaculties: false, faculties: response));
      } else if (response is Map && response['data'] is List) {
        emit(state.copyWith(isLoadingFaculties: false, faculties: response['data'] as List));
      } else {
        emit(state.copyWith(isLoadingFaculties: false, faculties: []));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingFaculties: false, faculties: []));
    }
  }

  void _onFacultySelected(FacultySelected event, Emitter<DocumentUploadState> emit) async {
    final clearedState = state.clearAfterFaculty().copyWith(
      facultyId: event.facultyId,
      selectedFacultyName: event.facultyName,
      isLoadingDepartments: true,
    );
    emit(clearedState);
    
    try {
      final response = await academicDataSource.getDepartmentsByFaculty(event.facultyId.toString());
      if (response is List) {
        emit(state.copyWith(isLoadingDepartments: false, departments: response));
      } else if (response is Map && response['data'] is List) {
        emit(state.copyWith(isLoadingDepartments: false, departments: response['data'] as List));
      } else {
        emit(state.copyWith(isLoadingDepartments: false, departments: []));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingDepartments: false, departments: []));
    }
  }

  void _onDepartmentSelected(DepartmentSelected event, Emitter<DocumentUploadState> emit) async {
    final clearedState = state.clearAfterDepartment().copyWith(
      departmentId: event.departmentId,
      selectedDepartmentName: event.departmentName,
      isLoadingSubjects: true,
    );
    emit(clearedState);
    
    try {
      final response = await academicDataSource.getSubjectsByDepartment(event.departmentId.toString());
      if (response is List) {
        emit(state.copyWith(isLoadingSubjects: false, subjects: response));
      } else if (response is Map && response['data'] is List) {
        emit(state.copyWith(isLoadingSubjects: false, subjects: response['data'] as List));
      } else {
        emit(state.copyWith(isLoadingSubjects: false, subjects: []));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingSubjects: false, subjects: []));
    }
  }

  void _onSubjectSelected(SubjectSelected event, Emitter<DocumentUploadState> emit) {
    emit(state.copyWith(subjectId: event.subjectId, selectedSubjectName: event.subjectName));
  }

  void _onLoadUniversities(LoadUniversities event, Emitter<DocumentUploadState> emit) async {
    emit(state.copyWith(isLoadingUniversities: true));
    try {
      final response = await academicDataSource.getUniversities();
      if (response is List) {
        emit(state.copyWith(isLoadingUniversities: false, universities: response));
      } else if (response is Map && response['data'] is List) {
        emit(state.copyWith(isLoadingUniversities: false, universities: response['data'] as List));
      } else {
        emit(state.copyWith(isLoadingUniversities: false, universities: []));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingUniversities: false, universities: []));
    }
  }

  void _onUploadSubmitted(UploadSubmitted event, Emitter<DocumentUploadState> emit) async {
    if (state.selectedFile == null) return;
    
    emit(state.copyWith(isSubmitting: true, isSuccess: false, errorMessage: null));
    try {
      MultipartFile? multipartFile;
      if (state.selectedFile != null) {
        if (state.selectedFile!.bytes != null) {
          multipartFile = MultipartFile.fromBytes(state.selectedFile!.bytes!, filename: state.selectedFile!.name);
        } else if (state.selectedFile!.path != null) {
          multipartFile = await MultipartFile.fromFile(state.selectedFile!.path!, filename: state.selectedFile!.name);
        }
      }

      final formData = FormData.fromMap({
         'title': state.documentName ?? state.selectedFileName,
         'description': state.description ?? '',
         'universityId': state.universityId ?? 1,
         'facultyId': state.facultyId ?? 1,
         'departmentId': state.departmentId ?? 1,
         'subjectId': state.subjectId ?? 1,
         'schoolYear': state.schoolYear ?? '2024 - 2025',
         'year': state.schoolYear ?? '2024 - 2025',
         'school_year': state.schoolYear ?? '2024 - 2025',
         'isPublic': true,
      });
      
      if (multipartFile != null) {
        formData.files.add(MapEntry('file', multipartFile));
      } else {
        // If we couldn't create a MultipartFile (e.g., both bytes and path are null), abort.
        emit(state.copyWith(isSubmitting: false));
        return;
      }

      await repository.uploadDocument(formData);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Có lỗi xảy ra khi tải lên.'));
    }
  }
}
