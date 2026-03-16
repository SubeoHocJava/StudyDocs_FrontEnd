import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';

class DocumentUploadState extends Equatable {
  final List<School> schools;
  final School? selectedSchool;
  final List<Subject> subjects;
  final Subject? selectedSubject;
  final String? fileName;
  final File? file;
  final bool isLoading;
  final String? errorMessage;

  const DocumentUploadState({
    this.schools = const [],
    this.selectedSchool,
    this.subjects = const [],
    this.selectedSubject,
    this.fileName,
    this.file,
    this.isLoading = false,
    this.errorMessage,
  });

  DocumentUploadState copyWith({
    List<School>? schools,
    School? selectedSchool,
    List<Subject>? subjects,
    Subject? selectedSubject,
    String? fileName,
    File? file,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DocumentUploadState(
      schools: schools ?? this.schools,
      selectedSchool: selectedSchool ?? this.selectedSchool,
      subjects: subjects ?? this.subjects,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      fileName: fileName ?? this.fileName,
      file: file ?? this.file,
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
        file,
        isLoading,
        errorMessage,
      ];
}

