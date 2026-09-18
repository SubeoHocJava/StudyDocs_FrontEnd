import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_event.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_state.dart';

class LibrarySubjectBloc
    extends Bloc<LibrarySubjectEvent, LibrarySubjectState> {
  final LibraryRepository _repository;

  LibrarySubjectBloc({
    required LibraryRepository repository,
  })  : _repository = repository,
        super(const LibrarySubjectInitial()) {
    on<LibrarySubjectRequested>(_onRequested);
  }

  Future<void> _onRequested(
    LibrarySubjectRequested event,
    Emitter<LibrarySubjectState> emit,
  ) async {
    emit(const LibrarySubjectLoading());
    try {
      final data = await _repository.getLibrarySubjectPage(event.subjectId);
      emit(LibrarySubjectLoaded(data));
    } catch (error) {
      emit(LibrarySubjectFailure(error.toString()));
    }
  }
}
