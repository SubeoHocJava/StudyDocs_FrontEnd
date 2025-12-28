import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';

// class Header extends StatelessWidget implements PreferredSizeWidget {
//   final VoidCallback? onMenuTap;
//   final VoidCallback? onLogoTap;
//   final VoidCallback? onLoginTap;
//
//   const Header({
//     super.key,
//     this.onMenuTap,
//     this.onLogoTap,
//     this.onLoginTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = context.read<ThemeController>();
//
//     return Container(
//       height: kToolbarHeight,
//       decoration: const BoxDecoration(
//         color: AppColors.headerBackground,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 9.0),
//           child: Row(
//             children: [
//               AppIconButton(
//                 iconData: Icons.menu,
//                 color: AppColors.headerForeground,
//                 onPressed: onMenuTap ?? () {},
//                 size: 24,
//               ),
//
//               const SizedBox(width: 12),
//
//               GestureDetector(
//                 onTap: onLogoTap ?? () {},
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Logo image
//                     Image.asset(
//                       AppAssets.logo,
//                       width: 60,
//                       height: 60,
//                     ),
//                     const SizedBox(width: 12),
//                   ],
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Login button and sun icon on the right
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Login button
//                   ElevatedButton(
//                     onPressed: onLoginTap ?? () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.headerForeground,
//                       foregroundColor: AppColors.headerBackground,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 6,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       textStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         fontFamily: 'Montserrat',
//                       ),
//                     ),
//                     child: const Text('Đăng nhập'),
//                   ),
//
//                   const SizedBox(width: 8),
//
//                   // Sun/brightness icon
//                   AppIconButton(
//                     iconData: Icons.wb_sunny_outlined,
//                     color: AppColors.headerForeground,
//                     onPressed: () => theme.toggle(),
//                     size: 24,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool isDefault;
  final String? headerTitle;
  final VoidCallback? onBack;
  final void Function(BuildContext)? onModal;

  const Header({
    super.key,
    this.isDefault = true,
    this.headerTitle,
    this.onBack,
    this.onModal,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.headerBackground,
      child: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLeading(context),
                    if (onModal != null)
                      AppIconButton(
                        iconData: Icons.more_vert,
                        color: AppColors.headerForeground,
                        onPressed: () => onModal?.call(context),
                      ),
                  ],
                ),
              ),
              // Position the title in the center and ignore pointer events so buttons remain clickable
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(child: _buildTitle()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// LEFT
  Widget _buildLeading(BuildContext context) {
    if (isDefault) {
      return AppIconButton(
        iconData: Icons.menu,
        color: AppColors.headerForeground,
        onPressed: () {},
      );
    }

    return AppIconButton(
      iconData: Icons.arrow_back_ios_new,
      color: AppColors.headerForeground,
      onPressed: onBack ?? () => Navigator.pop(context),
    );
  }

  /// CENTER
  Widget _buildTitle() {
    if (headerTitle != null) {
      return Text(
        headerTitle!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.headerForeground,
        ),
      );
    }

    return Image.asset(AppAssets.logo, width: 60, height: 60);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
