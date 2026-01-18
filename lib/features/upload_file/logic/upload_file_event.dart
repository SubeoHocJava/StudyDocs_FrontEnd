
import 'package:equatable/equatable.dart';

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

// Select School Event (với ID và Name)
class SelectSchool extends UploadFileEvent {
  final String schoolId;
  final String schoolName;

  const SelectSchool(this.schoolId, this.schoolName);

  @override
  List<Object?> get props => [schoolId, schoolName];
}

// Select Subject Event (với ID và Name)
class SelectSubject extends UploadFileEvent {
  final String subjectId;
  final String subjectName;

  const SelectSubject(this.subjectId, this.subjectName);

  @override
  List<Object?> get props => [subjectId, subjectName];
}

// Gửi form upload
class SendFormUpload extends UploadFileEvent {
  final String fileName;
  final String year;
  final String description;

  const SendFormUpload({
    required this.fileName,
    required this.year,
    required this.description,
  });

  @override
  List<Object?> get props => [fileName, year, description];
}
