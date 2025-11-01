import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationEvent extends NotificationEvent {
  final DateTime createdAt;
  final bool isDeleted;

  const LoadNotificationEvent(this.createdAt, this.isDeleted);

  @override
  List<Object?> get props => [createdAt, isDeleted];
}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsReadEvent extends NotificationEvent {}

enum DeleteType { soft, hard }

//Delete
class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  final DeleteType type;

  const DeleteNotificationEvent(this.notificationId, this.type);

  @override
  List<Object?> get props => [notificationId];
}
