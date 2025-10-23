import 'package:flutter/material.dart';
import '../constants/app_icons.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  BottomNavigationBarItem _item(String icon, String picked, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(icon, width: 24, height: 24),
      activeIcon: Image.asset(picked, width: 24, height: 24),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        _item(AppAssets.home, AppAssets.homePick, 'Trang chủ'),
        _item(AppAssets.lib, AppAssets.libPick, 'Thư viện'),
        _item(AppAssets.explore, AppAssets.explorePick, 'Khám phá'),
        _item(AppAssets.bell, AppAssets.bellPick, 'Thông báo'),
      ],
    );
  }
}
