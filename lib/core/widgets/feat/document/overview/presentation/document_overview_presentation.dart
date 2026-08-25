import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_event.dart';
import 'package:studydocs/core/widgets/feat/document/overview/logic/document_overview_state.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';

class DocumentOverviewPresentation extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const DocumentOverviewPresentation({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentOverviewBloc, DocumentOverviewState>(
      listenWhen: (previous, current) {
        if (previous is DocumentOverviewLoaded && current is DocumentOverviewLoaded) {
          return previous.downloadUrl != current.downloadUrl && current.downloadUrl == 'success';
        }
        return false;
      },
      listener: (context, state) {
        if (state is DocumentOverviewLoaded && state.downloadUrl == 'success') {
          final fileUrl = state.documentOverview.fileUrl;
          if (fileUrl != null && fileUrl.isNotEmpty) {
            html.window.open(fileUrl, '_blank');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy đường dẫn tải về')),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is DocumentOverviewLoaded) {
          return Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          state.documentOverview.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 32,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(color: AppColors.divider, thickness: 1),
                const SizedBox(height: 12),

                // Course
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Image.asset(
                        AppAssets.folder,
                        width: 20,
                        height: 20,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<DocumentOverviewBloc>().add(
                            SchoolClicked(
                              schoolId: state.documentOverview.courseInfo.id,
                            ),
                          );
                        },
                        child: Text(
                          state.documentOverview.courseInfo.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryBlue,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // School
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Image.asset(
                        AppAssets.school,
                        width: 20,
                        height: 20,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<DocumentOverviewBloc>().add(
                            SchoolClicked(
                              schoolId: state.documentOverview.schoolInfo.id,
                            ),
                          );
                        },
                        child: Text(
                          state.documentOverview.schoolInfo.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryBlue,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Download Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        context.read<DocumentOverviewBloc>().add(
                          DocumentDownloadRequested(
                            id: state.documentOverview.id,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.cloud_download_outlined,
                        color: AppColors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Tải về",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    // Bookmark Button
                    IconButton(
                      onPressed: () {
                        if (state.documentOverview.isSaved) {
                          context.read<DocumentOverviewBloc>().add(
                            DocumentUnSave(id: state.documentOverview.id),
                          );
                        } else {
                          context.read<DocumentOverviewBloc>().add(
                            DocumentSave(id: state.documentOverview.id),
                          );
                        }
                      },
                      icon: Icon(
                        state.documentOverview.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        size: 30,
                        color:
                            state.documentOverview.isSaved
                                ? AppColors.warning
                                : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
