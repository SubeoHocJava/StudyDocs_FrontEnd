import 'dart:io';

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

class SearchDocument extends LibraryEvent {
  final String keyword;
  const SearchDocument(this.keyword);
  @override
  List<Object?> get props => [keyword];

}

class UpLoadDocument extends LibraryEvent{
  final bool hasfile;
  const UpLoadDocument(this.hasfile);
  @override
  List<Object?> get props => [hasfile];
}

class PickDocument extends LibraryEvent{

  const PickDocument();
  @override
  List<Object?> get props => [];
}
