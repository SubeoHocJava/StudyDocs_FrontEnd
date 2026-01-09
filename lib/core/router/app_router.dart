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
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_documents_screen.dart';
import 'package:studydocs/features/subject_library/domain/data/impl/SubjectLibraryRepositoryImpl.dart';
import 'package:studydocs/features/subject_library/domain/repository/impl/subject_repository_impl.dart';
import 'package:studydocs/features/subject_library/domain/usecase/DocsUseCase.dart';
import 'package:studydocs/features/subject_library/domain/usecase/get_subjects_by_school_usecase.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_bloc.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_event.dart';

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
      // School subject library route - standalone screen
      GoRoute(
        path: '/school/:schoolName',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          // GoRouter đã tự động decode path parameters rồi
          final decodedSchoolName = state.pathParameters['schoolName'] ?? 'Unknown School';
          
          // Create repositories
          final subjectLibraryRepo = SubjectLibraryRepositoryImpl();
          final subjectRepo = SubjectRepositoryImpl();
          
          return MaterialPage(
            child: BlocProvider(
              create: (_) => SubjectLibraryBloc(
                searchDocumentsUseCase: SearchDocumentsUseCase(
                  repository: subjectLibraryRepo,
                ),
                likeDocumentUseCase: LikeDocumentUseCase(repository: subjectLibraryRepo),
                getCommentsUseCase: GetCommentsUseCase(repository: subjectLibraryRepo),
                downloadDocumentUseCase: DownloadDocumentUseCase(
                  repository: subjectLibraryRepo,
                ),
                bookmarkDocumentUseCase: BookmarkDocumentUseCase(
                  repository: subjectLibraryRepo,
                ),
                getSubjectsBySchoolUseCase: GetSubjectsBySchoolUseCase(
                  repository: subjectRepo,
                ),
              )..add(SubjectLibraryLoadBySchool(decodedSchoolName)),
              child: SubjectLibraryScreen(schoolName: decodedSchoolName),
            ),
          );
        },
      ),
      // Subject documents route - standalone screen
      GoRoute(
        path: '/school/:schoolName/subject/:subjectName',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          // GoRouter đã tự động decode path parameters rồi
          final decodedSchoolName = state.pathParameters['schoolName'] ?? 'Unknown School';
          final decodedSubjectName = state.pathParameters['subjectName'] ?? 'Unknown Subject';
          
          // Create repositories
          final subjectLibraryRepo = SubjectLibraryRepositoryImpl();
          final subjectRepo = SubjectRepositoryImpl();
          
          return MaterialPage(
            child: BlocProvider(
              create: (_) => SubjectLibraryBloc(
                searchDocumentsUseCase: SearchDocumentsUseCase(
                  repository: subjectLibraryRepo,
                ),
                likeDocumentUseCase: LikeDocumentUseCase(repository: subjectLibraryRepo),
                getCommentsUseCase: GetCommentsUseCase(repository: subjectLibraryRepo),
                downloadDocumentUseCase: DownloadDocumentUseCase(
                  repository: subjectLibraryRepo,
                ),
                bookmarkDocumentUseCase: BookmarkDocumentUseCase(
                  repository: subjectLibraryRepo,
                ),
                getSubjectsBySchoolUseCase: GetSubjectsBySchoolUseCase(
                  repository: subjectRepo,
                ),
              )..add(SubjectLibraryLoadDocumentByKeyWord(decodedSubjectName)),
              child: SubjectDocumentsScreen(
                schoolName: decodedSchoolName,
                subjectName: decodedSubjectName,
              ),
            ),
          );
        },
      ),
    ],
  );
}
