import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repository/explore_repository.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final ExploreRepository repository;

  ExploreBloc({required this.repository}) : super(ExploreInitial()) {
    on<FetchExploreDataEvent>(_onFetchExploreData);
    on<SearchExploreEvent>(_onSearch);
  }

  Future<void> _onFetchExploreData(FetchExploreDataEvent event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    try {
      final data = await repository.getExploreData();
      emit(ExploreLoaded(data));
    } catch (e) {
      emit(ExploreError("Đã có lỗi xảy ra khi tải dữ liệu khám phá"));
    }
  }

  Future<void> _onSearch(SearchExploreEvent event, Emitter<ExploreState> emit) async {
    if (event.query.trim().isEmpty) {
      // Khi xoá hết query → quay lại trang khám phá
      add(FetchExploreDataEvent());
      return;
    }
    emit(ExploreSearching());
    try {
      final results = await repository.searchDocuments(event.query.trim());
      emit(ExploreSearchResult(query: event.query.trim(), results: results));
    } catch (e) {
      emit(ExploreError("Không thể tìm kiếm, vui lòng thử lại"));
    }
  }
}
