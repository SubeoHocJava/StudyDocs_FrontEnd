import '../repository/docs_repository.dart';

class ReactReviewUseCase {
  final DocsRepository repository;

  ReactReviewUseCase(this.repository);

  Future<void> call({
    required String reviewId,
    required bool isLike, // true = like, false = dislike
  }) async {
    await repository.reactToReview(
      reviewId: reviewId,
      isLike: isLike,
    );
  }
}