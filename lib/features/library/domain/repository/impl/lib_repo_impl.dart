import '../library_repository.dart';
import '../../model/document_library.dart';

class LibraryRepositoryImpl implements LibraryRepository {

  @override
  Future<List<DocumentLibraryUI>> loadDocuments(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockDocuments();
  }

  @override
  Future<List<DocumentLibraryUI>> searchDocuments(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerKeyword = keyword.toLowerCase();

    return _mockDocuments()
        .where(
          (doc) =>
      doc.title.toLowerCase().contains(lowerKeyword) ||
          doc.category.toLowerCase().contains(lowerKeyword),
    )
        .toList();
  }

  @override
  Future<void> downloadDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print("⬇️ Download document: $documentId");
  }

  @override
  Future<void> saveDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print("💾 Save document: $documentId");
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print("❤️ Like document: $documentId");
  }

  // ===========================
  // Mock data theo DocumentLibraryUI (NEW)
  // ===========================

  List<DocumentLibraryUI> _mockDocuments() {
    return const [
      DocumentLibraryUI(
        id: "doc_1",
        title: "Lập trình Flutter cơ bản",
        category: "Mobile",
        institution: "ĐH Bách Khoa",
        pages: 120,
        createdAt: "2024-03-12",
        likesCount: 45,
        commentsCount: 12,
        thumbnailUrl: "https://picsum.photos/200/300",
        isLiked: false,
        isSaved: false,
      ),
      DocumentLibraryUI(
        id: "doc_2",
        title: "Spring Boot cho người mới",
        category: "Backend",
        institution: "ĐH Công Nghệ",
        pages: 200,
        createdAt: "2024-01-01",
        likesCount: 78,
        commentsCount: 20,
        thumbnailUrl: "https://picsum.photos/200/301",
        isLiked: true,
        isSaved: false,
      ),
      DocumentLibraryUI(
        id: "doc_3",
        title: "Clean Architecture Android",
        category: "Mobile",
        institution: "ĐH Khoa Học Tự Nhiên",
        pages: 160,
        createdAt: "2024-02-20",
        likesCount: 60,
        commentsCount: 15,
        thumbnailUrl: "https://picsum.photos/200/302",
        isLiked: false,
        isSaved: true,
      ),
    ];
  }
}
