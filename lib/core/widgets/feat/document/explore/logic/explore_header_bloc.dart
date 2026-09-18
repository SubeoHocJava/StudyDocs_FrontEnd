import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/explore/logic/explore_header_event.dart';
import 'package:studydocs/core/widgets/feat/document/explore/logic/explore_header_state.dart';

class ExploreHeaderBloc extends Bloc<ExploreHeaderEvent, ExploreHeaderState> {
  ExploreHeaderBloc({
    required String initialSchoolName,
    required String initialSubjectName,
    required int initialDocumentCount,
    required int initialUserCount,
    String initialSearchText = '',
  }) : super(
          ExploreHeaderState(
            schoolName: initialSchoolName,
            subjectName: initialSubjectName,
            documentCount: initialDocumentCount,
            userCount: initialUserCount,
            searchText: initialSearchText,
          ),
        ) {
    on<ExploreHeaderInitialized>(_onInitialized);
    on<ExploreSchoolNameChanged>((event, emit) {
      emit(state.copyWith(schoolName: event.value));
    });
    on<ExploreSubjectNameChanged>((event, emit) {
      emit(state.copyWith(subjectName: event.value));
    });
    on<ExploreCountsChanged>((event, emit) {
      emit(
        state.copyWith(
          documentCount: event.documentCount,
          userCount: event.userCount,
        ),
      );
    });
    on<ExploreSearchChanged>((event, emit) {
      emit(state.copyWith(searchText: event.value));
    });
  }

  void _onInitialized(
    ExploreHeaderInitialized event,
    Emitter<ExploreHeaderState> emit,
  ) {
    emit(
      state.copyWith(
        schoolName: event.schoolName,
        subjectName: event.subjectName,
        documentCount: event.documentCount,
        userCount: event.userCount,
        searchText: event.searchText,
      ),
    );
  }
}
