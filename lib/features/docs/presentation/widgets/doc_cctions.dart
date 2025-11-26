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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: onDownload,
          icon: Image.asset(AppAssets.download, width: 20, height: 20),
          label: const Text("Tải về"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryTeal,
            foregroundColor: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => context.read<DocsBloc>().add(ToggleSave()),
          icon: Image.asset(
            state is DocsLoaded ? (state.isSaved ? AppAssets.saved : AppAssets.unsaved) : AppAssets.unsaved,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }
}
