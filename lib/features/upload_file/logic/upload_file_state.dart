import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../library/data/model/File.dart';


abstract class UploadFileState extends Equatable {
  const UploadFileState();

  @override
  List<Object?> get props => [];
}

class UploadFileInitial extends UploadFileState {}

class UploadFileLoading extends UploadFileState {}

class UploadFileLoaded extends UploadFileState {
  final List<MyFile> file;
  final String subject;

  const UploadFileLoaded(this.file, this.subject);

  @override
  List<Object?> get props => [file, subject];
}

class UploadFileError extends UploadFileState {
  final String message;

  const UploadFileError(this.message);

  @override
  List<Object?> get props => [message];
}
