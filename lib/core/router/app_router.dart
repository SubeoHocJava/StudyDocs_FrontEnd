import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/main/main_screen.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_bloc.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_event.dart';
import 'package:studydocs/features/statistic/presentation/screens/statistic_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String explore = '/explore';
  static const String notifications = '/notifications';
  static const String statistic = '/statistic';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _libraryNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _exploreNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationsNavigatorKey =
    GlobalKey<NavigatorState>();

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
                    (context, state) => NoTransitionPage(
                      child: const MainTabNotificationsPage(),
                    ),
              ),
            ],
          ),
        ],
      ),
      // Statistic route - standalone screen outside main navigation
      GoRoute(
        path: AppRoutes.statistic,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: MultiBlocProvider(
              providers: [
                // Create StatisticBloc for this screen
                BlocProvider(
                  create: (_) =>
                      createStatisticBloc()
                        ..add(const LoadDownloadStatisticsEvent()),
                ),
                // Provide ProfileBloc for ActivitySummaryCard
                BlocProvider(
                  create: (_) =>
                      ProfileBloc(ProfileRepositoryImpl())
                        ..add(const LoadProfile(0)),
                ),
              ],
              child: const StatisticScreen(),
            ),
          );
        },
      ),
    ],
  );
}
