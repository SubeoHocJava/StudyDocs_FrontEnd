import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/notification_remote_datasource.dart';
import 'package:studydocs/data/model/cursor_pagination_result.dart';
import 'package:studydocs/data/model/notification.dart';
import 'package:studydocs/data/model/notification_metadata.dart';

class NotificationDataSourceImpl implements NotificationDataSource {
  final String path = "/notifications";
  final DioClient dioClient;

  NotificationDataSourceImpl({required this.dioClient});

  @override
  Future<CursorPaginationResult<Notification>> getNotifications(
      dynamic cursor,
      bool isDeleted,
      ) async {
    final Map<String, dynamic> queryParams = {
      "isDeleted": isDeleted,
      "limit": 10,
    };
    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }

    final apiResponse = await dioClient.get(
      path,
      queryParameters: queryParams,
    );

    return CursorPaginationResult.fromJson(
      apiResponse.data,
          (json) => Notification.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final apiResponse = await dioClient.get("$path/count-unread");
    return apiResponse.data is int
        ? apiResponse.data
        : int.parse(apiResponse.data.toString());
  }

  @override
  Future<void> softDelete(List<String> notificationIds) async {
    await dioClient.delete("$path/soft", data: {"notificationIds": notificationIds});
  }

  @override
  Future<void> hardDelete(List<String> notificationIds) async {
    await dioClient.delete("$path/hard", data: {"notificationIds": notificationIds});
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await dioClient.patch("$path/$notificationId/read");
  }

  @override
  Future<void> markAllAsRead() async {
    await dioClient.patch("$path/read-all");
  }

  @override
  Future<void> restore(List<String> notificationIds) async {
    await dioClient.patch(
      "$path/restore",
      data: {"notificationIds": notificationIds},
    );
  }

  @override
  Future<List<NotificationMetadata>> getMetadata() async {
    final apiResponse = await dioClient.get("$path/metadata");
    final list = apiResponse.data as List;
    return list.map((e) => NotificationMetadata.fromJson(e)).toList();
  }

  @override
  Future<void> registerFcmToken(String token) async {
    await dioClient.post(
      "$path/user-profiles/fcm-tokens",
      data: {"fcmToken": token},
    );
  }
}
