import 'package:equatable/equatable.dart';
import '../../domain/entity/download_statistic_entity.dart';

/// Base class for all Statistic states
abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class StatisticInitial extends StatisticState {
  const StatisticInitial();
}

/// State when statistics are being loaded
class StatisticLoading extends StatisticState {
  const StatisticLoading();
}

/// State when statistics are successfully loaded
class StatisticLoaded extends StatisticState {
  final List<DownloadStatisticEntity> statistics;

  const StatisticLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

/// State when there's an error loading statistics
class StatisticError extends StatisticState {
  final String message;

  const StatisticError({required this.message});

  @override
  List<Object?> get props => [message];
}
