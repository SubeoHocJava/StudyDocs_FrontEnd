import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../screens/auth/presentation/cubit/auth_cubit.dart';
import '../../../../../screens/auth/presentation/cubit/auth_state.dart';
import '../../../../../screens/auth/presentation/widgets/auth_dialog.dart';
import '../../menu/presentation/menu.dart';
import '../../../../theme/theme_cubit.dart';

import 'package:studydocs/core/widgets/common/user_avatar.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onProfileTap;

  // New properties from user
  final bool isDefault;
  final String? headerTitle;
  final VoidCallback? onBack;
  final void Function(BuildContext)? onModal;
  final int selectedIndex;

  const Header({
    super.key,
    this.onMenuTap,
    this.onLogoTap,
    this.onLoginTap,
    this.onFollowTap,
    this.onProfileTap,
    this.isDefault = true,
    this.headerTitle,
    this.onBack,
    this.onModal,
    this.selectedIndex = -1,
  });

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _HeaderState extends State<Header> {
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  //auth
  void _showLoginModal(BuildContext context) {
    showAuthDialog(context);
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _openMenu() {
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Barrier
              Positioned.fill(
                top:
                    widget.preferredSize.height +
                    MediaQuery.of(context).padding.top,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque, // ← THÊM DÒNG NÀY
                  onTap: _closeMenu,
                  child: Container(color: AppColors.black.withValues(alpha: 0.3)),
                ),
              ),
              // Drawer Content
              Positioned(
                top:
                    widget.preferredSize.height +
                    MediaQuery.of(context).padding.top,
                left: 0,
                bottom: 0,
                width: 300,
                child: MenuDrawer(
                  onClose: _closeMenu,
                  onLogoTap: widget.onLogoTap,
                  selectedIndex: widget.selectedIndex,
                ),
              ),
            ],
          ),
    );

    overlayState.insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: widget.preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Menu + Logo
                Row(
                  mainAxisSize:
                      MainAxisSize.min, // QUAN TRỌNG: Sửa lỗi Overflow
                  children: [
                    _buildLeading(context),
                    const SizedBox(width: 8),
                    if (widget.isDefault) _buildLogo(),
                  ],
                ),

                if (!widget.isDefault && widget.headerTitle != null)
                  _buildTitle(),

                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// LEFT: Menu Button or Back Button
  Widget _buildLeading(BuildContext context) {
    if (widget.isDefault) {
      return GestureDetector(
        onTap: _toggleMenu,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('assets/icons/nav.png', width: 24, height: 24),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      color: Theme.of(context).appBarTheme.foregroundColor,
      onPressed: widget.onBack ?? () => Navigator.pop(context),
      iconSize: 24,
    );
  }

  /// LOGO
  Widget _buildLogo() {
    return GestureDetector(
      onTap: widget.onLogoTap ?? () => context.go('/home'),
      child: Row(
        mainAxisSize: MainAxisSize.min, // QUAN TRỌNG: Sửa lỗi Overflow
        children: [Image.asset('assets/icons/logo.png', height: 40)],
      ),
    );
  }

  /// TITLE
  Widget _buildTitle() {
    return Text(
      widget.headerTitle ?? '',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).appBarTheme.foregroundColor,
        fontFamily: 'Montserrat',
      ),
    );
  }

  /// RIGHT ACTIONS
  Widget _buildActions(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (authState is AuthAuthenticated)
              _buildUserAction(context, authState)
            else
              ElevatedButton(
                onPressed: widget.onLoginTap ?? () => _showLoginModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                  foregroundColor: Theme.of(context).appBarTheme.backgroundColor ?? AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            const SizedBox(width: 12),
            // Nút Đổi Theme
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final isDark = themeMode == ThemeMode.dark;
                return GestureDetector(
                  onTap: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      isDark ? 'assets/icons/moon.png' : 'assets/icons/sun.png',
                      width: 28,
                      height: 28,
                      // color: AppColors.headerForeground, // Optional: apply color if needed
                    ),
                  ),
                );
              }
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserAction(BuildContext context, AuthAuthenticated authState) {
    final label = authState.displayName ?? authState.username ?? 'User';
    final avatarUrl = authState.avatarUrl;

    return GestureDetector(
      onTap: widget.onProfileTap ?? () => context.go('/profile'),
      child: Tooltip(
        message: label,
        child: UserAvatar(
          avatarUrl: avatarUrl,
          radius: 20,
          backgroundColor: Theme.of(context).appBarTheme.foregroundColor?.withValues(alpha: 0.12) ?? AppColors.headerForeground.withValues(alpha: 0.12),
          iconColor: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
    );
  }
}
