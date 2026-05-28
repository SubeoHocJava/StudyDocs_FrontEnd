import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/user/User.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];
}

class LoadStatisticData extends StatisticEvent {
  final User user;
  LoadStatisticData(this.user);

  @override
  List<Object> get props => [user];
}
