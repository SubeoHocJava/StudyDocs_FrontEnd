import '../model/document_library.dart';
import '../model/result.dart';

abstract class LibraryRepository {
  /// Load document theo keyword
  Future<List<DocumentLibraryUI>> loadDocuments(String keyword);

  /// Search document
  Future<List<DocumentLibraryUI>> searchDocuments(String keyword);

  /// Download document
  Future<void> downloadDocument(String documentId);

  /// Save document
  Future<void> saveDocument(String documentId);

  /// Like document
  Future<void> likeDocument(String documentId);

}
