import 'package:dio/dio.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/features/home/domain/entity/home_documents_page.dart';
import 'package:studydocs/features/home/domain/repository/home_repository.dart';

class HomeRemoteRepository implements HomeRepository, DocumentRepository {
  final Dio _dio;

  HomeRemoteRepository({Dio? dio}) : _dio = dio ?? DioClient().dio;

  @override
  Future<HomeDocumentsPage> getHomeDocuments({
    required int page,
    required int pageSize,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      DocumentEndpoints.base,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    final body = response.data;
    if (body == null) {
      throw ApiException('Response rỗng từ server');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ApiException(
        body['message']?.toString() ?? 'Không tải được danh sách tài liệu',
        statusCode: response.statusCode,
      );
    }

    final data = body['data'];
    if (data is! Map) {
      throw ApiException('Sai định dạng data khi tải danh sách tài liệu');
    }

    return _parseDocumentsPage(Map<String, dynamic>.from(data));
  }

  @override
  Future<String?> like(String documentId) async {
    await _dio.post('${DocumentEndpoints.base}/$documentId/like');
    return null;
  }

  @override
  Future<String?> bookmark(String documentId) async {
    await _dio.post('${DocumentEndpoints.base}/$documentId/bookmark');
    return null;
  }

  @override
  Future<String?> download(String documentId) async {
    await _dio.post('${DocumentEndpoints.base}/$documentId/download');
    return null;
  }

  HomeDocumentsPage _parseDocumentsPage(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => DocumentSummaryModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(growable: false)
        : const <DocumentSummaryModel>[];

    return HomeDocumentsPage(
      items: items,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 5,
      total: json['total'] as int? ?? items.length,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}
