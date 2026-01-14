import 'package:dio/dio.dart';
import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../services/token_storage_service.dart';
import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {
  final Dio _dio;
  final String baseUrl;

  SubjectLibraryRepositoryImpl({Dio? dio, this.baseUrl = ApiConstants.baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: ApiConstants.connectTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
            ),
          );

  Future<void> _attachAuthHeader() async {
    final token = await TokenStorageService().getAuthorizationHeader();
    if (token != null) {
      _dio.options.headers['Authorization'] = token;
    }
  }

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    await _attachAuthHeader();

    try {
      final bool isSearch = query.trim().isNotEmpty;
      final endpoint =
          isSearch
              ? ApiConstants.searchDocuments
              : ApiConstants.recentDocuments;

      final Map<String, dynamic> queryParams = {};
      if (isSearch) {
        queryParams['q'] =
            query; // Adjust param name based on backend expectation
        queryParams['keyword'] = query; // Fallback key
      }

      final response = await _dio.get(endpoint, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final body = response.data;
        final list =
            body is Map && body['data'] != null
                ? body['data'] as List
                : (body is List ? body : []);

        return list.map<DocumentSubjectLibUI>((item) {
          return DocumentSubjectLibUI(
            id: (item['id'] ?? '').toString(),
            title: (item['title'] ?? item['name'] ?? 'Untitled').toString(),
            category:
                (item['subject']?['name'] ?? item['category'] ?? 'General')
                    .toString(),
            institution:
                (item['institution']?['name'] ??
                        item['school'] ??
                        'Unknown School')
                    .toString(),
            pages: int.tryParse((item['pages'] ?? '0').toString()) ?? 0,
            createdAt:
                (item['createdAt'] ?? item['created_at'] ?? '').toString(),
            likesCount:
                int.tryParse((item['likesCount'] ?? '0').toString()) ?? 0,
            commentsCount:
                int.tryParse((item['commentsCount'] ?? '0').toString()) ?? 0,
            thumbnailUrl: item['thumbnailUrl'] ?? item['thumbnail'],
            isLiked: item['isLiked'] ?? false,
            isSaved: item['isSaved'] ?? false,
          );
        }).toList();
      }
    } catch (e) {
      // Return empty on error
      return [];
    }
    return [];
  }

  // --- Các method dưới đây tạm thời gọi API hoặc mock tùy endpoint backend ---

  @override
  Future<void> likeDocument(String documentId) async {
    await _attachAuthHeader();
    try {
      // Giả định endpoint like document
      await _dio.post('/documents/$documentId/like');
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    await _attachAuthHeader();
    try {
      final response = await _dio.get('/documents/$documentId/comments');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map(
              (e) => CommentEntity(
                id: (e['id'] ?? '').toString(),
                username: (e['user']?['username'] ?? 'User').toString(),
                avatarUrl: e['user']?['avatarUrl'],
                content: (e['content'] ?? '').toString(),
                createdAt: (e['createdAt'] ?? '').toString(),
              ),
            )
            .toList();
      }
    } catch (e) {
      // ignore
    }
    return [];
  }

  @override
  Future<String> downloadDocument(String documentId) async {
    // Trả về URL download từ API
    return "${ApiConstants.baseUrl}/documents/$documentId/download";
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await _attachAuthHeader();
    try {
      await _dio.post('/documents/$documentId/save');
    } catch (e) {
      // ignore
    }
  }
}
