import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/auth/presentation/bloc/auth_status_cubit.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/features/admin/presentation/screen/admin_dashboard_screen.dart';
import 'package:studydocs/features/docs_management/data/repository/docs_management_repository_impl.dart';
import 'package:studydocs/features/docs_management/domain/repository/docs_management_repository.dart';
import 'package:studydocs/features/docs_management/domain/usecase/delete_doc_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/get_my_docs_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/get_all_docs_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/delete_admin_doc_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/update_doc_usecase.dart';
import 'package:studydocs/features/docs_management/domain/usecase/upload_doc_usecase.dart';
import 'package:studydocs/features/docs_management/logic/docs_management_bloc.dart';
import 'package:studydocs/features/docs_management/presentation/screen/docs_management_screen.dart';
import 'package:studydocs/features/docs/logic/docs_page.dart';
import 'package:studydocs/core/network/dio_client.dart';
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
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/profile/presentation/screen/profile_screen.dart';
import 'package:studydocs/features/statistic/presentation/bloc/statistic_bloc.dart'
    show createStatisticBloc;
import 'package:studydocs/features/statistic/presentation/bloc/statistic_event.dart';
import 'package:studydocs/features/statistic/presentation/screens/statistic_screen.dart';
import 'package:studydocs/features/docs/logic/docs_page.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import 'package:studydocs/features/subject_library/domain/data/impl/subject_library_repository_impl.dart';
import 'package:studydocs/features/subject_library/domain/repository/impl/subject_repository_impl.dart';
import 'package:studydocs/features/subject_library/domain/usecase/DocsUseCase.dart';
import 'package:studydocs/features/subject_library/domain/usecase/get_subjects_by_school_usecase.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_bloc.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_event.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_documents_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';

import '../../data/datasource/docs_management_remote_datasource.dart';

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

  // statistic & subject library
  static const String statistic = '/statistic';
  static const String documentDetail = '/document/:id';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _libraryNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _exploreNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationsNavigatorKey =
    GlobalKey<NavigatorState>();

String? _checkAuthRedirect(BuildContext context, GoRouterState state) {
  final authCubit = context.read<AuthStatusCubit>();
  if (!authCubit.isAuthenticated) {
    if (state.uri.toString() != AppRoutes.home) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vui lòng đăng nhập để truy cập trang này'),
            backgroundColor: AppColors.headerForeground,
          ),
        );
      });
      return AppRoutes.home;
    }
  }
  return null;
}

String? _checkAdminRedirect(BuildContext context, GoRouterState state) {
  final authCubit = context.read<AuthStatusCubit>();
  final st = authCubit.state;
  if (st is! AuthAuthenticated) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bạn cần đăng nhập để truy cập trang quản trị'),
          backgroundColor: AppColors.headerForeground,
        ),
      );
    });
    return AppRoutes.home;
  }
  if (!st.isAdmin) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bạn không có quyền truy cập trang này'),
          backgroundColor: AppColors.danger,
        ),
      );
    });
    return AppRoutes.home;
  }
  return null;
}

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
                redirect: _checkAuthRedirect,
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
                redirect: _checkAuthRedirect,
                pageBuilder:
                    (context, state) => NoTransitionPage(
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
      // Statistic route - standalone screen outside main navigation
      GoRoute(
        path: AppRoutes.statistic,
        redirect: _checkAuthRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: MultiBlocProvider(
              providers: [
                // Create StatisticBloc for this screen
                BlocProvider(
                  create:
                      (_) =>
                          createStatisticBloc()
                            ..add(const LoadDownloadStatisticsEvent()),
                ),
                // Provide ProfileBloc for ActivitySummaryCard
                BlocProvider(
                  create:
                      (_) =>
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
        path: '/school/:schoolId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          // Get ID from path, Name from query
          final decodedSchoolId = state.pathParameters['schoolId'] ?? '';
          final decodedSchoolName =
              state.uri.queryParameters['name'] ?? 'Unknown School';

          // Create DataSources
          final dioClient = context.read<DioClient>();
          final documentDataSource = DocsRemoteDataSourceImpl(
            dioClient: dioClient,
          );
          final academicDataSource = AcademicRemoteDataSourceImpl(
            dioClient: dioClient,
          );

          // Create repositories
          final subjectLibraryRepo = SubjectLibraryRepositoryImpl(
            documentDataSource: documentDataSource,
          );
          final subjectRepo = SubjectRepositoryImpl(remote: academicDataSource);

          return MaterialPage(
            child: BlocProvider(
              create:
                  (_) => SubjectLibraryBloc(
                    searchDocumentsUseCase: SearchDocumentsUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    likeDocumentUseCase: LikeDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    getCommentsUseCase: GetCommentsUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    downloadDocumentUseCase: DownloadDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    bookmarkDocumentUseCase: BookmarkDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    getSubjectsBySchoolUseCase: GetSubjectsBySchoolUseCase(
                      repository: subjectRepo,
                    ),
                  )..add(
                    SubjectLibraryLoadBySchool(
                      decodedSchoolId,
                      decodedSchoolName,
                    ),
                  ),
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
          final decodedSchoolName =
              state.pathParameters['schoolName'] ?? 'Unknown School';
          final decodedSubjectName =
              state.pathParameters['subjectName'] ?? 'Unknown Subject';

          // Create DataSources
          final dioClient = context.read<DioClient>();
          final documentDataSource = DocsRemoteDataSourceImpl(
            dioClient: dioClient,
          );
          final academicDataSource = AcademicRemoteDataSourceImpl(
            dioClient: dioClient,
          );

          // Create repositories
          final subjectLibraryRepo = SubjectLibraryRepositoryImpl(
            documentDataSource: documentDataSource,
          );
          final subjectRepo = SubjectRepositoryImpl(remote: academicDataSource);

          return MaterialPage(
            child: BlocProvider(
              create:
                  (_) => SubjectLibraryBloc(
                    searchDocumentsUseCase: SearchDocumentsUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    likeDocumentUseCase: LikeDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    getCommentsUseCase: GetCommentsUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    downloadDocumentUseCase: DownloadDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    bookmarkDocumentUseCase: BookmarkDocumentUseCase(
                      repository: subjectLibraryRepo,
                    ),
                    getSubjectsBySchoolUseCase: GetSubjectsBySchoolUseCase(
                      repository: subjectRepo,
                    ),
                  )..add(
                    SubjectLibraryLoadDocumentByKeyWord(decodedSubjectName),
                  ),
              child: SubjectDocumentsScreen(
                schoolName: decodedSchoolName,
                subjectName: decodedSubjectName,
              ),
            ),
          );
        },
      ),
      // Standalone routes - Admin routes di chuyển ra ngoài StatefulShellRoute
      GoRoute(
        path: AppRoutes.manageUser,
        redirect: _checkAdminRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return RepositoryProvider<ManageUserRepository>(
            create: (_) => ManageUserRepositoryImpl(),
            child: BlocProvider(
              create:
                  (context) => createManageUserBloc(
                    context.read<ManageUserRepository>(),
                  )..add(LoadListUser(fromPage: 1, toPage: 3, numUser: 10)),
              child: const ManageUserScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notificationTemplates,
        redirect: _checkAdminRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // Tạo repository nếu chưa có trong context
          final repository = context.read<NotificationTemplateRepository>();
          return BlocProvider(
            create:
                (context) => NotificationTemplateBloc(
                  getTemplatesUseCase: GetNotificationTemplatesUseCase(
                    repository,
                  ),
                  getTypesUseCase: GetNotificationTemplateTypesUseCase(
                    repository,
                  ),
                  getChannelsUseCase: GetNotificationTemplateChannelsUseCase(
                    repository,
                  ),
                  searchKeywordsUseCase:
                      SearchNotificationTemplateKeywordsUseCase(repository),
                  createTemplateUseCase: CreateNotificationTemplateUseCase(
                    repository,
                  ),
                  updateTemplateUseCase: UpdateNotificationTemplateUseCase(
                    repository,
                  ),
                  deleteTemplateUseCase: DeleteNotificationTemplateUseCase(
                    repository,
                  ),
                )..add(const LoadNotificationTemplatesEvent()),
            child: const NotificationTemplateScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.docsManagement,
        redirect: _checkAdminRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repository = DocsManagementRepositoryImpl(
            dataSource: DocsManagementRemoteDataSourceImpl(dioClient: context.read<DioClient>()),
          );
          return BlocProvider(
            create:
                (context) => DocsManagementBloc(
                  getMyDocsUseCase: GetMyDocsUseCase(repository),
                  deleteDocUseCase: DeleteDocUseCase(repository),
                  updateDocUseCase: UpdateDocUseCase(repository),
                  uploadDocUseCase: UploadDocUseCase(repository),
                ),
            child: const DocsManagementScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        redirect: _checkAdminRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        redirect: _checkAuthRedirect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      // Document Detail Route
      GoRoute(
        path: AppRoutes.documentDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final docId = state.pathParameters['id'] ?? '';
          return DocsPage(documentId: docId);
        },
      ),
    ],
  );
}
