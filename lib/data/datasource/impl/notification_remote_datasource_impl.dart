import 'package:studydocs/core/network/dio_client.dart';
import '../notification_remote_datasource.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _client;

  NotificationRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getNotifications() async {
    final response = await _client.get('user/notifications');
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to load notifications');
  }

  @override
  Future<void> markAsRead(String id) async {
    final response = await _client.put('user/notifications/$id/read');
    if (!response.isSuccess) {
      throw Exception('Failed to mark as read');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final response = await _client.delete('user/notifications/$id');
    if (!response.isSuccess) {
      throw Exception('Failed to delete notification');
    }
  }

  @override
  Future<dynamic> getTrashNotifications() async {
    final response = await _client.get('user/notifications/trash');
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to load trash notifications');
  }

  @override
  Future<void> restoreNotification(String id) async {
    final response = await _client.put('user/notifications/$id/restore');
    if (!response.isSuccess) {
      throw Exception('Failed to restore notification');
    }
  }

  @override
  Future<void> hardDeleteNotification(String id) async {
    final response = await _client.delete('user/notifications/$id/hard-delete');
    if (!response.isSuccess) {
      throw Exception('Failed to permanently delete notification');
    }
  }
}
