import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/usecase/dislike_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_event.dart';
import 'package:studydocs/core/widgets/feat/document/information/logic/document_information_state.dart';

class DocumentInformationBloc
    extends Bloc<DocumentInformationEvent, DocumentInformationState> {
  final ReviewRepository reviewRepository;

  DocumentInformationBloc(this.reviewRepository)
    : super(DocumentInformationInitial()) {
    final LikeDocumentUseCase likeDocumentUseCase = LikeDocumentUseCaseImpl(
      reviewRepository,
    );
    final DislikeDocumentUseCase dislikeDocumentUseCase =
        DislikeDocumentUseCaseImpl(reviewRepository);

    on<DocumentInformationDataReceived>((event, emit) {
      emit(DocumentInformationLoaded(event.documentInfo));
    });

    on<DocumentLikeRequested>((event, emit) async {
      final current = state as DocumentInformationLoaded;
      final doc = current.documentInfo;

      int newLikeCount = doc.likeCount;
      int newDislikeCount = doc.dislikeCount;
      bool newIsLiked = doc.isLiked;
      bool newIsDisliked = doc.isDisliked;

      if (doc.isLiked) {
        // Bỏ like
        newLikeCount = (newLikeCount - 1 < 0) ? 0 : newLikeCount - 1;
        newIsLiked = false;
      } else {
        // Like
        newLikeCount++;
        newIsLiked = true;

        // Nếu đang dislike thì bỏ dislike
        if (doc.isDisliked) {
          newDislikeCount = (newDislikeCount - 1 < 0) ? 0 : newDislikeCount - 1;
          newIsDisliked = false;
        }
      }

      emit(
        DocumentInformationLoaded(
          doc.copyWith(
            likeCount: newLikeCount,
            dislikeCount: newDislikeCount,
            isLiked: newIsLiked,
            isDisliked: newIsDisliked,
          ),
        ),
      );

      try {
        await likeDocumentUseCase.call(event.documentId);
      } catch (e) {
        emit(current); // rollback
      }
    });

    on<DocumentDislikeRequested>((event, emit) async {
      final current = state as DocumentInformationLoaded;
      final doc = current.documentInfo;

      int newLikeCount = doc.likeCount;
      int newDislikeCount = doc.dislikeCount;
      bool newIsLiked = doc.isLiked;
      bool newIsDisliked = doc.isDisliked;

      if (doc.isDisliked) {
        // Bỏ dislike
        newDislikeCount = (newDislikeCount - 1 < 0) ? 0 : newDislikeCount - 1;
        newIsDisliked = false;
      } else {
        // Dislike
        newDislikeCount++;
        newIsDisliked = true;

        // Nếu đang like thì bỏ like
        if (doc.isLiked) {
          newLikeCount = (newLikeCount - 1 < 0) ? 0 : newLikeCount - 1;
          newIsLiked = false;
        }
      }

      emit(
        DocumentInformationLoaded(
          doc.copyWith(
            likeCount: newLikeCount,
            dislikeCount: newDislikeCount,
            isLiked: newIsLiked,
            isDisliked: newIsDisliked,
          ),
        ),
      );

      try {
        await dislikeDocumentUseCase.call(event.documentId);
      } catch (e) {
        emit(current); // rollback
      }
    });

    on<AuthorClick>((event, emit) {
      
    });
  }
}
