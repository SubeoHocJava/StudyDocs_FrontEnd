import 'package:equatable/equatable.dart';
import '../../domain/entity/statistic_entity.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object?> get props => [];
}

class StatisticInitial extends StatisticState {
  const StatisticInitial();
}

class StatisticLoading extends StatisticState {
  const StatisticLoading();
}

class StatisticLoaded extends StatisticState {
  final StatisticEntity statistics;

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
