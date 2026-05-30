import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/core/widgets/feat/profile/update_infor_form/logic/update_infor_bloc.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../router/app_router.dart';
import '../../myqr/presentation/my_qr_widget.dart';
import '../../update_infor_form/logic/update_infor_event.dart';
import '../../update_infor_form/presentation/UpdateInforDialog.dart';
import '../logic/setting_bloc.dart';
import '../logic/setting_event.dart';
import '../logic/setting_state.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  // ----- Mở hộp thoại cập nhật thông tin -----
  void _openUpdateDialog(BuildContext context) {
    showGlobalDialog(BlocProvider(
      create: (_) => UpdateInforBloc()..add(LoadUpdateInfor()),
      child: const UpdateInforDialog(),
    ),);
  }

  // ----- Popup QR -----
  void _showQRPopup(BuildContext context, String data) {
    showGlobalDialog(MyQRWidget(userId: ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingActionSuccess) {
          switch (state.action) {
            case "open_update_dialog":
              _openUpdateDialog(context);
              break;

            case "link_google":
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã gửi yêu cầu liên kết Google")),
              );
              break;

            case "show_qr":
              _showQRPopup(context, "my-qr-data-123456");
              break;

            case "logout":
              context.read<AuthCubit>().logout().then((_) {
                if (!context.mounted) return;
                Navigator.pop(context);
                context.go('/home');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã đăng xuất'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
              break;
          }
        }

        if (state is SettingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AlertDialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(10),
        titlePadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        actionsAlignment: MainAxisAlignment.center,

        // ----- TITLE -----
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Cài đặt",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 32,
                color: Colors.black87,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),

        // ----- CONTENT -----
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              text: "Cập nhật thông tin",
              onTap:
                  () => context.read<SettingBloc>().add(OpenUpdateInfoEvent()),
            ),

            const SizedBox(height: 12),

            _buildButton(
              text: "Liên kết tài khoản Google",
              onTap:
                  () =>
                      context.read<SettingBloc>().add(LinkGoogleAccountEvent()),
            ),

            const SizedBox(height: 12),

            _buildButton(
              text: "Chia sẻ mã QR",
              onTap: () => context.read<SettingBloc>().add(ShowQrEvent()),
            ),
          ],
        ),

        // ----- ACTIONS -----
        actions: [
          TextButton.icon(
            onPressed: () => context.read<SettingBloc>().add(LogoutEvent()),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ----- Button style -----
  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
