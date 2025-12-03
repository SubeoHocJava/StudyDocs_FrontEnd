import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/notification.dart';

abstract interface class NotificationDataSource {
  Future<List<Notification>> getNotifications(
    DateTime receivedAt,
    bool isDeleted,
  );

  Future<void> markAsRead(String notificationId);

  Future<void> softDelete(String notificationId);

  Future<void> hardDelete(String notificationId);

  Future<void> markAllAsRead();
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final String path = "/notifications";
  final DioClient dioClient;

  NotificationDataSourceImpl({required this.dioClient});

  @override
  Future<List<Notification>> getNotifications(
    DateTime receivedAt,
    bool isDeleted,
  ) async {
    final apiResponse = await dioClient.get(
      path,
      queryParameters: {"isDeleted": isDeleted, "limit": 10},
    );
    final list = apiResponse.data as List;

    return list.map((e) => Notification.fromJson(e)).toList();
  }

  @override
  Future<void> softDelete(String notificationId) async {
    dioClient.delete("$path/$notificationId/soft");
  }

  @override
  Future<void> hardDelete(String notificationId) async {
    dioClient.delete("$path/$notificationId/hard");

  }

  @override
  Future<void> markAsRead(String notificationId) async {
    dioClient.patch("$path/$notificationId/read");
  }

  @override
  Future<void> markAllAsRead() async {
    dioClient.patch("$path/read-all");
  }
}
