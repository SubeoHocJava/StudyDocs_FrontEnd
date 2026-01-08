import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/features/notification/domain/usecase/register_fcm_token_usecase.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  factory FcmService() => _instance;

  FcmService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  late final RegisterFcmTokenUseCase _registerFcmTokenUseCase;

  late final AndroidNotificationChannel _channel;

  /// Khởi tạo FCM: xin quyền và đăng ký các listener
  Future<void> initialize(NotificationRepository repository) async {
    _registerFcmTokenUseCase = RegisterFcmTokenUseCase(repository);

    // Initialize local notifications
    _channel = const AndroidNotificationChannel(
      'studydocs_notifications', // id
      'StudyDocs Notifications', // title
      description: 'Channel for StudyDocs notifications',
      importance: Importance.max,
    );

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      // Optionally handle notification tap when app is in foreground/background
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        try {
          if (response.payload != null && response.payload!.isNotEmpty) {
            final data = jsonDecode(response.payload!);
            log('[FCM] Local notification tapped with payload: $data');
            // You can expose a callback or use a navigator key to navigate here
          }
        } catch (e) {
          log('[FCM] Error handling notification tap: $e');
        }
      },
    );

    // Create channel for Android
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);

    // 1. Xin quyền thông báo
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    // 2. Lấy Token hiện tại
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _registerToken(token);
      }
    } catch (e) {
      log('[FCM] Error getting token: $e');
    }

    // 3. Lắng nghe sự thay đổi Token
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _registerToken(newToken);
    });

    // 4. Lắng nghe tin nhắn khi App (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('[FCM] Received foreground message: ${message.notification?.title}');

      if (message.notification != null) {
        // Show a local notification
        await _showLocalNotification(message);
      }
    });

    // Xử lý khi user tap vào thông báo từ background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('[FCM] Message clicked! ${message.messageId}');
      // Điều hướng user tới màn hình tương ứng if needed
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notif = message.notification;
      final title = notif?.title ?? '';
      final body = notif?.body ?? '';
      final id = message.hashCode & 0x7fffffff;
      final payload = jsonEncode(message.data);

      final androidDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      final iosDetails = DarwinNotificationDetails();

      final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _localNotifications.show(id, title, body, details, payload: payload);
    } catch (e) {
      log('[FCM] Failed to show local notification: $e');
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _registerFcmTokenUseCase(token);
    } catch (e) {
      log('[FCM] Failed to register token with server: $e');
    }
  }

  /// Lấy token thủ công nếu cần
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
