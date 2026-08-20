import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object?> get props => [];
}

class FileSelected extends DocumentUploadEvent {
  final PlatformFile file;
  const FileSelected(this.file);

  @override
  List<Object?> get props => [file];
}

class InitialFileSelected extends DocumentUploadEvent {
  final String fileName;
  const InitialFileSelected(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class FileRemoved extends DocumentUploadEvent {}

class SchoolSelected extends DocumentUploadEvent {
  final int universityId;
  final String schoolName;
  const SchoolSelected(this.universityId, this.schoolName);

  @override
  List<Object?> get props => [universityId, schoolName];
}

class LoadUniversities extends DocumentUploadEvent {}

class SubjectSelected extends DocumentUploadEvent {
  final int subjectId;
  final String subjectName;
  const SubjectSelected(this.subjectId, this.subjectName);

  @override
  List<Object?> get props => [subjectId, subjectName];
}

class FacultySelected extends DocumentUploadEvent {
  final int facultyId;
  final String facultyName;
  const FacultySelected(this.facultyId, this.facultyName);

  @override
  List<Object?> get props => [facultyId, facultyName];
}

class DepartmentSelected extends DocumentUploadEvent {
  final int departmentId;
  final String departmentName;
  const DepartmentSelected(this.departmentId, this.departmentName);

  @override
  List<Object?> get props => [departmentId, departmentName];
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
