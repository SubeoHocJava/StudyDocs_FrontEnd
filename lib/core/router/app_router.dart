import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/route_security.dart';
import 'package:studydocs/core/widgets/layout/app_shell.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/screens/user/library/presentation/library_screen.dart';
import 'package:studydocs/screens/user/library/presentation/library_subject_screen.dart';
import 'package:studydocs/screens/document_detail/presentation/document_detail_screen.dart';

import '../../screens/explore/presentation/explore_screen.dart';
import '../../screens/home/presentation/home_screen.dart';
import '../../screens/notification/presentation/notification_screen.dart';
import '../../screens/profile/presentation/profile_screen.dart';
import '../../screens/user_follow/presentation/screen/user_follow_screen.dart';
import '../../screens/document_upload/presentation/document_upload_screen.dart';

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
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
          ),
          GoRoute(
            path: '/profile',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                ),
          ),
          GoRoute(
            path: '/profile/:id',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              return NoTransitionPage(
                key: state.pageKey,
                child: ProfileScreen(userId: id),
              );
            },
          ),
          GoRoute(
            path: '/library',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const LibraryScreen(),
                ),
          ),
          GoRoute(
            path: '/library/:subjectId',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              return NoTransitionPage(
                key: state.pageKey,
                child: LibrarySubjectScreen(subjectId: subjectId),
              );
            },
          ),
          GoRoute(
            path: '/explore',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExploreScreen(),
                ),
          ),
          GoRoute(
            path: '/notifications',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NotificationScreen(),
                ),
          ),
          GoRoute(
            path: '/followers',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const UserFollowScreen(initialTab: 0),
                ),
          ),
          GoRoute(
            path: '/following',
            parentNavigatorKey: shellNavigatorKey,
            redirect: authGuard,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const UserFollowScreen(initialTab: 1),
                ),
          ),
          GoRoute(
            path: '/document/:id',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage(
                key: state.pageKey,
                child: DocumentDetailScreen(documentId: id),
              );
            },
          ),
          GoRoute(
            path: '/upload',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              final initialFile = state.extra as PlatformFile?;
              return NoTransitionPage(
                key: state.pageKey,
                child: DocumentUploadScreen(initialFile: initialFile),
              );
            },
          ),
        ],
      ),
    ],
  );
}

void showGlobalDialog(Widget dialog) {
  final context = rootNavigatorKey.currentContext;
  if (context != null) {
    showDialog(context: context, builder: (_) => dialog);
  }
}
