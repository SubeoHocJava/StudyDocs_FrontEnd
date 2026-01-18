import 'package:equatable/equatable.dart';

/// =======================
/// BASE EVENT
/// =======================
abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

/// =======================
/// LOAD / SEARCH
/// =======================
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

/// =======================
/// PICK / UPLOAD
/// =======================
class PickDocument extends LibraryEvent {
  const PickDocument();
}

class UploadDocumentRequested extends LibraryEvent {
  final bool hasFile;

  const UploadDocumentRequested(this.hasFile);

  @override
  List<Object?> get props => [hasFile];
}

/// =======================
/// DOCUMENT ACTIONS (FROM UI)
/// =======================

/// Download document
class DownloadDocumentRequested extends LibraryEvent {
  final String documentId;

  const DownloadDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Save / Bookmark document
class SaveDocumentRequested extends LibraryEvent {
  final String documentId;

  const SaveDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Like document
class LikeDocumentRequested extends LibraryEvent {
  final String documentId;

  const LikeDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Open comment screen / bottom sheet
class OpenCommentRequested extends LibraryEvent {
  final String documentId;

  const OpenCommentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Load saved documents
class LoadSavedDocuments extends LibraryEvent {
  const LoadSavedDocuments();
}
