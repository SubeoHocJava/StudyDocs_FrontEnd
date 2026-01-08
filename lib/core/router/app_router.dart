import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/main/main_screen.dart';
import 'package:studydocs/features/notification_template/presentation/notification_template_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String explore = '/explore';
  static const String notifications = '/notifications';
  static const String notificationTrash = '/notifications/trash';

  //   admin
  static const String manageUser = '/manage-user';
  static const String notificationTemplates = '/admin/notification-templates';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _libraryNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _exploreNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationsNavigatorKey = GlobalKey<NavigatorState>();
// admin
final GlobalKey<NavigatorState> _manageUserNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationTemplateNavigatorKey = GlobalKey<NavigatorState>();
GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.notificationTemplates,
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
          StatefulShellBranch(
            navigatorKey: _manageUserNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.manageUser,
                pageBuilder:
                    (context, state) =>
                    NoTransitionPage(child: const MainTabManageUserPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _notificationTemplateNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.notificationTemplates,
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: const MainTabNotificationTemplatePage(),
                    ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
