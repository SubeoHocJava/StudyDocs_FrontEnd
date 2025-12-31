import 'package:flutter/material.dart';
import 'package:studydocs/core/widgets/bottom_nav.dart';
import 'package:studydocs/features/home/presentation/home_screen.dart';
import 'package:studydocs/features/library/presentation/screen/library_screen.dart';
import 'package:studydocs/features/subject_library/presentation/screen/subject_library_screen.dart';
import 'package:studydocs/features/notification/presentation/screen/notification_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _screens = [
    HomePage(),
    const LibraryScreen(),
    SubjectLibraryScreen(),
    const NotificationScreen(userId: ''),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to change pages
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
