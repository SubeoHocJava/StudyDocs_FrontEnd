import 'package:equatable/equatable.dart';

/// Base class for all Statistic events
abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load download statistics
class LoadDownloadStatisticsEvent extends StatisticEvent {
  const LoadDownloadStatisticsEvent();
}

/// Event to refresh download statistics
class RefreshDownloadStatisticsEvent extends StatisticEvent {
  const RefreshDownloadStatisticsEvent();
}
