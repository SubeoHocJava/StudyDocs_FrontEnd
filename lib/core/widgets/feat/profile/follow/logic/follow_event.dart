import 'package:studydocs/data/model/user/user.dart';

abstract class FollowEvent {}

class LoadFollowDataEvent extends FollowEvent {
  final User user;
  LoadFollowDataEvent(this.user);
}
