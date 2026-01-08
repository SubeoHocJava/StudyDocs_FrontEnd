import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsManagementRemoteDataSource {
  Future<List<DocumentEntity>> getMyDocuments();
  Future<void> deleteDocument(String id);
  Future<void> updateDocument(String id, DocumentEntity updatedDoc);
}

class DocsManagementRemoteDataSourceImpl implements DocsManagementRemoteDataSource {
  // Mock In-Memory Data
  final List<DocumentEntity> _mockDocs = [
    DocumentEntity(
      title: "Huong_dan_cai_dat_Linux.pdf",
      course: "Lập trình .NET",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2024/2025",
      uploader: "Subeo Dangiu",
      likes: 16,
      dislikes: 0,
      pages: 19,
      fileSize: "3.0 MB",
      downloadUrl: "",
      previewUrls: [],
      comments: [],
      isSaved: false,
    ),
    DocumentEntity(
      title: "De_cuong_chi_tiet.pdf",
      course: "Công nghệ thông tin",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2024/2025",
      uploader: "Subeo Dangiu",
      likes: 5,
      dislikes: 0,
      pages: 10,
      fileSize: "1.5 MB",
      downloadUrl: "",
      previewUrls: [],
      comments: [],
      isSaved: true,
    ),
    DocumentEntity(
      title: "Slide_Chapter_1.pdf",
      course: "Lập trình Web",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2023/2024",
      uploader: "Subeo Dangiu",
      likes: 12,
      dislikes: 1,
      pages: 25,
      fileSize: "5.2 MB",
      downloadUrl: "",
      previewUrls: [],
      comments: [],
      isSaved: false,
    ),
  ];

  @override
  Future<List<DocumentEntity>> getMyDocuments() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate latency
    return List.from(_mockDocs);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, use ID. Here we mock removal by title or index if we had IDs.
    // Assuming simple mock: remove the first one basically or just pretend.
    if (_mockDocs.isNotEmpty) {
      _mockDocs.removeAt(0); // Mock remove behavior
    }
  }

  @override
  Future<void> updateDocument(String id, DocumentEntity updatedDoc) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Find and update
    // Mock: just print
    print("Updated doc $id with title: ${updatedDoc.title}");
  }
}
