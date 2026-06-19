import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/layout/bottom/bottom_nav.dart';

import 'package:studydocs/screens/user/explore/presentation/explore_screen.dart';
import 'package:studydocs/screens/user/library/presentation/library_screen.dart';
import 'package:studydocs/screens/user/notification/presentation/notification_screen.dart';

import '../home/presentation/home_screen.dart';

class UserRootShell extends StatefulWidget {
  const UserRootShell({super.key});

  @override
  State<UserRootShell> createState() => _UserRootShellState();
}

class _UserRootShellState extends State<UserRootShell> {
  int _currentIndex = 0;

  static const _pages = [
    HomeScreen(),
    LibraryScreen(),
    ExploreScreen(),
    NotificationScreen(),
  ];

  void _onFooterTap(int index) {
    if (index == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onFooterTap,
      ),
    );
  }
}
