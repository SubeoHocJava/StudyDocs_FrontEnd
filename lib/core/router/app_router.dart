import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/route_security.dart';
import 'package:studydocs/core/widgets/layout/app_shell.dart';
import 'package:studydocs/features/home/presentation/home_screen.dart';
import 'package:studydocs/features/user/profile/presentation/ProfileScreen.dart';
import 'package:studydocs/features/user/user_follow/presentation/screen/user_follow_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter initAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: '/followers',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const UserFollowScreen(initialTab: 0),
            ),
          ),
          GoRoute(
            path: '/following',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const UserFollowScreen(initialTab: 1),
            ),
          ),
        ],
      ),
    ],
  );
}

void showGlobalDialog(Widget dialog) {
  final context = rootNavigatorKey.currentContext;
  if (context != null) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }
}
