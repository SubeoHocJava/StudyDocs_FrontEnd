import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../../logic/docs_event.dart';

class DocActions extends StatelessWidget {
  final DocsState state;

  const DocActions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bool isSaved = state is DocsLoaded ? (state as DocsLoaded).isSaved : false;
    final doc = state is DocsLoaded ? (state as DocsLoaded).docDetails : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút Tải về: Download trực tiếp với progress dialog
        Expanded(
          child: ElevatedButton.icon(
            onPressed: doc != null ? () => _downloadPdf(context, doc.downloadUrl) : null,
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

        // Nút Lưu: Dùng IconButton để xóa hover effect thừa
        Expanded(
          child: SizedBox(
            height: 56,
            child: IconButton(
              onPressed: () => context.read<DocsBloc>().add(ToggleSave()),
              icon: Image.asset(
                isSaved ? AppAssets.saved : AppAssets.unsaved,
                width: 40,
                height: 40,
                color: isSaved ? Colors.yellow : Colors.grey.shade400,
              ),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
                highlightColor: Colors.transparent, // Xóa highlight khi nhấn
                hoverColor: Colors.transparent, // Xóa hover effect
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Hàm download PDF với progress dialog
  Future<void> _downloadPdf(BuildContext context, String downloadUrl) async {
    double progress = 0;
    bool isDownloading = true;

    // Hiển thị dialog progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Đang tải PDF...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(value: progress > 0 ? progress : null),
            const SizedBox(height: 16),
            Text('${(progress * 100).toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'studydocs_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress = received / total;
            // Update dialog nếu cần, nhưng vì dialog không stateful, ta dùng setState nếu wrap trong Stateful
          }
        },
      );

      await OpenFilex.open(savePath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tải thành công!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải: $e')));
      }
    } finally {
      isDownloading = false;
      if (context.mounted) {
        Navigator.pop(context); // Đóng dialog
      }
    }
  }
}