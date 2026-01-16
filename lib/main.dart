import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/datasource/impl/notification_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/notification_template_remote_datasource_impl.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'features/notification/domain/repository/impl/notification_repository.dart';
import 'features/notification/domain/repository/notification_repository.dart';
import 'features/notification/service/fcm_service.dart';
import 'features/notification_template/data/repository/notification_template_repository_impl.dart';
import 'features/notification_template/domain/repository/notification_template_repository.dart';
import 'features/notification_template/domain/repository/notification_template_repository.dart';
import 'firebase_options.dart';

import 'data/datasource/docs_management_remote_datasource.dart';
import 'features/docs_management/data/repository/docs_management_repository_impl.dart';
import 'features/docs_management/domain/repository/docs_management_repository.dart';
import 'data/datasource/docs_remote_datasource.dart';
import 'features/docs/data/repository/docs_repository_impl.dart';
import 'features/docs/domain/repository/docs_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dioClient = DioClient();
  final notificationDataSource = NotificationDataSourceImpl(dioClient: dioClient);
  final notificationRepository = NotificationRepositoryImpl(notificationDataSource);

  final notificationTemplateDataSource = NotificationTemplateDataSourceImpl(dioClient: dioClient);
  final notificationTemplateRepository = NotificationTemplateRepositoryImpl(dataSource: notificationTemplateDataSource);

  // Docs Management
  final docsMgmtDataSource = DocsManagementRemoteDataSourceImpl(dioClient: dioClient);
  final docsMgmtRepository = DocsManagementRepositoryImpl(dataSource: docsMgmtDataSource);

  // Docs Viewing (Public)
  final docsDataSource = DocsRemoteDataSourceImpl(dioClient: dioClient);
  final docsRepository = DocsRepositoryImpl(dataSource: docsDataSource);

  FcmService().initialize(notificationRepository);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DioClient>.value(
          value: dioClient,
        ),
        RepositoryProvider<NotificationRepository>.value(
          value: notificationRepository,
        ),
        RepositoryProvider<NotificationTemplateRepository>.value(
          value: notificationTemplateRepository,
        ),
        RepositoryProvider<DocsManagementRepository>.value(
          value: docsMgmtRepository,
        ),
        RepositoryProvider<DocsRepository>.value(
          value: docsRepository,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
