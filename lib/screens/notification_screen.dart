import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

import 'package:studydocs/features/notification/logic/notification_helper.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_items_container.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_section_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoadedState) {
            final mapNotification = NotificationHelper.groupNotificationsByTime(
              state.notifications,
            );
            final todayNotifications =
                mapNotification[NotificationHelper.today] ?? [];
            final agoNotifications =
                mapNotification[NotificationHelper.ago] ?? [];
            return ListView(
              children: [
                if (todayNotifications.isNotEmpty) ...[
                  NotificationSectionHeader(time: "Hôm nay"),
                  NotificationItemsContainer(notifications: todayNotifications),
                ],
                if (agoNotifications.isNotEmpty) ...[
                  NotificationSectionHeader(time: "Trước đó"),
                  NotificationItemsContainer(notifications: agoNotifications),
                ],
              ],
            );
          } else {
            return const Center(child: Text("Chưa có dữ liệu"));
          }
        },
      ),
    );
  }
}
