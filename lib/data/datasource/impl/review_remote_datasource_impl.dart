import 'package:studydocs/core/network/dio_client.dart';
import '../review_remote_datasource.dart';

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient _client;

  ReviewRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getReviewsForDocument(String documentId, {int? page, int? size, String? sort}) async {
    final Map<String, dynamic> params = {};
    if (page != null) params['page'] = page;
    if (size != null) params['size'] = size;
    if (sort != null) params['sort'] = sort;

    final response = await _client.get('documents/$documentId/reviews', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load reviews');
  }

  @override
  Future<dynamic> getRepliesForReview(String reviewId, {int? page, int? size}) async {
    final Map<String, dynamic> params = {};
    if (page != null) params['page'] = page;
    if (size != null) params['size'] = size;

    final response = await _client.get('reviews/$reviewId/replies', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load replies');
  }

  @override
  Future<dynamic> addReview(String documentId, String content, int rating) async {
    final response = await _client.post('reviews', data: {
      'documentId': documentId,
      'content': content,
      'rating': rating,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to add review');
  }

  @override
  Future<dynamic> replyToReview(String reviewId, String content) async {
    final response = await _client.post('reviews/$reviewId/replies', data: {
      'content': content,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to reply to review');
  }

  @override
  Future<dynamic> updateReview(String reviewId, String content, {int? rating}) async {
    final Map<String, dynamic> data = {'content': content};
    if (rating != null) data['rating'] = rating;

    final response = await _client.put('reviews/$reviewId', data: data);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to update review');
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final response = await _client.delete('reviews/$reviewId');
    if (!response.isSuccess) throw Exception('Failed to delete review');
  }

  @override
  Future<void> interactWithReview(String reviewId, String type) async {
    final response = await _client.post('reviews/$reviewId/interactions', data: {'type': type});
    if (!response.isSuccess) throw Exception('Failed to interact with review');
  }
}
