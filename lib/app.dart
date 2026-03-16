import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/feat/notification/logic/notification_bloc.dart';
import 'package:studydocs/core/feat/notification/logic/notification_event.dart';
import 'package:studydocs/core/feat/notification/logic/notification_state.dart';
import 'package:studydocs/core/feat/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/core/feat/notification/domain/repository/mock_notification_repository.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/delete_permanently_usecase.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/get_trash_notifications_usecase.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/mark_as_read_usecase.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/move_to_trash_usecase.dart';
import 'package:studydocs/core/feat/notification/domain/usecase/restore_from_trash_usecase.dart';
import 'package:studydocs/core/feat/notification/presentation/notification_presentation.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/active_notification_list.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_item.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_options_bottom_sheet.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/global_notification_options_bottom_sheet.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/trash_notification_list.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/trash_notification_item.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [RepositoryProvider<NotificationRepository>(create: (c) => MockNotificationRepositoryImpl())],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>(create: (c) => NotificationBloc(
              getNotifications: GetNotificationsUseCaseImpl(c.read<NotificationRepository>()),
              getTrashNotifications: GetTrashNotificationsUseCaseImpl(c.read<NotificationRepository>()),
              markAsReadUseCase: MarkAsReadUseCaseImpl(c.read<NotificationRepository>()),
              moveToTrashUseCase: MoveToTrashUseCaseImpl(c.read<NotificationRepository>()),
              restoreFromTrashUseCase: RestoreFromTrashUseCaseImpl(c.read<NotificationRepository>()),
              deletePermanentlyUseCase: DeletePermanentlyUseCaseImpl(c.read<NotificationRepository>()),
            )..add(FetchNotificationsEvent())),
          ],
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (c, state) {
              if (state is NotificationLoaded) {
                 return const NotificationPresentation();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          ),
        ),
      ),
    );
  }
}
