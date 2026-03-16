import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadInitialized extends DocumentUploadEvent {
  final String? initialFileName;
  final File? initialFile;

  const UploadInitialized({this.initialFileName, this.initialFile});

  @override
  List<Object?> get props => [initialFileName, initialFile];
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
  final File file;

  const UploadFilePicked(this.fileName, this.file);

  @override
  List<Object?> get props => [fileName, file];
}

class UploadErrorCleared extends DocumentUploadEvent {
  const UploadErrorCleared();
}

