import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import '../domain/usecase/toggle_like_usecase.dart';
import '../domain/usecase/post_comment_usecase.dart';
import '../domain/usecase/react_review_usecase.dart';
import 'docs_event.dart';
import 'docs_state.dart';

class DocsBloc extends Bloc<DocsEvent, DocsState> {
  final GetDocumentUseCase getDocumentUseCase;
  final ToggleSaveUseCase toggleSaveUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;
  final PostCommentUseCase postCommentUseCase;
  final ReactReviewUseCase reactReviewUseCase;

  final String documentId;

  DocsBloc({
    required this.documentId,
    required this.getDocumentUseCase,
    required this.toggleSaveUseCase,
    required this.toggleLikeUseCase,
    required this.postCommentUseCase,
    required this.reactReviewUseCase,
  }) : super(DocsInitial()) {
    on<LoadDocDetails>(_onLoadDocDetails);
    on<ToggleSave>(_onToggleSave);
    on<ToggleDocumentLike>(_onToggleDocumentLike);
    on<PostComment>(_onPostComment);
    on<ReactToReview>(_onReactToReview);
  }

  Future<void> _onLoadDocDetails(
      LoadDocDetails event,
      Emitter<DocsState> emit,
      ) async {
    emit(DocsLoading());
    try {
      final doc = await getDocumentUseCase(documentId: documentId);
      emit(DocsLoaded(doc));
    } catch (e) {
      emit(DocsError(e.toString()));
    }
  }

  Future<void> _onToggleSave(
      ToggleSave event,
      Emitter<DocsState> emit,
      ) async {
    if (state is DocsLoaded) {
      final current = state as DocsLoaded;
      await toggleSaveUseCase(documentId: documentId);
      emit(current.copyWith(isSaved: !current.isSaved));
    }
  }

  Future<void> _onToggleDocumentLike(
      ToggleDocumentLike event,
      Emitter<DocsState> emit,
      ) async {
    if (state is DocsLoaded) {
      final current = state as DocsLoaded;
      final doc = current.docDetails;

      String? newReaction;
      int newLikes = doc.likes;
      int newDislikes = doc.dislikes;

      // Current State
      final bool isLiked = doc.currentUserReaction == 'LIKE';
      final bool isDisliked = doc.currentUserReaction == 'DISLIKE';

      // Action
      if (event.isLike) {
        // User clicked LIKE
        if (isLiked) {
          // Previously Liked -> Unlike (None)
          newReaction = null;
          newLikes = (doc.likes - 1).clamp(0, 999999);
        } else {
          // Previously None or Disliked -> Like
          newReaction = 'LIKE';
          newLikes = doc.likes + 1;
          if (isDisliked) {
            newDislikes = (doc.dislikes - 1).clamp(0, 999999);
          }
        }
      } else {
        // User clicked DISLIKE
        if (isDisliked) {
          // Previously Disliked -> Undislike (None)
          newReaction = null;
          newDislikes = (doc.dislikes - 1).clamp(0, 999999);
        } else {
          // Previously None or Liked -> Dislike
          newReaction = 'DISLIKE';
          newDislikes = doc.dislikes + 1;
          if (isLiked) {
            newLikes = (doc.likes - 1).clamp(0, 999999);
          }
        }
      }

      // Optimistic update
      emit(current.copyWith(
        docDetails: doc.copyWith(
          likes: newLikes,
          dislikes: newDislikes,
          currentUserReaction: newReaction, 
        ),
      ));

      try {
        String reactionToSend;
        if (newReaction == null) {
          // We are removing. Send the OLD reaction to toggle it off.
          reactionToSend = isLiked ? 'LIKE' : 'DISLIKE';
        } else {
          // We are setting a new reaction.
          reactionToSend = newReaction;
        }

        // Call UseCase with the specific type
        await toggleLikeUseCase(documentId: documentId, reactionType: reactionToSend);
        
      } catch (e) {
        // Revert
        emit(current.copyWith(docDetails: doc));
        emit(DocsError("Không thể đánh giá: $e"));
      }
    }
  }

  Future<void> _onPostComment(
      PostComment event,
      Emitter<DocsState> emit,
      ) async {
    if (state is DocsLoaded) {
      final current = state as DocsLoaded;
      try {
        await postCommentUseCase(documentId: documentId, text: event.text);
        // Reload lại doc để lấy comment mới (hoặc add manual vào list)
        add(const LoadDocDetails()); 
      } catch (e) {
        emit(DocsError("Lỗi đăng bình luận: $e"));
        // Emit lại state cũ để không bị kẹt ở loading/error
        emit(current); 
      }
    }
  }

  Future<void> _onReactToReview(
      ReactToReview event,
      Emitter<DocsState> emit,
      ) async {
     try {
       await reactReviewUseCase(
         documentId: documentId,
         reviewId: event.reviewId,
         isLike: event.isLike,
       );
       // Có thể reload hoặc update state cục bộ nếu muốn
     } catch (e) {
       // Silent error or toast
       print("Lỗi react review: $e");
     }

  }

}