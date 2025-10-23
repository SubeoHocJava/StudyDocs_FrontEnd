import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onUserTap;
  final VoidCallback? onLogoTap;

  const Header({
    super.key,
    this.title = 'StudyDocs',
    this.onUserTap,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeController>();
    return AppBar(
      backgroundColor: AppColors.headerBg,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.headerFg,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: AppIconButton(
        assetPath: AppAssets.user,
        color: AppColors.headerFg,
        onPressed: onUserTap ?? () {},
        size: 22,
      ),
      actions: [
        AppIconButton(
          assetPath: AppAssets.logo,
          color: AppColors.headerFg,
          onPressed: onLogoTap ?? () {},
          size: 22,
        ),
        AppIconButton(
          assetPath: AppAssets.sun,
          color: AppColors.headerFg,
          onPressed: () => theme.toggle(),
          size: 22,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
