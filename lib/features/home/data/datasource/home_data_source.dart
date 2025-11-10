import '../model/document_model.dart';

abstract class HomeDataSource {
  Future<List<DocumentModel>> getDocuments();
  Future<List<DocumentModel>> getPopularDocuments();
  Future<List<DocumentModel>> getRecentDocuments();
  Future<List<DocumentModel>> searchDocuments(String query);
}

class HomeDataSourceImpl implements HomeDataSource {
  // TODO: Replace with actual API calls
  // For now, returning mock data

  @override
  Future<List<DocumentModel>> getDocuments() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data
    return [
      DocumentModel(
        id: '1',
        title: 'Báo Cáo Đồ Án Chuyên Ngành Trang web bán rượu - Treso\'r de Levure',
        description: 'Đồ án chuyên ngành về phát triển trang web bán rượu sử dụng công nghệ .NET',
        author: 'Lý Tuấn Dũng, Nguyễn Văn Hảo',
        authorId: 'author1',
        thumbnailUrl: null,
        category: 'Lập trình .NET',
        institution: 'Trường Đại học Nông Lâm Tp. HCM',
        pageCount: 19,
        academicYear: '2024/2025',
        viewCount: 1250,
        downloadCount: 320,
        likesCount: 15,
        commentsCount: 3,
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        fileType: 'PDF',
      ),
      DocumentModel(
        id: '2',
        title: 'Bài giảng Lập Trình Mobile Flutter',
        description: 'Tài liệu hướng dẫn lập trình ứng dụng mobile với Flutter',
        author: 'Trần Thị B',
        authorId: 'author2',
        thumbnailUrl: null,
        category: 'Lập trình Mobile',
        institution: 'Trường Đại học Bách Khoa',
        pageCount: 45,
        academicYear: '2024/2025',
        viewCount: 890,
        downloadCount: 245,
        likesCount: 23,
        commentsCount: 5,
        rating: 4.8,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        fileType: 'PDF',
      ),
      DocumentModel(
        id: '3',
        title: 'Đề thi Tiếng Anh Chuyên Ngành Công Nghệ Thông Tin',
        description: 'Bộ đề thi tham khảo môn Tiếng Anh chuyên ngành CNTT',
        author: 'Lê Văn C',
        authorId: 'author3',
        thumbnailUrl: null,
        category: 'Tiếng Anh',
        institution: 'Trường Đại học Nông Lâm Tp. HCM',
        pageCount: 12,
        academicYear: '2023/2024',
        viewCount: 2100,
        downloadCount: 567,
        likesCount: 42,
        commentsCount: 8,
        rating: 4.2,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        fileType: 'PDF',
      ),
      DocumentModel(
        id: '4',
        title: 'Slide Thuyết Trình Kinh Tế Vĩ Mô',
        description: 'Tài liệu thuyết trình về các vấn đề kinh tế vĩ mô',
        author: 'Phạm Thị D',
        authorId: 'author4',
        thumbnailUrl: null,
        category: 'Kinh tế',
        institution: 'Trường Đại học Kinh tế',
        pageCount: 28,
        academicYear: '2024/2025',
        viewCount: 654,
        downloadCount: 189,
        likesCount: 18,
        commentsCount: 2,
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        fileType: 'PPTX',
      ),
      DocumentModel(
        id: '5',
        title: 'Giáo trình Vật Lý Đại Cương và Ứng Dụng',
        description: 'Tài liệu học tập môn Vật Lý cho sinh viên năm nhất',
        author: 'Hoàng Văn E',
        authorId: 'author5',
        thumbnailUrl: null,
        category: 'Vật lý',
        institution: 'Trường Đại học Khoa học Tự nhiên',
        pageCount: 156,
        academicYear: '2024/2025',
        viewCount: 1567,
        downloadCount: 412,
        likesCount: 67,
        commentsCount: 12,
        rating: 4.6,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        fileType: 'PDF',
      ),
    ];
  }

  @override
  Future<List<DocumentModel>> getPopularDocuments() async {
    final allDocuments = await getDocuments();
    // Sort by view count descending
    allDocuments.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    return allDocuments.take(5).toList();
  }

  @override
  Future<List<DocumentModel>> getRecentDocuments() async {
    final allDocuments = await getDocuments();
    // Sort by created date descending
    allDocuments.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
    return allDocuments.take(5).toList();
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    final allDocuments = await getDocuments();
    final lowerQuery = query.toLowerCase();
    return allDocuments.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          (doc.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          (doc.category?.toLowerCase().contains(lowerQuery) ?? false) ||
          (doc.author?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}

