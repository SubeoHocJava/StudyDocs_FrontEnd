import 'package:equatable/equatable.dart';

class SubjectLibraryEvent extends Equatable {
  const SubjectLibraryEvent();

  @override
  List<Object?> get props => [];
}
// load document
class SubjectLibraryLoadDocumentByKeyWord extends SubjectLibraryEvent {
  final String keyword;
  const SubjectLibraryLoadDocumentByKeyWord(this.keyword);
  @override
  List<Object?> get props => [keyword];
}

//tìm document
class FindDocument extends SubjectLibraryEvent{
  final String keyword;
  const FindDocument(this.keyword);
  @override
  List<Object?> get props => [keyword];
}