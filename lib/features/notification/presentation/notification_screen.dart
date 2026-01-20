import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_enum.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/helper/notification_helper.dart';
import 'component/normal/notification_normal_modal.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'component/base/notification_section.dart';
import 'shared/notification_page_layout.dart';
import 'package:studydocs/core/widgets/global_error_listener.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) { 
    return BlocProvider(
      create: (_) => NotificationBloc(context.read<NotificationRepository>())..add(const LoadNotificationEvent(isDeleted: false)),
      child: GlobalErrorListener<NotificationBloc, NotificationState>(
        errorExtractor: (state) => state is NotificationErrorState ? state.message : null,
        child: Builder(
          builder: (context) {
            return NotificationPageLayout(
              userId: userId,
              isDeleted: false,
              headerTitle: "Thông báo",
              emptyMessage: "Chưa có dữ liệu",
              extraAction: Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    context.push(
                      AppRoutes.notificationTrash,
                      extra: {
                        'userId': userId,
                        'bloc': context.read<NotificationBloc>(),
                      },
                    );
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              onModal: (BuildContext ctx) {
                showModalBottomSheet(
                  context: ctx,
                  barrierColor: Colors.black.withValues(alpha: 0.6),
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
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationBloc>().add(
                      const LoadNotificationEvent(isDeleted: false),
                    );
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return NotificationSection(
                        title: section.title,
                        notifications: section.items,
                        type: NotificationSectionType.normal,
                        onSoftDelete: (id) {
                          context.read<NotificationBloc>().add(
                            DeleteNotificationEvent([id], DeleteType.soft),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
