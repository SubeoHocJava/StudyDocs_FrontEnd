import 'package:equatable/equatable.dart';

import '../domain/entities/statistic_entity.dart';


abstract class StatisticState extends Equatable {
  const StatisticState();
  
  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticLoaded extends StatisticState {
  final StatisticEntity statisticData;

  const StatisticLoaded(this.statisticData);

  @override
  List<Object> get props => [statisticData];
}

class StatisticError extends StatisticState {
  final String message;

  const StatisticError(this.message);

  @override
  List<Object> get props => [message];
}
