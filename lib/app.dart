import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/feat/notification/domain/repository/notification_repository.dart';
import 'core/feat/notification/domain/repository/mock_notification_repository.dart';
import 'core/feat/notification/domain/usecase/delete_permanently_usecase.dart';
import 'core/feat/notification/domain/usecase/get_notifications_usecase.dart';
import 'core/feat/notification/domain/usecase/get_trash_notifications_usecase.dart';
import 'core/feat/notification/domain/usecase/mark_as_read_usecase.dart';
import 'core/feat/notification/domain/usecase/move_to_trash_usecase.dart';
import 'core/feat/notification/domain/usecase/restore_from_trash_usecase.dart';
import 'core/feat/notification/logic/notification_bloc.dart';
import 'core/feat/notification/logic/notification_event.dart';
import 'core/feat/notification/presentation/notification_presentation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationRepository>(
            create: (context) => MockNotificationRepositoryImpl(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>(
              create: (context) => NotificationBloc(
                getNotifications: GetNotificationsUseCaseImpl(context.read<NotificationRepository>()),
                getTrashNotifications: GetTrashNotificationsUseCaseImpl(context.read<NotificationRepository>()),
                markAsReadUseCase: MarkAsReadUseCaseImpl(context.read<NotificationRepository>()),
                moveToTrashUseCase: MoveToTrashUseCaseImpl(context.read<NotificationRepository>()),
                restoreFromTrashUseCase: RestoreFromTrashUseCaseImpl(context.read<NotificationRepository>()),
                deletePermanentlyUseCase: DeletePermanentlyUseCaseImpl(context.read<NotificationRepository>()),
              )..add(FetchNotificationsEvent()),
            ),
          ],
          child: const NotificationPresentation(),
        ),
      ),
    );
  }
}