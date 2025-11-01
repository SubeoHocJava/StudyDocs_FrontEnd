import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification/models/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final List<AppNotification> notifications;

  const NotificationLoadedState(this.notifications);

  @override
  List<Object?> get props => [notifications];

}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
