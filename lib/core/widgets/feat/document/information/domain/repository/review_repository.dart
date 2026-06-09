import 'package:studydocs/core/network/dio_client.dart';

abstract interface class ReviewRepository {
  Future<void> likeDocument(String documentId);

  Future<void> dislikeDocument(String documentId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final DioClient _dioClient;

  ReviewRepositoryImpl({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  @override
  Future<void> likeDocument(String documentId) async {
    await _dioClient.post('documents/$documentId/interactions', data: {'type': 'LIKE'});
  }

  @override
  Future<void> dislikeDocument(String documentId) async {
    await _dioClient.post('documents/$documentId/interactions', data: {'type': 'DISLIKE'});
  }
}
