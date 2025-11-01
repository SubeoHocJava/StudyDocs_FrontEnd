import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/api/notification_api.dart';
import 'package:studydocs/features/notification/data/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

import '../../../../screens/notification_trash_screen.dart';

class NotificationTrashPage extends StatelessWidget {
  final String userId;

  const NotificationTrashPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              NotificationBloc(NotificationRepository(NotificationApi()))
                ..add(LoadNotificationEvent(DateTime.now(), true)),
      child: NotificationTrashScreen(userId: userId),
    );
  }
}
