import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_document_usecase.dart';
import '../domain/usecase/toggle_save_usecase.dart';
import 'docs_event.dart';
import 'docs_state.dart';

/// BLoC quản lý luồng dữ liệu của Document Details.
/// Gồm 2 hành vi:
/// 1. Load chi tiết tài liệu
/// 2. Toggle trạng thái lưu tài liệu
class DocsBloc extends Bloc<DocsEvent, DocsState> {
  final GetDocumentUseCase getDocumentUseCase;
  final ToggleSaveUseCase toggleSaveUseCase;

  DocsBloc({
    required this.getDocumentUseCase,
    required this.toggleSaveUseCase,
  }) : super(DocsInitial()) {
    /// Đăng ký xử lý event
    on<LoadDocDetails>(_onLoadDocDetails);
    on<ToggleSave>(_onToggleSave);
  }

  /// Xử lý event: LoadDocDetails
  Future<void> _onLoadDocDetails(
      LoadDocDetails event,
      Emitter<DocsState> emit,
      ) async {
    emit(DocsLoading());
    try {
      final doc = await getDocumentUseCase();
      emit(DocsLoaded(doc));
    } catch (e) {
      emit(DocsError(e.toString()));
    }
  }

  /// Xử lý event: ToggleSave
  Future<void> _onToggleSave(
      ToggleSave event,
      Emitter<DocsState> emit,
      ) async {
    if (state is DocsLoaded) {
      final current = state as DocsLoaded;

      // Call use case
      await toggleSaveUseCase();

      // Emit lại state mới với isSaved đã đổi
      emit(DocsLoaded(
        current.docDetails,
        isSaved: !current.isSaved,
      ));
    }
  }
}
