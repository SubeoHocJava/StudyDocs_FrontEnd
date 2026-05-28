import 'package:studydocs/data/model/user/User.dart';

abstract class FollowEvent {}

class LoadFollowDataEvent extends FollowEvent {
  final User user;
  LoadFollowDataEvent(this.user);
}
