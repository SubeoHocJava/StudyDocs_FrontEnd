import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';
import '../../features/auth/presentation/widgets/login_modal.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final VoidCallback? onLoginTap;

  const Header({
    super.key,
    this.onMenuTap,
    this.onLogoTap,
    this.onLoginTap,
  });

  void _showLoginModal(BuildContext context) {
    // Hiển thị dialog đăng nhập với hiệu ứng chuẩn Material.
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const LoginModal(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeController>();
    
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(
        color: AppColors.headerBackground,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: [
              AppIconButton(
                iconData: Icons.menu,
                color: AppColors.headerForeground,
                onPressed: onMenuTap ?? () {},
                size: 24,
              ),
              
              const SizedBox(width: 12),
              
              GestureDetector(
                onTap: onLogoTap ?? () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo image
                    Image.asset(
                      AppAssets.logo,
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Login button and sun icon on the right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Login button
                  ElevatedButton(
                    onPressed: onLoginTap ?? () => _showLoginModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.headerForeground,
                      foregroundColor: AppColors.headerBackground,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    child: const Text('Đăng nhập'),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Sun/brightness icon
                  AppIconButton(
                    iconData: Icons.wb_sunny_outlined,
                    color: AppColors.headerForeground,
                    onPressed: () => theme.toggle(),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
