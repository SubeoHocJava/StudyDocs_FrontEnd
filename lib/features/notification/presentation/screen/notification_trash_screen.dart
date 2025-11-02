import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/notification/data/repository/notification_repository.dart';
import 'package:studydocs/features/notification/data/data_source/notification_data_source.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_items_container.dart';

class NotificationTrashScreen extends StatelessWidget {

  final String userId;

  const NotificationTrashScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
      NotificationBloc(NotificationRepository(NotificationDataSource()))
        ..add(LoadNotificationEvent(DateTime.now(), true)),
      child: Scaffold(
        appBar: const Header(),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoadedState) {
              return ListView(
                children: [
                  NotificationItemsContainer(notifications: state.notifications),
                ],
              );
            } else {
              return const Center(child: Text("Chưa có thông báo nào bị xóa"));
            }
          },
        ),
      ),
    );
  }
}
