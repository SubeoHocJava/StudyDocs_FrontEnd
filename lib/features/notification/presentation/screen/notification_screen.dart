import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';
import 'package:studydocs/data/datasource/notification_remote_datasource.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/logic/notification_helper.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_items_container.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_section_header.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => NotificationBloc(
            NotificationRepositoryImpl(
              NotificationDataSourceImpl(dioClient: DioClient()),
            ),
          )..add(LoadNotificationEvent(DateTime.now(), true)),
      child: Scaffold(
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoadedState) {
              final mapNotification =
                  NotificationHelper.groupNotificationsByTime(
                    state.notifications,
                  );
              final todayNotifications =
                  mapNotification[NotificationHelper.today] ?? [];
              final agoNotifications =
                  mapNotification[NotificationHelper.ago] ?? [];
              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  if (index == 0 && todayNotifications.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NotificationSectionHeader(time: "Hôm nay"),
                        NotificationItemsContainer(
                          notifications: todayNotifications,
                        ),
                      ],
                    );
                  } else if (index == 1 && agoNotifications.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NotificationSectionHeader(time: "Trước đó"),
                        NotificationItemsContainer(
                          notifications: agoNotifications,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            } else {
              return const Center(child: Text("Chưa có dữ liệu"));
            }
          },
        ),
      ),
    );
  }
}
