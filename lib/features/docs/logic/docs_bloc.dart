import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/docs_repository.dart';
import 'docs_event.dart';
import 'docs_state.dart';

class DocsBloc extends Bloc<DocsEvent, DocsState> {
  final DocsRepository repository;
  DocsBloc(this.repository) : super(DocsInitial()) {
    on<LoadDocDetails>((event, emit) async {
      emit(DocsLoading());
      try {
        final doc = await repository.getDocDetails();
        emit(DocsLoaded(doc));
      } catch (e) {
        emit(DocsError(e.toString()));
      }
    });

    on<ToggleSave>((event, emit) {
      final s = state;
      if (s is DocsLoaded) {
        emit(DocsLoaded(s.docDetails, isSaved: !s.isSaved));
      }
    });
  }
}
