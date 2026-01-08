import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/core/widgets/header.dart';
import 'package:studydocs/features/home/presentation/home_screen.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/presentation/notification_screen.dart';
import 'package:studydocs/features/notification/presentation/notification_trash_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';

import '../manage_user/presentation/screen/manage_user_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
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
        onTap: (i) => _goBranch(context, i),
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
    return SubjectLibraryScreen();
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
