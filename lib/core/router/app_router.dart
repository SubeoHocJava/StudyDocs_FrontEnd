import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/main/main_screen.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_management_screen.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_bloc.dart';
import 'package:studydocs/features/docs_management/data/datasource/docs_management_remote_datasource.dart';
import 'package:studydocs/features/docs_management/data/repository/docs_management_repository_impl.dart';
import 'package:studydocs/features/docs_management/domain/usecase/get_my_docs_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/delete_doc_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/update_doc_usecase.dart';
import 'package:studydocs/features/docs/logic/docs_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String explore = '/explore';
  static const String notifications = '/notifications';
  static const String docsManagement = '/docs-management';
  static const String docsDetail = '/docs/detail';
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
      GoRoute(
        path: AppRoutes.docsManagement,
        builder: (context, state) {
          final dataSource = DocsManagementRemoteDataSourceImpl();
          final repository = DocsManagementRepositoryImpl(dataSource: dataSource);
          return BlocProvider(
            create: (_) => DocsManagementBloc(
              getMyDocsUseCase: GetMyDocsUseCase(repository),
              deleteDocUseCase: DeleteDocUseCase(repository),
              updateDocUseCase: UpdateDocUseCase(repository),
            ),
            child: const DocsManagementScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.docsDetail,
        builder: (context, state) {
          return const DocsPage();
        },
      ),
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
    ],
  );
}
