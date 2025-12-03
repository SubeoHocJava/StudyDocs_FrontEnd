import 'dart:convert';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/api_response.dart';
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
  Future<void> markAsRead(String notificationId) async {}

  @override
  Future<List<Notification>> getNotifications(
    DateTime receivedAt,
    bool isDeleted,
  ) async {
    final response = await dioClient.get(
      "notifications",
      queryParameters: {
        "isDeleted": isDeleted,
        "limit": 10
      },
    );
    dynamic responseData = response.data;
    if (responseData is String) {
      responseData = jsonDecode(responseData);
    }
    final apiResponse = ApiResponse.fromJson(
      responseData,
      (data) => (data as List?)
              ?.map((item) => Notification.fromJson(item))
              .toList() ??
          [],
    );
    return apiResponse.data;
  }

  @override
  Future<void> softDelete(String notificationId) async {}

  @override
  Future<void> hardDelete(String notificationId) async {}

  @override
  Future<void> markAllAsRead() async {
    dioClient.post(path);
  }
}
