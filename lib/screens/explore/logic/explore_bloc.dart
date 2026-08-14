import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_explore_data_usecase.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExploreDataUseCase getExploreData;

  ExploreBloc({required this.getExploreData}) : super(ExploreInitial()) {
    on<FetchExploreDataEvent>(_onFetchExploreData);
  }

  Future<void> _onFetchExploreData(FetchExploreDataEvent event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    try {
      final data = await getExploreData();
      emit(ExploreLoaded(data));
    } catch (e) {
      emit(ExploreError("Đã có lỗi xảy ra khi tải dữ liệu khám phá"));
    }
  }
}
