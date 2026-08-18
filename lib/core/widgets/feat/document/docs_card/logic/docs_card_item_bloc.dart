import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/bookmark_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/download_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/usecase/like_document_usecase.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_event.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/docs_card_item_state.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class DocsCardItemBloc extends Bloc<DocsCardItemEvent, DocsCardItemState> {
  final LikeDocumentUseCase _likeUseCase;
  final BookmarkDocumentUseCase _bookmarkUseCase;
  final DownloadDocumentUseCase _downloadUseCase;

  DocsCardItemBloc({
    required LikeDocumentUseCase likeUseCase,
    required BookmarkDocumentUseCase bookmarkUseCase,
    required DownloadDocumentUseCase downloadUseCase,
    required DocumentSummaryModel initialDoc,
  })  : _likeUseCase = likeUseCase,
        _bookmarkUseCase = bookmarkUseCase,
        _downloadUseCase = downloadUseCase,
        super(DocsCardItemState(doc: initialDoc)) {
    on<CardLiked>(_onLiked);
    on<CardBookmarked>(_onBookmarked);
    on<CardDownloaded>(_onDownloaded);
    on<CardErrorCleared>((event, emit) {
      emit(state.copyWith(lastError: null));
    });
  }

  Future<void> _onLiked(
    CardLiked event,
    Emitter<DocsCardItemState> emit,
  ) async {
    final previous = state.doc;
    final nextIsLiked = !previous.isLiked;
    emit(
      state.copyWith(
        doc: previous.copyWith(
          isLiked: nextIsLiked,
          likeCount: previous.likeCount + (nextIsLiked ? 1 : -1),
        ),
      ),
    );

    final errorCode = await _likeUseCase(previous.id);
    if (errorCode != null) {
      emit(state.copyWith(
        doc: previous,
        lastError: ErrorMapper.map(errorCode, defaultMessage: 'Like không thành công'),
      ));
    }
  }

  Future<void> _onBookmarked(
    CardBookmarked event,
    Emitter<DocsCardItemState> emit,
  ) async {
    final previous = state.doc;
    emit(
      state.copyWith(
        doc: previous.copyWith(isBookmarked: !previous.isBookmarked),
      ),
    );

    final errorCode = await _bookmarkUseCase(previous.id);
    if (errorCode != null) {
      emit(state.copyWith(
        doc: previous,
        lastError: ErrorMapper.map(errorCode, defaultMessage: 'Lưu không thành công'),
      ));
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
