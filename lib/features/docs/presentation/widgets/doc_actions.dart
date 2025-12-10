import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../../logic/docs_event.dart';

class DocActions extends StatelessWidget {
  final DocsState state;
  final VoidCallback? onDownload;

  const DocActions({super.key, required this.state, this.onDownload});

  @override
  Widget build(BuildContext context) {
    final bool isSaved = state is DocsLoaded ? state.isSaved : false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút Tải về (giữ nguyên)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDownload,
            icon: Image.asset(AppAssets.download, width: 28, height: 28),
            label: const Text(
              "Tải về",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide.none,
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Nút Lưu: khi chưa lưu → trong suốt + icon xám, khi đã lưu → xanh lá
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.read<DocsBloc>().add(ToggleSave()),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaved ? Colors.transparent : Colors.transparent, // Không màu nền khi chưa lưu
                foregroundColor: Colors.transparent, // Không áp dụng foreground mặc định
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSaved
                      ? BorderSide.none
                      : BorderSide(color: AppColors.secondaryTeal.withOpacity(0.0), width: 0.0), // Viền nhẹ khi chưa lưu
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isSaved ? Colors.yellow : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  isSaved ? AppAssets.saved : AppAssets.unsaved,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}