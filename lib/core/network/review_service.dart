import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class ReviewService {
  final DioClient dioClient;

  ReviewService({required this.dioClient});

  Future<void> reactToReview({
    required String reviewId,
    required String type, // "like" hoặc "dislike"
  }) async {
    await dioClient.dio.post(
      '/api/v1/reviews/$reviewId/react',
      queryParameters: {'type': type},
    );
  }
}