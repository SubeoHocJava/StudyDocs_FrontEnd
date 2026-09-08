import 'package:studydocs/data/datasource/notification_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/notification_remote_datasource_impl.dart';
import 'package:studydocs/data/model/notification_model.dart';
import 'package:studydocs/screens/notification/domain/repository/notification_repository.dart';

class NotificationRemoteRepository implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRemoteRepository([NotificationRemoteDataSource? dataSource])
      : _dataSource = dataSource ?? NotificationRemoteDataSourceImpl();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final responseData = await _dataSource.getNotifications();
      if (responseData != null) {
        final dataList = _extractList(responseData);
        if (dataList != null) {
          return dataList.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return NotificationModel(
              id: map['id']?.toString() ?? '',
              title: map['title']?.toString() ?? 'Thông báo',
              content: map['content']?.toString() ?? '',
              avatarUrl: 'https://i.pravatar.cc/150?u=${map['id']}', // mock avatar since backend doesn't provide
              receivedAt: _parseDate(map['createdAt']?.toString()),
              type: NotificationType.system, // default since backend doesn't provide type
              isRead: map['isRead'] as bool? ?? false,
              isDeleted: false,
            );
          }).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<NotificationModel>> getTrashNotifications() async {
    try {
      final responseData = await _dataSource.getTrashNotifications();
      if (responseData != null) {
        final dataList = _extractList(responseData);
        if (dataList != null) {
          return dataList.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return NotificationModel(
              id: map['id']?.toString() ?? '',
              title: map['title']?.toString() ?? 'Thông báo',
              content: map['content']?.toString() ?? '',
              avatarUrl: 'https://i.pravatar.cc/150?u=${map['id']}',
              receivedAt: _parseDate(map['createdAt']?.toString()),
              type: NotificationType.system,
              isRead: map['isRead'] as bool? ?? false,
              isDeleted: true,
            );
          }).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _dataSource.markAsRead(id);
    } catch (_) {}
  }

  @override
  Future<void> moveToTrash(String id) async {
    try {
      await _dataSource.deleteNotification(id);
    } catch (_) {}
  }

  @override
  Future<void> restoreFromTrash(String id) async {
    try {
      await _dataSource.restoreNotification(id);
    } catch (_) {}
  }

  @override
  Future<void> deletePermanently(String id) async {
    try {
      await _dataSource.hardDeleteNotification(id);
    } catch (_) {}
  }

  @override
  Future<void> moveToTarget(String id, String targetId) async {
    // Not supported
  }

  @override
  Future<void> markAllAsRead() async {
    // Not supported by backend as a single API, could iterate but maybe too many requests.
    // Assuming backend will add it later, doing nothing for now or calling a non-existent API
  }

  @override
  Future<void> deleteAllPermanently() async {
    // Not supported
  }

  @override
  Future<void> restoreAllFromTrash() async {
    // Not supported
  }

  List? _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['items'] is List) return responseData['items'] as List;
      if (responseData['data'] is List) return responseData['data'] as List;
      if (responseData['data'] is Map && responseData['data']['items'] is List) {
        return responseData['data']['items'] as List;
      }
    }
    return null;
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }
}
