import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';

class DocumentUploadState extends Equatable {
  final List<School> schools;
  final School? selectedSchool;
  final List<Subject> subjects;
  final Subject? selectedSubject;
  final String? fileName;
  final bool isLoading;
  final String? errorMessage;

  const DocumentUploadState({
    this.schools = const [],
    this.selectedSchool,
    this.subjects = const [],
    this.selectedSubject,
    this.fileName,
    this.isLoading = false,
    this.errorMessage,
  });

  DocumentUploadState copyWith({
    List<School>? schools,
    School? selectedSchool,
    List<Subject>? subjects,
    Subject? selectedSubject,
    String? fileName,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DocumentUploadState(
      schools: schools ?? this.schools,
      selectedSchool: selectedSchool ?? this.selectedSchool,
      subjects: subjects ?? this.subjects,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        schools,
        selectedSchool,
        subjects,
        selectedSubject,
        fileName,
        isLoading,
        errorMessage,
      ];
}

