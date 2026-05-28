import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/profile/statistic/data/repositories/mock_statistic_repository_impl.dart';
import 'package:studydocs/core/widgets/feat/profile/statistic/domain/repositories/statistic_repository.dart';
import '../domain/entities/statistic_entity.dart';
import '../domain/usecases/get_statistic_usecase.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';


class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  late final   StatisticRepository _repository;
 late final GetStatisticUseCase getStatisticUseCase;

  StatisticBloc() : super(StatisticInitial()) {
    _repository = MockStatisticRepositoryImpl();
    getStatisticUseCase= GetStatisticUseCase(_repository);
    on<LoadStatisticData>(_onLoadStatisticData);
  }

  Future<void> _onLoadStatisticData(
    LoadStatisticData event,
    Emitter<StatisticState> emit,
  ) async {
    emit(StatisticLoading());
    try {
      final user = event.user;
      final data = StatisticEntity(
        totalDocuments: user.postsCount,
        totalLikes: user.likesCount,
        totalComments: user.commentsCount,
      );
      emit(StatisticLoaded(data));
    } catch (e) {
      emit(StatisticError(e.toString()));
    }
  }
}
