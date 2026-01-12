import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/datasource/statistic_remote_datasource.dart';
import '../../domain/repositories/impl/statistic_repository_impl.dart';
import '../../domain/usecases/get_download_statistics_usecase.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';

/// BLoC for managing statistics feature state
/// Handles loading and refreshing download statistics
class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final GetDownloadStatisticsUseCase getDownloadStatisticsUseCase;

  StatisticBloc({required this.getDownloadStatisticsUseCase})
      : super(const StatisticInitial()) {
    on<LoadDownloadStatisticsEvent>(_onLoadDownloadStatistics);
    on<RefreshDownloadStatisticsEvent>(_onRefreshDownloadStatistics);
  }

  /// Handle loading download statistics
  Future<void> _onLoadDownloadStatistics(
    LoadDownloadStatisticsEvent event,
    Emitter<StatisticState> emit,
  ) async {
    emit(const StatisticLoading());

    try {
      final statistics = await getDownloadStatisticsUseCase();
      emit(StatisticLoaded(statistics: statistics));
    } catch (e) {
      emit(StatisticError(message: e.toString()));
    }
  }

  /// Handle refreshing download statistics
  Future<void> _onRefreshDownloadStatistics(
    RefreshDownloadStatisticsEvent event,
    Emitter<StatisticState> emit,
  ) async {
    // Don't show loading state on refresh (better UX)
    try {
      final statistics = await getDownloadStatisticsUseCase();
      emit(StatisticLoaded(statistics: statistics));
    } catch (e) {
      emit(StatisticError(message: e.toString()));
    }
  }
}

/// Helper function to create StatisticBloc with all dependencies
/// Following the same pattern as createHomeBloc()
StatisticBloc createStatisticBloc() {
  final remoteDataSource = StatisticRemoteDataSource();
  final repository = StatisticRepositoryImpl(remoteDataSource: remoteDataSource);
  final useCase = GetDownloadStatisticsUseCase(repository: repository);

  return StatisticBloc(getDownloadStatisticsUseCase: useCase);
}
