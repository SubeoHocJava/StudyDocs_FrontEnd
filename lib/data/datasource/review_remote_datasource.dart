abstract interface class ReviewRemoteDataSource {
  Future<dynamic> getReviewsForDocument(String documentId, {int? page, int? size, String? sort});
  Future<dynamic> getRepliesForReview(String reviewId, {int? page, int? size});
  Future<dynamic> addReview(String documentId, String content, int rating);
  Future<dynamic> replyToReview(String reviewId, String content);
  Future<dynamic> updateReview(String reviewId, String content, {int? rating});
  Future<void> deleteReview(String reviewId);
  Future<void> interactWithReview(String reviewId, String type);
}
