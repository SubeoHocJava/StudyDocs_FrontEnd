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
  final bool isTrashMode;
  final List<String> selectedTrashIds;

  const NotificationLoaded({
    required this.activeNotifications,
    required this.trashNotifications,
    this.isTrashMode = false,
    this.selectedTrashIds = const [],
  });

  NotificationLoaded copyWith({
    List<NotificationModel>? activeNotifications,
    List<NotificationModel>? trashNotifications,
    bool? isTrashMode,
    List<String>? selectedTrashIds,
  }) {
    return NotificationLoaded(
      activeNotifications: activeNotifications ?? this.activeNotifications,
      trashNotifications: trashNotifications ?? this.trashNotifications,
      isTrashMode: isTrashMode ?? this.isTrashMode,
      selectedTrashIds: selectedTrashIds ?? this.selectedTrashIds,
    );
  }

  @override
  List<Object> get props => [activeNotifications, trashNotifications, isTrashMode, selectedTrashIds];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
