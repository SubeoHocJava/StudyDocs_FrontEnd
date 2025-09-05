import 'package:equatable/equatable.dart';

class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}
// load document
class LoadDocumentByKeyWord extends LibraryEvent {
  final String keyword;
  const LoadDocumentByKeyWord(this.keyword);
  @override
  List<Object?> get props => [keyword];
}
