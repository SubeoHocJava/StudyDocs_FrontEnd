import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/theme/app_theme.dart';
import 'package:studydocs/core/widgets/menu.dart';
import 'app_icon_button.dart';

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
  Size get preferredSize => const Size.fromHeight(90);
}

class _HeaderState extends State<Header> {
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

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
                  onTap: _closeMenu,
                  child: Container(color: Colors.black.withOpacity(0.3)),
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
      color: AppColors.headerBackground,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: widget.preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Menu + Logo
                      Row(
                        children: [
                          _buildLeading(context),
                          const SizedBox(width: 12),
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
            ],
          ),
        ),
      ),
    );
  }

  /// LEFT: Menu Button or Back Button
  Widget _buildLeading(BuildContext context) {
    if (widget.isDefault) {
      return AppIconButton(
        iconData: Icons.menu,
        color: AppColors.headerForeground,
        onPressed: _toggleMenu,
        size: 24,
      );
    }

    return AppIconButton(
      iconData: Icons.arrow_back_ios_new,
      color: AppColors.headerForeground,
      onPressed: widget.onBack ?? () => Navigator.pop(context),
      size: 24,
    );
  }

  /// LOGO
  Widget _buildLogo() {
    return GestureDetector(
      onTap: () {
        if (widget.onLogoTap != null) {
          widget.onLogoTap!();
        } else {
          // Navigate to Home reset logic if needed
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Image.asset(AppAssets.logo, width: 56, height: 56),
    );
  }

  /// TITLE
  Widget _buildTitle() {
    return Text(
      widget.headerTitle ?? '',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.headerForeground,
        fontFamily: 'Montserrat',
      ),
    );
  }

  /// RIGHT ACTIONS
  Widget _buildActions(BuildContext context) {
    final theme = context.read<ThemeController>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onModal != null) ...[
          AppIconButton(
            iconData: Icons.more_vert,
            color: AppColors.headerForeground,
            onPressed: () => widget.onModal?.call(context),
            size: 24,
          ),
        ],

        if (widget.onProfileTap != null) ...[
          AppIconButton(
            iconData: Icons.account_circle_outlined,
            color: AppColors.headerForeground,
            onPressed: widget.onProfileTap!,
            size: 28,
          ),
        ] else if (widget.isDefault) ...[
          ElevatedButton(
            onPressed: widget.onLoginTap ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.headerForeground,
              foregroundColor: AppColors.headerBackground,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        ],
        const SizedBox(width: 8),
        AppIconButton(
          iconData: Icons.wb_sunny_outlined,
          color: AppColors.headerForeground,
          onPressed: () => theme.toggle(),
          size: 24,
        ),
      ],
    );
  }
}
