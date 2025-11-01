import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/api/notification_api.dart';
import 'package:studydocs/features/notification/data/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

import '../../../../screens/notification_screen.dart';

class NotificationPage extends StatelessWidget {
  final String userId;

  const NotificationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
      NotificationBloc(NotificationRepository(NotificationApi()))
        ..add(LoadNotificationEvent(DateTime.now(),false)),
      child: NotificationScreen(),
    );
  }
}
