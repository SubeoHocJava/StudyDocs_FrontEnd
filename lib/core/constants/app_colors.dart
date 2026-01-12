import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (xanh dương đậm, thương hiệu chính)
  static const Color primary = Color(0xFF0505C4);
  static const Color primaryLight = Color(0xFFE6EAFA);

  // Secondary Palette (xanh ngọc & tím nhạt — màu nhấn phụ)
  static const Color secondaryTeal = Color(0xFF00C0CD);
  static const Color secondaryBlue = Color(0xFF7A94FF);

  // Neutral Palette (trắng, đen, xám)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF7A7A7A);
  static const Color navy = Color(0xFF000F4C); // Xanh navy đậm

  // Semantic aliases (dễ đọc, dùng cho widget cụ thể)
  static const Color headerBackground = primaryLight;
  static const Color headerForeground = primary;

  static const Color profileName = navy;
  static const Color profileSchool = secondaryBlue;

  static const Color docTitleBorder = navy;
  static const Color docSmallText = gray;

  static const Color followerChip = secondaryTeal;
  static const Color followingChip = secondaryBlue;
  //Notification
  static const notificationUnread = Color(0xFFE6EAFA);

  // Semantic feedback colors
  static const Color success = Color(0xFF2ECC71); // green
  static const Color warning = Color(0xFFF39C12); // orange
  static const Color danger = Color(0xFFE74C3C); // red
}
