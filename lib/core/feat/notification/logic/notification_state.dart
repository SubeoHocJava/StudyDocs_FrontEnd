import 'package:equatable/equatable.dart';
import '../domain/entity/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> activeNotifications;
  final List<NotificationModel> trashNotifications;

  const NotificationLoaded({
    required this.activeNotifications,
    required this.trashNotifications,
  });

  @override
  List<Object> get props => [activeNotifications, trashNotifications];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
