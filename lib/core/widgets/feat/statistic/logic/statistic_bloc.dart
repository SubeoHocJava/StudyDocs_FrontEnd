import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_statistic_usecase.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';


class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final GetStatisticUseCase getStatisticUseCase;

  StatisticBloc({required this.getStatisticUseCase}) : super(StatisticInitial()) {
    on<LoadStatisticData>(_onLoadStatisticData);
  }

  Future<void> _onLoadStatisticData(
    LoadStatisticData event,
    Emitter<StatisticState> emit,
  ) async {
    emit(StatisticLoading());
    try {
      final data = await getStatisticUseCase();
      emit(StatisticLoaded(data));
    } catch (e) {
      emit(StatisticError(e.toString()));
    }
  }
}
