import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../domain/entity/notification_model.dart';
import '../logic/notification_bloc.dart';
import '../logic/notification_event.dart';
import '../logic/notification_state.dart';

class NotificationPresentation extends StatelessWidget {
  const NotificationPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is NotificationLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Thông báo'),
              leading: state.isTrashMode ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.read<NotificationBloc>().add(ToggleTrashModeEvent())) : null,
            ),
            body: const Center(child: Text('Notification Feature: Header Loaded')),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Thông báo')),
          body: const Center(child: Text("Đã có lỗi xảy ra")),
        );
      },
    );
  }
}
