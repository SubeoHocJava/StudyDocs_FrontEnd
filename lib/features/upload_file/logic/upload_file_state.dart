import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';




abstract class UploadFileState extends Equatable {
  const UploadFileState();

  @override
  List<Object?> get props => [];
}

class UploadFileInitial extends UploadFileState {
  @override
  List<Object?> get props => [];
}

class UploadFileLoading extends UploadFileState {}

class UploadFileLoaded extends UploadFileState {
  final List<PlatformFile> file;
  final String subject;
  final String school;

  const UploadFileLoaded(this.file, this.subject,this.school);

  @override
  List<Object?> get props => [file, subject,school];
}

class UploadFileError extends UploadFileState {
  final String message;
  final List<PlatformFile> file;
  final String subject;
  final String school;


  const UploadFileError(this.message, this.file, this.subject, this.school);

  @override
  List<Object?> get props => [message, file, subject, school];
}

class UploadFileSuccess extends UploadFileState {
  const UploadFileSuccess();

  @override
  List<Object?> get props => [];
}
