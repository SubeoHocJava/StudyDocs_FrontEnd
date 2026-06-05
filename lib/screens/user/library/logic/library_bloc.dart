import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/user/library/domain/usecase/get_library_page_usecase.dart';
import 'package:studydocs/screens/user/library/logic/library_event.dart';
import 'package:studydocs/screens/user/library/logic/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetLibraryPageUseCase _getLibraryPageUseCase;

  LibraryBloc({
    required GetLibraryPageUseCase getLibraryPageUseCase,
  })  : _getLibraryPageUseCase = getLibraryPageUseCase,
        super(const LibraryInitial()) {
    on<LibraryRequested>(_onRequested);
  }

  Future<void> _onRequested(
    LibraryRequested event,
    Emitter<LibraryState> emit,
  ) async {
    emit(const LibraryLoading());
    try {
      final data = await _getLibraryPageUseCase();
      emit(LibraryLoaded(data));
    } catch (error) {
      emit(LibraryFailure(error.toString()));
    }
  }
}
