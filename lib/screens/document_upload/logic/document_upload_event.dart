import 'package:equatable/equatable.dart';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object?> get props => [];
}

class FileSelected extends DocumentUploadEvent {
  final String fileName;
  const FileSelected(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class FileRemoved extends DocumentUploadEvent {}

class SchoolSelected extends DocumentUploadEvent {
  final String schoolName;
  const SchoolSelected(this.schoolName);

  @override
  List<Object?> get props => [schoolName];
}

class SubjectSelected extends DocumentUploadEvent {
  final String subjectName;
  const SubjectSelected(this.subjectName);

  @override
  List<Object?> get props => [subjectName];
}

class DocumentNameChanged extends DocumentUploadEvent {
  final String documentName;
  const DocumentNameChanged(this.documentName);

  @override
  List<Object?> get props => [documentName];
}

class SchoolYearChanged extends DocumentUploadEvent {
  final String schoolYear;
  const SchoolYearChanged(this.schoolYear);

  @override
  List<Object?> get props => [schoolYear];
}

class DescriptionChanged extends DocumentUploadEvent {
  final String description;
  const DescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class UploadSubmitted extends DocumentUploadEvent {}
