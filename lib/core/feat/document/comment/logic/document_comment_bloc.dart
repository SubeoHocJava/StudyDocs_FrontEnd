import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/feat/document/comment/domain/usecase/comment_usecase.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_state.dart';

class DocumentCommentBloc
    extends Bloc<DocumentCommentEvent, DocumentCommentState> {
  final CommentUseCase _commentUseCase;
  final String _documentId;

  DocumentCommentBloc({
    required CommentUseCase commentUseCase,
    required String documentId,
  }) : _commentUseCase = commentUseCase,
       _documentId = documentId,
       super(DocumentCommentInitial()) {
    on<CommentRequested>((event, emit) async {
      try {
        await _commentUseCase(_documentId, event.content);
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
