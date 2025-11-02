import 'package:flutter/material.dart';
import '../../../core/widgets/header.dart';
import '../../../core/widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Default to Home (index 0)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Subeo chưa làm cái này",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000F4C),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation here
          _handleNavigation(index);
        },
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Library
        print('Navigate to Library');
        break;
      case 2:
        // Explore
        print('Navigate to Explore');
        break;
      case 3:
        // Notifications
        print('Navigate to Notifications');
        break;
    }
  }
}
