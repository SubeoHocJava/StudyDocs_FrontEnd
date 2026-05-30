import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/features/auth/presentation/cubit/auth_state.dart';

import 'header/presentation/header.dart';

/// Shell layout: Header cố định, chỉ [child] (Navigator con) đổi khi chuyển route.
/// Dùng với [ShellRoute] — không bọc AppShell từng trang riêng lẻ.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous is AuthAuthenticated && current is AuthUnauthenticated,
      listener: (context, state) {
        context.go('/home');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(
              isDefault: _isDefaultHeader(location),
              headerTitle: _headerTitle(location),
              selectedIndex: _selectedIndex(location),
              onBack:
                  _isDefaultHeader(location)
                      ? null
                      : () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
              onLogoTap: () => context.go('/home'),
              onProfileTap: () => context.go('/profile'),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    return -1;
  }

  bool _isDefaultHeader(String location) {
    return location.startsWith('/home') || location.startsWith('/profile');
  }

  String? _headerTitle(String location) {
    if (location.startsWith('/followers') ||
        location.startsWith('/following')) {
      return 'Theo dõi';
    }
    return null;
  }
}
