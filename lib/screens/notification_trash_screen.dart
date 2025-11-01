import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';
import 'package:studydocs/features/notification/presentation/components/items/notification_items_container.dart';

class NotificationTrashScreen extends StatelessWidget {
  const NotificationTrashScreen({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
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
    );
  }
}
