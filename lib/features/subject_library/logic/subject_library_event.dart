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

//
// 2️⃣ Like / Unlike document
//
class SubjectLibraryLikeDocument extends SubjectLibraryEvent {
  final String documentId;
  const SubjectLibraryLikeDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

//
// 3️⃣ Mở phần comment của document
//
class SubjectLibraryOpenComments extends SubjectLibraryEvent {
  final String documentId;
  const SubjectLibraryOpenComments(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

//
// 4️⃣ Download document
//
class SubjectLibraryDownloadDocument extends SubjectLibraryEvent {
  final String documentId;
  const SubjectLibraryDownloadDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

//
// 5️⃣ Đánh dấu (bookmark / save) document
//
class SubjectLibraryBookmarkDocument extends SubjectLibraryEvent {
  final String documentId;
  const SubjectLibraryBookmarkDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}