import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'data/datasource/notification_remote_datasource.dart';
import 'features/notification/domain/repository/impl/notification_repository.dart';
import 'features/notification/domain/repository/notification_repository.dart';
import 'features/notification/service/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dioClient = DioClient();
  final notificationDataSource = NotificationDataSourceImpl(dioClient: dioClient);
  final notificationRepository = NotificationRepositoryImpl(notificationDataSource);

  await FcmService().initialize(notificationRepository);
  runApp(
    RepositoryProvider<NotificationRepository>.value(
      value: notificationRepository,
      child: const MyApp(),
    ),
  );
}
