import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import '../domain/usecase/toggle_like_usecase.dart';
import 'docs_event.dart';
import 'docs_state.dart';

class DocsBloc extends Bloc<DocsEvent, DocsState> {
  final GetDocumentUseCase getDocumentUseCase;
  final ToggleSaveUseCase toggleSaveUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;

  DocsBloc({
    required this.getDocumentUseCase,
    required this.toggleSaveUseCase,
    required this.toggleLikeUseCase,
  }) : super(DocsInitial()) {
    on<LoadDocDetails>(_onLoadDocDetails);
    on<ToggleSave>(_onToggleSave);
    on<ToggleDocumentLike>(_onToggleDocumentLike);
  }

  Future<void> _onLoadDocDetails(
      LoadDocDetails event,
      Emitter<DocsState> emit,
      ) async {
    emit(DocsLoading());
    try {
      final doc = await getDocumentUseCase();
      emit(DocsLoaded(doc as DocumentEntity));
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
      await toggleSaveUseCase();
      emit(DocsLoaded(
        current.docDetails,
        isSaved: !current.isSaved,
      ));
    }
  }

  Future<void> _onToggleDocumentLike(
      ToggleDocumentLike event,
      Emitter<DocsState> emit,
      ) async {
    if (state is DocsLoaded) {
      final current = state as DocsLoaded;
      final doc = current.docDetails;

      // Optimistic update
      final newLikes = event.isLike ? doc.likes + 1 : doc.likes;
      final newDislikes = event.isLike ? doc.dislikes : doc.dislikes + 1;

      emit(DocsLoaded(
        doc.copyWith(likes: newLikes, dislikes: newDislikes),
        isSaved: current.isSaved,
      ));

      try {
        await toggleLikeUseCase(isLike: event.isLike);
      } catch (e) {
        // Revert nếu lỗi
        emit(DocsLoaded(doc, isSaved: current.isSaved));
        emit(DocsError("Không thể đánh giá: $e"));
      }
    }
  }
}