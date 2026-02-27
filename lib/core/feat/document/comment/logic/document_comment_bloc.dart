import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/reply_comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/like_comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/edit_comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/delete_comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/unlike_comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_state.dart';

class DocumentCommentBloc
    extends Bloc<DocumentCommentEvent, DocumentCommentState> {
  final CommentUseCase _commentUseCase;
  final ReplyCommentUseCase _replyCommentUseCase;
  final LikeCommentUseCase _likeCommentUseCase;
  final UnlikeCommentUseCase _unlikeCommentUseCase;
  final EditCommentUseCase _editCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final String _documentId;

  DocumentCommentBloc({
    required CommentUseCase commentUseCase,
    required ReplyCommentUseCase replyCommentUseCase,
    required LikeCommentUseCase likeCommentUseCase,
    required UnlikeCommentUseCase unlikeCommentUseCase,
    required EditCommentUseCase editCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
    required String documentId,
  }) : _commentUseCase = commentUseCase,
       _replyCommentUseCase = replyCommentUseCase,
       _likeCommentUseCase = likeCommentUseCase,
       _unlikeCommentUseCase = unlikeCommentUseCase,
       _editCommentUseCase = editCommentUseCase,
       _deleteCommentUseCase = deleteCommentUseCase,
       _documentId = documentId,
       super(DocumentCommentInitial()) {
    on<CommentRequested>((event, emit) async {
      try {
        await _commentUseCase(_documentId, event.content);
      } catch (_) {}
    });

    on<CommentReplied>((event, emit) async {
      try {
        await _replyCommentUseCase(event.documentId, event.commentId, event.content);
      } catch (_) {}
    });

    on<CommentLiked>((event, emit) async {
      if (state is DocumentCommentLoaded) {
        final currentState = state as DocumentCommentLoaded;
        final currentComments = currentState.comments;
        
        // Optimistic UI Update
        final newComments = currentComments.map((comment) {
          if (comment.id == event.commentId) {
            return comment.copyWith(
              isLiked: true,
              likeCount: comment.likeCount + 1,
            );
          }
          return comment;
        }).toList();
        
        emit(DocumentCommentLoaded(newComments));

        try {
          await _likeCommentUseCase(event.documentId, event.commentId);
        } catch (_) {
          // Rollback on failure
          emit(DocumentCommentLoaded(currentComments));
        }
      }
    });

    on<CommentUnliked>((event, emit) async {
      if (state is DocumentCommentLoaded) {
        final currentState = state as DocumentCommentLoaded;
        final currentComments = currentState.comments;
        
        // Optimistic UI Update
        final newComments = currentComments.map((comment) {
          if (comment.id == event.commentId) {
            return comment.copyWith(
              isLiked: false,
              likeCount: comment.likeCount > 0 ? comment.likeCount - 1 : 0,
            );
          }
          return comment;
        }).toList();
        
        emit(DocumentCommentLoaded(newComments));

        try {
          await _unlikeCommentUseCase(event.documentId, event.commentId);
        } catch (_) {
          // Rollback on failure
          emit(DocumentCommentLoaded(currentComments));
        }
      }
    });

    on<CommentEdited>((event, emit) async {
      try {
        await _editCommentUseCase(event.documentId, event.commentId, event.content);
      } catch (_) {}
    });

    on<CommentDeleted>((event, emit) async {
      try {
        await _deleteCommentUseCase(event.documentId, event.commentId);
      } catch (_) {}
    });


    on<ReceivedData>((event, emit) {
      emit(DocumentCommentLoaded(event.comments));
    });

    on<AuthorClick>((event, emit) {
      ///To-do: Navigate to author profile
    });
  }
}
