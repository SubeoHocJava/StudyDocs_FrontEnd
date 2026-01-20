import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

class NotificationPageLayout extends StatelessWidget {
  final bool isDeleted;
  final String emptyMessage;
  final Widget Function(List<NotificationEntity>) childBuilder;
  final String userId;
  final Future<void> Function()? onRefresh;

  const NotificationPageLayout({
    super.key,
    required this.isDeleted,
    required this.emptyMessage,
    required this.childBuilder,
    required this.userId,
    this.isDefault = true,
    this.headerTitle,
    this.onModal,
    this.extraAction,
    this.onRefresh,
  });

  // Header props
  final bool isDefault;
  final String? headerTitle;
  final void Function(BuildContext)? onModal;
  final Widget? extraAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Body content based on state
          Widget bodyContent;
          if (state is NotificationLoadingState) {
            bodyContent = const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoadedState) {
            final list =
                isDeleted ? state.deletedNotifications : state.activeNotifications;
            if (list.isEmpty) {
              bodyContent = onRefresh != null
                  ? RefreshIndicator(
                      onRefresh: onRefresh!,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(child: Text(emptyMessage)),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text(emptyMessage));
            } else {
              bodyContent = childBuilder(list);
            }
          } else if (state is NotificationErrorState) {
            final responsive = ResponsiveHelper(context);
            bodyContent = Center(
              child: Text(
                "Lỗi: ${state.message}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            );
          } else {
            final responsive = ResponsiveHelper(context);
            bodyContent = Center(
              child: Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            );
          }

          return Column(
            children: [
              _buildCustomHeader(context),
              Expanded(child: bodyContent),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              headerTitle ?? "Thông báo",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
          ),
          
          if (extraAction != null) ...[
            extraAction!,
            const SizedBox(width: 8),
          ],

          // Modal Button
          if (onModal != null)
            Material(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onModal!(context),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
