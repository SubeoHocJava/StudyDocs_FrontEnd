import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import '../../domain/repository/explore_repository.dart';
import '../../domain/entity/explore_model.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final DioClient _dioClient = DioClient();

  @override
  Future<ExploreModel> getExploreData() async {
    try {
      final mostLikedFuture = _dioClient.get('/education/documents/public/most-liked?limit=10');
      final newestFuture = _dioClient.get('/education/documents/public/newest?limit=10');

      final results = await Future.wait([mostLikedFuture, newestFuture]);

      final mostLikedResponse = results[0].data as List<dynamic>? ?? [];
      final newestResponse = results[1].data as List<dynamic>? ?? [];

      final mostLiked = mostLikedResponse
          .map((json) => DocumentSummaryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final newest = newestResponse
          .map((json) => DocumentSummaryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ExploreModel(
        universityName: 'Nội dung thịnh hành',
        hintText: 'Tìm kiếm tài liệu, môn học...',
        mostLikedDocuments: mostLiked,
        newestDocuments: newest,
      );
    } catch (e) {
      return const ExploreModel(
        universityName: 'Khám phá',
        hintText: 'Tìm kiếm...',
      );
    }
  }
}
