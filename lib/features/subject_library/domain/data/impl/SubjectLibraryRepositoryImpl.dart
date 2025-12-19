
import '../../entity/CommentEntity.dart';
import '../../entity/DocumentEntity.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {

  final List<DocumentEntity> dummyDocuments = [
    DocumentEntity("Math Set 1", "Math", "HCMUE", 12, "2025-01-01"),
    DocumentEntity("Physics Homework", "Physics", "HCMUE", 5, "2025-01-02"),
    DocumentEntity("Chemistry Lab Report", "Chemistry", "HCMUE", 8, "2025-01-03"),
    DocumentEntity("English Essay", "English", "HCMUE", 4, "2025-01-04"),
    DocumentEntity("IT Notes", "IT", "HCMUE", 20, "2025-01-05"),
    DocumentEntity("History Summary", "History", "HCMUE", 6, "2025-01-06"),
  ];

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    await Future.delayed(Duration(milliseconds: 300));
    return dummyDocuments; // luôn trả 6 tài liệu
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await Future.delayed(Duration(milliseconds: 200));
    // Không làm gì – chỉ mock
    return;
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    await Future.delayed(Duration(milliseconds: 200));

    return [
    ];
  }

  @override
  Future<String> downloadDocument(String documentId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return "/downloads/document_$documentId.pdf"; // trả về path file tạm
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return;
  }
}
