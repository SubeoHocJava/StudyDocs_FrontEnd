import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

class NotificationPageLayout extends StatelessWidget {
  final bool isDeleted;
  final String emptyMessage;
  final Widget Function(List<NotificationEntity>) childBuilder;
  final String userId;

  final bool showHeader;
  // Header props
  final bool isDefault;
  final String? headerTitle;
  final VoidCallback? onBack;
  final void Function(BuildContext)? onModal;

  const NotificationPageLayout({
    super.key,
    required this.isDeleted,
    required this.emptyMessage,
    required this.childBuilder,
    required this.userId,
    this.showHeader = true,
    this.isDefault = true,
    this.headerTitle,
    this.onBack,
    this.onModal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader ? Header(
        isDefault: isDefault,
        headerTitle: headerTitle,
        onBack: onBack ?? () => Navigator.pop(context),
        onModal: onModal,
      ) : null,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationLoadedState) {
            final list = isDeleted ? state.deletedNotifications : state.activeNotifications;
            return Column(
              children: [
                Expanded(
                  child: list.isEmpty
                      ? Center(child: Text(emptyMessage))
                      : childBuilder(list),
                ),
              ],
            );
          }

          if (state is NotificationErrorState) {
            final responsive = ResponsiveHelper(context);
            return Center(
              child: Text(
                "Lỗi: ${state.message}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            );
          }

          final responsive = ResponsiveHelper(context);
          return Center(
            child: Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          );
        },
      ),
    );
  }
}
