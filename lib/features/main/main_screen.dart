import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/home/presentation/home_screen.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/presentation/notification_screen.dart';
import 'package:studydocs/features/notification/presentation/notification_trash_screen.dart';
import 'package:studydocs/features/notification_template/presentation/notification_template_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';
import 'package:studydocs/features/manage_user/presentation/screen/manage_user_screen.dart';
import 'package:studydocs/data/datasource/explore_remote_datasource.dart';
import 'package:studydocs/features/explore/domain/repository/impl/explore_repository_impl.dart';
import 'package:studydocs/features/explore/domain/usecase/search_schools_usecase.dart';
import 'package:studydocs/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:studydocs/features/explore/presentation/widgets/explore_bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(BuildContext context, int index) {
    // Nếu bấm nút "Khám phá" (index 2) → Show bottom sheet tìm kiếm trường
    if (index == 2) {
      _showExploreBottomSheet(context);
      return;
    }

    // Các tab khác vẫn navigate bình thường
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  /// Hiển thị bottom sheet khám phá trường
  void _showExploreBottomSheet(BuildContext context) {
    final remote = ExploreRemoteDataSource();
    final repo = ExploreRepositoryImpl(remote: remote);
    final searchUseCase = SearchSchoolsUseCase(repository: repo);
    final getCurrentSchoolUseCase = GetCurrentSchoolUseCase(repository: repo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider(
            create:
                (_) => ExploreBloc(
                  searchSchoolsUseCase: searchUseCase,
                  getCurrentSchoolUseCase: getCurrentSchoolUseCase,
                ),
            child: const ExploreBottomSheet(),
          ),
    );
  }

  void _onTabTap(BuildContext context, int index) {
    // Home tab (index 0) vẫn dùng navigationShell
    if (index == 0) {
      navigationShell.goBranch(0, initialLocation: true);
      return;
    }
    // Khám phá (index 2) vẫn show bottom sheet
    if (index == 2) {
      _showExploreBottomSheet(context);
      return;
    }
    // Các tab khác dùng GoRouter để trigger redirect
    final routes = [
      AppRoutes.home, // 0
      AppRoutes.library, // 1
      AppRoutes.explore, // 2 (handled above)
      AppRoutes.notifications, // 3
    ];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Header(
              isDefault: true,
              selectedIndex: currentIndex,
              onLogoTap: () {
                navigationShell.goBranch(0, initialLocation: true);
              },
            ),
            Expanded(child: navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (i) => _onTabTap(context, i),
      ),
    );
  }
}

class MainTabHomePage extends StatelessWidget {
  const MainTabHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class MainTabLibraryPage extends StatelessWidget {
  const MainTabLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LibraryScreen();
  }
}

class MainTabExplorePage extends StatelessWidget {
  const MainTabExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tab "Khám phá" chỉ hiển thị empty state
    // User phải click vào tab để mở bottom sheet tìm trường
    return const Center(
      child: Text(
        'Nhấn vào tab "Khám phá" để tìm kiếm trường',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class MainTabNotificationsPage extends StatelessWidget {
  const MainTabNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationScreen(userId: '');
  }
}

class MainTabNotificationsTrashPage extends StatelessWidget {
  final String userId;
  final NotificationBloc? parentBloc;

  const MainTabNotificationsTrashPage({
    super.key,
    required this.userId,
    this.parentBloc,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationTrashScreen(userId: userId, parentBloc: parentBloc);
  }
}

class MainTabManageUserPage extends StatelessWidget {
  const MainTabManageUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManageUserScreen();
  }
}

class MainTabNotificationTemplatePage extends StatelessWidget {
  const MainTabNotificationTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationTemplateScreen();
  }
}
