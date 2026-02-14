import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/document/information/domain/repository/review_repository.dart';
import 'package:studydocs/core/feat/document/information/domain/usecase/dislike_document_usecase.dart';
import 'package:studydocs/core/feat/document/information/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/feat/document/information/logic/document_information_event.dart';
import 'package:studydocs/core/feat/document/information/logic/document_information_state.dart';

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

    on<DocumentInformationLikeRequested>((event, emit) async {
      final current = state as DocumentInformationLoaded;
      emit(
        DocumentInformationLoaded(
          current.documentInfo.copyWith(likes: current.documentInfo.likes + 1),
        ),
      );
      try {
        await likeDocumentUseCase.call(event.documentId);
      } catch (e) {
        emit(
          DocumentInformationLoaded(
            current.documentInfo.copyWith(
              likes: current.documentInfo.likes - 1,
            ),
          ),
        );
      }
    });

    on<DocumentInformationDislikeRequested>((event, emit) async {
      final current = state as DocumentInformationLoaded;

      emit(
        DocumentInformationLoaded(
          current.documentInfo.copyWith(
            dislikes: current.documentInfo.dislikes - 1,
          ),
        ),
      );
      try {
        await dislikeDocumentUseCase.call(event.documentId);
      } catch (e) {
        emit(
          DocumentInformationLoaded(
            current.documentInfo.copyWith(
              likes: current.documentInfo.likes + 1,
            ),
          ),
        );
      }
    });
  }
}
