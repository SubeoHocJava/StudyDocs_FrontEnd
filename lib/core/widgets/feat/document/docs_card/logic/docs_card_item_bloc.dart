import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/bookmark_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_event.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_state.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/document_sync_cubit.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class DocsCardItemBloc extends Bloc<DocsCardItemEvent, DocsCardItemState> {
  final LikeDocumentUseCase _likeUseCase;
  final BookmarkDocumentUseCase _bookmarkUseCase;
  final DownloadDocumentUseCase _downloadUseCase;
  final DocumentSyncCubit? _syncCubit;
  StreamSubscription? _syncSubscription;

  DocsCardItemBloc({
    required LikeDocumentUseCase likeUseCase,
    required BookmarkDocumentUseCase bookmarkUseCase,
    required DownloadDocumentUseCase downloadUseCase,
    required DocumentSummaryModel initialDoc,
    DocumentSyncCubit? syncCubit,
  })  : _likeUseCase = likeUseCase,
        _bookmarkUseCase = bookmarkUseCase,
        _downloadUseCase = downloadUseCase,
        _syncCubit = syncCubit,
        super(DocsCardItemState(doc: initialDoc)) {
    on<CardLiked>(_onLiked);
    on<CardBookmarked>(_onBookmarked);
    on<CardDownloaded>(_onDownloaded);
    on<CardErrorCleared>((event, emit) {
      emit(state.copyWith(lastError: null));
    });
    on<CardSyncUpdated>((event, emit) {
      emit(state.copyWith(
        doc: state.doc.copyWith(
          isBookmarked: event.isBookmarked ?? state.doc.isBookmarked,
          isLiked: event.isLiked ?? state.doc.isLiked,
          likeCount: event.newLikeCount ?? state.doc.likeCount,
          commentCount: event.newCommentCount ?? state.doc.commentCount,
        ),
      ));
    });

    _syncSubscription = _syncCubit?.stream.listen((syncState) {
      final lastEvent = syncState.lastEvent;
      if (lastEvent is DocumentBookmarkToggled && lastEvent.documentId == initialDoc.id) {
        if (lastEvent.isBookmarked != state.doc.isBookmarked) {
          add(CardSyncUpdated(isBookmarked: lastEvent.isBookmarked));
        }
      } else if (lastEvent is DocumentLikeToggled && lastEvent.documentId == initialDoc.id) {
        if (lastEvent.isLiked != state.doc.isLiked) {
          add(CardSyncUpdated(isLiked: lastEvent.isLiked, newLikeCount: lastEvent.newLikeCount));
        }
      } else if (lastEvent is DocumentCommentCountUpdated && lastEvent.documentId == initialDoc.id) {
        if (lastEvent.newCommentCount != state.doc.commentCount) {
          add(CardSyncUpdated(newCommentCount: lastEvent.newCommentCount));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLiked(
    CardLiked event,
    Emitter<DocsCardItemState> emit,
  ) async {
    final previous = state.doc;
    final nextIsLiked = !previous.isLiked;
    final nextLikeCount = previous.likeCount + (nextIsLiked ? 1 : -1);
    
    emit(
      state.copyWith(
        doc: previous.copyWith(
          isLiked: nextIsLiked,
          likeCount: nextLikeCount,
        ),
      ),
    );
    
    _syncCubit?.toggleLike(previous.id, nextIsLiked, nextLikeCount);

    final errorCode = await _likeUseCase(previous.id);
    if (errorCode != null) {
      emit(state.copyWith(
        doc: previous,
        lastError: ErrorMapper.map(errorCode, defaultMessage: 'Like không thành công'),
      ));
      _syncCubit?.toggleLike(previous.id, previous.isLiked, previous.likeCount);
    }
  }

  Future<void> _onBookmarked(
    CardBookmarked event,
    Emitter<DocsCardItemState> emit,
  ) async {
    final previous = state.doc;
    final nextIsBookmarked = !previous.isBookmarked;
    emit(
      state.copyWith(
        doc: previous.copyWith(isBookmarked: nextIsBookmarked),
      ),
    );
    
    _syncCubit?.toggleBookmark(previous.id, nextIsBookmarked);

    final errorCode = await _bookmarkUseCase(previous.id);
    if (errorCode != null) {
      emit(state.copyWith(
        doc: previous,
        lastError: ErrorMapper.map(errorCode, defaultMessage: 'Lưu không thành công'),
      ));
      _syncCubit?.toggleBookmark(previous.id, previous.isBookmarked);
    }
  }

  Future<void> _onDownloaded(
    CardDownloaded event,
    Emitter<DocsCardItemState> emit,
  ) async {
    final errorCode = await _downloadUseCase(state.doc.id);
    if (errorCode != null) {
      emit(state.copyWith(
        lastError: ErrorMapper.map(errorCode, defaultMessage: 'Tải không thành công'),
      ));
    }
  }

  void clearError() => add(const CardErrorCleared());
}
