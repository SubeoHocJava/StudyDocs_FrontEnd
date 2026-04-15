import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/reply_comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/like_comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/edit_comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/delete_comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/unlike_comment_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/get_comments_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/usecase/get_comment_replies_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_state.dart';

class DocumentCommentBloc
    extends Bloc<DocumentCommentEvent, DocumentCommentState> {
  final String _documentId;

  DocumentCommentBloc({
    required ReviewRepository reviewRepository,
    required String documentId,
  }) : _documentId = documentId,
       super(DocumentCommentInitial()) {
    final CommentUseCase commentUseCase = CommentUseCaseImpl(reviewRepository);
    final ReplyCommentUseCase replyCommentUseCase = ReplyCommentUseCaseImpl(
      reviewRepository,
    );
    final LikeCommentUseCase likeCommentUseCase = LikeCommentUseCaseImpl(
      reviewRepository,
    );
    final UnlikeCommentUseCase unlikeCommentUseCase = UnlikeCommentUseCaseImpl(
      reviewRepository,
    );
    final EditCommentUseCase editCommentUseCase = EditCommentUseCaseImpl(
      reviewRepository,
    );
    final DeleteCommentUseCase deleteCommentUseCase = DeleteCommentUseCaseImpl(
      reviewRepository,
    );
    final GetCommentsUseCase getCommentsUseCase = GetCommentsUseCaseImpl(
      reviewRepository,
    );
    final GetCommentRepliesUseCase getCommentRepliesUseCase =
        GetCommentRepliesUseCaseImpl(reviewRepository);

    on<LoadCommentsRequested>((event, emit) async {
      emit(DocumentCommentLoading()); // Thêm trạng thái loading
      try {
        final comments = await getCommentsUseCase(event.documentId);
        emit(DocumentCommentLoaded(comments));
      } catch (e) {
        // Có thể emit thêm trạng thái Error nếu cần
        emit(const DocumentCommentLoaded([])); 
      }
    });

    on<CommentRequested>((event, emit) async {
      try {
        await commentUseCase(_documentId, event.content);
        add(LoadCommentsRequested(_documentId)); // Reload sau khi comment
      } catch (_) {}
    });

    on<LoadCommentRepliesRequested>((event, emit) async {
      try {
        final replies = await getCommentRepliesUseCase(
          event.documentId,
          event.commentId,
        );
        if (state is DocumentCommentLoaded) {
          final currentState = state as DocumentCommentLoaded;
          final updatedComments =
              currentState.comments.map((c) {
                return _updateCommentInTree(c, event.commentId, (target) {
                  return target.copyWith(children: replies);
                });
              }).toList();
          emit(DocumentCommentLoaded(updatedComments));
        }
      } catch (_) {}
    });

    on<CommentReplied>((event, emit) async {
      try {
        await replyCommentUseCase(
          event.documentId,
          event.commentId,
          event.content,
        );
        add(LoadCommentsRequested(_documentId));
      } catch (_) {}
    });

    on<CommentLiked>((event, emit) async {
      if (state is DocumentCommentLoaded) {
        final currentState = state as DocumentCommentLoaded;
        final currentComments = currentState.comments;

        final newComments =
            currentComments.map((comment) {
              return _updateCommentInTree(comment, event.commentId, (target) {
                return target.copyWith(
                  isLiked: true,
                  likeCount: target.likeCount + 1,
                );
              });
            }).toList();

        emit(DocumentCommentLoaded(newComments));

        try {
          await likeCommentUseCase(event.documentId, event.commentId);
        } catch (_) {
          emit(DocumentCommentLoaded(currentComments));
        }
      }
    });

    on<CommentUnliked>((event, emit) async {
      if (state is DocumentCommentLoaded) {
        final currentState = state as DocumentCommentLoaded;
        final currentComments = currentState.comments;

        final newComments =
            currentComments.map((comment) {
              return _updateCommentInTree(comment, event.commentId, (target) {
                return target.copyWith(
                  isLiked: false,
                  likeCount: target.likeCount > 0 ? target.likeCount - 1 : 0,
                );
              });
            }).toList();

        emit(DocumentCommentLoaded(newComments));

        try {
          await unlikeCommentUseCase(event.documentId, event.commentId);
        } catch (_) {
          emit(DocumentCommentLoaded(currentComments));
        }
      }
    });

    on<CommentEdited>((event, emit) async {
      try {
        await editCommentUseCase(
          event.documentId,
          event.commentId,
          event.content,
        );
        add(LoadCommentsRequested(_documentId));
      } catch (_) {}
    });

    on<CommentDeleted>((event, emit) async {
      try {
        await deleteCommentUseCase(event.documentId, event.commentId);
        add(LoadCommentsRequested(_documentId));
      } catch (_) {}
    });

    on<ReceivedData>((event, emit) {
      emit(DocumentCommentLoaded(event.comments));
    });

    on<AuthorClick>((event, emit) {
      ///To-do: Navigate to author profile
    });
  }

  Comment _updateCommentInTree(
    Comment current,
    String targetId,
    Comment Function(Comment) updateFn,
  ) {
    if (current.id == targetId) {
      return updateFn(current);
    }
    if (current.children.isNotEmpty) {
      return current.copyWith(
        children:
            current.children
                .map((child) => _updateCommentInTree(child, targetId, updateFn))
                .toList(),
      );
    }
    return current;
  }
}
