import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class UploadFileEvent extends Equatable {
  const UploadFileEvent();

  @override
  List<Object?> get props => [];
}

// Load document theo keyword
class UploadFileLoadDocumentByKeyWord extends UploadFileEvent {
  final String keyword;

  const UploadFileLoadDocumentByKeyWord(this.keyword);

  @override
  List<Object?> get props => [keyword];
}
// chọn file
class PickDocument extends UploadFileEvent {

  const PickDocument();

  @override
  List<Object?> get props => [];
}
// xóa file đã chọn
class RemovePickDocument extends UploadFileEvent {
  final int index;

  const RemovePickDocument(this.index);

  @override
  List<Object?> get props => [index];
}
// Chỉnh sửa tên môn học
class EditSubjectLabel extends UploadFileEvent {
  final String subject;

  const EditSubjectLabel(this.subject);

  @override
  List<Object?> get props => [subject];
}

// Chỉnh sửa tên trường học
class EditSchoolLabel extends UploadFileEvent {
  final String school;

  const EditSchoolLabel(this.school);

  @override
  List<Object?> get props => [school];
}
// Gửi form upload
class SendFormUpload extends UploadFileEvent {
  final String fileName;
  final String year;
  final String description;

  const SendFormUpload(
    this.fileName,
    this.year,
    this.description,
  );
  @override
  List<Object?> get props => [ fileName, year, description];
}
