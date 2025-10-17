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
