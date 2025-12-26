import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {

  final List<DocumentSubjectLibUI> dummyDocuments = [
    DocumentSubjectLibUI(
      id: 'sub_1',
      title: "Math Set 1",
      category: "Math",
      institution: "HCMUE",
      pages: 12,
      createdAt: "2025-01-01",
      likesCount: 120,
      commentsCount: 15,
      thumbnailUrl: "https://picsum.photos/200/300",
    ),
    DocumentSubjectLibUI(
      id: 'sub_2',
      title: "Physics Homework",
      category: "Physics",
      institution: "HCMUE",
      pages: 5,
      createdAt: "2025-01-02",
      likesCount: 95,
      commentsCount: 10,
      thumbnailUrl: "https://picsum.photos/200/301",
    ),
    DocumentSubjectLibUI(
      id: 'sub_3',
      title: "Chemistry Lab Report",
      category: "Chemistry",
      institution: "HCMUE",
      pages: 8,
      createdAt: "2025-01-03",
      likesCount: 70,
      commentsCount: 8,
      thumbnailUrl: "https://picsum.photos/200/302",
    ),
    DocumentSubjectLibUI(
      id: 'sub_4',
      title: "English Essay",
      category: "English",
      institution: "HCMUE",
      pages: 4,
      createdAt: "2025-01-04",
      likesCount: 40,
      commentsCount: 5,
      thumbnailUrl: "https://picsum.photos/200/303",
    ),
    DocumentSubjectLibUI(
      id: 'sub_5',
      title: "IT Notes",
      category: "IT",
      institution: "HCMUE",
      pages: 20,
      createdAt: "2025-01-05",
      likesCount: 200,
      commentsCount: 30,
      thumbnailUrl: "https://picsum.photos/200/304",
    ),
    DocumentSubjectLibUI(
      id: 'sub_6',
      title: "History Summary",
      category: "History",
      institution: "HCMUE",
      pages: 6,
      createdAt: "2025-01-06",
      likesCount: 60,
      commentsCount: 6,
      thumbnailUrl: "https://picsum.photos/200/305",
    ),
  ];

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // nếu muốn filter đơn giản theo title / category
    return dummyDocuments;
    //     .where((doc) =>
    // doc.title.toLowerCase().contains(query.toLowerCase()) ||
    //     doc.category.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
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
