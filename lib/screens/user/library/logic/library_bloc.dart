import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';
import 'package:studydocs/screens/user/library/logic/library_event.dart';
import 'package:studydocs/screens/user/library/logic/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _repository;

  LibraryBloc({
    required LibraryRepository repository,
  })  : _repository = repository,
        super(const LibraryInitial()) {
    on<LibraryRequested>(_onRequested);
  }

  Future<void> _onRequested(
    LibraryRequested event,
    Emitter<LibraryState> emit,
  ) async {
    emit(const LibraryLoading());
    try {
      final data = await _repository.getLibraryPage();
      emit(LibraryLoaded(data));
    } catch (error) {
      emit(LibraryFailure(error.toString()));
    }
  }
}
