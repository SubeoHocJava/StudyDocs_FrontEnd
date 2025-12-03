import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/data/datasource/notification_remote_datasource.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

/// Layout chung cho các trang notification (Danh sách và Thùng rác)
/// - Quản lý BlocProvider và BlocBuilder
/// - Xử lý loading và empty state
/// - Hiển thị Header
class NotificationPageLayout extends StatelessWidget {
  final bool isDeleted;
  final String emptyMessage;
  final Widget Function(List<NotificationEntity> notifications) childBuilder;

  const NotificationPageLayout({
    super.key,
    required this.isDeleted,
    required this.emptyMessage,
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(
        NotificationRepositoryImpl(
          NotificationDataSourceImpl(dioClient: DioClient()),
        ),
      )..add(LoadNotificationEvent(DateTime.now(), isDeleted)),
      child: Scaffold(
        appBar: const Header(),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoadedState) {
              if (state.notifications.isEmpty) {
                return Center(child: Text(emptyMessage));
              }
              return childBuilder(state.notifications);
            } else if (state is NotificationErrorState) {
              return Center(child: Text("Lỗi: ${state.message}"));
            } else {
              return Center(child: Text(emptyMessage));
            }
          },
        ),
      ),
    );
  }
}
