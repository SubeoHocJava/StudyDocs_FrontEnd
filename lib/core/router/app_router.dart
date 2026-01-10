import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/features/admin/presentation/screen/admin_dashboard_screen.dart';
import 'package:studydocs/features/docs_management/data/datasource/docs_management_remote_datasource.dart'
    show DocsManagementRemoteDataSourceImpl;
import 'package:studydocs/features/docs_management/data/repository/docs_management_repository_impl.dart';
import 'package:studydocs/features/docs_management/domain/repository/docs_management_repository.dart';
import 'package:studydocs/features/docs_management/domain/usecase/delete_doc_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/get_my_docs_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/update_doc_usecase.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_bloc.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_management_screen.dart';
import 'package:studydocs/features/main/main_screen.dart';
import 'package:studydocs/features/manage_user/domain/repository/impl/ManageUserRepositoryImpl.dart';
import 'package:studydocs/features/manage_user/domain/repository/manage_user_repository.dart';
import 'package:studydocs/features/manage_user/logic/manage_user_bloc.dart'
    show createManageUserBloc;
import 'package:studydocs/features/manage_user/logic/manage_user_event.dart';
import 'package:studydocs/features/manage_user/presentation/screen/manage_user_screen.dart';
import 'package:studydocs/features/notification_template/data/repository/notification_template_repository_impl.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';
import 'package:studydocs/features/notification_template/domain/usecase/create_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/delete_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_channels_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_template_types_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/get_notification_templates_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/search_notification_template_keywords_usecase.dart';
import 'package:studydocs/features/notification_template/domain/usecase/update_notification_template_usecase.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_bloc.dart';
import 'package:studydocs/features/notification_template/logic/notification_template_event.dart';
import 'package:studydocs/features/notification_template/presentation/notification_template_screen.dart';
import 'package:studydocs/features/profile/presentation/screen/profile_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String explore = '/explore';
  static const String notifications = '/notifications';
  static const String notificationTrash = '/notifications/trash';

  //   admin
  static const String manageUser = '/manage-user';
  static const String notificationTemplates = '/admin/notification-templates';
  static const String adminDashboard = '/admin/dashboard';
  static const String profile = '/profile';
  static const String docsManagement = '/admin/docs-management';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _libraryNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _exploreNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationsNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder:
                    (context, state) =>
                    NoTransitionPage(child: const MainTabHomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _libraryNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.library,
                pageBuilder:
                    (context, state) =>
                    NoTransitionPage(child: const MainTabLibraryPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _exploreNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder:
                    (context, state) =>
                    NoTransitionPage(child: const MainTabExplorePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _notificationsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.notifications,
                pageBuilder:
                    (context, state) =>
                    NoTransitionPage(
                      child: const MainTabNotificationsPage(),
                    ),
                routes: [
                  GoRoute(
                    name: AppRoutes.notificationTrash,
                    path: 'trash',
                    builder: (context, state) {
                      final args = state.extra as Map<String, dynamic>?;
                      return MainTabNotificationsTrashPage(
                        userId: args?['userId'] ?? '',
                        parentBloc: args?['bloc'],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Standalone routes - Admin routes di chuyển ra ngoài StatefulShellRoute
      GoRoute(
        path: AppRoutes.manageUser,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return RepositoryProvider<ManageUserRepository>(
            create: (_) => ManageUserRepositoryImpl(),
            child: BlocProvider(
              create: (context) =>
                  createManageUserBloc(context.read<ManageUserRepository>())
                    ..add(LoadListUser(fromPage: 1, toPage: 3, numUser: 10)),
              child: const ManageUserScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notificationTemplates,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // Tạo repository nếu chưa có trong context
          final repository = context.read<NotificationTemplateRepository>();
          return BlocProvider(
            create: (context) => NotificationTemplateBloc(
              getTemplatesUseCase: GetNotificationTemplatesUseCase(repository),
              getTypesUseCase: GetNotificationTemplateTypesUseCase(repository),
              getChannelsUseCase: GetNotificationTemplateChannelsUseCase(repository),
              searchKeywordsUseCase: SearchNotificationTemplateKeywordsUseCase(repository),
              createTemplateUseCase: CreateNotificationTemplateUseCase(repository),
              updateTemplateUseCase: UpdateNotificationTemplateUseCase(repository),
              deleteTemplateUseCase: DeleteNotificationTemplateUseCase(repository),
            )..add(const LoadNotificationTemplatesEvent()),
            child: const NotificationTemplateScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.docsManagement,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repository = DocsManagementRepositoryImpl(
            dataSource: DocsManagementRemoteDataSourceImpl(),
          );
          return BlocProvider(
            create: (context) => DocsManagementBloc(
              getMyDocsUseCase: GetMyDocsUseCase(repository),
              deleteDocUseCase: DeleteDocUseCase(repository),
              updateDocUseCase: UpdateDocUseCase(repository),
            ),
            child: const DocsManagementScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
