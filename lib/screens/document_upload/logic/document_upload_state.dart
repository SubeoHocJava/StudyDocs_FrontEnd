import 'package:equatable/equatable.dart';

class DocumentUploadState extends Equatable {
  final String? selectedFileName;
  final String? selectedSchoolName;
  final String? selectedSubjectName;
  final String? documentName;
  final String? schoolYear;
  final String? description;
  final bool isSubmitting;

  const DocumentUploadState({
    this.selectedFileName, 
    this.selectedSchoolName = 'Trường Đại học Nông Lâm Tp. HCM',
    this.selectedSubjectName,
    this.documentName,
    this.schoolYear,
    this.description,
    this.isSubmitting = false,
  });

  DocumentUploadState copyWith({
    String? selectedFileName,
    String? selectedSchoolName,
    String? selectedSubjectName,
    String? documentName,
    String? schoolYear,
    String? description,
    bool? isSubmitting,
  }) {
    return DocumentUploadState(
      selectedFileName: selectedFileName ?? this.selectedFileName,
      selectedSchoolName: selectedSchoolName ?? this.selectedSchoolName,
      selectedSubjectName: selectedSubjectName ?? this.selectedSubjectName,
      documentName: documentName ?? this.documentName,
      schoolYear: schoolYear ?? this.schoolYear,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  // Nullable copyWith helper for clearing fields
  DocumentUploadState copyWithClearFile() {
    return DocumentUploadState(
      selectedFileName: null,
      selectedSchoolName: selectedSchoolName,
      selectedSubjectName: selectedSubjectName,
      documentName: documentName,
      schoolYear: schoolYear,
      description: description,
      isSubmitting: isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        selectedFileName,
        selectedSchoolName,
        selectedSubjectName,
        documentName,
        schoolYear,
        description,
        isSubmitting,
      ];
}
