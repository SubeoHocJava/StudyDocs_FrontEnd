import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/token_services.dart';
import '../../domain/repositories/statistic_repository.dart';
import '../../domain/entities/statistic_entity.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final DioClient _dioClient = DioClient();
  final TokenStorageService _tokenStorage = TokenStorageService();

  @override
  Future<StatisticEntity> getStatisticData() async {
    try {
      final userId = await _tokenStorage.getUserId() ?? "me";

      final docFuture = _dioClient.get('/education/documents/user/me/count');
      final likeFuture = _dioClient.get('/user/reviews/user/me/reactions/count');
      final cmtFuture = _dioClient.get('/user/reviews/user/$userId/count');

      final results = await Future.wait([docFuture, likeFuture, cmtFuture]);

      final docData = results[0].data as Map<String, dynamic>? ?? {};
      final totalDocuments = docData['documentCount'] ?? docData['total'] ?? 0;

      final likeData = results[1].data as Map<String, dynamic>? ?? {};
      final totalLikes = likeData['reactionCount'] ?? 0;

      final cmtData = results[2].data as Map<String, dynamic>? ?? {};
      final totalComments = cmtData['reviewCount'] ?? 0;

      return StatisticEntity(
        totalDocuments: int.tryParse(totalDocuments.toString()) ?? 0,
        totalLikes: int.tryParse(totalLikes.toString()) ?? 0,
        totalComments: int.tryParse(totalComments.toString()) ?? 0,
      );
    } catch (e) {
      // Fallback in case of error
      return const StatisticEntity(
        totalDocuments: 0,
        totalLikes: 0,
        totalComments: 0,
      );
    }
  }
}
