abstract interface class ReviewRepository {
  Future<void> likeDocument(String documentId);

  Future<void> dislikeDocument(String documentId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  Future<void> likeDocument(String documentId) async {}

  Future<void> dislikeDocument(String documentId) async {}
}
