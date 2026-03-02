import 'package:equatable/equatable.dart';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadInitialized extends DocumentUploadEvent {
  const UploadInitialized();
}

class UploadSchoolChanged extends DocumentUploadEvent {
  final String schoolId;

  const UploadSchoolChanged(this.schoolId);

  @override
  List<Object?> get props => [schoolId];
}

class UploadSubjectChanged extends DocumentUploadEvent {
  final String subjectId;

  const UploadSubjectChanged(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}

class UploadFilePicked extends DocumentUploadEvent {
  final String fileName;

  const UploadFilePicked(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class UploadErrorCleared extends DocumentUploadEvent {
  const UploadErrorCleared();
}

