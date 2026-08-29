import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/user/user.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];
}

class LoadStatisticData extends StatisticEvent {
  final User user;
  const LoadStatisticData(this.user);

  @override
  List<Object> get props => [user];
}
