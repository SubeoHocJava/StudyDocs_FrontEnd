import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';

// States cho NotificationBloc — biểu diễn các trạng thái UI khác nhau.
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu (chưa load dữ liệu)
class NotificationInitialState extends NotificationState {}

// Đang tải dữ liệu
class NotificationLoadingState extends NotificationState {}

// Đã tải xong: chứa danh sách notifications
class NotificationLoadedState extends NotificationState {
  final List<NotificationEntity> activeNotifications;
  final List<NotificationEntity> deletedNotifications;
  final int unreadCount;
  final dynamic nextCursor;
  final bool hasNext;

  const NotificationLoadedState(
    this.activeNotifications, {
    this.deletedNotifications = const [],
    this.unreadCount = 0,
    this.nextCursor,
    this.hasNext = false,
  });

  @override
  List<Object?> get props => [activeNotifications, deletedNotifications, unreadCount, nextCursor, hasNext];

  NotificationLoadedState copyWith({
    List<NotificationEntity>? activeNotifications,
    List<NotificationEntity>? deletedNotifications,
    int? unreadCount,
    dynamic nextCursor,
    bool? hasNext,
  }) {
    return NotificationLoadedState(
      activeNotifications ?? this.activeNotifications,
      deletedNotifications: deletedNotifications ?? this.deletedNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
      nextCursor: nextCursor ?? this.nextCursor,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
