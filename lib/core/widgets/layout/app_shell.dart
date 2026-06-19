import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';


import '../../../screens/auth/presentation/cubit/auth_cubit.dart';
import '../../../screens/auth/presentation/cubit/auth_state.dart';
import 'bottom/bottom_nav.dart';
import 'header/presentation/header.dart';

/// Shell layout: header and footer stay fixed while the route child changes.
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
        bottomNavigationBar: BottomNav(
          currentIndex: _selectedIndex(location),
          onTap: (index) => _onFooterTap(context, index),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(
              isDefault: _isDefaultHeader(location),
              headerTitle: _headerTitle(location),
              selectedIndex: _selectedIndex(location),
              onBack: _isDefaultHeader(location)
                  ? null
                  : () => _handleBack(context, location),
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
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/notifications')) return 3;
    return -1;
  }

  void _onFooterTap(BuildContext context, int index) {
    const routes = ['/home', '/library', '/explore', '/notifications'];
    if (index < 0 || index >= routes.length) return;

    final target = routes[index];
    final currentLocation = GoRouterState.of(context).uri.path;
    if (currentLocation == target) return;

    context.go(target);
  }

  void _handleBack(BuildContext context, String location) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    if (location.startsWith('/library/')) {
      context.go('/library');
      return;
    }

    context.go('/home');
  }

  bool _isDefaultHeader(String location) {
    return location.startsWith('/home') ||
        location.startsWith('/profile') ||
        location == '/library' ||
        location.startsWith('/explore') ||
        location.startsWith('/notifications');
  }

  String? _headerTitle(String location) {
    if (location.startsWith('/library')) return 'Thư viện';
    if (location.startsWith('/explore')) return 'Khám phá';
    if (location.startsWith('/notifications')) return 'Thông báo';
    if (location.startsWith('/followers') ||
        location.startsWith('/following')) {
      return 'Theo dõi';
    }
    return null;
  }
}
