import 'document_library.dart';

class LibraryResult {
  final List<DocumentLibraryUI> documents;
  final List<String> categories;

  LibraryResult({
    required this.documents,
    required this.categories,
  });
}