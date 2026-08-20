import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class DocumentUploadState extends Equatable {
  final PlatformFile? selectedFile;
  final String? selectedFileName;
  final String? selectedSchoolName;
  final int? universityId;
  final String? selectedFacultyName;
  final int? facultyId;
  final String? selectedDepartmentName;
  final int? departmentId;
  final String? selectedSubjectName;
  final int? subjectId;
  final String? documentName;
  final String? schoolYear;
  final String? description;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  
  final List<dynamic> universities;
  final bool isLoadingUniversities;
  final List<dynamic> faculties;
  final bool isLoadingFaculties;
  final List<dynamic> departments;
  final bool isLoadingDepartments;
  final List<dynamic> subjects;
  final bool isLoadingSubjects;

  const DocumentUploadState({
    this.selectedFile,
    this.selectedFileName, 
    this.selectedSchoolName,
    this.universityId,
    this.selectedFacultyName,
    this.facultyId,
    this.selectedDepartmentName,
    this.departmentId,
    this.selectedSubjectName,
    this.subjectId,
    this.documentName,
    this.schoolYear,
    this.description,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.universities = const [],
    this.isLoadingUniversities = false,
    this.faculties = const [],
    this.isLoadingFaculties = false,
    this.departments = const [],
    this.isLoadingDepartments = false,
    this.subjects = const [],
    this.isLoadingSubjects = false,
  });

  DocumentUploadState copyWith({
    PlatformFile? selectedFile,
    String? selectedFileName,
    String? selectedSchoolName,
    int? universityId,
    String? selectedFacultyName,
    int? facultyId,
    String? selectedDepartmentName,
    int? departmentId,
    String? selectedSubjectName,
    int? subjectId,
    String? documentName,
    String? schoolYear,
    String? description,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    List<dynamic>? universities,
    bool? isLoadingUniversities,
    List<dynamic>? faculties,
    bool? isLoadingFaculties,
    List<dynamic>? departments,
    bool? isLoadingDepartments,
    List<dynamic>? subjects,
    bool? isLoadingSubjects,
  }) {
    return DocumentUploadState(
      selectedFile: selectedFile ?? this.selectedFile,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      selectedSchoolName: selectedSchoolName ?? this.selectedSchoolName,
      universityId: universityId ?? this.universityId,
      selectedFacultyName: selectedFacultyName ?? this.selectedFacultyName,
      facultyId: facultyId ?? this.facultyId,
      selectedDepartmentName: selectedDepartmentName ?? this.selectedDepartmentName,
      departmentId: departmentId ?? this.departmentId,
      selectedSubjectName: selectedSubjectName ?? this.selectedSubjectName,
      subjectId: subjectId ?? this.subjectId,
      documentName: documentName ?? this.documentName,
      schoolYear: schoolYear ?? this.schoolYear,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      universities: universities ?? this.universities,
      isLoadingUniversities: isLoadingUniversities ?? this.isLoadingUniversities,
      faculties: faculties ?? this.faculties,
      isLoadingFaculties: isLoadingFaculties ?? this.isLoadingFaculties,
      departments: departments ?? this.departments,
      isLoadingDepartments: isLoadingDepartments ?? this.isLoadingDepartments,
      subjects: subjects ?? this.subjects,
      isLoadingSubjects: isLoadingSubjects ?? this.isLoadingSubjects,
    );
  }

  // Nullable copyWith helper for clearing fields
  DocumentUploadState copyWithClearFile() {
    return DocumentUploadState(
      selectedFile: null,
      selectedFileName: null,
      selectedSchoolName: selectedSchoolName,
      universityId: universityId,
      selectedFacultyName: selectedFacultyName,
      facultyId: facultyId,
      selectedDepartmentName: selectedDepartmentName,
      departmentId: departmentId,
      selectedSubjectName: selectedSubjectName,
      subjectId: subjectId,
      documentName: documentName,
      schoolYear: schoolYear,
      description: description,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      universities: universities,
      isLoadingUniversities: isLoadingUniversities,
      faculties: faculties,
      isLoadingFaculties: isLoadingFaculties,
      departments: departments,
      isLoadingDepartments: isLoadingDepartments,
      subjects: subjects,
      isLoadingSubjects: isLoadingSubjects,
    );
  }

  @override
  List<Object?> get props => [
        selectedFile,
        selectedFileName,
        selectedSchoolName,
        universityId,
        selectedFacultyName,
        facultyId,
        selectedDepartmentName,
        departmentId,
        selectedSubjectName,
        subjectId,
        documentName,
        schoolYear,
        description,
        isSubmitting,
        isSuccess,
        errorMessage,
        universities,
        isLoadingUniversities,
        faculties,
        isLoadingFaculties,
        departments,
        isLoadingDepartments,
        subjects,
        isLoadingSubjects,
      ];

  DocumentUploadState clearAfterUniversity() {
    return DocumentUploadState(
      selectedFile: selectedFile,
      selectedFileName: selectedFileName,
      documentName: documentName,
      schoolYear: schoolYear,
      description: description,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      universities: universities,
      isLoadingUniversities: isLoadingUniversities,
      selectedSchoolName: selectedSchoolName,
      universityId: universityId,
      // Cleared fields below
      faculties: const [],
      isLoadingFaculties: false,
      selectedFacultyName: null,
      facultyId: null,
      departments: const [],
      isLoadingDepartments: false,
      selectedDepartmentName: null,
      departmentId: null,
      subjects: const [],
      isLoadingSubjects: false,
      selectedSubjectName: null,
      subjectId: null,
    );
  }

  DocumentUploadState clearAfterFaculty() {
    return DocumentUploadState(
      selectedFile: selectedFile,
      selectedFileName: selectedFileName,
      documentName: documentName,
      schoolYear: schoolYear,
      description: description,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      universities: universities,
      isLoadingUniversities: isLoadingUniversities,
      selectedSchoolName: selectedSchoolName,
      universityId: universityId,
      faculties: faculties,
      isLoadingFaculties: isLoadingFaculties,
      selectedFacultyName: selectedFacultyName,
      facultyId: facultyId,
      // Cleared fields below
      departments: const [],
      isLoadingDepartments: false,
      selectedDepartmentName: null,
      departmentId: null,
      subjects: const [],
      isLoadingSubjects: false,
      selectedSubjectName: null,
      subjectId: null,
    );
  }

  DocumentUploadState clearAfterDepartment() {
    return DocumentUploadState(
      selectedFile: selectedFile,
      selectedFileName: selectedFileName,
      documentName: documentName,
      schoolYear: schoolYear,
      description: description,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      universities: universities,
      isLoadingUniversities: isLoadingUniversities,
      selectedSchoolName: selectedSchoolName,
      universityId: universityId,
      faculties: faculties,
      isLoadingFaculties: isLoadingFaculties,
      selectedFacultyName: selectedFacultyName,
      facultyId: facultyId,
      departments: departments,
      isLoadingDepartments: isLoadingDepartments,
      selectedDepartmentName: selectedDepartmentName,
      departmentId: departmentId,
      // Cleared fields below
      subjects: const [],
      isLoadingSubjects: false,
      selectedSubjectName: null,
      subjectId: null,
    );
  }
}
