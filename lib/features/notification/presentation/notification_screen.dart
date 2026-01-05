import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_enum.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/helper/notification_helper.dart';
import 'component/normal/notification_normal_modal.dart';

import 'component/base/notification_section.dart';
import 'shared/notification_page_layout.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(context.read<NotificationRepository>())..add(const LoadNotificationEvent(isDeleted: false)),
      child: NotificationPageLayout(
        userId: userId,
        isDeleted: false,
        showHeader: false, // MainScreen already has header
        headerTitle: "Thông báo",
        emptyMessage: "Chưa có dữ liệu",
        onModal: (BuildContext ctx) {
          showModalBottomSheet(
            context: ctx,
            barrierColor: Colors.black.withOpacity(0.6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: ctx.read<NotificationBloc>(),
              child: NotificationNormalModal(userId: userId),
            ),
          );
        },
        childBuilder: (notifications) {
          final sections = NotificationHelper.buildSections(notifications);
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              return NotificationSection(
                title: section.title,
                notifications: section.items,
                type: NotificationSectionType.normal,
              );
            },
          );
        },
      ),
    );
  }
}
