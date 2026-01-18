/// Ví dụ cách sử dụng AuthStatusCubit để check quyền admin
///
/// Trong Widget, lắng nghe AuthStatusCubit để kiểm tra isAdmin:
///
/// ```dart
/// context.watch<AuthStatusCubit>().state is AuthAuthenticated
///     && (context.watch<AuthStatusCubit>().state as AuthAuthenticated).isAdmin
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/auth_status_cubit.dart';

/// Widget example: Hiển thị nút Admin chỉ khi user có quyền
class AdminPanelButtonExample extends StatelessWidget {
  const AdminPanelButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit, AuthStatus>(
      builder: (context, authState) {
        // Nếu user chưa login, ẩn nút
        if (authState is AuthUnauthenticated) {
          return const SizedBox.shrink();
        }

        // Nếu user đã login, check role
        if (authState is AuthAuthenticated) {
          final isAdmin = authState.isAdmin;

          return Column(
            children: [
              // Hiển thị user info
              Text('User: ${authState.displayName}'),
              Text('Roles: ${authState.roles.join(", ")}'),
              const SizedBox(height: 16),

              // Hiển thị nút admin nếu là admin
              if (isAdmin)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to admin panel
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigating to Admin Panel...'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Admin Panel'),
                )
              else
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Admin Panel (Disabled)'),
                ),

              // Logout button
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await context.read<AuthStatusCubit>().logout();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Hỗ trợ Extension Method cho dễ dàng check role
extension AuthStatusExtension on AuthStatus {
  bool get isAuthenticated => this is AuthAuthenticated;

  bool get isAdmin {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).isAdmin;
    }
    return false;
  }

  AuthAuthenticated? get asAuthenticated =>
      this is AuthAuthenticated ? this as AuthAuthenticated : null;

  String get userDisplayName {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).displayName;
    }
    return '';
  }

  List<String> get userRoles {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).roles;
    }
    return [];
  }
}
