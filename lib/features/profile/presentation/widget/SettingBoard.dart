import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../logic/profile_bloc.dart';
import '../../../auth/presentation/bloc/auth_status_cubit.dart';
import 'UpdateInforDialog.dart';

class SettingBoard extends StatefulWidget {
  final ProfileBloc bloc;

  const SettingBoard({super.key, required this.bloc});

  @override
  State<SettingBoard> createState() => _SettingBoardState();
}

class _SettingBoardState extends State<SettingBoard> {

  Future<void> _openUpdateDialog() async {
    final ProfileBloc bloc = widget.bloc;

    // LẤY ROOT CONTEXT (KHÔNG BỊ DISPOSE)
    final BuildContext rootContext =
        Navigator.of(context, rootNavigator: true).context;

    // Đóng dialog Setting
    Navigator.of(context).pop();

    // Đợi animation đóng dialog
    await Future.delayed(const Duration(milliseconds: 200));

    // Mở dialog Update
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: UpdateInforDialog(bloc: bloc),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardTheme.color,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(10),
      titlePadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      actionsAlignment: MainAxisAlignment.center,

      // ---------- TITLE ----------
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Cài đặt",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 32,
              color: Theme.of(context).iconTheme.color,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      // ---------- CONTENT ----------
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cập nhật thông tin
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openUpdateDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Cập nhật thông tin",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Liên kết Google
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: xử lý liên kết Google
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Liên kết tài khoản Google",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      // ---------- ACTIONS ----------
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextButton.icon(
            onPressed: () async {
              // Logout: Xóa tokens và cập nhật auth state
              await context.read<AuthStatusCubit>().logout();
              
              // Đóng dialog
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                
                // Navigate về home page
                context.go(AppRoutes.home);
                
                // Show thông báo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã đăng xuất'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              "Đăng xuất",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
