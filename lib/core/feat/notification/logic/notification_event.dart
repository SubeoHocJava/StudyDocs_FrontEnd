import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String id;
  const MarkNotificationAsReadEvent(this.id);
  @override
  List<Object> get props => [id];
}

class MarkAllAsReadEvent extends NotificationEvent {}

class MoveAllToTrashEvent extends NotificationEvent {}

class MoveNotificationToTrashEvent extends NotificationEvent {
  final String id;
  const MoveNotificationToTrashEvent(this.id);
  @override
  List<Object> get props => [id];
}

class RestoreNotificationEvent extends NotificationEvent {
  final String id;
  const RestoreNotificationEvent(this.id);
  @override
  List<Object> get props => [id];
}

class DeleteNotificationPermanentlyEvent extends NotificationEvent {
  final String id;
  const DeleteNotificationPermanentlyEvent(this.id);
  @override
  List<Object> get props => [id];
}

// UI State Events
class ToggleTrashModeEvent extends NotificationEvent {}

class ToggleTrashSelectionEvent extends NotificationEvent {
  final String id;
  const ToggleTrashSelectionEvent(this.id);
  @override
  List<Object> get props => [id];
}

class RestoreAllSelectedEvent extends NotificationEvent {}

class DeleteAllSelectedEvent extends NotificationEvent {}
