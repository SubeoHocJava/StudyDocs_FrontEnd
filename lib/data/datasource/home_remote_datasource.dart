import '../model/document_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

abstract class HomeRemoteDataSource {
  Future<List<DocumentModel>> getDocuments();
  Future<List<DocumentModel>> getPopularDocuments();
  Future<List<DocumentModel>> getRecentDocuments();
  Future<List<DocumentModel>> searchDocuments(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DocumentModel>> getDocuments() async {
    try {
      // TODO: Thay bằng API call thật
      // final response = await dioClient.get(ApiConstants.documents);
      // final List<dynamic> data = response.data['data'];
      // return data.map((json) => DocumentModel.fromJson(json)).toList();

      // 🎭 MOCK DATA (giữ lại để test)
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockDocuments();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getPopularDocuments() async {
    try {
      // TODO: API call
      // final response = await dioClient.get(ApiConstants.popularDocuments);

      await Future.delayed(const Duration(milliseconds: 500));
      final allDocs = _getMockDocuments();
      allDocs.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
      return allDocs.take(5).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getRecentDocuments() async {
    try {
      // TODO: API call
      // final response = await dioClient.get(ApiConstants.recentDocuments);

      await Future.delayed(const Duration(milliseconds: 500));
      final allDocs = _getMockDocuments();
      allDocs.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return allDocs.take(5).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    try {
      // TODO: API call
      // final response = await dioClient.get(
      //   ApiConstants.searchDocuments,
      //   queryParameters: {'q': query},
      // );

      await Future.delayed(const Duration(milliseconds: 500));
      final allDocs = _getMockDocuments();
      final lowerQuery = query.toLowerCase();
      return allDocs.where((doc) {
        return doc.title.toLowerCase().contains(lowerQuery) ||
            (doc.description?.toLowerCase().contains(lowerQuery) ?? false) ||
            (doc.category?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }

  // Mock data
  List<DocumentModel> _getMockDocuments() {
    return [
      DocumentModel(
        id: '1',
        title: 'Báo Cáo Đồ Án Chuyên Ngành Trang web bán rượu',
        description: 'Đồ án chuyên ngành về phát triển trang web bán rượu sử dụng công nghệ .NET',
        author: 'Lý Tuấn Dũng, Nguyễn Văn Hảo',
        authorId: 'author1',
        category: 'Lập trình .NET',
        institution: 'Trường Đại học Nông Lâm Tp. HCM',
        pageCount: 19,
        academicYear: '2024/2025',
        viewCount: 1250,
        downloadCount: 320,
        likesCount: 15,
        commentsCount: 3,
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        fileType: 'PDF',
      ),
      DocumentModel(
        id: '2',
        title: 'Bài giảng Lập Trình Mobile Flutter',
        description: 'Tài liệu hướng dẫn lập trình ứng dụng mobile với Flutter',
        author: 'Trần Thị B',
        authorId: 'author2',
        category: 'Lập trình Mobile',
        institution: 'Trường Đại học Bách Khoa',
        pageCount: 45,
        academicYear: '2024/2025',
        viewCount: 890,
        downloadCount: 245,
        likesCount: 23,
        commentsCount: 5,
        rating: 4.8,
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        fileType: 'PDF',
      ),
    ];
  }
}