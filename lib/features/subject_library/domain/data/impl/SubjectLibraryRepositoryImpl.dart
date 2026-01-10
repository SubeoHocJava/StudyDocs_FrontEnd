import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {

  /// Mock documents - mỗi môn học có 1 file
  /// Map theo category/name để match với subjects
  final List<DocumentSubjectLibUI> dummyDocuments = [
    // Công nghệ phần mềm
    DocumentSubjectLibUI(
      id: 'doc_1',
      title: "Báo Cáo Đồ Ấn Chuyên Ngành Trang web...",
      category: "Công nghệ phần mềm",
      institution: "Trường Đại học Nông Lâm Tp. HCM",
      pages: 25,
      createdAt: "2025-01-01",
      likesCount: 36,
      commentsCount: 5,
      thumbnailUrl: "https://picsum.photos/200/300",
    ),
    // An toàn và bảo mật hệ thống thông tin
    DocumentSubjectLibUI(
      id: 'doc_2',
      title: "Tài liệu hướng dẫn sử dụng tool mã hoá, giải...",
      category: "An toàn và bảo mật hệ thống thông tin",
      institution: "Trường Đại học Nông Lâm Tp. HCM",
      pages: 15,
      createdAt: "2025-01-02",
      likesCount: 33,
      commentsCount: 4,
      thumbnailUrl: "https://picsum.photos/200/301",
    ),
    // Lập trình .NET
    DocumentSubjectLibUI(
      id: 'doc_3',
      title: "Bài giảng Lập trình mạng Chương 4: Socket",
      category: "Lập trình .NET",
      institution: "Trường Đại học Nông Lâm Tp. HCM",
      pages: 30,
      createdAt: "2025-01-03",
      likesCount: 30,
      commentsCount: 3,
      thumbnailUrl: "https://picsum.photos/200/302",
    ),
    // Lập trình Front End
    DocumentSubjectLibUI(
      id: 'doc_4',
      title: "Hướng dẫn React Native cơ bản",
      category: "Lập trình Front End",
      institution: "Trường Đại học Nông Lâm Tp. HCM",
      pages: 18,
      createdAt: "2025-01-04",
      likesCount: 28,
      commentsCount: 2,
      thumbnailUrl: "https://picsum.photos/200/303",
    ),
    // Machine Learning
    DocumentSubjectLibUI(
      id: 'doc_5',
      title: "Tài liệu Machine Learning với Python",
      category: "Machine Learning",
      institution: "Trường Đại học Nông Lâm Tp. HCM",
      pages: 40,
      createdAt: "2025-01-05",
      likesCount: 45,
      commentsCount: 8,
      thumbnailUrl: "https://picsum.photos/200/304",
    ),
  ];

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Nếu query là tên trường → trả về tất cả documents của trường đó
    // Nếu query là keyword → filter theo title/category
    if (query.trim().isEmpty || query == "keyword") {
      return dummyDocuments;
    }

    // Filter theo title hoặc category
    final lowerQuery = query.toLowerCase();
    return dummyDocuments
        .where((doc) =>
            doc.title.toLowerCase().contains(lowerQuery) ||
            doc.category?.toLowerCase().contains(lowerQuery) == true ||
            doc.institution?.toLowerCase().contains(lowerQuery) == true)
        .toList();
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // mock → không xử lý state
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  @override
  Future<String> downloadDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return "/downloads/document_$documentId.pdf";
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
