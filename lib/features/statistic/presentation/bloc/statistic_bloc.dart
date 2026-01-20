import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../data/datasource/impl/statistic_remote_datasource_impl.dart';
import '../../domain/repositories/impl/statistic_repository_impl.dart';
import '../../domain/usecases/get_download_statistics_usecase.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final GetStatisticsUseCase getStatisticsUseCase;

  StatisticBloc({required this.getStatisticsUseCase})
      : super(const StatisticInitial()) {
    on<LoadDownloadStatisticsEvent>(_onLoadStatistics);
    on<RefreshDownloadStatisticsEvent>(_onRefreshStatistics);
  }

  Future<void> _onLoadStatistics(
    LoadDownloadStatisticsEvent event,
    Emitter<StatisticState> emit,
  ) async {
    emit(const StatisticLoading());

    try {
      final statistics = await getStatisticsUseCase();
      emit(StatisticLoaded(statistics: statistics));
    } catch (e) {
      emit(StatisticError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshStatistics(
    RefreshDownloadStatisticsEvent event,
    Emitter<StatisticState> emit,
  ) async {
    try {
      final statistics = await getStatisticsUseCase();
      emit(StatisticLoaded(statistics: statistics));
    } catch (e) {
      emit(StatisticError(message: _getErrorMessage(e)));
    }
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ErrorMapper.map(int.tryParse(error.code ?? ''));
    }
    return ErrorMapper.map(500);
  }
}

// Temporary Factory for DI (until main.dart refactor)
StatisticBloc createStatisticBloc() {
  final dioClient = DioClient(); // Assuming DioClient is a singleton or safe to invoke
  final remoteDataSource = StatisticRemoteDataSourceImpl(dioClient: dioClient);
  final repository = StatisticRepositoryImpl(remoteDataSource: remoteDataSource);
  final useCase = GetStatisticsUseCase(repository: repository);

  return StatisticBloc(getStatisticsUseCase: useCase);
}
